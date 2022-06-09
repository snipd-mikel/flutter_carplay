import 'package:flutter_carplay/messages.dart';

abstract class CPImage {
  CPImage._();
  factory CPImage.systemName(String systemName) => _CPSystemImage._(systemName);
  factory CPImage.flutterAsset(String flutterAsset) =>
      _CPFlutterAssetImage._(flutterAsset);
  factory CPImage.base64(String base64) => _CPFBase64Image._(base64);

  CPImageMessage toMessage();
}

class _CPFlutterAssetImage extends CPImage {
  _CPFlutterAssetImage._(this.flutterAsset) : super._();

  final String flutterAsset;

  @override
  CPImageMessage toMessage() {
    return CPImageMessage(flutterAsset: flutterAsset);
  }
}

class _CPFBase64Image extends CPImage {
  _CPFBase64Image._(this.base64) : super._();

  final String base64;

  @override
  CPImageMessage toMessage() {
    return CPImageMessage(base64: base64);
  }
}

class _CPSystemImage extends CPImage {
  _CPSystemImage._(this.systemName) : super._();

  final String systemName;

  @override
  CPImageMessage toMessage() {
    return CPImageMessage(systemName: systemName);
  }
}
