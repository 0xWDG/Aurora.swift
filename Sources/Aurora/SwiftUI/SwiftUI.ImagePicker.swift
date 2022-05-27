//
//  File.swift
//  
//
//  Created by Wesley de Groot on 27/05/2022.
//

#if canImport(SwiftUI)
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: Image?

    func updateUIViewController(_: UIImagePickerController,
                                context _: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> ImagePickerCordinator {
        return ImagePickerCordinator(isShown: $isShown, image: $image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
}

class ImagePickerCordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isShown: Bool
    @Binding var image: Image?

    init(isShown: Binding<Bool>, image: Binding<Image?>) {
        _isShown = isShown
        _image = image
    }

    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            isShown = false
            return
        }
        image = Image(uiImage: uiImage)
        isShown = false
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        isShown = false
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker(isShown: .constant(true), image: .constant(Image(systemName: "cloud")))
    }
}
#endif
