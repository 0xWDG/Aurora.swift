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

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI
import UIKit

public struct AttributedText: View {
    @State private var size: CGSize = .zero
    let attributedString: NSAttributedString

    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    init(HTML: String) {
        if let HTMLData = HTML.data(using: .utf8),
           let attributedString = try? NSAttributedString(
            data: HTMLData,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
           ) {
            self.init(attributedString)
            return
        }

        self.init(.init(string: "Failed to decode HTML"))
    }

    var body: some View {
        AttributedTextRepresentable(attributedString: attributedString, size: $size)
            .frame(width: size.width, height: size.height)
    }

    struct AttributedTextRepresentable: UIViewRepresentable {
        let attributedString: NSAttributedString
        @Binding var size: CGSize

        func makeUIView(context: Context) -> UILabel {
            let label = UILabel()

            label.lineBreakMode = .byClipping
            label.numberOfLines = 0

            return label
        }

        func updateUIView(_ uiView: UILabel, context: Context) {
            uiView.attributedText = attributedString

            DispatchQueue.main.async {
                size = uiView.sizeThatFits(uiView.superview?.bounds.size ?? .zero)
            }
        }
    }
}
#endif
