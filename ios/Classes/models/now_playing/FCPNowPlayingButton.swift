//
//  FCPNowPlayingButton.swift
//  flutter_carplay
//
//  Created by Mikel Corcuera on 09.06.22.
//

import CarPlay

@available(iOS 14.0, *)
protocol FCPNowPlayingButtonProtocol {
  func getCPNowPlayingButton() -> CPNowPlayingButton;
}

@available(iOS 14.0, *)
class FCPNowPlayingButton : FCPNowPlayingButtonProtocol {
  func getCPNowPlayingButton() -> CPNowPlayingButton {
    return CPNowPlayingButton.init(handler: handler)
  }
  
  init(isEnabled: Bool, isSelected: Bool, elementId: String) {
    self.elementId =  elementId
    self.isEnabled = isEnabled
    self.isSelected = isSelected
  }
  open var isEnabled: Bool
  open var isSelected: Bool
  private(set) var elementId: String
  
  func handler(_: CPNowPlayingButton) {
    DispatchQueue.main.async {
      SwiftFlutterCarplayPlugin.shared.onNowPlayingButtonPressed(self.elementId)
    }
  }
  static func createNowPlayingButton(_ message: FCPNowPlayingButtonMessage) -> FCPNowPlayingButton? {
    if message.imageButton != nil {
      return FCPNowPlayingImageButton(message: message.imageButton!)
    }
    return nil
  }
}

@available(iOS 14.0, *)
class FCPNowPlayingImageButton : FCPNowPlayingButton {
  override func getCPNowPlayingButton() -> CPNowPlayingButton {
    return self.cpInstance
  }
  
  private(set) lazy var cpInstance: CPNowPlayingButton = {
    let image = image.toUIImage(size: CPNowPlayingButtonMaximumImageSize)
    return CPNowPlayingImageButton.init(image: image, handler: handler)
  }()
  
  private var image: FCPImage
  
  init(message: FCPNowPlayingImageButtonMessage) {
    image = message.image.toFCPImage()
    super.init(isEnabled: message.isEnabled.boolValue, isSelected: message.isSelected.boolValue, elementId: message.elementId)
  }
}

@available(iOS 14.0, *)
extension FCPNowPlayingButton: FCPObject {
  var children: [FCPObject] {
    return []
  }
}
