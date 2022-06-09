//
//  FCPProtocols.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 25.08.2021.
//

import CarPlay


protocol FCPObject {
  var elementId: String {get}
  var children: [FCPObject] {get}
  
}

protocol FCPPresentTemplate : FCPObject{}

@available(iOS 14.0, *)
protocol FCPRootTemplate: FCPObject {
  func getCPTemplate() -> CPTemplate
}

@available(iOS 14.0, *)
extension FCPObject {
  func getById(_ elementId: String) -> FCPObject? {
    if self.elementId == elementId {
      return self
    }
    for child in children {
      let found = child.getById(elementId)
      if found != nil {
        return found
      }
    }
    
    return nil
  }
}
