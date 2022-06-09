import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/image.dart';
import 'package:flutter_carplay/models/template_base.dart';

/// A selectable list item object that appears in a list template.
class CPListItem extends CPObject with CPMutableObject<CPListItem> {
  /// Text displayed in the list item cell.
  String text;

  /// Secondary text displayed below the primary text in the list item cell.
  String? detailText;

  /// An optional callback function that CarPlay invokes when the user selects the list item.
  final Function(Function() complete, CPListItem self)? onPress;

  /// Displays an image on the leading edge of the list item cell.
  /// Image asset path in pubspec.yaml file.
  /// For example: images/flutter_logo.png
  CPImage? image;

  /// Playback progress status for the content that the list item represents.
  double? playbackProgress;

  /// Determines whether the list item displays its Now Playing indicator.
  bool? isPlaying;

  /// The location where the list item displays its Now Playing indicator.
  CPListItemPlayingIndicatorLocation? playingIndicatorLocation;

  /// An accessory that the list item displays in its trailing region.
  CPListItemAccessoryType? accessoryType;

  /// Creates [CPListItem] that manages the content of a single row in a [CPListTemplate].
  /// CarPlay manages the layout of a list item and may adjust its layout to allow for
  /// the display of auxiliary content, such as, an accessory or a Now Playing indicator.
  /// A list item can display primary text, secondary text, now playing indicators as playback progress,
  /// an accessory image and a trailing image.
  CPListItem({
    required this.text,
    this.detailText,
    this.onPress,
    this.image,
    this.playbackProgress,
    this.isPlaying,
    this.playingIndicatorLocation,
    this.accessoryType,
  });

  CPListItemMessage toMessage() => CPListItemMessage(
        elementId: elementId,
        text: text,
        detailText: detailText,
        image: image?.toMessage(),
        playbackProgress: playbackProgress,
        isPlaying: isPlaying,
        playingIndicatorLocation: playingIndicatorLocation,
        accessoryType: accessoryType,
        onPress: onPress == null ? false : true,
      );

  void update({
    String? text,
    CPNullable<String> detailText = const CPNullable.empty(),
    CPNullable<CPImage> image = const CPNullable.empty(),
    CPNullable<double> playbackProgress = const CPNullable.empty(),
    CPNullable<bool> isPlaying = const CPNullable.empty(),
    CPNullable<CPListItemPlayingIndicatorLocation> playingIndicatorLocation =
        const CPNullable.empty(),
    CPNullable<CPListItemAccessoryType> accessoryType =
        const CPNullable.empty(),
  }) {
    var updated = false;
    if (text != null) {
      this.text = text;
      updated = true;
    }
    if (detailText.hasValue) {
      this.detailText = detailText.value;
      updated = true;
    }
    if (image.hasValue) {
      this.image = image.value;
      updated = true;
    }
    if (playbackProgress.hasValue) {
      this.playbackProgress = playbackProgress.value;
      updated = true;
    }
    if (isPlaying.hasValue) {
      this.isPlaying = isPlaying.value;
      updated = true;
    }
    if (playingIndicatorLocation.hasValue) {
      this.playingIndicatorLocation = playingIndicatorLocation.value;
      updated = true;
    }
    if (accessoryType.hasValue) {
      this.accessoryType = accessoryType.value;
      updated = true;
    }
    if (updated) {
      onUpdate();
    }
  }

  @override
  List<CPObject> getChildren() {
    return [];
  }
}
