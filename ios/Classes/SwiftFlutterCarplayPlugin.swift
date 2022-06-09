//
//  SwiftFlutterCarplayPlugin.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import Flutter
import CarPlay


@available(iOS 14.0, *)
func convertFCPTemplateMessage(_ message: FCPTemplateMessage) -> FCPRootTemplate? {
  if message.tabBar != nil {
    return FCPTabBarTemplate(message: message.tabBar!)
  } else if message.poi != nil {
    return FCPPointOfInterestTemplate(message: message.poi!)
  } else if message.list != nil {
    return FCPListTemplate(message: message.list!, templateType: FCPListTemplateType.DEFAULT)
  } else if message.grid != nil {
    return FCPGridTemplate(message: message.grid!)
  }
  
  return nil
}

@available(iOS 14.0, *)
public class SwiftFlutterCarplayPlugin : NSObject, FCarplayApi, CPNowPlayingTemplateObserver, CPInterfaceControllerDelegate, FlutterPlugin {
  
  static private var _shared: SwiftFlutterCarplayPlugin?
  static var shared: SwiftFlutterCarplayPlugin {
    get {
      return _shared!
    }
  }
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlutterCarplayPlugin(registrar: registrar)
    SwiftFlutterCarplayPlugin._shared = instance
  }
  
  private init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
    eventsApi = FCarplayEventsApi(binaryMessenger: registrar.messenger())
    super.init()
    FCarplayApiSetup(registrar.messenger(), self)
  }
  
  
  let registrar: FlutterPluginRegistrar
  private var eventsApi: FCarplayEventsApi
  private var state = FlutterCarplayState()
  
  
  private var _interfaceController: CPInterfaceController?
  var interfaceController: CPInterfaceController? {
    get {
      return _interfaceController
    }
  }
  
  func connect(_ controller: CPInterfaceController) {
    state = FlutterCarplayState()
    _interfaceController = controller
    _interfaceController?.delegate = self
    CPNowPlayingTemplate.shared.add(self)
    onCarplayConnectionChange(FCPConnectionStatus.connected)
  }
  
  func disconnect() {
    state = FlutterCarplayState()
    _interfaceController?.delegate = nil
    _interfaceController = nil
    CPNowPlayingTemplate.shared.remove(self)
    onCarplayConnectionChange(FCPConnectionStatus.disconnected)
  }
  
  func onBackground() {
    onCarplayConnectionChange(FCPConnectionStatus.background)
  }
  
  func onForeground() {
    onCarplayConnectionChange(FCPConnectionStatus.connected)
  }
  
  // Implement FCarplayApi
  
  public func setRootTemplateTemplate(_ template: FCPTemplateMessage, animate: NSNumber) async -> (NSNumber?, FlutterError?) {
    
    guard let fcpTemplate = convertFCPTemplateMessage(template) else {
      return (nil,  FlutterError(code: "ERROR", message: "Cannot setRootTemplate because no valid template was provided", details: nil))
    }
    
    guard let interfaceController = interfaceController else {
      return (false, nil)
    }
     
    let cpTemplate = fcpTemplate.getCPTemplate()
    // Cannot use the async version of setRootTempalte as the
    // completion handler is never called:
    //  https://stackoverflow.com/questions/70931559/carplays-setroottemplate-fails-to-run-completion-handler-or-work-using-async-aw
    interfaceController.setRootTemplate(cpTemplate, animated: animate.boolValue, completion: { _, _ in })
    
    state.setRooTemplate(fcpTemplate)
    
    return (true, nil)
    
  }
  
  public func presentAlertTemplateTemplate(_ alert: FCPAlertTemplateMessage, animated: NSNumber) async -> (NSNumber?, FlutterError?) {
    guard let interfaceController = interfaceController else {
      return (false, nil)
    }
    
    let fcpAlert = FCPAlertTemplate(message: alert)
    do {
      let result = try await interfaceController.presentTemplate(fcpAlert.cpInstance, animated: animated.boolValue)
      onPresentStateChanged(fcpAlert.elementId, completed: result)
      if result {
        state.showModal(fcpAlert)
      }
      return (result as NSNumber, nil)
    } catch {
      onPresentStateChanged(fcpAlert.elementId, completed: false)
      return (nil, FlutterError(code: "EXCEPTION", message: "Exception when calling presentTemplate", details: error.localizedDescription))
    }
  }
  
  public func popTemplateAnimated(_ animated: NSNumber) async -> (NSNumber?, FlutterError?) {
    guard let interfaceController = interfaceController else {
      return (false, nil)
    }
    
    do {
      let result = try await interfaceController.popTemplate(animated: animated.boolValue)
      if result {
        state.pop()
      }
      return (result as NSNumber, nil)
    } catch {
      return (nil, FlutterError(code: "EXCEPTION", message: "Exception when calling popTemplate", details: error.localizedDescription))
    }
  }
  
  public func dismissTemplateAnimated(_ animated: NSNumber) async -> (NSNumber?, FlutterError?) {
    guard let interfaceController = interfaceController else {
      return (false, nil)
    }
    do {
      let result = try await interfaceController.dismissTemplate(animated: animated.boolValue)
      if result {
        state.popModal()
      }
      return (result as NSNumber, nil)
    } catch {
      return (nil, FlutterError(code: "EXCEPTION", message: "Exception when calling dismissTemplate", details: error.localizedDescription))
    }
  }
  
  public func pushTemplateTemplate(_ template: FCPTemplateMessage, animate: NSNumber) async -> (NSNumber?, FlutterError?) {
    guard let interfaceController = interfaceController else {
      return (false, nil)
    }
    
    guard let fcpTemplate = convertFCPTemplateMessage(template) else {
      return (nil, FlutterError(code: "ERROR", message: "Cannot pushTempalte because no valid template was provided", details: nil))
    }
    
    do {
      let result = try await interfaceController.pushTemplate(fcpTemplate.getCPTemplate(), animated: animate.boolValue)
      if result {
        state.push(fcpTemplate)
      }
      return (result as NSNumber, nil)
    } catch {
      return (nil, FlutterError(code: "EXCEPTION", message: "Exception when calling pushTemplate", details: error.localizedDescription))
    }
  }
  
  
  public func pushNowPlayingAnimated(_ animated: NSNumber) async -> (NSNumber?, FlutterError?) {
    guard let interfaceController = interfaceController else {
      return (false, nil)
    }
    do {
      let result = try await interfaceController.pushTemplate(CPNowPlayingTemplate.shared, animated: animated.boolValue)
      if result {
        state.push(FCPNowPlayingTemplate.shared)
      }
      return (result as NSNumber, nil)
    } catch {
      return (nil, FlutterError(code: "EXCEPTION", message: "Exception when calling pushNowPlaying", details: error.localizedDescription))
    }
  }
  
  
  public func presentActionSheetTemplateTemplate(_ actionSheet: FCPActionSheetTemplateMessage, animated: NSNumber) async -> (NSNumber?, FlutterError?) {
    guard let interfaceController = interfaceController else {
      return (false, nil)
    }
    let fcpActionSheet = FCPActionSheetTemplate(message: actionSheet)
    
    do {
      let result = try await interfaceController.presentTemplate(fcpActionSheet.cpInstance, animated: animated.boolValue)
      onPresentStateChanged(fcpActionSheet.elementId, completed: result)
      if result {
        state.showModal(fcpActionSheet)
      }
      return (result as NSNumber, nil)
    } catch {
      onPresentStateChanged(fcpActionSheet.elementId, completed: false)
      return (nil, FlutterError(code: "EXCEPTION", message: "Exception when calling setActionSheetActionSheet", details: error.localizedDescription))
    }
  }
  
  public func pop(toRootTemplateAnimated animated: NSNumber) async -> (NSNumber?, FlutterError?) {
    guard let interfaceController = interfaceController else {
      return (false, nil)
    }
    
    if interfaceController.templates.isEmpty {
      return (false, nil)
    }
    
    do {
      let result =  try await interfaceController.popToRootTemplate(animated: animated.boolValue)
      if result {
        state.popToRoot()
      }
      return (result as NSNumber, nil)
    } catch {
      return (nil, FlutterError(code: "EXCEPTION", message: "Exception when calling popToRootTemplate", details: error.localizedDescription))
    }
  }
  
  public func updateListItemUpdatedItem(_ updatedItem: FCPListItemMessage, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
    let listItem = FCPListItem(message: updatedItem);
    guard let found = state.getById(listItem.elementId, of: FCPListItem.self) else {
      return false
    }
    found.update(text: listItem.text,
                 detailText: listItem.detailText,
                 image: listItem.image,
                 playbackProgress: listItem.playbackProgress,
                 isPlaying: listItem.isPlaying,
                 playingIndicatorLocation: listItem.playingIndicatorLocation,
                 accessoryType: listItem.accessoryType)
    
    return true
  }
  
  public func updateListSectionsListId(_ listId: String, sections: [FCPListSectionMessage], error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
    guard let found = state.getById(listId, of: FCPListTemplate.self) else {
      return false
    }
    let fcpSections = sections.map({FCPListSection(message: $0)})
    found.updateSections(fcpSections)
    state.updateListSections(found)
    return true
  }
  
  public func updateNowPlayingButtonsButtons(_ buttons: [FCPNowPlayingButtonMessage], error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
    let fcpButtons = buttons.map({FCPNowPlayingButton.createNowPlayingButton($0)}).compactMap({$0})
    
    CPNowPlayingTemplate.shared.updateNowPlayingButtons(fcpButtons.map({$0.getCPNowPlayingButton()}))
    return true
  }
  
  public func setNowPlayingUpNextButtonTitleTitle(_ title: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
    guard interfaceController != nil else {
      return false
    }
    CPNowPlayingTemplate.shared.upNextTitle = title
    return true
  }
  
  public func enableNowPlayingUpNextButtonTitle(_ title: String?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
    
    CPNowPlayingTemplate.shared.isUpNextButtonEnabled = true
    if let title = title {
      CPNowPlayingTemplate.shared.upNextTitle = title
    }
    return true
  }
  
  public func disableNowPlayingUpNextButtonWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
    CPNowPlayingTemplate.shared.isUpNextButtonEnabled = false
    guard interfaceController != nil else {
      return false
    }
    CPNowPlayingTemplate.shared.isUpNextButtonEnabled = false
    return true
  }
  
  
  public func onListItemSelectedCompleteListItemId(_ listItemId: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
    guard interfaceController != nil else {
      return
    }
    state.getById(listItemId, of: FCPListItem.self)?.stopHandler()
  }
  
  // Carplay event callbacks
  
  public func onAlertActionPressed(_ elementId: String) {
    guard interfaceController != nil else {
      return
    }
    eventsApi.onAlertActionPressedElementId(elementId, completion: {_ in })
  }
  
  public func onBarButtonPressed(_ elementId: String) {
    guard interfaceController != nil else {
      return
    }
    eventsApi.onBarButtonPressedElementId(elementId, completion: {_ in })
  }
  
  public func onTextButtonPressed(_ elementId: String) {
    guard interfaceController != nil else {
      return
    }
    eventsApi.onTextButtonPressedElementId(elementId, completion: {_ in })
  }
  
  
  public func onGridButtonPressed(_ elementId: String) {
    guard interfaceController != nil else {
      return
    }
    eventsApi.onGridButtonPressedElementId(elementId, completion: {_ in })
  }
  
  public func onListItemSelected(_ elementId: String) {
    guard interfaceController != nil else {
      return
    }
    eventsApi.onListItemSelectedElementId(elementId, completion: {_ in })
  }
  
  public func onNowPlayingButtonPressed(_ elementId: String) {
    guard interfaceController != nil else {
      return
    }
    eventsApi.onNowPlayingButtonPressedElementId(elementId, completion: {_ in })
  }
  
  public func onPresentStateChanged(_ elementId: String, completed: Bool) {
    guard interfaceController != nil else {
      return
    }
    eventsApi.onPresentStateChangedCompleted(completed as NSNumber, completion: {_ in})
    
  }
  
  public func onCarplayConnectionChange(_ status: FCPConnectionStatus) {
    eventsApi.onConnectionChangeData(FCPConnectionStatusChangeMessage.make(with: status), completion: {_ in})
  }
  
  // CPNowPlayingTemplateObserver implementations
    
  public func nowPlayingTemplateUpNextButtonTapped(_ nowPlayingTemplate: CPNowPlayingTemplate) {
    guard interfaceController != nil else {
      return
    }
    eventsApi.onNowPlayingUpNextButtonPressed(completion: {_ in })
  }
  
  // CPInterfaceControllerDelegate implementations
  
  public func templateWillDisappear(
    _ aTemplate: CPTemplate,
    animated: Bool
  ) {
    syncHistoryStack()
  }
  
  public func templateWillAppear(
    _ aTemplate: CPTemplate,
    animated: Bool
  ) {
    syncHistoryStack()
  }
  
  func syncHistoryStack() {
    guard interfaceController != nil else {
      return
    }
    let changed = state.syncHistoryStack(interfaceController!.templates)
    
    if (changed) {
      eventsApi.onHistoryStackChangedHistoryStack(state.historyStack.map({$0.elementId}), completion:{_ in})
    }
  }
}
