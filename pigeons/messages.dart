import 'package:pigeon/pigeon.dart';

enum CPListItemPlayingIndicatorLocation {
  trailing,
  leading,
}

enum CPConnectionStatus {
  connected,
  background,
  disconnected,
  unknown,
}

enum CPListItemAccessoryType {
  none,
  cloud,
  disclosureIndicator,
}

enum CPBarButtonStyle {
  none,
  rounded,
}

enum CPInformationTemplateLayout {
  leading,
  twoColumn,
}

enum CPTextButtonStyle {
  normal,
  cancel,
  confirm,
}

enum CPAlertActionStyle {
  normal,
  cancel,
  destructive,
}

class CPListItemMessage {
  late String elementId;
  late String text;
  String? detailText;
  CPImageMessage? image;
  double? playbackProgress;
  bool? isPlaying;
  late bool onPress;
  CPListItemPlayingIndicatorLocation? playingIndicatorLocation;
  CPListItemAccessoryType? accessoryType;
}

class CPListSectionMessage {
  late String elementId;
  String? header;
  late List<CPListItemMessage?> items;
}

class CPBarButtonMessage {
  late String elementId;
  late String title;
  late CPBarButtonStyle style;
}

class CPListTemplateMessage {
  late String elementId;
  String? title;
  late List<CPListSectionMessage?> sections;
  List<String?>? emptyViewTitleVariants;
  List<String?>? emptyViewSubtitleVariants;
  late bool showsTabBadge;
  late String systemIcon;
  CPBarButtonMessage? backButton;
}

class CPAlertActionMessage {
  late String elementId;
  late String title;
  late CPAlertActionStyle style;
}

class CPAlertTemplateMessage {
  late String elementId;
  late List<String?> titleVariants;
  late List<CPAlertActionMessage?> actions;
  late bool onPresent;
}

class CPActionSheetTemplateMessage {
  late String elementId;
  String? title;
  String? message;
  late List<CPAlertActionMessage?> actions;
}

class CPTextButtonMessage {
  late String elementId;
  late String title;
  late CPTextButtonStyle style;
}

class CPGridButtonMessage {
  late String elementId;
  late List<String?> titleVariants;
  late CPImageMessage image;
}

class CPGridTemplateMessage {
  late String elementId;
  late String title;
  late List<CPGridButtonMessage?> buttons;
}

class CPInformationItemMessage {
  late String elementId;
  String? title;
  String? detail;
}

class CPInformationTemplateMessage {
  late String elementId;
  late String title;
  late CPInformationTemplateLayout layout;
  late List<CPTextButtonMessage?> actions;
  late List<CPInformationItemMessage?> informationItems;
}

class CPNowPlayingImageButtonMessage {
  late String elementId;
  late bool isEnabled;
  late bool isSelected;
  late CPImageMessage image;
}

class CPNowPlayingButtonMessage {
  CPNowPlayingImageButtonMessage? imageButton;
}

class CPConnectionStatusChangeMessage {
  late CPConnectionStatus status;
}

class CPPointOfInterestMessage {
  late String elementId;
  late double latitude;
  late double longitude;
  late String title;
  String? subtitle;
  String? summary;
  String? detailTitle;
  String? detailsSubtitle;
  String? detailSummary;
  CPImageMessage? image;
  CPTextButtonMessage? primaryButton;
  CPTextButtonMessage? secondaryButton;
}

class CPPointOfInterestTemplateMessage {
  late String elementId;
  late String title;
  late List<CPPointOfInterestMessage?> poi;
}

class CPTabBarTemplateMessage {
  late String elementId;
  String? title;
  late List<CPListTemplateMessage?> templates;
}

class CPTemplateMessage {
  CPGridTemplateMessage? grid;
  CPInformationTemplateMessage? information;
  CPListTemplateMessage? list;
  CPPointOfInterestTemplateMessage? poi;
  CPTabBarTemplateMessage? tabBar;
}

class CPImageMessage {
  String? systemName;
  String? flutterAsset;
  Uint8List? data;
}

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/messages.dart',
  objcOptions: ObjcOptions(
    prefix: 'F',
  ),
  objcHeaderOut: 'ios/Classes/messages.h',
  objcSourceOut: 'ios/Classes/messages.m',
))
@HostApi()
abstract class CarplayApi {
  @async
  bool setRootTemplate(CPTemplateMessage template, bool animate);
  @async
  bool pushTemplate(CPTemplateMessage template, bool animate);
  @async
  bool pushNowPlaying(bool animated);
  @async
  bool popTemplate(bool animated);
  @async
  bool popToRootTemplate(bool animated);
  @async
  bool presentAlertTemplate(CPAlertTemplateMessage template, bool animated);
  @async
  bool presentActionSheetTemplate(
      CPActionSheetTemplateMessage template, bool animated);
  @async
  bool dismissTemplate(bool animated);
  bool updateNowPlayingButtons(List<CPNowPlayingButtonMessage> buttons);
  bool setNowPlayingUpNextButtonTitle(String title);
  bool enableNowPlayingUpNextButton(String? title);
  bool disableNowPlayingUpNextButton();
  bool updateListItem(CPListItemMessage updatedItem);
  bool updateListSections(String listId, List<CPListSectionMessage> sections);
  void onListItemSelectedComplete(String listItemId);
}

@FlutterApi()
abstract class CarplayEventsApi {
  void onConnectionChange(CPConnectionStatusChangeMessage data);
  void onListItemSelected(String elementId);
  void onAlertActionPressed(String elementId);
  void onPresentStateChanged(bool completed);
  void onGridButtonPressed(String elementId);
  void onBarButtonPressed(String elementId);
  void onTextButtonPressed(String elementId);
  void onNowPlayingButtonPressed(String elementId);
  void onNowPlayingUpNextButtonPressed();
  void onHistoryStackChanged(List<String?> historyStack);
}
