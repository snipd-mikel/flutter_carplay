import 'package:flutter/foundation.dart';
import 'package:flutter_carplay/flutter_carplay.dart';

class CarplayState {
  List<CPTemplate> _historyStack = [];
  final Map<String, CPObject> _objectMap = {};
  final Map<String, String> _parentMap = {};
  final Map<String, VoidCallback> _popCallbacks = {};
  CPTemplate? _rootTemplate;
  CPPresentTemplate? _presentTemplate;

  CPPresentTemplate? get currentPresentTemplate => _presentTemplate;
  CPTemplate? get rootTemplate => _rootTemplate;
  CPTemplate? get topTemplate =>
      _historyStack.isEmpty ? null : _historyStack.last;
  List<CPTemplate> get templates => _historyStack;

  void pushTemplate(CPTemplate template, {VoidCallback? onPop}) {
    _historyStack.add(template);
    if (onPop != null) {
      _popCallbacks[template.elementId] = onPop;
    }
    _addObject(template, null);
  }

  void updateObject(CPObject updated) {
    final existing = getById(updated.elementId);
    final parentId = _parentMap[updated.elementId];
    if (existing != null) {
      _removeObject(existing);
    }
    _addObject(updated, parentId);
  }

  void setRootTemplate(CPTemplate template) {
    if (_rootTemplate != null) {
      _removeObject(_rootTemplate!);
    }
    _addObject(template, null);
    _rootTemplate = template;
    popToRoot();
  }

  void syncHistoryStack(List<String> templateIds) {
    final newHistoryStack = <CPTemplate>[];
    for (final id in templateIds) {
      if (id == CPNowPlayingTemplate.shared.elementId) {
        newHistoryStack.add(CPNowPlayingTemplate.shared);
      } else {
        final template = getById<CPTemplate>(id);
        if (template == null) {
          // ignore: avoid_print
          print('CPState: Couldnt find tempalte with id $id');
        } else {
          newHistoryStack.add(template);
        }
      }
    }

    for (final template in _historyStack) {
      if (!newHistoryStack.contains(template)) {
        _removeObject(template);
      }
    }
    for (final template in newHistoryStack) {
      if (!_historyStack.contains(template)) {
        _addObject(template, null);
      }
    }

    _historyStack = newHistoryStack;
  }

  void pop() {
    if (_historyStack.isNotEmpty) {
      final template = _historyStack.removeLast();
      _removeObject(template);
    }
  }

  void popModal() {
    if (_presentTemplate != null) {
      _removeObject(_presentTemplate!);
    }
    _presentTemplate = null;
  }

  void presentTemplate(CPPresentTemplate template) {
    if (_presentTemplate != null) {
      _removeObject(_presentTemplate!);
    }
    _addObject(template, null);
    _presentTemplate = template;
  }

  void popToRoot() {
    for (final historyTemplate in _historyStack) {
      if (historyTemplate != rootTemplate) {
        _removeObject(historyTemplate);
      }
    }
    _historyStack = [if (rootTemplate != null) rootTemplate!];
  }

  T? getById<T extends CPObject>(String elementId) {
    final object = _objectMap[elementId];
    if (object == null || object is! T) {
      return null;
    }
    return object;
  }

  void _addObject(CPObject object, String? parentId) {
    _objectMap[object.elementId] = object;
    if (parentId != null) {
      _parentMap[object.elementId] = parentId;
    }

    for (final child in object.getChildren()) {
      _addObject(child, object.elementId);
    }
  }

  void _removeObject(CPObject object) {
    final popCallback = _popCallbacks[object.elementId];
    if (popCallback != null) {
      popCallback();
      _popCallbacks.remove(object.elementId);
    }
    _objectMap.remove(object.elementId);
    _parentMap.remove(object.elementId);

    _parentMap
        .removeWhere((elementId, parentId) => parentId == object.elementId);
    for (final child in object.getChildren()) {
      _removeObject(child);
    }
  }
}
