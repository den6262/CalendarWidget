
import SwiftUI
import UnsplashPhotoPicker

/// Photo picker from Unsplash
struct UnsplashImagePicker: UIViewControllerRepresentable {
    
    var selectedImage: (_ image: UIImage?) -> Void
    
    let config = UnsplashPhotoPickerConfiguration(accessKey: Constants.accessKey, secretKey: Constants.secretKey, allowsMultipleSelection: false)
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UnsplashImagePicker>) -> UnsplashPhotoPicker {
        let unsplashPhotoPicker = UnsplashPhotoPicker(configuration: config)
        unsplashPhotoPicker.photoPickerDelegate = context.coordinator
        return unsplashPhotoPicker
    }
    
    func makeCoordinator() -> UnsplashImagePicker.Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: UnsplashPhotoPickerDelegate {
        
        var parent: UnsplashImagePicker
        
        init(_ parent: UnsplashImagePicker) {
            self.parent = parent
        }
        
        func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
            if let url = photos.first?.urls[.thumb] {
                URLSession.shared.dataTask(with: url) { (data, _, _) in
                    if let imageData = data {
                        self.parent.selectedImage(UIImage(data: imageData))
                    }
                }.resume()
            }
        }
        
        func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) { }
    }
    
    func updateUIViewController(_ uiViewController: UnsplashPhotoPicker, context: UIViewControllerRepresentableContext<UnsplashImagePicker>) {
    }
}
