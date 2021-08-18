// $$HEADER$$

#if canImport(QuartzCore) && canImport(UIKit)

import UIKit
import QuartzCore

/// Create a toast view (like  Watch unlocked, Paired AirPods)
///
///     ToastView(
///       title: "Warning",
///       subtitle: "This is not good?",
///       icon: UIImage.init(systemName: "exclamationmark.triangle"),
///       iconColor: .orange,
///       haptic: .warning
///       onTap: nil
///     )
@available(iOS 13.0, *)
// swiftlint:disable:next type_body_length
public class ToastView: UIView {
    /// Toast bounds
    override public var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    /// Set the toast height
    private let toastHeight: CGFloat = 50

    /// Create a horizontal stack
    private var hStack: UIStackView = UIStackView(frame: CGRect.zero)

    /// Default dark background color
    private let darkBackgroundColor = UIColor(
        red: 0.13,
        green: 0.13,
        blue: 0.13,
        alpha: 1.00
    )

    /// Default light background color
    private let lightBackgroundColor = UIColor(
        red: 0.99,
        green: 0.99,
        blue: 0.99,
        alpha: 1.00
    )

    // Background color of toast?
    private var viewBackgroundColor: UIColor? {
        return traitCollection.userInterfaceStyle == .dark ? darkBackgroundColor : lightBackgroundColor
    }

    /// What to execute on TAP
    private var onTap: (() -> Void)?

    /// Hide the view automatically after showing ?
    public var autoHide = true

    /// Display time for the notification view in seconds
    public var displayTime: TimeInterval = 5

    /// Hide the view automatically on tap ?
    public var hideOnTap = true

    /// Create a toast view (like  Watch unlocked, Paired AirPods)
    ///
    /// - Parameters:
    ///   - title: Title to display
    ///   - subtitle: Subtitle to display
    ///   - icon: Icon (if any)
    ///   - iconColor: Icon color (if an icon)
    ///   - haptic: Haptic feedback
    ///   - onTap: What to do on tap?
    @discardableResult
    public init(title: String,
                subtitle: String? = nil,
                icon: UIImage? = nil,
                iconColor: UIColor? = .label,
                haptic: UINotificationFeedbackGenerator.FeedbackType?,
                onTap: (() -> Void)? = nil
    ) {
        super.init(frame: CGRect.zero)

        backgroundColor = viewBackgroundColor

        getTopViewController()?.view.addSubview(self)

        hStack = UIStackView(frame: CGRect.zero).configure {
            $0.spacing = 16
            $0.axis = .horizontal
            $0.alignment = .center
        }

        let vStack = UIStackView(frame: CGRect.zero).configure {
            $0.axis = .vertical
            $0.alignment = .center
        }

        let titleLabel = UILabel(frame: CGRect.zero).configure {
            $0.numberOfLines = 1
            $0.font = .systemFont(ofSize: 13, weight: .regular)
            $0.text = title
        }

        vStack.addArrangedSubview(titleLabel)

        if let icon = icon {
            let iconImageView = UIImageView(
                frame: CGRect(x: 0, y: 0, width: 28, height: 28)
            )

            iconImageView.tintColor = iconColor ?? .label

            iconImageView.image = icon.withRenderingMode(.alwaysTemplate)
            hStack.addArrangedSubview(iconImageView)
        }

        if let subtitle = subtitle {
            let subtitleLabel = UILabel.init().configure {
                $0.textColor = .secondaryLabel
                $0.numberOfLines = 1
                $0.font = .systemFont(ofSize: 11, weight: .light)
                $0.text = subtitle
            }

            vStack.addArrangedSubview(subtitleLabel)
        }

        self.onTap = onTap
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap)
        )

        addGestureRecognizer(tapGestureRecognizer)

        hStack.addArrangedSubview(vStack)
        addSubview(hStack)

        setupConstraints()
        setupStackViewConstraints()

        transform = CGAffineTransform(translationX: 0, y: -100)

        if let hapticType = haptic {
            UINotificationFeedbackGenerator().notificationOccurred(hapticType)
        }

        addAnimation()
    }

    /// Add the animations
    private func addAnimation() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.transform = .identity
            },
            completion: { [self] _ in
                if autoHide {
                    hide(after: displayTime)
                }
            }
        )
    }

    /// Hide toast after some time
    /// - Parameter time: time
    public func hide(after time: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseOut,
                animations: { self.transform = CGAffineTransform(translationX: 0, y: -100) },
                completion: { _ in
                    self.removeFromSuperview()
                }
            )
        })
    }

    /// Called when the iOS interface environment changes.
    /// - Parameter previousTraitCollection: The UITraitCollection object before the interface environment changed.
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        backgroundColor = viewBackgroundColor
    }

    /// Get the top most UIViewController
    /// - Returns: UIViewController
    private func getTopViewController() -> UIViewController? {
        let windows = UIApplication.shared.windows
        let keyWindow = windows.count == 1
            ? windows.first
            : windows.first(where: {
                $0.isKeyWindow
            })

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        } else {
            return nil
        }
    }

    /// Setup constraints
    // swiftlint:disable:next function_body_length
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        let heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: toastHeight
        )

        let centerConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: superview,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )

        // Height from top defaults to 10
        let topConstraint = NSLayoutConstraint(
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: superview,
            attribute: .topMargin,
            multiplier: 1,
            constant: 10
        )

        let leadingConstraint = NSLayoutConstraint(
            item: self, attribute: .leading,
            relatedBy: .greaterThanOrEqual,
            toItem: superview,
            attribute: .leadingMargin,
            multiplier: 1, constant: 8
        )

        let trailingConstraint = NSLayoutConstraint(
            item: self,
            attribute: .trailing,
            relatedBy: .lessThanOrEqual,
            toItem: superview,
            attribute: .trailingMargin,
            multiplier: 1,
            constant: -8
        )

        clipsToBounds = true
        layer.cornerRadius = toastHeight / 2
        superview?.addConstraints([
            heightConstraint,
            leadingConstraint,
            trailingConstraint,
            centerConstraint,
            topConstraint
        ])
    }

    /// Setup StackView constraints
    private func setupStackViewConstraints() {
        hStack.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(
            item: hStack,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1,
            constant: 24
        )

        let trailingConstraint = NSLayoutConstraint(
            item: hStack,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1,
            constant: -24
        )

        let topConstraint = NSLayoutConstraint(
            item: hStack,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )

        let bottomConstraint = NSLayoutConstraint(
            item: hStack,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )

        addConstraints([
            leadingConstraint,
            trailingConstraint,
            topConstraint,
            bottomConstraint
        ])
    }

    /// Setup shadow
    private func setupShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 1
    }

    /// Did tap on toast
    @objc private func didTap() {
        if hideOnTap {
            hide(after: 0)
        }
        onTap?()
    }

    /// Init
    /// - Parameter coder: An abstract class that serves as the basis for objects that\
    ///  enable archiving and distribution of other objects.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// swiftlint:disable:last type_body_length
#endif
