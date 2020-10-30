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
import Beagle
import BeagleSchema

class BeagleControllerSpy: BeagleController {
    
    var dependencies: BeagleDependenciesProtocol = Beagle.dependencies
    var serverDrivenState: ServerDrivenState = .finished
    var screenType: ScreenType = .declarativeText("")
    var screen: Screen?
    
    var expectation: XCTestExpectation?
    
    var bindings: [() -> Void] = []
    
    func execute(action: RawAction, sender: Any) { }
    
    private(set) var didCalledExecute = false
    private(set) var lastImplicitContext: Context?
    
    func addOnInit(_ onInit: [RawAction], in view: UIView) {
        execute(actions: onInit, origin: view)
    }
    
    func addBinding<T: Decodable>(expression: ContextExpression, in view: UIView, update: @escaping (T?) -> Void) {
        // Intentionally unimplemented...
    }
    
    func execute(actions: [RawAction]?, origin: UIView) {
        didCalledExecute = true
        expectation?.fulfill()
    }
    
    func execute(actions: [RawAction]?, with contextId: String, and contextValue: DynamicObject, origin: UIView) {
        lastImplicitContext = Context(id: contextId, value: contextValue)
        didCalledExecute = true
        expectation?.fulfill()
    }
    
}
