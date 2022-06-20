//
//  FCPImage.swift
//  flutter_carplay
//
//  Created by Mikel Corcuera on 14.06.22.
//


@available(iOS 14.0, *)
enum FCPImage {
  case systemName(String)
  case flutterAsset(String)
  case data(Data)
  case unknown
  
  static func fromMessage(_ message: FCPImageMessage) -> FCPImage {
    if message.flutterAsset != nil {
      return FCPImage.flutterAsset(message.flutterAsset!)
    }
    if message.systemName != nil {
      return FCPImage.systemName(message.systemName!)
    }
    if message.data != nil {
      return FCPImage.data(message.data!.data)
    }
    
    return FCPImage.unknown
  }
  
  func toUIImage(size: CGSize? = nil) -> UIImage {
    switch (self) {
      
    case .systemName(let systemName):
      return UIImage(systemName: systemName) ?? UIImage(systemName: "questionmark")!
    case .flutterAsset(let flutterAsset):
      let image = UIImage().fromFlutterAsset(name: flutterAsset)
      guard let size = size else {
        return image
      }
      return image.scalePreservingAspectRatio(targetSize: size)
    case .data(let data):
      guard let image = UIImage(data: data) else {
        return UIImage(systemName: "questionmark")!
      }

      guard let size = size else {
        return image
      }
      
      return image.scalePreservingAspectRatio(targetSize: size)
    case .unknown:
      return UIImage(systemName: "questionmark")!
    }
  }
}


@available(iOS 14.0, *)
extension FCPImageMessage {
  func toFCPImage() -> FCPImage {
    return FCPImage.fromMessage(self)
  }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
