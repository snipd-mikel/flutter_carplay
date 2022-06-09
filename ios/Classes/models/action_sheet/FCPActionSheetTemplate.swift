//
//  FCPActionSheetTemplate.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 25.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPActionSheetTemplate {
  private(set) lazy var cpInstance: CPActionSheetTemplate = {
    return CPActionSheetTemplate.init(title: title, message: self.message, actions: actions.map({$0.cpInstance}))
  }()
  private(set) var _super: CPActionSheetTemplate?
  private(set) var elementId: String
  private var title: String?
  private var message: String?
  private var actions: [FCPAlertAction]
  
  init(message: FCPActionSheetTemplateMessage) {
    elementId = message.elementId
    title = message.title
    self.message = message.message
    actions = message.actions.map({FCPAlertAction(message: $0, type: FCPAlertActionType.ACTION_SHEET)})
  }
}

@available(iOS 14.0, *)
extension FCPActionSheetTemplate: FCPPresentTemplate {
  var children: [FCPObject] {
    return actions
  }
}
