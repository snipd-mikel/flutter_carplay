//
//  FCPBarButton.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 25.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPBarButton {
  private(set) lazy var cpInstance: CPBarButton = {
    return CPBarButton.init(title: title, handler: { _ in
      DispatchQueue.main.async {
        SwiftFlutterCarplayPlugin.shared.onBarButtonPressed(self.elementId)
      }
    })
  } ()
  private(set) var elementId: String
  private var title: String
  private var style: CPBarButtonStyle
  
  init(message: FCPBarButtonMessage) {
    elementId = message.elementId
    title = message.title
    
    switch(message.style) {
    case .none:
      style = .none
    case .rounded:
      style = .rounded
    @unknown default:
      style = .none
    }
  }
  
}

@available(iOS 14.0, *)
extension FCPBarButton: FCPObject {
  var children: [FCPObject] {
    return []
  }
}
