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

// MARK: - Dependency Protocol
public protocol DependencyAnalyticsExecutor {
    var analytics: Analytics? { get }
    var analyticsProvider: AnalyticsProvider? { get }
}

// MARK: - Executor Protocol
public protocol Analytics {
    func trackEventOnScreenAppeared(_ event: AnalyticsScreen)
    func trackEventOnScreenDisappeared(_ event: AnalyticsScreen)
    func trackEventOnClick(_ event: AnalyticsClick)
}

// MARK: - Analytics 2
public protocol AnalyticsProvider {
    var getConfig: (@escaping (Result<AnalyticsConfig, Error>) -> Void) -> Void { get }
    var startSession: (@escaping (Result<Void, Error>) -> Void) -> Void { get }
    var maximumItemsInQueue: Int? { get }
    
    func createRecord(_ record: AnalyticsRecord)
}
