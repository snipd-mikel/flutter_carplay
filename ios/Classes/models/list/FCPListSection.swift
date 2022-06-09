//
//  FCPListSection.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
class FCPListSection {
  private(set) lazy var cpInstance: CPListSection = {
    CPListSection.init(items: items.map({$0.cpInstance}), header: header, sectionIndexTitle: header)
  }()
  private(set) var elementId: String
  private var header: String?
  private var items: [FCPListItem]
  
  init(message: FCPListSectionMessage) {
    elementId = message.elementId
    header = message.header
    items = message.items.map {
      FCPListItem(message: $0)
    }
  }
  
  public func getItems() -> [FCPListItem] {
    return items
  }
}

@available(iOS 14.0, *)
extension FCPListSection: FCPObject {
  var children: [FCPObject] {
    return items
  }
}
