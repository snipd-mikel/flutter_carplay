//
//  FlutterCarplayState.swift
//  flutter_carplay
//
//  Created by Mikel Corcuera on 10.06.22.
//

import Foundation
import CarPlay

@available(iOS 14.0, *)
class FlutterCarplayNowPlayingState {
  private(set) var buttons: [FCPNowPlayingButton] = []
  
  func updateButtons(_ buttons: [FCPNowPlayingButton]) {
    self.buttons = buttons
  }
  func getButtonById(_ elementId: String) -> FCPNowPlayingButton? {
    return buttons.first(where: {$0.elementId == elementId})
  }
}

@available(iOS 14.0, *)
class FlutterCarplayState {
  private(set) var historyStack: [FCPRootTemplate] = []
  private var objectMap: ThreadSafeDictionary<String, FCPObject> = ThreadSafeDictionary(dict: [:])
  private var parentMap: ThreadSafeDictionary<String, String> = ThreadSafeDictionary(dict: [:])
  private var templateMap: ThreadSafeDictionary<CPTemplate, String> = ThreadSafeDictionary(dict: [:])
  private(set) var rootTemplate: FCPRootTemplate?
  private(set) var presentTemplate: FCPPresentTemplate?
  let nowPlaying = FlutterCarplayNowPlayingState()
  
  func setRooTemplate(_ template: FCPRootTemplate) {
    if rootTemplate != nil {
      removeTemplate(rootTemplate!)
    }
    rootTemplate = template
    addTemplate(rootTemplate!)
    popToRoot()
  }
  
  func updateListSections(_ updated: FCPListTemplate) {
    if let found = getById(updated.elementId, of: FCPListTemplate.self) {
      removeObject(found)
    }
    let parentId = parentMap[updated.elementId]
    addObject(updated, parentId)
  
  }
  
  func syncHistoryStack(_ cpTemplates: [CPTemplate]) -> Bool {
    var newHistoryStack: [FCPRootTemplate] = []
    
    for cpTemplate in cpTemplates {
      if cpTemplate == CPNowPlayingTemplate.shared {
        newHistoryStack.append(FCPNowPlayingTemplate.shared)
      } else {
        if let templateId = templateMap[cpTemplate] {
          if let template = getById(templateId, of: FCPRootTemplate.self) {
            newHistoryStack.append(template)
          }
        }
      }
    }
    
    if newHistoryStack.count != historyStack.count {
      for template in historyStack {
        removeTemplate(template)
      }
      for template in newHistoryStack {
        addTemplate(template)
      }
      historyStack = newHistoryStack
      return true
    }
    return false
  }
  
  func push(_ template: FCPRootTemplate) {
    historyStack.append(template)
    addTemplate(template)
  }
  
  func pop() {
    if !historyStack.isEmpty {
      let template = historyStack.removeLast()
      removeTemplate(template)
    }
  }

  
  func popModal() {
    if presentTemplate != nil {
      removeObject(presentTemplate!)
    }
    presentTemplate = nil
  }
  
  func showModal(_ template: FCPPresentTemplate) {
    if presentTemplate != nil {
      removeObject(presentTemplate!)
    }
    presentTemplate = template
    addObject(presentTemplate!, nil)
  }
  
  func popToRoot() {
    for template in historyStack {
      if template.elementId != rootTemplate?.elementId {
        removeTemplate(template)
      }
    }
    
    if rootTemplate == nil {
      historyStack = []
    } else {
      historyStack = [rootTemplate!]
    }
    
  }
  
  func getById<T>(_ elementId: String, of: T.Type) -> T? {
    guard let found = objectMap[elementId] as? T else {
      return nil
    }
    return found
  }
  
  private func addTemplate(_ template: FCPRootTemplate) {
    addObject(template, nil)
    templateMap[template.getCPTemplate()] = template.elementId
  }
  
  private func removeTemplate(_ template: FCPRootTemplate) {
    removeObject(template)
    templateMap.removeValue(forKey: template.getCPTemplate())
  }
  
  private func addObject(_ object: FCPObject, _ parent: String?) {
    objectMap[object.elementId] = object
    if parent != nil {
      parentMap[object.elementId] = parent
    }
    
    for child in object.children {
      addObject(child, object.elementId)
    }
  }
  
  private func removeObject(_ object: FCPObject) {
    objectMap.removeValue(forKey: object.elementId)
    parentMap.removeValue(forKey: object.elementId)
    
    for child in object.children {
      removeObject(child)
    }
  }
  
  
  
}
