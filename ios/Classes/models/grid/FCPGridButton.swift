//
//  FCPGridButton.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPGridButton {
  private(set) lazy var cpInstance: CPGridButton = {
    let gridButton = CPGridButton.init(titleVariants: titleVariants,
                                       image: image.toUIImage(),
                                       handler: { _ in
      DispatchQueue.main.async {
        SwiftFlutterCarplayPlugin.shared.onGridButtonPressed(self.elementId)
      }
    })
    gridButton.isEnabled = true
    return gridButton
  }()
  private(set) var elementId: String
  private var titleVariants: [String]
  private var image: FCPImage
  
  init(message: FCPGridButtonMessage) {
    elementId = message.elementId
    titleVariants = message.titleVariants
    image = message.image.toFCPImage()
  }
}

@available(iOS 14.0, *)
extension FCPGridButton: FCPObject {
  var children: [FCPObject] {
    return []
  }
}
