import 'package:flutter_carplay/flutter_carplay.dart';
import 'package:flutter_carplay/messages.dart';

abstract class CPNowPlayingButton extends CPObject {
  CPNowPlayingButton(
      {this.isEnabled = true, this.isSelected = false, required this.onPress});
  final bool isEnabled;
  final bool isSelected;
  final Function() onPress;

  CPNowPlayingButtonMessage toButtonMessage();
}

class CPNowPlayingImageButton extends CPNowPlayingButton {
  CPNowPlayingImageButton({
    required this.image,
    required Function() onPress,
    bool isEnabled = true,
    bool isSelected = false,
  }) : super(onPress: onPress, isEnabled: isEnabled, isSelected: isSelected);

  final CPImage image;

  CPNowPlayingImageButtonMessage toMessage() => CPNowPlayingImageButtonMessage(
        elementId: elementId,
        image: image.toMessage(),
        isSelected: isSelected,
        isEnabled: isEnabled,
      );

  @override
  CPNowPlayingButtonMessage toButtonMessage() => CPNowPlayingButtonMessage(
        imageButton: toMessage(),
      );

  @override
  List<CPObject> getChildren() {
    return [];
  }
}
