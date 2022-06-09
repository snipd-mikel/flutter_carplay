import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/button/text_button.dart';
import 'package:flutter_carplay/models/template_base.dart';

import 'information_item.dart';

/// A template object that displays and manages information items and text buttons.
class CPInformationTemplate extends CPTemplate {
  /// A title will be shown in the navigation bar.
  final String title;

  final CPInformationTemplateLayout layout;

  /// The array of actions as [CPTextButton] displayed on the template.
  final List<CPTextButton> actions;

  /// The array of information items  as [CPInformationItem] displayed on the template.

  final List<CPInformationItem> informationItems;

  /// Creates [CPInformationTemplate]
  CPInformationTemplate({
    required this.title,
    required this.layout,
    required this.actions,
    required this.informationItems,
  });

  CPInformationTemplateMessage toMessage() => CPInformationTemplateMessage(
        elementId: elementId,
        title: title,
        layout: layout,
        actions: actions.map((e) => e.toMessage()).toList(),
        informationItems: informationItems.map((e) => e.toMessage()).toList(),
      );

  @override
  CPTemplateMessage toTemplateMessage() => CPTemplateMessage(
        information: toMessage(),
      );

  @override
  List<CPObject> getChildren() {
    return [...informationItems, ...actions];
  }
}
