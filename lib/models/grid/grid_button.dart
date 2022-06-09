import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/image.dart';
import 'package:flutter_carplay/models/template_base.dart';

/// A grid button object displayed on a grid template.
class CPGridButton extends CPObject {
  /// An array of title variants for the button.
  /// When the system displays the button, it selects the title that best fits the available
  /// screen space, so arrange the titles from most to least preferred when creating a grid button.
  /// Also, localize each title for display to the user, and **be sure to include at least
  /// one title in the array.**
  final List<String> titleVariants;

  /// Image asset path in pubspec.yaml file.
  /// For example: images/flutter_logo.png
  ///
  /// **[!] When creating a grid button, do NOT provide an animated image. If you do, the button
  /// uses the first image in the animation sequence.**
  final CPImage image;

  /// Fired after the user taps the button.
  final Function() onPress;

  CPGridButton({
    required this.titleVariants,
    required this.image,
    required this.onPress,
  });

  CPGridButtonMessage toMessage() => CPGridButtonMessage(
      elementId: elementId,
      titleVariants: titleVariants,
      image: image.toMessage());

  @override
  List<CPObject> getChildren() {
    return [];
  }
}
