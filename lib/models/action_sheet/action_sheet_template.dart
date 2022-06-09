import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/alert/alert_action.dart';
import 'package:flutter_carplay/models/template_base.dart';

/// A template object that displays a modal action sheet.
class CPActionSheetTemplate extends CPPresentTemplate {
  /// The title of the action sheet.
  final String? title;

  /// The descriptive message providing details about the reason for displaying the action sheet.
  final String? message;

  /// The list of actions as [CPAlertAction] available on the action sheet.
  @override
  final List<CPAlertAction> actions;

  /// Creates [CPActionSheetTemplate] with a title, a message and a list of actions available on the action sheet.
  CPActionSheetTemplate({
    this.title,
    this.message,
    required this.actions,
  });

  CPActionSheetTemplateMessage toMessage() => CPActionSheetTemplateMessage(
        elementId: elementId,
        title: title,
        message: message,
        actions: actions.map((e) => e.toMessage()).toList(),
      );

  @override
  List<CPObject> getChildren() {
    throw actions;
  }
}
