import 'package:flutter_carplay/messages.dart';
import 'package:flutter_carplay/models/template_base.dart';

import 'poi.dart';

/// A template object that displays point of interest.
class CPPointOfInterestTemplate extends CPTemplate {
  /// A title will be shown in the navigation bar.
  final String title;
  final List<CPPointOfInterest> poi;

  /// Creates [CPPointOfInterestTemplate]
  CPPointOfInterestTemplate({required this.title, required this.poi});

  CPPointOfInterestTemplateMessage toMessage() =>
      CPPointOfInterestTemplateMessage(
        elementId: elementId,
        title: title,
        poi: poi.map((e) => e.toMessage()).toList(),
      );
  @override
  CPTemplateMessage toTemplateMessage() => CPTemplateMessage(
        poi: toMessage(),
      );

  @override
  List<CPObject> getChildren() {
    return poi;
  }
}
