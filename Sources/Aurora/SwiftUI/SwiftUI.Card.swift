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

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 11.0, *, iOS 14, *)
public struct CardView<Content: View>: View {
    // To dismiss this screen using the button.
    @Environment(\.presentationMode) var presentationMode

    let title: String
    let subtitle: String?
    let content: Content

    public init(title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var closeButton: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
            .font(.system(size: 26))
            .accessibility(label: Text("Close"))
            .accessibility(hint: Text("Tap to close the screen"))
            .accessibility(addTraits: .isButton)
            .accessibility(removeTraits: .isImage)
    }

    public var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Custom Content
                    self.content
                        .padding(.top, 5)

                    // Move everything up
                    Spacer()
                }
            }.toolbar {
                ToolbarItem(placement: .navigation) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(.init(title))
                            .font(.headline)
                            .lineLimit(1)

                        if let subtitle = subtitle {
                            Text(.init(subtitle))
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        self.closeButton
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
    }
}

@available(macOS 11.0, *, iOS 14, *)
struct CardViewPreviews: PreviewProvider {
    static var previews: some View {
        CardView(title: "Title") {
            Text("Hello")
        }
    }

    static var previews2: some View {
        CardView(title: "Title", subtitle: "AAA") {
            Text("Hello")
        }
    }

}
#endif
