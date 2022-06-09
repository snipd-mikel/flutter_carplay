//
//  FCPAlertTemplate.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPAlertTemplate {
  private(set) lazy var cpInstance: CPAlertTemplate = {
    return CPAlertTemplate.init(titleVariants: titleVariants, actions: actions.map({$0.cpInstance}))
  }()
  private(set) var elementId: String
  private var titleVariants: [String]
  private var actions: [FCPAlertAction]
  
  init(message: FCPAlertTemplateMessage) {
    elementId = message.elementId
    titleVariants = message.titleVariants
    actions = message.actions.map {
      FCPAlertAction(message: $0, type: FCPAlertActionType.ALERT)
    }
  }
}

@available(iOS 14.0, *)
extension FCPAlertTemplate: FCPPresentTemplate {
  var children: [FCPObject] {
    return actions
  }
}
