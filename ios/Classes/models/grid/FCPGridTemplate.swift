//
//  FCPGridTemplate.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPGridTemplate {
  private(set) lazy var cpInstance: CPGridTemplate = {
    return CPGridTemplate.init(title: title, gridButtons: buttons.map({$0.cpInstance}))
  } ()
  private(set) var elementId: String
  private var title: String
  private var buttons: [FCPGridButton]
  
  init(message: FCPGridTemplateMessage) {
    elementId = message.elementId
    title = message.title
    buttons = message.buttons.map {
      FCPGridButton(message: $0)
    }
  }
}

@available(iOS 14.0, *)
extension FCPGridTemplate: FCPRootTemplate {
  func getCPTemplate() -> CPTemplate {
    return cpInstance
  }
  
  var children: [FCPObject] {
    return buttons
  }
}
