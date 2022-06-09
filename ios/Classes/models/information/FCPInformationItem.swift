//
//  FCPPointOfInterestTemplate.swift
//  flutter_carplay
//
//  Created by Olaf Schneider on 17.02.22.
//

import CarPlay

@available(iOS 14.0, *)
class FCPInformationItem {
  private(set) lazy var cpInstance: CPInformationItem = {
    return CPInformationItem.init(title: title, detail: detail)
  }()
  private(set) var elementId: String
  private var title: String?
  private var detail: String?
  
  init(message: FCPInformationItemMessage) {
    elementId = message.elementId
    title = message.title
    detail = message.detail
  }
}


@available(iOS 14.0, *)
extension FCPInformationItem: FCPObject {
  var children: [FCPObject] {
    return []
  }
}
