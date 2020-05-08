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
    private var callbacks_onResolved: [(Value) -> Void] = []
    private var callbacks_onError: [(Value) -> Void] = []
    
    init(executor: (_ resolve: @escaping (Value) -> Void) -> Void) {
        executor(resolve)
    }
    
    // observe
    public func then(_ onResolved: @escaping (Value) -> Void) {
        callbacks_onResolved.append(onResolved)
        triggerCallbacks()
    }
    
    // flatMap
    public func then<NewValue>(_ onResolved: @escaping (Value) -> Promise<NewValue>) -> Promise<NewValue> {
        return Promise<NewValue> { resolve in
            then { value in
                onResolved(value).then(resolve)
            }
        }
    }
    
    // map
    public func then<NewValue>(_ onResolved: @escaping (Value) -> NewValue) -> Promise<NewValue> {
        return then { value in
            return Promise<NewValue> { resolve in
                resolve(onResolved(value))
            }
        }
    }
    
    public func onError(_ onFailure: @escaping (Value) -> Void) {
        callbacks_onError.append(onFailure)
        triggerCallbacks()
    }
    
    public func onFailure(_ onFailure: @escaping (Value) -> Void) {
        callbacks_onError.append(onFailure)
        triggerCallbacks()
    }

    
    public func validate(_ expression: @escaping (Value) -> Bool) {
        
    }
    
    private func resolve(value: Value) {
        updateState(to: .resolved(value))
    }

    private func fail(value: Value) {
        updateState(to: .failed(value))
    }
    
    private func updateState(to newState: State<Value>) {
        guard case .pending = state else { return }
        state = newState
        triggerCallbacks()
    }
    
    private func triggerCallbacks() {
        callbacksForResolved()
        callbacksForFailed()
    }
    
    private func callbacksForResolved() {
        guard case let .resolved(value) = state else { return }
        
        callbacks_onResolved.forEach { callback in
            callback(value)
        }
        
        callbacks_onResolved.removeAll()
    }
    
    private func callbacksForFailed() {
        guard case let .failed(value) = state else { return }
        
        callbacks_onError.forEach { callback in
            callback(value)
        }
        
        callbacks_onError.removeAll()
    }
}
