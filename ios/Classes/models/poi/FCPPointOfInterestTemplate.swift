//
//  FCPPointOfInterestTemplate.swift
//  flutter_carplay
//
//  Created by Olaf Schneider on 15.02.22.
//

import CarPlay

@available(iOS 14.0, *)
class FCPPointOfInterestTemplate {
  private(set) lazy var cpInstace: CPPointOfInterestTemplate = {
    
    return CPPointOfInterestTemplate.init(title: title,pointsOfInterest: poi.map({$0.cpInstance}), selectedIndex: NSNotFound)
  }()
  private(set) var elementId: String
  private var title: String
  private var poi: [FCPPointOfInterest]
  
  init(message: FCPPointOfInterestTemplateMessage) {
    elementId = message.elementId
    title = message.title
    poi = message.poi.map {
      FCPPointOfInterest(message: $0)
    }
  }
}

@available(iOS 14.0, *)
extension FCPPointOfInterestTemplate: FCPRootTemplate {
  func getCPTemplate() -> CPTemplate {
    return cpInstace
  }
  
  var children: [FCPObject] {
    return poi
  }
}
