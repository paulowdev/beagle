package br.com.zup.beagle.cucumber.steps

import br.com.zup.beagle.setup.SuiteSetup
import io.cucumber.java.Before
import io.cucumber.java.en.Given
import io.cucumber.java.en.Then
import io.cucumber.java.en.When

class AnalyticsScreenSteps : AbstractStep() {

    override var bffRelativeUrlPath = "/analytics2.0"
    private val recordHashMap = hashMapOf<String, List<String>>(
        "Analytics 02" to listOf(
            "type:action",
            "event:onPress",
            "type:beagle:button",
            "id:_beagle_5",
            "position:{\"x\":8,\"y\":44}",
            "beagleAction:beagle:confirm",
            "title:Confirm Title",
            "message:Confirm Message",
            "url:/analytics2.0",
            platformCheck()
        ),
        "Analytics 03" to listOf(
            "type:action",
            "event:onPress",
            "type:beagle:button",
            "id:_beagle_6",
            "position:{\"x\":8,\"y\":80}",
            "beagleAction:beagle:alert",
            "message:AlertMessage",
            "url:/analytics2.0",
            platformCheck()
        ),
        "Analytics 05" to listOf(
            "type:screen",
            "url:analytics2.0-navigate"
        )
    )

    @Before("@analytics2.0")
    fun setup() {
        loadBffScreenFromMainScreen()
    }

    @Given("^the Beagle application did launch with the Analytics screen url$")
    fun checkBaseScreen() {
        waitForElementWithTextToBeClickable("Analytics 2.0", false, false)
    }

    @When("^I press the button with title (.*)$")
    fun clickOnButton(string: String) {
        waitForElementWithTextToBeClickable(string, false, false).click()
    }

    @Then("^an alert dialog should appear on the screen$")
    fun checkAlertDialog() {
        waitForElementWithTextToBeClickable("AlertMessage", false, false)
    }

    @Then("^a confirm dialog should appear on the screen$")
    fun checkConfirmDialog() {
        waitForElementWithTextToBeClickable("Confirm Message", false, false)
    }

    @Then("^no analytics record should be created$")
    fun checkNoAnalyticsGenerated() {
        waitForElementWithTextToBeClickable("Analytics 2.0 native", false, false)
        waitForElementWithTextToBeInvisible("type", false, false)
    }

    @Then("^an analytics record should be created for (.*)$")
    fun checkAnalyticsGenerated(string: String) {
        waitForElementWithTextToBeClickable("Analytics 2.0 native", false, false)
        val analytics = recordHashMap[string]
        analytics?.forEach {
            waitForElementWithTextToBeClickable(it, true, false)
        }
    }

    private fun platformCheck(): String {
        if (SuiteSetup.isAndroid()) {
            return "platform:android"
        }
        return "platform:ios"
    }

}