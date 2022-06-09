import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_carplay/_carplay_state.dart';
import 'package:flutter_carplay/flutter_carplay.dart';
import 'package:flutter_carplay/messages.dart';

/// The Carplay controller that manages the CarPlay scene
///
/// See more at: https://developer.apple.com/documentation/carplay/cptemplateapplicationscene/3340480-interfacecontroller
abstract class CarplayController {
  static CarplayController get instance => _internalInstance;
  static final _internalInstance = _CarplayControllerImplamentation._();

  Stream<CPConnectionStatus> get connectionStatusChanges;
  CPConnectionStatus get connectionStatus;

  /// The root template in the navigation hierarchy.
  CPTemplate? get rootTemplate;

  /// The top-most template in the navigation hierarchy.
  CPTemplate? get topTemplate;

  /// The contents of the navigation hierarchy.
  List<CPTemplate> get templates;

  /// Shared instance of [CPNowPlayingTemplate]
  CPNowPlayingTemplate get nowPlayingTemplate;

  /// Sets the [rootTemplate] as the root of a new navigation hierarchy.
  ///
  /// If you set a root template when a navigation hierarchy already exists,
  /// CarPlay replaces the entire hierarchy.
  ///
  /// If [animated] is true, CarPlay animates the presentation of the template.
  /// CarPlay ignores this flag when there isn’t an existing navigation
  /// hierarchy to replace.
  Future<void> setRootTemplate(CPTemplate rootTemplate, {bool animated = true});

  /// Removes the top-most template from the navigation hierarchy.
  ///
  /// If [animated] is true, CarPlay animates the transition between templates.
  Future<void> pop({bool animated = true});

  /// Removes all of the templates from the navigation hierarchy
  /// except the root template.
  ///
  /// If [animated] is true, CarPlay animates the transition between templates.
  Future<void> popToRoot({bool animated = true});

  /// Presents [presentTemplate] modally.
  ///
  /// CarPlay can only present one modal template at a time.
  /// [presentTemplate] must be one of [CPActionSheetTemplate] or
  /// [CPAlertTemplate].
  ///
  /// If [animated] is true, CarPlay animates the transition between templates.
  Future<void> presentTemplate(CPPresentTemplate presentTemplate,
      {bool animated = true});

  /// Dismisses a modal template.
  ///
  /// If [animated] is true, CarPlay animates the transition between templates.
  Future<void> dismissTemplate({bool animated = true});

  /// Adds [template] to the navigation hierarchy and displays it.
  ///
  /// The template you add becomes the [topTemplate] in the navigation hierarchy.
  ///
  /// If [animated] is true, CarPlay animates the transition between templates.
  Future<void> push(CPTemplate template,
      {bool animated = true, VoidCallback? onPop});
}

abstract class CarplayControllerInternal {
  static CarplayControllerInternal get instance =>
      CarplayController._internalInstance;

  Future<void> updateListSections(CPListTemplate updatedList);
  Future<void> updateObject<T extends CPObject>(CPObject updated);
  Future<void> updateListItem(CPListItem updatedListItem);
  Future<void> updateNowPlayingButtons(List<CPNowPlayingButton> buttons);
  Future<void> pushNowPlaying({bool animated = true});
  Future<void> enableUpNextButton(VoidCallback callback, {String? title});
  Future<void> setUpNextButtonTitle(String title);
  Future<void> disableUpNextButton();
}

class _CarplayControllerImplamentation
    implements CarplayController, CarplayControllerInternal, CarplayEventsApi {
  _CarplayControllerImplamentation._() {
    CarplayEventsApi.setup(this);
  }
  final _carplayApi = CarplayApi();
  var _state = CarplayState();
  final _connectionStatusStream =
      StreamController<CPConnectionStatus>.broadcast();
  CPConnectionStatus _connectionStatus = CPConnectionStatus.unknown;

  void connect() {
    _state = CarplayState();
  }

  void disconnect() {
    _state = CarplayState();
  }

  @override
  CPConnectionStatus get connectionStatus => _connectionStatus;

  @override
  CPTemplate? get rootTemplate => _state.rootTemplate;

  @override
  CPTemplate? get topTemplate => _state.topTemplate;

  @override
  List<CPTemplate> get templates => _state.templates;

  @override
  Stream<CPConnectionStatus> get connectionStatusChanges =>
      _connectionStatusStream.stream;

  @override
  CPNowPlayingTemplate get nowPlayingTemplate => CPNowPlayingTemplate.shared;

  @override
  Future<void> setRootTemplate(CPTemplate rootTemplate,
      {bool animated = true}) async {
    final result = await _carplayApi.setRootTemplate(
        rootTemplate.toTemplateMessage(), animated);
    if (result) {
      _state.setRootTemplate(rootTemplate);
    }
  }

  @override
  Future<void> pop({bool animated = true}) async {
    final result = await _carplayApi.popTemplate(animated);
    if (result) {
      _state.pop();
    }
  }

  @override
  Future<void> popToRoot({bool animated = true}) async {
    final result = await _carplayApi.popToRootTemplate(animated);
    if (result == true) {
      _state.popToRoot();
    }
  }

  @override
  Future<void> push(CPTemplate template,
      {bool animated = true, VoidCallback? onPop}) async {
    bool result;
    if (template == CPNowPlayingTemplate.shared) {
      result = await _carplayApi.pushNowPlaying(animated);
    } else {
      result = await _carplayApi.pushTemplate(
          template.toTemplateMessage(), animated);
    }
    if (result) {
      _state.pushTemplate(template, onPop: onPop);
    }
  }

  @override
  Future<void> pushNowPlaying({bool animated = true}) async {
    await _carplayApi.pushNowPlaying(animated);
  }

  @override
  Future<void> presentTemplate(CPPresentTemplate template,
      {bool animated = true}) async {
    bool result;
    if (template is CPActionSheetTemplate) {
      result = await _carplayApi.presentActionSheetTemplate(
          template.toMessage(), animated);
    } else if (template is CPAlertTemplate) {
      result = await _carplayApi.presentAlertTemplate(
          template.toMessage(), animated);
    } else {
      throw Exception(
          'Cannot present template of type ${template.runtimeType}. Only valid template template to present are CPActionSheetTemplate and CPAlertTemplate');
    }
    if (result) {
      _state.presentTemplate(template);
    }
  }

  @override
  Future<void> dismissTemplate({bool animated = true}) async {
    final result = await _carplayApi.dismissTemplate(animated);
    if (result) {
      _state.popModal();
    }
  }

  @override
  Future<void> updateNowPlayingButtons(List<CPNowPlayingButton> buttons) async {
    await _carplayApi.updateNowPlayingButtons(
        buttons.map((e) => e.toButtonMessage()).toList());
  }

  @override
  Future<void> enableUpNextButton(VoidCallback callback,
      {String? title}) async {
    await _carplayApi.enableNowPlayingUpNextButton(title);
  }

  @override
  Future<void> disableUpNextButton() async {
    await _carplayApi.disableNowPlayingUpNextButton();
  }

  @override
  Future<void> setUpNextButtonTitle(String title) async {
    await _carplayApi.setNowPlayingUpNextButtonTitle(title);
  }

  @override
  Future<void> updateListItem(CPListItem updatedListItem) async {
    final result =
        await _carplayApi.updateListItem(updatedListItem.toMessage());
    if (result) {
      _state.updateObject(updatedListItem);
    }
  }

  @override
  Future<void> updateObject<T extends CPObject>(CPObject updated) async {
    if (updated is CPListItem) {
      await updateListItem(updated);
    } else {
      throw Exception('Cannot update CPObject of type ${updated.runtimeType}');
    }

    _state.updateObject(updated);
  }

  @override
  Future<void> updateListSections(CPListTemplate updatedList) async {
    final result = await _carplayApi.updateListSections(updatedList.elementId,
        updatedList.sections.map((e) => e.toMessage()).toList());
    if (result) {
      _state.updateObject(updatedList);
    }
  }

  @override
  void onAlertActionPressed(String elementId) {
    _state.getById<CPAlertAction>(elementId)?.onPress();
  }

  @override
  void onBarButtonPressed(String elementId) {
    _state.getById<CPBarButton>(elementId)?.onPress();
  }

  @override
  void onConnectionChange(CPConnectionStatusChangeMessage data) {
    final oldSattus = _connectionStatus;
    if (oldSattus != data.status) {
      if (oldSattus == CPConnectionStatus.disconnected) {
        connect();
      }
      if (data.status == CPConnectionStatus.disconnected) {
        connect();
      }
      _connectionStatus = data.status;
      _connectionStatusStream.add(data.status);
    }
  }

  @override
  void onGridButtonPressed(String elementId) {
    _state.getById<CPGridButton>(elementId)?.onPress();
  }

  @override
  void onListItemSelected(String elementId) {
    final item = _state.getById<CPListItem>(elementId);
    if (item != null) {
      item.onPress
          ?.call(() => _carplayApi.onListItemSelectedComplete(elementId), item);
    }
  }

  @override
  void onNowPlayingButtonPressed(String elementId) {
    CPNowPlayingTemplate.shared.getButtonById(elementId)?.onPress();
  }

  @override
  void onPresentStateChanged(bool completed) {
    final presentTemplate = _state.currentPresentTemplate;
    if (presentTemplate is CPAlertTemplate) {
      presentTemplate.onPresent?.call(completed);
    }
  }

  @override
  void onTextButtonPressed(String elementId) {
    _state.getById<CPTextButton>(elementId)?.onPress();
  }

  @override
  void onNowPlayingUpNextButtonPressed() {
    CPNowPlayingTemplate.shared.onUpNextButtonPressed?.call();
  }

  @override
  void onHistoryStackChanged(List<String?> historyStack) {
    _state.syncHistoryStack(historyStack.whereType<String>().toList());
  }
}
