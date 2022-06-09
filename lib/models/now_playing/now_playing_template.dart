import 'package:flutter_carplay/carplay_controller.dart';
import 'package:flutter_carplay/flutter_carplay.dart';
import 'package:flutter_carplay/messages.dart';

class CPNowPlayingTemplate extends CPTemplate {
  CPNowPlayingTemplate._();

  @override
  String get elementId => 'now-playing-shared';

  static CPNowPlayingTemplate? _instance;
  static CPNowPlayingTemplate get shared {
    _instance ??= CPNowPlayingTemplate._();
    return _instance!;
  }

  List<CPNowPlayingButton> _buttons = [];
  Function()? onUpNextButtonPressed;
  String? _upNextTitle;
  bool _upNextEnabled = false;

  String? get upNextTitle => _upNextTitle;
  bool get upNextEnabled => _upNextEnabled;

  void updateNowPlayingButtons(List<CPNowPlayingButton> buttons) {
    _buttons = buttons;
    CarplayControllerInternal.instance.updateNowPlayingButtons(buttons);
  }

  void setUpNextButtonTitle(String title) {
    _upNextTitle = title;

    CarplayControllerInternal.instance.setUpNextButtonTitle(title);
  }

  void enableUpNextButton(Function() callback, {String? title}) {
    onUpNextButtonPressed = callback;
    _upNextEnabled = true;
    if (title != null) {
      _upNextTitle = title;
    }
    CarplayControllerInternal.instance
        .enableUpNextButton(callback, title: title);
  }

  void disableUpNextButton() {
    _upNextEnabled = false;
    onUpNextButtonPressed = null;
    CarplayControllerInternal.instance.disableUpNextButton();
  }

  CPNowPlayingButton? getButtonById(String elementId) {
    final results =
        _buttons.where((element) => element.elementId == elementId).toList();
    if (results.isEmpty) {
      return null;
    }
    return results.first;
  }

  @override
  List<CPObject> getChildren() {
    return [];
  }

  @override
  CPTemplateMessage toTemplateMessage() {
    return CPTemplateMessage();
  }
}
