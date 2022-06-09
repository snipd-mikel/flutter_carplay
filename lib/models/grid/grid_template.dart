import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/grid/grid_button.dart';
import 'package:flutter_carplay/models/template_base.dart';

/// A template object that displays and manages a grid of items.
class CPGridTemplate extends CPTemplate {
  /// A title will be shown in the navigation bar.
  final String title;

  /// The array of grid buttons as [CPGridButton] displayed on the template.
  final List<CPGridButton> buttons;

  /// Creates [CPGridTemplate] in order to display a grid of items as buttons.
  /// When creating the grid template, provide an array of [CPGridButton] objects.
  /// Each button must contain a title that is shown in the grid template's navigation bar.
  CPGridTemplate({
    required this.title,
    required this.buttons,
  });

  CPGridTemplateMessage toMessage() => CPGridTemplateMessage(
      elementId: elementId,
      title: title,
      buttons: buttons.map((e) => e.toMessage()).toList());

  @override
  CPTemplateMessage toTemplateMessage() => CPTemplateMessage(
        grid: toMessage(),
      );

  @override
  List<CPObject> getChildren() {
    return buttons;
  }
}
