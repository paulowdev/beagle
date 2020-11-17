#
# Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
    
@pageview @regression
Feature: PageView Component Validation

    As a Beagle developer/user
    I'd like to make sure my pageView component works as expected
    
    Background:
        Given the Beagle application did launch with the pageView on screen

    Scenario: PageView 01 - PageView component renders correctly
        Then checks that "Page 1", "Page 2" and "Page 3" are rendered correctly.

    Scenario: PageView 02 - PageView onPageChange runs correctly
        Then checks that "0", "1" and "2" texts are displayed.
        
    Scenario: PageView 03 - PageView page set in onCurrentPage is displayed
        Then checks that the page set in onCurrentPage attribute is displayed.
        
    Scenario Outline: PageView 04 - PageView change the page via the onCurrentPage attribute
        When I press a button with the "<buttonTitle>" title
        Then the page with the "<name>" name should appear on the screen

        Examples:
        |         buttonTitle             |               name                   |
        |   SetCurrentPageToPageThree     |    Page 3                            |
        |   SetCurrentPageToPageOne       |    Page 1                            |
        |   SetCurrentPageToPageTwo       |    Page 2                            |
        
    Scenario Outline: PageView 05 - PageView checks the context set on PageView
        When I press a button with the "<buttonTitle>" title
        Then the label with the "<name>" name should appear on the screen

        Examples:
        |         buttonTitle             |               name                   |
        |   SetCurrentPageToPageOne       |    0                                 |
        |   SetCurrentPageToPageTwo       |    1                                 |
        |   SetCurrentPageToPageThree     |    2                                 |
