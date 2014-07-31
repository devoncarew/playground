// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/**
 * TODO:
 */
library scriptable;

import 'dart:async';

/**
 * TODO:
 */
abstract class IsScriptable {
  Scriptable getScriptable();
}

/**
 * TODO:
 */
class Scriptable {
  final String name;
  final List<ScriptableProperty> properties;
  final List<ScriptableAction> actions;

  Scriptable(this.name, this.properties, this.actions);

  /**
   * Return any [Scriptable]s referenced from the properties of this object.
   */
  List<Scriptable> getReferencedScriptables() {
    return properties
        .map((property) => property.value)
        .where((value) => value is IsScriptable)
        .map((value) => value.getScriptable())
        .toList();
  }

  ScriptableAction getAction(String name) {
    return actions.firstWhere((action) => action.name == name,
        orElse: () => null);
  }

  String toString() => 'scriptable ${name}';
}

/**
 * TODO:
 */
class ScriptableProperty {
  final String name;
  final Function _getter;
  final Function _setter;

  ScriptableProperty(this.name, this._getter, [this._setter]);

  dynamic get value => _getter();

  set value(dynamic val) {
    if (_setter != null) {
      _setter(val);
    }
  }

  bool get isMutable => _setter != null;

  String toString() => 'property ${name}';
}

/**
 * TODO:
 */
class ScriptableAction {
  final String name;
  final Function _function;

  ScriptableAction(this.name, this._function);

  Future invoke() {
    try {
      var result = _function();
      return result is Future ? result : new Future.value(result);
    } catch (e) {
      return new Future.error(e);
    }
  }

  String toString() => 'action ${name}';
}
