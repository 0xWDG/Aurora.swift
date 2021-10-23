// Aurora framework for Swift
//
// The **Aurora.framework** contains a base for your project.
//
// It has a lot of extensions built-in to make development easier.
//
// - Version: 1.0
// - Copyright: [Wesley de Groot](https://wesleydegroot.nl) ([WDGWV](https://wdgwv.com))\
//  and [Contributors](https://github.com/AuroraFramework/Aurora.swift/graphs/contributors).
//
// Thanks for using!
//
// Licence: MIT

import Foundation

/// Promise sometthing
class Promise<Value> {
    /// Promise state
    enum State<T> {
        case pending
        case resolved(T)
        case failed(T)
    }

    /// On which state we are
    private var state: State<Value> = .pending

    /// What (resolved) callbacks are waiting
    private var callbacksOnResolved: [(Value) -> Void] = []

    /// What (error) callbacks are waiting
    private var callbacksOnError: [(Value) -> Void] = []

    /// Initialize executor
    /// - Parameter executor: executor
    init(executor: (_ resolve: @escaping (Value) -> Void) -> Void) {
        executor(resolve)
    }

    /// Observe
    /// - Parameter onResolved: on promise resolved
    public func then(_ onResolved: @escaping (Value) -> Void) {
        callbacksOnResolved.append(onResolved)
        triggerCallbacks()
    }

    /// flatMap
    /// - Parameter onResolved: on promise resolved
    /// - Returns: Promise
    public func then<NewValue>(_ onResolved: @escaping (Value) -> Promise<NewValue>) -> Promise<NewValue> {
        return Promise<NewValue> { resolve in
            then { value in
                onResolved(value).then(resolve)
            }
        }
    }

    /// map
    /// - Parameter onResolved: on promise resolved
    /// - Returns: Promise
    public func then<NewValue>(_ onResolved: @escaping (Value) -> NewValue) -> Promise<NewValue> {
        return then { value in
            return Promise<NewValue> { resolve in
                resolve(onResolved(value))
            }
        }
    }

    /// On error
    /// - Parameter onFailure: block to run on error
    public func onError(_ onFailure: @escaping (Value) -> Void) {
        callbacksOnError.append(onFailure)
        triggerCallbacks()
    }

    /// On Failure
    /// - Parameter onFailure: block to run on failure
    public func onFailure(_ onFailure: @escaping (Value) -> Void) {
        callbacksOnError.append(onFailure)
        triggerCallbacks()
    }

    /// Validate expression
    /// - Parameter expression: expression
    public func validate(_ expression: @escaping (Value) -> Bool) {

    }

    /// Resolve
    /// - Parameter value: value
    private func resolve(value: Value) {
        updateState(to: .resolved(value))
    }

    /// Fail
    /// - Parameter value: Failed
    private func fail(value: Value) {
        updateState(to: .failed(value))
    }

    /// Update state
    /// - Parameter newState: new state
    private func updateState(to newState: State<Value>) {
        guard case .pending = state else { return }
        state = newState
        triggerCallbacks()
    }

    /// Trigger all the callbacks
    private func triggerCallbacks() {
        callbacksForResolved()
        callbacksForFailed()
    }

    /// Execute callbacks for resolved
    private func callbacksForResolved() {
        guard case let .resolved(value) = state else { return }

        callbacksOnResolved.forEach { callback in
            callback(value)
        }

        callbacksOnResolved.removeAll()
    }

    /// Execute callbacks for failed promises
    private func callbacksForFailed() {
        guard case let .failed(value) = state else { return }

        callbacksOnError.forEach { callback in
            callback(value)
        }

        callbacksOnError.removeAll()
    }
}
