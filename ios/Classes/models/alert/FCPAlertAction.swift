//
//  FCPAlertAction.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPAlertAction {
  private(set) lazy var cpInstance: CPAlertAction = {
    return CPAlertAction.init(title: title, style: style, handler: { _ in
      DispatchQueue.main.async {
        SwiftFlutterCarplayPlugin.shared.onAlertActionPressed(self.elementId)
      }
    })
  }()
  
  private(set) var elementId: String
  private var title: String
  private var style: CPAlertAction.Style
  private var handlerType: FCPAlertActionType
   
  init(message: FCPAlertActionMessage, type: FCPAlertActionType) {
    elementId = message.elementId
    title = message.title
    switch(message.style) {
    case .normal:
      style = .default
    case .cancel:
      style = .cancel
    case .destructive:
      style = .destructive
    @unknown default:
      style = .default
    }
    handlerType = type
  }
}

@available(iOS 14.0, *)
extension FCPAlertAction: FCPObject {
  var children: [FCPObject] {
    return []
  }
}
