import 'package:flutter_carplay/flutter_carplay.dart';
import 'package:flutter_carplay/messages.dart';

/// A section object of list items that appear in a list template.
class CPPointOfInterest extends CPObject {
  /// Header text of the section.
  double latitude = 0.0;
  double longitude = 0.0;
  String title = '';
  String? subtitle;
  String? summary;
  String? detailTitle;
  String? detailSubtitle;
  String? detailSummary;
  CPImage? image;

  final CPTextButton? primaryButton;
  final CPTextButton? secondaryButton;

  /// Creates [CPPointOfInterest]
  CPPointOfInterest(
      {required this.latitude,
      required this.longitude,
      required this.title,
      this.subtitle,
      this.summary,
      this.detailTitle,
      this.detailSubtitle,
      this.detailSummary,
      this.image,
      this.primaryButton,
      this.secondaryButton});

  CPPointOfInterestMessage toMessage() => CPPointOfInterestMessage(
        elementId: elementId,
        latitude: latitude,
        longitude: longitude,
        title: title,
        image: image?.toMessage(),
        detailsSubtitle: detailSubtitle,
        detailSummary: detailSummary,
        detailTitle: detailTitle,
        secondaryButton: secondaryButton?.toMessage(),
        subtitle: subtitle,
        summary: summary,
        primaryButton: primaryButton?.toMessage(),
      );

  @override
  List<CPObject> getChildren() {
    return [
      if (primaryButton != null) primaryButton!,
      if (secondaryButton != null) secondaryButton!,
    ];
  }
}
