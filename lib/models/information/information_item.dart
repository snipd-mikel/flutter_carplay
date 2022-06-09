import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/template_base.dart';

/// A information item  object displayed on a information template.
class CPInformationItem extends CPObject {
  final String? title;
  final String? detail;

  CPInformationItem({this.title, this.detail});

  CPInformationItemMessage toMessage() => CPInformationItemMessage(
      elementId: elementId, title: title, detail: detail);

  @override
  List<CPObject> getChildren() {
    return [];
  }
}
