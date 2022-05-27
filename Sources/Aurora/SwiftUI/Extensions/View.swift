//
//  File.swift
//  
//
//  Created by Wesley de Groot on 27/05/2022.
//

#if canImport(SwiftUI)
import SwiftUI

extension View {
    /// Calls a block each time that view is reloaded
    ///
    ///     content.onReload(perform: {
    ///         print("onReload")
    ///     })
    ///
    /// - Returns: The same view but calling the block asynchronously when is reloaded
    @inlinable func onReload(perform: @escaping () -> Void) -> some View {
        DispatchQueue.main.async {
            perform()
        }
        return self
    }

    @ViewBuilder func hidden(_ hidden: Bool) -> some View {
        switch hidden {
        case true: self.hidden()
        case false: self
        }
    }

    /// Allows to execute a function whenever this view is rendered. This is a useful helper for debugging
    /// View state when rendering. Can be used to e.g. print something whenever this view is re-created
    /// (the body is accessed).
    ///
    /// Usage:
    ///
    ///     .debug {
    ///         print("Print something whenever view is rendered")
    ///     }
    ///
    /// - Parameter closure: Closure to execute whenever this view hierarchy is created.
    /// - Returns: The same view this was called, chainable.
    public func debug(_ closure: () -> Void) -> Self {
        closure()
        return self
    }
}

// MARK: Animations
public extension View {

    /// Animate an action with an animation on appear.
    ///
    ///    myView.animateOnAppear(using: .easeInOut) { self.scale = 0.5 }
    ///
    /// - Parameters:
    ///   - animation: animation to be applied
    ///   - action: action to be animated
    /// - Returns: some View
    @inlinable func animateOnAppear(using animation: Animation = .easeInOut,
                                    action: @escaping () -> Void) -> some View {
        return onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }

    /// Animate an action with an animation on disappear.
    ///
    ///    myView.animateOnDisappear(using: .easeInOut) { self.scale = 0.5 }
    ///
    /// - Parameters:
    ///   - animation: animation to be applied
    ///   - action: action to be animated
    /// - Returns: some View
    @inlinable func animateOnDisappear(using animation: Animation = .easeInOut,
                                       action: @escaping () -> Void) -> some View {
        return onDisappear {
            withAnimation(animation) {
                action()
            }
        }
    }


    @inlinable
    func then(_ body: (inout Self) -> Void) -> Self {
        var result = self
        body(&result)
        return result
    }

    /// Wraps view inside `AnyView`
    func embedInAnyView() -> AnyView {
        AnyView( self )
    }

    /// Wraps view inside `AnyView`
    func eraseToAnyView() -> AnyView { embedInAnyView() }

    /// Wraps view inside `NavigationView`
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
}

#if canImport(UIKit)
public extension View {
    func didAppear(perform action: (() -> Void)? = nil ) -> some View {
        self.overlay(AppearViewController(action: action).disabled(true))
    }

    func didDisapear(perform action: (() -> Void)? = nil ) -> some View {
        self.overlay(DisappearViewController(action: action).disabled(true))
    }
}

fileprivate struct AppearViewController: UIViewControllerRepresentable {
    let action: (() -> Void)?

    func makeUIViewController(context: Context) -> Controller {
        let vc = Controller()
        vc.action = action
        return vc
    }

    func updateUIViewController(_ controller: Controller, context: Context) {}

    class Controller: UIViewController {
        var action: (() -> Void)? = nil

        override func viewDidLoad() {
            view.addSubview(UILabel())
        }

        override func viewDidAppear(_ animated: Bool) {
            action?()
        }
    }
}

fileprivate struct DisappearViewController: UIViewControllerRepresentable {
    let action: (() -> Void)?

    func makeUIViewController(context: Context) -> Controller {
        let vc = Controller()
        vc.action = action
        return vc
    }

    func updateUIViewController(_ controller: Controller, context: Context) {}

    class Controller: UIViewController {
        var action: (() -> Void)? = nil

        override func viewDidLoad() {
            view.addSubview(UILabel())
        }

        override func viewWillDisappear(_ animated: Bool) {
            action?()
        }
    }
}
#endif
#endif
