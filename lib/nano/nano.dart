
library nano;

import 'dart:async';

// TODO:

/**
 * TODO:
 */
class NanoContainer {
  static NanoContainer _instance;

  /**
   * TODO:
   */
  static NanoContainer get instance {
    NanoContainer nano = Zone.current['nano'];
    return nano != null ? nano : _instance;
  }

  static setGlobalInstance(NanoContainer nano) {
    _instance = nano;
  }

  Map<Type, dynamic> _services = {};

  NanoContainer();

  /**
   * TODO:
   */
  void runInNewZone(Function function) {
    Zone zone = Zone.current.fork(zoneValues: {'nano': this});
    zone.run(function);
  }

  dynamic getService(Type type) => _services[type];

  void setService(Type type, dynamic instance) {
    _services[type] = instance;
  }

  dynamic operator[](Type type) => _services[type];

  void operator[]=(Type type, dynamic instance) {
    _services[type] = instance;
  }

  Iterable<Type> get services => _services.keys;
}
