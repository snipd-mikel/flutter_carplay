//
//  FCPTabBarTemplate.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPTabBarTemplate {
  private(set) lazy var cpInstance: CPTabBarTemplate = {
    let tabBarTemplate = CPTabBarTemplate.init(templates: templates.map({$0.cpInstance}))
    tabBarTemplate.tabTitle = title
    return tabBarTemplate
  }()
  private(set) var elementId: String
  private var title: String?
  private var templates: [FCPListTemplate]
  
  init(message: FCPTabBarTemplateMessage) {
    elementId = message.elementId
    title = message.title
    templates = message.templates.map {
      FCPListTemplate(message: $0, templateType: FCPListTemplateType.PART_OF_GRID_TEMPLATE)
    }
   
  }
  
  public func getTemplates() -> [FCPListTemplate] {
    return templates
  }
}

@available(iOS 14.0, *)
extension FCPTabBarTemplate: FCPRootTemplate {
  func getCPTemplate() -> CPTemplate {
    return cpInstance
  }
  
  
  var children: [FCPObject] {
    return templates
  }
}
