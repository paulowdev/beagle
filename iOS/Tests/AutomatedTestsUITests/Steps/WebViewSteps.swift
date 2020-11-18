//
/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
    

import Foundation
import XCTest

class WebViewSteps: CucumberStepsDefinition {
    var application: XCUIApplication!
    
    func loadSteps() {
        // MARK: - Before
        before { scenarioDefinition in
            if scenarioDefinition?.tags.contains("webview") ?? false {
                let url = "http://localhost:8080/webview"
                self.application = TestUtils.launchBeagleApplication(url: url)
            }
        }
        
        // MARK: - Given
        Given(#"^the Beagle application did launch with the web view url screen$"#) { _, _ -> Void in
            XCTAssertTrue(self.application.staticTexts["WebView screen"].exists)
        }
        
        // MARK: - When
        
        // Scenarios 2
        When(#"^I press a button with the "([^\"]*)" title to change urls$"#) { args, _ -> Void in
            let text = args![0]
            self.application.buttons[text].tap()
        }
        
        // MARK: - Then
        
        // Scenario 1, 2
        Then(#"^the text "([^\"]*)" from webView should appear on the screen$"#) { args, _ -> Void in
            let text = args![0]
            let element = self.application.webViews.staticTexts[text]
            let result = element.waitForExistence(timeout: 3)
            XCTAssertNotNil(result)
            XCTAssertTrue(element.exists)
        }
    }
}
