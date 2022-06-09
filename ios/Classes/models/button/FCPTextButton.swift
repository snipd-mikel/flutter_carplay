//
//  FCPTextButton.swift
//  Runner
//
//  Created by Olaf Schneider on 17.02.22.
//

import CarPlay

@available(iOS 14.0, *)
class FCPTextButton {
  private(set) lazy var cpInstance: CPTextButton = {
    return CPTextButton.init(title: title, textStyle:style, handler: { _ in
      DispatchQueue.main.async {
        SwiftFlutterCarplayPlugin.shared.onTextButtonPressed(self.elementId)
      }
    })
  }()
  private(set) var elementId: String
  private var title: String
  private var style: CPTextButtonStyle
  
  init(message: FCPTextButtonMessage) {
    elementId = message.elementId
    title = message.title
    
    switch(message.style) {
    case .normal:
      style = .normal
    case .cancel:
      style = .cancel
    case .confirm:
      style = .confirm
    @unknown default:
      style = .normal
    }
  }
}


@available(iOS 14.0, *)
extension FCPTextButton: FCPObject {
  var children: [FCPObject] {
    return []
  }
}
