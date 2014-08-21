
import 'dart:async';
import 'dart:html';

import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart' as ace_proxy;
import 'package:polymer/polymer.dart';

@CustomTag('ace-view')
class AceView extends PolymerElement {
  ace.Editor editor;

  AceView.created() : super.created();

  void attached() {
    super.attached();

    ace.implementation = ace_proxy.ACE_PROXY_IMPLEMENTATION;
    editor = ace.edit(_container);
    //editor.renderer.fixedWidthGutter = true;
    editor.showPrintMargin = false;
    editor.renderer.showGutter = false;
    editor.highlightActiveLine = false;
    //editor.printMarginColumn = 80;
    editor.theme = new ace.Theme.named('monokai');
    editor.resize(false);

    _syncStyleNodes();

    new Timer(new Duration(milliseconds: 100), () {
      _syncStyleNodes();

      ace.EditSession session = ace.createEditSession(text,
          new ace.Mode.forFile('foo.dart'));
      session.value = SAMPLE_SOURCE;
      session.useWorker = false;
      editor.session = session;
    });

    editor.onChangeSelection.listen((_) {
      notifyPropertyChange(#lineNumber, 0, lineNumber);
    });
  }

  @reflectable
  int get lineNumber => editor == null ? 0 : editor.selectionRange.start.row;

  Element get _container => $['container'];

  int _styleId = 0;

  void _syncStyleNodes() {
    Set<String> existingStyles = new Set();

    existingStyles.addAll(shadowRoot
        .querySelectorAll('style')
        .map((style) => _getStyleId(style)));

    // Look for and copy new styles.
    document.head.querySelectorAll('style').forEach((Element element) {
      if (element.text.contains('.ace_')) {
        String id = _getStyleId(element);
        if (id == null) {
          _cloneStyle(element, shadowRoot);
        } else {
          existingStyles.remove(id);
        }
      }
    });

    // Remove old styles.
    if (existingStyles.isNotEmpty) {
      shadowRoot.querySelectorAll('styles').reversed.forEach((Element e) {
        if (existingStyles.contains(_getStyleId(e))) {
          e.parent.children.remove(e);
        }
      });
    }
  }

  String _getStyleId(Element element) => element.attributes['styleId'];

  void _cloneStyle(Element element, Node parent) {
    String id = '${_styleId++}';

    // Stamp the source with a unique id.
    element.attributes['styleId'] = id;

    // Copy the source to the dest.
    StyleElement e = new StyleElement();
    e.text = element.text;
    if (element.attributes.containsKey('id')) {
      e.id = element.id;
    }
    e.attributes['styleId'] = id;
    parent.append(e);

    e.disabled = true;
    e.disabled = false;
  }
}

@CustomTag('ace-status')
class AceStatus extends PolymerElement {
  @published int line = 0;

  @reflectable String get statusText => '${line}';

  AceStatus.created() : super.created();
}

final String SAMPLE_SOURCE = r"""

library ace_view;

import 'dart:async';
import 'dart:html';

import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart' as ace_proxy;
import 'package:polymer/polymer.dart';

@CustomTag('ace-view')
class AceView extends PolymerElement {
  ace.Editor editor;

  AceView.created() : super.created();

  void attached() {
    super.attached();

    ace.implementation = ace_proxy.ACE_PROXY_IMPLEMENTATION;
    editor = ace.edit(_container);
    //editor.renderer.fixedWidthGutter = true;
    editor.showPrintMargin = false;
    editor.renderer.showGutter = false;
    editor.highlightActiveLine = false;
    //editor.printMarginColumn = 80;
    editor.theme = new ace.Theme.named('monokai');
    editor.resize(false);

    _syncStyleNodes();

    new Timer(new Duration(milliseconds: 100), () {
      _syncStyleNodes();

      ace.EditSession session = ace.createEditSession(text,
          new ace.Mode.forFile('foo.dart'));
      session.value = '\nvoid main() {\n  print("hello");\n}\n';
      session.useWorker = false;
      editor.session = session;
    });

    editor.onChangeSelection.listen((_) {
      notifyPropertyChange(#lineNumber, 0, lineNumber);
    });
  }

  @reflectable
  int get lineNumber => editor == null ? 0 : editor.selectionRange.start.row;

  Element get _container => $['container'];

  int _styleId = 0;

  void _syncStyleNodes() {
    Set<String> existingStyles = new Set();

    existingStyles.addAll(shadowRoot
        .querySelectorAll('style')
        .map((style) => _getStyleId(style)));

    // Look for and copy new styles.
    document.head.querySelectorAll('style').forEach((Element element) {
      if (element.text.contains('.ace_')) {
        String id = _getStyleId(element);
        if (id == null) {
          _cloneStyle(element, shadowRoot);
        } else {
          existingStyles.remove(id);
        }
      }
    });

    // Remove old styles.
    if (existingStyles.isNotEmpty) {
      shadowRoot.querySelectorAll('styles').reversed.forEach((Element e) {
        if (existingStyles.contains(_getStyleId(e))) {
          e.parent.children.remove(e);
        }
      });
    }
  }

  String _getStyleId(Element element) => element.attributes['styleId'];

  void _cloneStyle(Element element, Node parent) {
    String id = '${_styleId++}';

    // Stamp the source with a unique id.
    element.attributes['styleId'] = id;

    // Copy the source to the dest.
    StyleElement e = new StyleElement();
    e.text = element.text;
    if (element.attributes.containsKey('id')) {
      e.id = element.id;
    }
    e.attributes['styleId'] = id;
    parent.append(e);

    e.disabled = true;
    e.disabled = false;
  }
}

@CustomTag('ace-status')
class AceStatus extends PolymerElement {
  @published int line = 0;

  @reflectable String get statusText => '${line}';

  AceStatus.created() : super.created();
}

""";