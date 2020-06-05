//
//  File.swift
//  
//
//  Created by Wesley de Groot on 08/05/2020.
//

import Foundation

class Promise<Value> {
    enum State<T> {
        case pending
        case resolved(T)
        case failed(T)
    }
    
    /// On which state we are
    private var state: State<Value> = .pending
    
    /// What callbacks are waiting
    private var callbacksOnResolved: [(Value) -> Void] = []
    private var callbacksOnError: [(Value) -> Void] = []
    
    /// <#Description#>
    /// - Parameter executor: <#executor description#>
    init(executor: (_ resolve: @escaping (Value) -> Void) -> Void) {
        executor(resolve)
    }
    
    /// Observe
    /// - Parameter onResolved: <#onResolved description#>
    public func then(_ onResolved: @escaping (Value) -> Void) {
        callbacksOnResolved.append(onResolved)
        triggerCallbacks()
    }
    
    /// flatMap
    /// - Parameter onResolved: <#onResolved description#>
    /// - Returns: <#description#>
    public func then<NewValue>(_ onResolved: @escaping (Value) -> Promise<NewValue>) -> Promise<NewValue> {
        return Promise<NewValue> { resolve in
            then { value in
                onResolved(value).then(resolve)
            }
        }
    }
    
    /// map
    /// - Parameter onResolved: <#onResolved description#>
    /// - Returns: <#description#>
    public func then<NewValue>(_ onResolved: @escaping (Value) -> NewValue) -> Promise<NewValue> {
        return then { value in
            return Promise<NewValue> { resolve in
                resolve(onResolved(value))
            }
        }
    }
    
    /// <#Description#>
    /// - Parameter onFailure: <#onFailure description#>
    public func onError(_ onFailure: @escaping (Value) -> Void) {
        callbacksOnError.append(onFailure)
        triggerCallbacks()
    }
    
    /// <#Description#>
    /// - Parameter onFailure: <#onFailure description#>
    public func onFailure(_ onFailure: @escaping (Value) -> Void) {
        callbacksOnError.append(onFailure)
        triggerCallbacks()
    }
    
    /// <#Description#>
    /// - Parameter expression: <#expression description#>
    public func validate(_ expression: @escaping (Value) -> Bool) {
        
    }
    
    /// <#Description#>
    /// - Parameter value: <#value description#>
    private func resolve(value: Value) {
        updateState(to: .resolved(value))
    }
    
    /// <#Description#>
    /// - Parameter value: <#value description#>
    private func fail(value: Value) {
        updateState(to: .failed(value))
    }
    
    /// <#Description#>
    /// - Parameter newState: <#newState description#>
    private func updateState(to newState: State<Value>) {
        guard case .pending = state else { return }
        state = newState
        triggerCallbacks()
    }
    
    /// <#Description#>
    private func triggerCallbacks() {
        callbacksForResolved()
        callbacksForFailed()
    }
    
    /// <#Description#>
    private func callbacksForResolved() {
        guard case let .resolved(value) = state else { return }
        
        callbacksOnResolved.forEach { callback in
            callback(value)
        }
        
        callbacksOnResolved.removeAll()
    }
    
    /// <#Description#>
    private func callbacksForFailed() {
        guard case let .failed(value) = state else { return }
        
        callbacksOnError.forEach { callback in
            callback(value)
        }
        
        callbacksOnError.removeAll()
    }
}
