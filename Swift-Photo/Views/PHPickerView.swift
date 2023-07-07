//
//  PHPickerView.swift
//  Swift-Photo
//
//  Created by k2hoon on 2023/07/08.
//

import Foundation
import SwiftUI
import PhotosUI


// https://developer.apple.com/documentation/photokit/phpickerviewcontroller
struct PHPickerView: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images // .any(of: [.images, .livePhotos, .videos])
        config.selectionLimit = 2
        config.selection = .ordered // this option shows numbers in order.
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PHPickerView
        
        init(_ parent: PHPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else {
                return
            }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    if let image = image as? UIImage {
                        
                    }
                }
            }
        }
    }
}

// https://developer.apple.com/documentation/uikit/uiimagepickercontroller
//struct ImagePickerView: UIViewControllerRepresentable {
//
//    @Binding var selectedImage: UIImage?
//    @Environment(\.presentationMode) var isPresented
//    var sourceType: UIImagePickerController.SourceType
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let imagePicker = UIImagePickerController()
//        imagePicker.sourceType = self.sourceType
//        imagePicker.delegate = context.coordinator
//        return imagePicker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//
//    }
//
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        var parent: ImagePickerView
//
//        init(_ parent: ImagePickerView) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            guard let selectedImage = info[.originalImage] as? UIImage else { return }
//            self.parent.selectedImage = selectedImage
//            self.parent.isPresented.wrappedValue.dismiss()
//        }
//
//    }
//}
