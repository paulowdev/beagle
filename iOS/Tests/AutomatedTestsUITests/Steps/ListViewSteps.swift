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

import XCTest
import SnapshotTesting
@testable import Beagle

class ListViewSteps: CucumberStepsDefinition {
    
    var application: XCUIApplication!
    
    func loadSteps() {
        
        before { scenarioDefinition in
            listViewDecelerates = false
            listViewBounces = false
            if scenarioDefinition?.tags.contains("listview") ?? false {
                let url = "http://localhost:8080/listview"
                self.application = TestUtils.launchBeagleApplication(url: url)
            }
        }
        
        Given("^the Beagle application did launch with the listview screen url$") { _, _ -> Void in
            XCTAssertTrue(ScreenElements.LISTVIEW_SCREEN_HEADER.element.exists)
        }
        
        When("^I click the button (.*)$") { args, _ -> Void in
            self.application.buttons[args![0]].tap()
        }
        
        Then("^should render the list of characters correctly with (.*) scroll$") { _, _ -> Void in
            let list = ListViewElements.CHARACTERS_LIST_VIEW_ID.element
            assertSnapshot(matching: list, as: .image)
            let horizontalScroll = list.otherElements.filter { $0.label.contains("Horizontal scroll bar") }
            while horizontalScroll.first?.value as? String != "100%" {
                list.swipe(from: .init(dx: 0.99, dy: 0), to: .init(dx: 0, dy: 0))
                assertSnapshot(matching: list, as: .image)
            }
        }
        
        Then("^the page number should be (.*)$") { args, _ -> Void in
            XCTAssertTrue(self.application.staticTexts[args![0]].exists)
        }
        
        Then("^the read status of the list of characters is (.*)$") { args, _ -> Void in
            XCTAssertTrue(self.application.staticTexts[args![0]].exists)
        }
        
    }
    
}

private enum ListViewElements: String {
    
//    const val LISTVIEW_SCREEN_HEADER = "Beagle ListView"
//    const val STATIC_LISTVIEW_TEXT_1 = "Static VERTICAL ListView"
//    const val STATIC_LISTVIEW_TEXT_2 = "Static HORIZONTAL ListView"
//    const val DYNAMIC_LISTVIEW_TEXT_1 = "Dynamic VERTICAL ListView"
//    const val DYNAMIC_LISTVIEW_TEXT_2 = "Dynamic HORIZONTAL ListView"
//    const val CHARACTERS_LIST_VIEW_ID = "charactersList"
    
    case SCREEN_HEADER = "Beagle ListView"
    case CHARACTERS_LIST_VIEW_ID = "charactersList"
    
    var element: XCUIElement {
        switch self {
        case .SCREEN_HEADER:
            return XCUIApplication().staticTexts[self.rawValue]
        case .CHARACTERS_LIST_VIEW_ID:
            return XCUIApplication().otherElements[self.rawValue]
        }
    }
    
}

extension Snapshotting where Value: XCUIElement, Format == UIImage {
    public static var image: Snapshotting {
        return Snapshotting<UIImage, UIImage>.image(precision: 0.95).asyncPullback { element in
            Async<UIImage> { callback in
                DispatchQueue.main.async {
                    callback(element.screenshot().image)
                }
            }
        }
    }
}

extension XCUIElement {

    public class var defaultSwipesCount: Int { return 15 }

    public func swipe(from startVector: CGVector, to stopVector: CGVector) {
        let pt1 = coordinate(withNormalizedOffset: startVector)
        let pt2 = coordinate(withNormalizedOffset: stopVector)
        pt1.press(forDuration: 0, thenDragTo: pt2)
    }

    /// Swipes scroll view to given direction until condition will be satisfied.
    ///
    /// A useful method to scroll collection view to reveal an element.
    /// In collection view, only a few cells are available in the hierarchy.
    /// To scroll to given element you have to provide swipe direction.
    /// It is not possible to detect when the end of the scroll was reached, that is why the maximum number of swipes is required (by default 10).
    /// The method will stop when the maximum number of swipes is reached or when the condition will be satisfied.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let collectionView = app.collectionViews.element
    /// let element = collectionView.staticTexts["More"]
    /// collectionView.swipe(to: .down, until: element.exists)
    /// ```
    ///
    /// - Parameters:
    ///   - direction: Swipe direction.
    ///   - times: Maximum number of swipes (by default 10).
    ///   - viewsToAvoid: Table of `AvoidableElement` that should be avoid while swiping, by default keyboard and navigation bar are passed.
    ///   - app: Application instance to use when searching for keyboard to avoid.
    ///   - orientation: Device orientation.
    ///   - condition: The condition to satisfy.
    public func swipe(to direction: SwipeDirection,
                      times: Int = XCUIElement.defaultSwipesCount,
                      avoid viewsToAvoid: [AvoidableElement] = [.keyboard, .navigationBar],
                      from app: XCUIApplication = XCUIApplication(),
                      orientation: UIDeviceOrientation = XCUIDevice.shared.orientation,
                      until condition: @autoclosure () -> Bool) {
        let scrollableArea = self.scrollableArea(avoid: viewsToAvoid, from: app, orientation: orientation)

        // Swipe `times` times in the provided direction.
        for _ in 0..<times {

            // Stop scrolling when condition will be satisfied.
            guard !condition() else {
                break
            }

            // Max swipe offset in both directions.
            let maxOffset = maxSwipeOffset(in: scrollableArea)

            /// Calculates vector for given direction.
            let vector: CGVector
            switch direction {
            case .up: vector = CGVector(dx: 0, dy: -maxOffset.height)
            case .down: vector = CGVector(dx: 0, dy: maxOffset.height)
            case .left: vector = CGVector(dx: -maxOffset.width, dy: 0)
            case .right: vector = CGVector(dx: maxOffset.width, dy: 0)
            }

            // Max possible distance to swipe (normalized).
            let maxNormalizedVector = normalize(vector: vector)

            // Center point.
            let center = centerPoint(in: scrollableArea)

            // Start and stop vectors.
            let (startVector, stopVector) = swipeVectors(from: center, vector: maxNormalizedVector)

            // Swipe.
            swipe(from: startVector, to: stopVector)
        }
    }

}

extension XCUIElement {
    // MARK: Properties
    /// Proportional horizontal swipe length.
    ///
    /// - note:
    /// To avoid swipe to back `swipeLengthX` is lower than `swipeLengthY`.
    var swipeLengthX: CGFloat {
        return 0.7
    }

    /// Proportional vertical swipe length.
    var swipeLengthY: CGFloat {
        return 0.7
    }

    // MARK: Methods
    /// Calculates scrollable area of the element by removing overlapping elements like keybard or navigation bar.
    ///
    /// - Parameters:
    ///   - viewsToAvoid: Table of `AvoidableElement` that should be avoid while swiping, by default keyboard and navigation bar are passed.
    ///   - app: Application instance to use when searching for keyboard to avoid.
    ///   - orientation: Device orientation.
    /// - Returns: Scrollable area of the element.
    func scrollableArea(avoid viewsToAvoid: [AvoidableElement] = [.keyboard, .navigationBar], from app: XCUIApplication = XCUIApplication(), orientation: UIDeviceOrientation) -> CGRect {

        let scrollableArea = viewsToAvoid.reduce(frame) {
            $1.overlapReminder(of: $0, in: app, orientation: orientation)
        }
//        assert(scrollableArea.height > 0, "Scrollable view is completely hidden.")
        return scrollableArea
    }

    /// Maximum available swipe offsets (in points) in the scrollable area.
    ///
    /// It takes `swipeLengthX` and `swipeLengthY` to calculate values.
    ///
    /// - Parameter scrollableArea: Scrollable area of the element.
    /// - Returns: Maximum available swipe offsets (in points).
    func maxSwipeOffset(in scrollableArea: CGRect) -> CGSize {
        return CGSize(
            width: scrollableArea.width * swipeLengthX,
            height: scrollableArea.height * swipeLengthY
        )
    }

    /// Normalize vector. From points to normalized values (<0;1>).
    ///
    /// - Parameter vector: Vector to normalize.
    /// - Returns: Normalized vector.
    func normalize(vector: CGVector) -> CGVector {
        return CGVector(
            dx: vector.dx / frame.width,
            dy: vector.dy / frame.height
        )
    }

    /// Returns center point of the scrollable area in the element in the normalized coordinate space.
    ///
    /// - Parameter scrollableArea: Scrollable area of the element.
    /// - Returns: Center point of the scrollable area in the element in the normalized coordinate space.
    func centerPoint(in scrollableArea: CGRect) -> CGPoint {
        return CGPoint(
            x: (scrollableArea.midX - frame.minX) / frame.width,
            y: (scrollableArea.midY - frame.minY) / frame.height
        )
    }

    /// Calculates swipe vectors from center point and swipe vector.
    ///
    /// Generated vectors can be used by `swipe(from:,to:)`.
    ///
    /// - Parameters:
    ///   - center: Center point of the scrollable area. Use `centerPoint(with:)` to calculate this value.
    ///   - vector: Swipe vector in the normalized coordinate space.
    /// - Returns: Swipes vector to use by `swipe(from:,to:)`.
    func swipeVectors(from center: CGPoint, vector: CGVector) -> (startVector: CGVector, stopVector: CGVector) {
        // Start vector.
        let startVector = CGVector(
            dx: center.x + vector.dx / 2,
            dy: center.y + vector.dy / 2
        )

        // Stop vector.
        let stopVector = CGVector(
            dx: center.x - vector.dx / 2,
            dy: center.y - vector.dy / 2
        )

        return (startVector, stopVector)
    }

    /// Calculates frame for given orientation.
    /// Due an open [issue](https://openradar.appspot.com/31529903). Coordinates works correctly only in portrait orientation.
    ///
    /// - Parameters:
    ///   - orientation: Device
    ///   - app: Application instance to use when searching for keyboard to avoid.
    /// - Returns: Calculated frame for given orientation.
    func frame(for orientation: UIDeviceOrientation, in app: XCUIApplication) -> CGRect {

        // Supports only landscape left, landscape right and upside down.
        // For all other unsupported orientations the default frame returned.
        guard orientation == .landscapeLeft
            || orientation == .landscapeRight
            || orientation == .portraitUpsideDown else {
                return frame
        }

        switch orientation {
        case .landscapeLeft:
            return CGRect(x: frame.minY, y: app.frame.width - frame.maxX, width: frame.height, height: frame.width)
        case .landscapeRight:
            return CGRect(x: app.frame.height - frame.maxY, y: frame.minX, width: frame.height, height: frame.width)
        case .portraitUpsideDown:
            return CGRect(x: app.frame.width - frame.maxX, y: app.frame.height - frame.maxY, width: frame.width, height: frame.height)
        default:
            preconditionFailure("Not supported orientation")
        }
    }
}

public enum AvoidableElement {
    /// Equivalent of `UINavigationBar`.
    case navigationBar
    /// Equivalent of `UIKeyboard`.
    case keyboard
    /// Equivalent of user defined `XCUIElement` with `CGRectEdge` on which it appears.
    case other(element: XCUIElement, edge: CGRectEdge)

    /// Edge on which `XCUIElement` appears.
    var edge: CGRectEdge {
        switch self {
        case .navigationBar: return .minYEdge
        case .keyboard: return .maxYEdge
        case .other(_, let edge): return edge
        }
    }

    /// Finds `XCUIElement` depending on case.
    ///
    /// - Parameter app: XCUIAppliaction to search through, `XCUIApplication()` by default.
    /// - Returns: `XCUIElement` equivalent of enum case.
    func element(in app: XCUIApplication = XCUIApplication()) -> XCUIElement {
        switch self {
        case .navigationBar: return app.navigationBars.element
        case .keyboard: return app.keyboards.element
        case .other(let element, _): return element
        }
    }

    /// Calculates rect that reminds scrollable through substract overlaping part of `XCUIElement`.
    ///
    /// - Parameters:
    ///   - rect: CGRect that is overlapped.
    ///   - app: XCUIApplication in which overlapping element can be found.
    /// - Returns: Part of rect not overlapped by element.
    func overlapReminder(of rect: CGRect, in app: XCUIApplication, orientation: UIDeviceOrientation) -> CGRect {

        let overlappingElement = element(in: app)
        guard overlappingElement.exists else { return rect }

        let overlappingElementFrame: CGRect
        if case .keyboard = self {
            overlappingElementFrame = overlappingElement.frame(for: orientation, in: app)
        } else {
            overlappingElementFrame = overlappingElement.frame
        }
        let overlap: CGFloat

        switch edge {
        case .maxYEdge:
            overlap = rect.maxY - overlappingElementFrame.minY
        case .minYEdge:
            overlap = overlappingElementFrame.maxY - rect.minY
        default:
            return rect
        }

        return rect.divided(atDistance: max(overlap, 0),
                            from: edge).remainder
    }
}

public enum SwipeDirection {
    case up
    case down
    case left
    case right
}

public func assertSnapshot<Value, Format>(
  matching value: @autoclosure () throws -> Value,
  as snapshotting: Snapshotting<Value, Format>,
  named name: String? = nil,
  record recording: Bool = false,
  timeout: TimeInterval = 5,
  file: StaticString = #file,
  testName: String = #function,
  line: UInt = #line
  ) {

  let failure = verifySnapshot(
    matching: try value(),
    as: snapshotting,
    named: name,
    record: recording,
    timeout: timeout,
    file: file,
    testName: testName,
    line: line
  )
  guard let message = failure, !recording else { return }
  XCTFail(message, file: file, line: line)
}
