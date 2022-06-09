//
//  FCPPointOfInterestTemplate.swift
//  flutter_carplay
//
//  Created by Olaf Schneider on 15.02.22.
//

import CarPlay

@available(iOS 14.0, *)
class FCPInformationTemplate {
  private(set) lazy var cpInstance: CPInformationTemplate = {
    return CPInformationTemplate.init(title: title, layout: layout, items: informationItems.map({$0.cpInstance}), actions: actions.map({$0.cpInstance}))
  }()
  private(set) var elementId: String
  private var title: String
  private var layout: CPInformationTemplateLayout
  
  private var informationItems: [FCPInformationItem]
  private var actions: [FCPTextButton]
  
  init(message: FCPInformationTemplateMessage) {
    elementId = message.elementId
    switch(message.layout) {
      
    case .leading:
      layout = .leading
    case .twoColumn:
      layout = .twoColumn
    @unknown default:
      layout = .leading
    }
    
    title = message.title
    
    informationItems = message.informationItems.map {
      FCPInformationItem(message: $0)
    }
    
    actions = message.actions.map {
      FCPTextButton(message: $0)
    }
    
  }
  
}
@available(iOS 14.0, *)
extension FCPInformationTemplate: FCPRootTemplate {
  func getCPTemplate() -> CPTemplate {
    return cpInstance
  }
  
  var children: [FCPObject] {
    return actions + informationItems
  }
}


