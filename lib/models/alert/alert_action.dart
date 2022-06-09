import 'package:flutter_carplay/messages.dart';

import '../template_base.dart';

/// An object that encapsulates an action the user can take on [CPActionSheetTemplate] or [CPAlertTemplate].
class CPAlertAction extends CPPresentAction {
  /// The action button's title.
  final String title;

  /// The display style for the action button.
  /// Default is [CPAlertActionStyle.normal]
  final CPAlertActionStyle style;

  /// A callback function that CarPlay invokes after the user taps the action button.
  @override
  final Function() onPress;

  /// Creates [CPAlertAction] with a title, style, and action handler.
  CPAlertAction({
    required this.title,
    this.style = CPAlertActionStyle.normal,
    required this.onPress,
  });

  CPAlertActionMessage toMessage() =>
      CPAlertActionMessage(elementId: elementId, title: title, style: style);

  @override
  List<CPObject> getChildren() {
    return [];
  }
}
