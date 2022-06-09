//
//  FCPListItem.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import CarPlay

@available(iOS 14.0, *)
func toCPListItemAccessoryType(_ type: FCPListItemAccessoryType) -> CPListItemAccessoryType {
  switch(type) {
  case .none:
    return CPListItemAccessoryType.none
  case .cloud:
    return .cloud
  case .disclosureIndicator:
    return .disclosureIndicator
  @unknown default:
    return CPListItemAccessoryType.none
  }
}

@available(iOS 14.0, *)
func toCPListItemPlayingIndicatorLocation(_ type: FCPListItemPlayingIndicatorLocation) -> CPListItemPlayingIndicatorLocation {
  switch(type) {
  case .trailing:
    return .trailing
  case .leading:
    return .leading
  @unknown default:
    return.leading
  }
}


@available(iOS 14.0, *)
class FCPListItem {
  private(set) lazy var cpInstance: CPListItem = {
    let listItem = CPListItem.init(text: text, detailText: detailText)
    listItem.handler = ((CPSelectableListItem, @escaping () -> Void) -> Void)? { [self] selectedItem, complete in
      if isOnPressListenerActive == true {
        DispatchQueue.main.async {
          self.completeHandler = complete
          SwiftFlutterCarplayPlugin.shared.onListItemSelected(self.elementId)
        }
      } else {
        complete()
      }
    }
    if image != nil {
      listItem.setImage(image?.toUIImage(size: CPListItem.maximumImageSize))
    }
    if playbackProgress != nil {
      listItem.playbackProgress = playbackProgress!
    }
    if isPlaying != nil {
      listItem.isPlaying = isPlaying!
    }
    if playingIndicatorLocation != nil {
      listItem.playingIndicatorLocation = toCPListItemPlayingIndicatorLocation(playingIndicatorLocation!)
    }
    if accessoryType != nil {
      listItem.accessoryType = toCPListItemAccessoryType(accessoryType!)
    }
    return listItem
  }()
  private(set) var elementId: String
  private(set) var text: String
  private(set) var detailText: String?
  private var isOnPressListenerActive: Bool = false
  private var completeHandler: (() -> Void)?
  private(set) var image: FCPImage?
  private(set) var playbackProgress: CGFloat?
  private(set) var isPlaying: Bool?
  private(set) var playingIndicatorLocation: FCPListItemPlayingIndicatorLocation? 
  private(set) var accessoryType: FCPListItemAccessoryType?
  
  init(message: FCPListItemMessage) {
    elementId = message.elementId
    text = message.text
    detailText = message.detailText
    isOnPressListenerActive = message.onPress.boolValue
    image = message.image?.toFCPImage()
    isPlaying = message.isPlaying?.boolValue
    accessoryType = message.accessoryType
    playingIndicatorLocation = message.playingIndicatorLocation
    let playbackFloat = message.playbackProgress?.floatValue
    
    if playbackFloat != nil {
      playbackProgress = CGFloat(playbackFloat!)
    }
    
  }
  
  public func stopHandler() {
    guard completeHandler != nil else {
      return
    }
    completeHandler!()
    completeHandler = nil
  }
  
  public func update(
    text: String?,
    detailText: String?,
    image: FCPImage?,
    playbackProgress: CGFloat?,
    isPlaying: Bool?,
    playingIndicatorLocation: FCPListItemPlayingIndicatorLocation?,
    accessoryType: FCPListItemAccessoryType?) {
      if text != nil {
        cpInstance.setText(text!)
        self.text = text!
      }
      if detailText != nil {
        cpInstance.setDetailText(detailText)
        self.detailText = detailText
      }
      if image != nil {
        cpInstance.setImage(image?.toUIImage(size: CPListItem.maximumImageSize))
        self.image = image
      }
      if playbackProgress != nil {
        cpInstance.playbackProgress = playbackProgress!
        self.playbackProgress = playbackProgress
      }
      if isPlaying != nil {
        cpInstance.isPlaying = isPlaying!
        self.isPlaying = isPlaying
      }
      if playingIndicatorLocation != nil {
        self.playingIndicatorLocation = playingIndicatorLocation!
        if playingIndicatorLocation != nil {
          cpInstance.playingIndicatorLocation = toCPListItemPlayingIndicatorLocation(self.playingIndicatorLocation!)
        }
      }
      if accessoryType != nil {
        self.accessoryType = accessoryType!
        if accessoryType != nil {
          cpInstance.accessoryType = toCPListItemAccessoryType(self.accessoryType!)
        }
      }
    }
  
}

@available(iOS 14.0, *)
extension FCPListItem: FCPObject {
  var children: [FCPObject] {
    return []
  }
}
