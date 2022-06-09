//
//  FCPListTemplate.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPListTemplate {
  private(set) lazy var cpInstance: CPListTemplate = {
    let listTemplate = CPListTemplate.init(title: title, sections: sections.map({$0.cpInstance}))
    listTemplate.emptyViewTitleVariants = emptyViewTitleVariants
    listTemplate.emptyViewSubtitleVariants = emptyViewSubtitleVariants
    listTemplate.showsTabBadge = showsTabBadge
    listTemplate.tabImage = UIImage(systemName: systemIcon)
    if (templateType == FCPListTemplateType.DEFAULT) {
      listTemplate.backButton = backButton?.cpInstance
    }
    return listTemplate
  }()
  private(set) var elementId: String
  private var title: String?
  private var systemIcon: String
  private var sections: [FCPListSection] = []
  private var emptyViewTitleVariants: [String] = []
  private var emptyViewSubtitleVariants: [String] = []
  private var showsTabBadge: Bool = false
  private var templateType: FCPListTemplateType
  private var backButton: FCPBarButton?
  
  init(message: FCPListTemplateMessage, templateType: FCPListTemplateType) {
    elementId = message.elementId
    title = message.title
    systemIcon = message.systemIcon
    emptyViewTitleVariants = message.emptyViewTitleVariants ?? []
    emptyViewSubtitleVariants = message.emptyViewSubtitleVariants ?? []
    showsTabBadge = message.showsTabBadge.boolValue
    self.templateType = templateType
    sections = message.sections.map {
      FCPListSection(message: $0)
    }
    let backButtonData = message.backButton
    if backButtonData != nil {
      backButton = FCPBarButton(message: backButtonData!)
    }
    
  }

  
  public func getSections() -> [FCPListSection] {
    return sections
  }
  
  public func updateSections(_ newSections: [FCPListSection]) {
    sections = newSections
    cpInstance.updateSections(sections.map({$0.cpInstance}))
  }
  
}

@available(iOS 14.0, *)
extension FCPListTemplate: FCPRootTemplate {
  func getCPTemplate() -> CPTemplate {
    return cpInstance
  }
  
  var children: [FCPObject] {
    return sections + (backButton == nil ? [] :  [backButton!])
  }
}

