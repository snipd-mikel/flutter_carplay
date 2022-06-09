import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/template_base.dart';

/// A button object for placement in a navigation bar.
class CPBarButton extends CPObject {
  /// The title displayed on the bar button.
  final String title;

  /// The style to use when displaying the button.
  /// Default is [CPBarButtonStyle.rounded]
  final CPBarButtonStyle style;

  /// Fired when the user taps a bar button.
  final Function() onPress;

  /// Creates [CPBarButton] with a title, style and handler.
  CPBarButton({
    required this.title,
    this.style = CPBarButtonStyle.rounded,
    required this.onPress,
  });

  CPBarButtonMessage toMessage() => CPBarButtonMessage(
        elementId: elementId,
        style: style,
        title: title,
      );

  @override
  List<CPObject> getChildren() {
    return [];
  }
}
