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
    let content: Content
    let blurStyle: UIBlurEffect.Style

    public init(title: String, blurStyle: UIBlurEffect.Style = .prominent, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
        self.blurStyle = blurStyle
    }

    var closeButton: some View {
        Image(systemName: "xmark")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .padding(.all, 5)
            .background(Color.black.opacity(0.6))
            .clipShape(Circle())
            .accessibility(label: Text("Close"))
            .accessibility(hint: Text("Tap to close the screen"))
            .accessibility(addTraits: .isButton)
            .accessibility(removeTraits: .isImage)
    }

    public var body: some View {
        VStack {
            HStack {
                Text(.init(title))
                    .font(.title)
                    .lineLimit(1)
                    .padding(.leading, 10)

                // To make it on the right
                Spacer()

                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: { self.closeButton })
            }.padding(5)

            // Custom Content
            self.content
                .padding(.top, 5)

            // Move everything up
            Spacer()
        }.background(
            Blur(style: blurStyle)
        )
    }
}

@available(macOS 11.0, *, iOS 15, *)
struct CardViewPreviews: PreviewProvider {
    static var previews: some View {
        CardView(title: "Title") {
            Text("Hello")
        }
    }

    static var previews2: some View {
        CardView(title: "Title", blurStyle: .regular) {
            Text("Hello")
        }
    }

}
#endif
