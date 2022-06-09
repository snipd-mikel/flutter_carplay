import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/list/list_item.dart';
import 'package:flutter_carplay/models/template_base.dart';

class CPListSection extends CPObject {
  /// Header text of the section.
  final String? header;

  /// A list of items as [[CPListItem]] to include in the section.
  final List<CPListItem> items;

  /// Creates [CPListSection] that contains zero or more list items. You can configure
  /// a section to display a header, which CarPlay displays on the trailing edge of the screen.
  CPListSection({
    this.header,
    required this.items,
  });

  CPListSectionMessage toMessage() => CPListSectionMessage(
      header: header,
      elementId: elementId,
      items: items.map((e) => e.toMessage()).toList());

  @override
  List<CPObject> getChildren() {
    return items;
  }
}
