#!/bin/bash
set -e
#sudo chown -R runner:runner /usr/local/
sudo npm install -g appium
appium -v
appium &>/dev/null &