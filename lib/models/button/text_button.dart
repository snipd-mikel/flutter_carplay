import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/template_base.dart';

/// A button object for placement in a point of interest or information template.
class CPTextButton extends CPObject {
  /// The title displayed on the bar button.
  final String title;

  /// The style to use when displaying the button.
  /// Default is [CPTextButtonStyle.normal]
  final CPTextButtonStyle style;

  /// Fired when the user taps a text button.
  final Function() onPress;

  /// Creates [CPTextButton] with a title, style and handler.
  CPTextButton({
    required this.title,
    this.style = CPTextButtonStyle.normal,
    required this.onPress,
  });

  CPTextButtonMessage toMessage() =>
      CPTextButtonMessage(elementId: elementId, title: title, style: style);

  @override
  List<CPObject> getChildren() {
    return [];
  }
}
