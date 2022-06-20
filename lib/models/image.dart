import 'dart:typed_data';

import 'package:flutter_carplay/messages.dart';

abstract class CPImage {
  CPImage._();
  factory CPImage.systemName(String systemName) => _CPSystemImage._(systemName);
  factory CPImage.flutterAsset(String flutterAsset) =>
      _CPFlutterAssetImage._(flutterAsset);
  factory CPImage.data(Uint8List data) => _CPFDataImage._(data);

  CPImageMessage toMessage();
}

class _CPFlutterAssetImage extends CPImage {
  _CPFlutterAssetImage._(this.flutterAsset) : super._();

  final String flutterAsset;

  @override
  CPImageMessage toMessage() {
    return CPImageMessage(flutterAsset: flutterAsset);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _CPFlutterAssetImage && flutterAsset == other.flutterAsset;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ flutterAsset.hashCode;
}

class _CPFDataImage extends CPImage {
  _CPFDataImage._(this.data) : super._();

  final Uint8List data;

  @override
  CPImageMessage toMessage() {
    return CPImageMessage(data: data);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _CPFDataImage && _uint8ListEquals(data, other.data);
  }

  @override
  int get hashCode => runtimeType.hashCode ^ data.hashCode;
}

bool _uint8ListEquals(Uint8List a, Uint8List b) {
  if (a.length != b.length) {
    return false;
  }
  if (a.isEmpty && b.isEmpty) {
    return true;
  }
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}

class _CPSystemImage extends CPImage {
  _CPSystemImage._(this.systemName) : super._();

  final String systemName;

  @override
  CPImageMessage toMessage() {
    return CPImageMessage(systemName: systemName);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _CPSystemImage && systemName == other.systemName;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ systemName.hashCode;
}
