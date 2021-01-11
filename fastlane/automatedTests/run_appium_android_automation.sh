#!/bin/bash

AVD_NAME='Pixel_3a_API_30_x86'
AVD_IMAGE='system-images;android-30;google_apis;x86'
APP_ANDROID_DIR=tests/appium/app-android
APP_ANDROID_APK_FILE=$APP_ANDROID_DIR/app/build/outputs/apk/debug/app-debug.apk
AVD_CONFIG_FILE=~/.android/avd/$AVD_NAME.avd/config.ini
APPIUM_PROJECT_DIR=tests/appium/project

function cleanup() {
    "$ANDROID_SDK_ROOT"/platform-tools/adb devices | grep emulator | cut -f1 | while read -r line; do
        "$ANDROID_SDK_ROOT"/platform-tools/adb -s "$line" emu kill
    done
}

function checkFileExists(){
	if [ -f "$1" ]; then
		echo "file $1 exists!"
	else 
		echo "ERROR: file $1 does not exist!"
		exit 1
	fi
}

trap exit SIGHUP SIGINT
trap cleanup EXIT

echo "##### Generating .apk from project $APP_ANDROID_DIR ..."
$APP_ANDROID_DIR/gradlew assembleDebug
checkFileExists $APP_ANDROID_APK_FILE

echo "##### Installing / updating image $AVD_IMAGE ..."
"$ANDROID_SDK_ROOT"/tools/bin/sdkmanager "$AVD_IMAGE"
"$ANDROID_SDK_ROOT"/tools/bin/sdkmanager --update

if "$ANDROID_SDK_ROOT"/emulator/emulator -list-avds | grep -q "$AVD_NAME"; then
    echo "##### Using avd from cache"
else
    echo "##### AVD not found in cache, creating AVD ..."
    #blank line necessary as input to AVD
    echo | "$ANDROID_SDK_ROOT"/tools/bin/avdmanager create avd -f -n $AVD_NAME -k "$AVD_IMAGE"
fi

echo "##### Checking if AVD was created correctly ..."
checkFileExists $AVD_CONFIG_FILE

echo "##### Configuring AVD settings ..."
echo "AvdId=AVD_TEST
PlayStore.enabled=false
abi.type=x86
avd.ini.displayname=AVD_TEST
avd.ini.encoding=UTF-8
disk.dataPartition.size=6G
fastboot.forceChosenSnapshotBoot=no
fastboot.forceColdBoot=no
fastboot.forceFastBoot=yes
hw.cpu.arch=x86
hw.gpu.enabled=yes
hw.gpu.mode=software
hw.initialOrientation=Portrait
hw.keyboard=no
hw.lcd.density=440
hw.lcd.height=2220
hw.lcd.width=1080
hw.mainKeys=no
hw.ramSize=1536
image.sysdir.1=system-images/android-30/google_apis/x86/
vm.heapSize=512" > $AVD_CONFIG_FILE

echo "##### Starting emulator with AVD ..."
nohup "$ANDROID_SDK_ROOT"/emulator/emulator -avd $AVD_NAME -no-audio -no-boot-anim -no-window

echo "##### Waiting for device to boot"
"$ANDROID_SDK_ROOT"/platform-tools/adb wait-for-device shell <<ENDSCRIPT
echo "" > /data/local/tmp/zero
getprop dev.bootcomplete > /data/local/tmp/bootcomplete
while cmp /data/local/tmp/zero /data/local/tmp/bootcomplete; do
{
    echo -n "."
    sleep 1
    getprop dev.bootcomplete > /data/local/tmp/bootcomplete
}; done
echo "Booted."
exit
ENDSCRIPT

echo "#### Waiting 30 secs for us to be really booted"
sleep 30

echo "##### Installing the .apk file in the emulator ..."
$ANDROID_SDK_ROOT/platform-tools/adb install $APP_ANDROID_APK_FILE

echo "#### Starting Appium tests ..."
$APPIUM_PROJECT_DIR/gradlew cucumber -Dplatform=android 

echo "Finish!"