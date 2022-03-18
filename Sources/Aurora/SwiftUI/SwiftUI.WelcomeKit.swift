//
//  SwiftUI.WelcomeView.swift
//  
//
//  Created by Wesley de Groot on 18/03/2022.
//
// Original coming from: https://github.com/JaydenIrwin/WelcomeKit

#if canImport(SwiftUI) && os(iOS)
import SwiftUI

public struct WelcomeFeature: Identifiable {
    public var image: Image
    public var title: String
    public var body: String
    public var id: String {
        title
    }

    public init(image: Image, title: String, body: String) {
        self.image = image
        self.title = title
        self.body = body
    }
}

@available(macOS 11.0, *, iOS 14, *)
public struct WelcomeView: View {
    public static let continueNotification = Notification.Name(
        "Aurora.Welcome.Continue"
    )

    public let isFirstLaunch: Bool
    public let appName: String
    public let features: [WelcomeFeature]

    @Environment(\.presentationMode) var presentationMode

    @State var animationCompleted = false

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 28) {
                Text(isFirstLaunch
                     ? "Welcome to \(appName)"
                     : "What's New in \(appName)"
                )
                .font(Font.system(size: 36, weight: .bold))
                .multilineTextAlignment(.center)
                Spacer()
                VStack(
                    alignment: .leading,
                    spacing: animationCompleted ? 28 : 150
                ) {
                    ForEach(features) { feature in
                        WelcomeFeatureView(feature: feature)
                    }
                }
                .frame(
                    idealWidth: 400,
                    maxWidth: 400)
                Spacer()
                Button(
                    action: {
                        self.presentationMode.wrappedValue.dismiss()
                        NotificationCenter.default.post(
                            name: WelcomeView.continueNotification,
                            object: nil
                        )
                    },
                    label: {
                        Text("Continue")
                            .font(.headline)
                            .frame(idealWidth: 340, maxWidth: 340)
                    })
                //                .buttonStyle(.borderedProminent)
                //                .controlSize(.large)
            }
            .padding(.vertical, 64)
            .padding(.horizontal, 32)
            .frame(
                width: geometry.size.width,
                height: animationCompleted
                ? nil
                : geometry.size.height * 2
            )
            .opacity(animationCompleted ? 1 : 0)
            .offset(x: 0, y: animationCompleted ? 0 : 75)
        }
        .onAppear {
            withAnimation(Animation.easeOut(duration: 0.6)) {
                animationCompleted = true
            }
        }
    }

    public init(isFirstLaunch: Bool, appName: String, features: [WelcomeFeature]) {
        self.isFirstLaunch = isFirstLaunch
        self.appName = appName.replacingOccurrences(
            of: " ", with: "\u{00a0}"
        )
        self.features = features
    }
}

@available(macOS 11.0, *, iOS 14, *)
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        let features = [
            WelcomeFeature(
                image: Image(systemName: "app.fill"),
                title: "Feature", body: "This feature is good."
            ),
            WelcomeFeature(
                image: Image(systemName: "app.fill"),
                title: "Feature", body: "This feature is good."
            ),
            WelcomeFeature(
                image: Image(systemName: "app.fill"),
                title: "Feature", body: "This feature is good."
            )
        ]

        return WelcomeView(
            isFirstLaunch: false,
            appName: "My App",
            features: features
        )
    }
}

@available(macOS 11.0, *, iOS 14, *)
public struct WelcomeFeatureView: View {
    @State var feature: WelcomeFeature

    public var body: some View {
        HStack(spacing: 12) {
            feature.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 54, height: 54)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title)
                    .font(.headline)
                Text(feature.body)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

@available(macOS 11.0, *, iOS 14, *)
struct WelcomeFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeFeatureView(
            feature: .init(
                image: Image(systemName: "app.fill"),
                title: "Feature",
                body: "This feature is good."
            )
        )
    }
}
#endif
