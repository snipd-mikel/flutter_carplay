//
//  FCPNowPlayingTemplate.swift
//  flutter_carplay
//
//  Created by Mikel Corcuera on 13.06.22.
//

import CarPlay

@available(iOS 14.0, *)
class FCPNowPlayingTemplate {
  private init() {}
  static private(set) var shared: FCPNowPlayingTemplate = FCPNowPlayingTemplate()
 
}

@available(iOS 14.0, *)
extension FCPNowPlayingTemplate: FCPRootTemplate {
  var elementId: String {
    return "now-playing-shared"
  }
  
  func getCPTemplate() -> CPTemplate {
    return CPNowPlayingTemplate.shared
  }
  
  var children: [FCPObject] {
    return []
  }
}
