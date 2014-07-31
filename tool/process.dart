
import 'dart:io';

import 'package:html5lib/parser.dart' show parse;
import 'package:html5lib/dom.dart';
import 'package:html5lib/dom_parsing.dart';
import 'package:path/path.dart' as path;

void main(List args) {
  if (args.length != 1) {
    print('usage: process <dirname>');
    exit(1);
  }

  Directory dir = new Directory(args.first);

  if (!dir.existsSync()) {
    print('usage: process <dirname>');
    exit(1);
  }

  dir.listSync(recursive: true, followLinks: true).forEach((FileSystemEntity entry) {
    if (entry is File) {
      File file = entry;

      if (file.path.endsWith('.html')) {
        _process(file);
      }
    }
  });
}

void _process(File file) {
  Document document = parse(file.readAsStringSync());

  ScriptProcessor visitor = new ScriptProcessor(file, document);
  visitor.processDoc();
}

class ScriptProcessor extends TreeVisitor {
  final File file;
  final Document document;

  Element polymerElement;

  bool noScript = false;
  List<Element> scriptNodes = [];

  ScriptProcessor(this.file, this.document);

  bool needsProcessing() => noScript || scriptNodes.isNotEmpty;

  void processDoc() {
    visitDocument(document);
  }

  void visitElement(Element node) {
    if (node.localName == 'script') {
      _checkScript(node);
    } else if (node.localName == 'polymer-element') {
      if (_checkPolymerElement(node)) {
        visitChildren(node);
      }
    } else {
      visitChildren(node);
    }
  }

  void process() {
    print('processing ${file.path}');

    Directory dir = file.parent;
    String elementName = polymerElement.attributes['name'];

    if (noScript) {
      polymerElement.attributes.remove('noscript');

      String fileName = '${elementName}.js';
      File outFile = new File(path.join(dir.path, fileName));
      outFile.writeAsStringSync("Polymer('${elementName}', {});\n");

      // <script src="core-splitter.js"></script>
      Element scriptNode = new Element.tag('script');
      scriptNode.attributes['src'] = fileName;
      polymerElement.append(scriptNode);
    } else {
      for (int i = 0; i < scriptNodes.length; i++) {
        Element node = scriptNodes[i];

        String fileName = (i == 0 ? elementName : '${elementName}-${i}') + '.js';
        File outFile = new File(path.join(dir.path, fileName));

        outFile.writeAsStringSync(node.innerHtml);

        Element newNode = new Element.tag('script');
        newNode.attributes['src'] = fileName;
        node.replaceWith(newNode);
      }

      scriptNodes.clear();
    }

    file.writeAsStringSync(document.outerHtml);
  }

  bool _checkPolymerElement(Element node) {
    polymerElement = node;

    // <polymer-element name="core-toolbar" noscript>
    if (node.attributes.containsKey('noscript')) {
      noScript = true;
      polymerElement = node;

      process();

      return false;
    } else {
      return true;
    }
  }

  void _checkScript(Element node) {
    if (polymerElement == null) return;

    if (node.attributes['type'] == 'application/dart') return;

    if (node.attributes.containsKey('src')) return;

    if (!node.innerHtml.isEmpty) {
      scriptNodes.add(node);
      process();
    }
  }
}
