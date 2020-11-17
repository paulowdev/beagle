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

// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable force_unwrapping
class PageViewSteps: CucumberStepsDefinition {
    
    var application: XCUIApplication!
    
    func loadSteps() {
        // MARK: - Before
        before { scenarioDefinition in
            if scenarioDefinition?.tags.contains("pageview") ?? false {
                let url = "http://localhost:8080/pageview"
                self.application = TestUtils.launchBeagleApplication(url: url)
            }
        }
        
        // MARK: - Given
        Given(#"^the Beagle application did launch with the pageView on screen$"#) { _, _ -> Void in
            XCTAssertTrue(ScreenElements.PAGEVIEW_SCREEN_HEADER.element.exists)
        }
        
        // MARK: - When
        
        // Scenarios 4 and 5
        When(#"^I press a button with the "([^\"]*)" title$"#) { args, _ -> Void in
            let title = args![0]

            let button = self.application.buttons[title]
            XCTAssertTrue(button.exists)
            button.tap()
        }
        
        // MARK: - Then
        
        // Scenario 1
        Then(#"^checks that "([^\"]*)", "([^\"]*)" and "([^\"]*)" are rendered correctly.$"#) { args, _ -> Void in
            let pageOne = self.application.staticTexts[args![0]]
            let pageTwo = self.application.staticTexts[args![1]]
            let pageThree = self.application.staticTexts[args![2]]
            
            XCTAssertTrue(pageOne.exists)
            pageOne.swipeLeft()
            XCTAssertTrue(pageTwo.exists)
            pageTwo.swipeLeft()
            XCTAssertTrue(pageThree.exists)
        }
        
        // Scenario 2
        Then(#"^checks that "([^\"]*)", "([^\"]*)" and "([^\"]*)" texts are displayed.$"#) { args, _ -> Void in
            let zero = self.application.staticTexts[args![0]]
            let one = self.application.staticTexts[args![1]]
            let two = self.application.staticTexts[args![2]]
            
            XCTAssertTrue(zero.exists)
            XCTAssertTrue(ScreenElements.PAGE_1_TEXT.element.exists)
            ScreenElements.PAGE_1_TEXT.element.swipeLeft()
            XCTAssertTrue(one.exists)
            XCTAssertTrue(ScreenElements.PAGE_2_TEXT.element.exists)
            ScreenElements.PAGE_2_TEXT.element.swipeLeft()
            XCTAssertTrue(two.exists)
            XCTAssertTrue(ScreenElements.PAGE_3_TEXT.element.exists)
        }
        
        // Scenario 3
        Then(#"^checks that the page set in onCurrentPage attribute is displayed.$"#) { _, _ -> Void in
            XCTAssertTrue(ScreenElements.PAGE_1_TEXT.element.exists)
            XCTAssertTrue(self.application.staticTexts["0"].exists)
        }
        
        // Scenario 4
        Then(#"^the page with the "([^\"]*)" name should appear on the screen$"#) { args, _ -> Void in
            let name = args![0]
            
            let text = self.application.staticTexts[name]
            XCTAssertTrue(text.exists)
        }
        
        // Scenario 5
        Then(#"^the label with the "([^\"]*)" name should appear on the screen$"#) { args, _ -> Void in
            let name = args![0]
            
            let label = self.application.staticTexts[name]
            XCTAssertTrue(label.exists)
        }
    }
}
