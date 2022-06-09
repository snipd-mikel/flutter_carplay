import 'package:flutter/foundation.dart';
import 'package:flutter_carplay/carplay_controller.dart';
import 'package:flutter_carplay/messages.dart';
import 'package:uuid/uuid.dart';

class CPNullable<T> {
  final T? value;
  final bool hasValue;

  const CPNullable.empty()
      : value = null,
        hasValue = false;
  const CPNullable(this.value) : hasValue = true;
}

extension CPOptionalExtension<T> on T {
  CPNullable<T> get nullable => CPNullable(this);
}

abstract class CPObject {
  final elementId = const Uuid().v4();

  List<CPObject> getChildren();
}

mixin CPMutableObject<T extends CPObject> on CPObject {
  @protected
  void onUpdate() {
    CarplayControllerInternal.instance.updateObject<T>(this);
  }
}

abstract class CPTemplate extends CPObject {
  CPTemplateMessage toTemplateMessage();
}

abstract class CPPresentAction extends CPObject {
  /// A callback function that CarPlay invokes after the user taps the action button.
  Function() get onPress;
}

abstract class CPPresentTemplate extends CPObject {
  List<CPPresentAction> get actions;
}
