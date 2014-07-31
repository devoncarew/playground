
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_checkbox.dart';
import 'package:playground/playground_app.dart';

void main() {
  print('Starting Polymer init...');

  // Init Polymer.
  initPolymer();

  // Register Polymer components (ones that are actually used in the app).
  registerWidgetsWithPolymer();
}

@initMethod
void postPolymerBoot() {
  print('Polymer init complete.');

  PlaygroundApp app = document.querySelector('playground-app');
  app.init();
}

void registerWidgetsWithPolymer() {
  //upgradeCoreIcon();
  upgradePaperCheckbox();
  //upgradePaperDialog();
  //upgradePaperFab();

//  Polymer.register('spark-button', SparkButton);
//  Polymer.register('spark-overlay', SparkOverlay);
//  Polymer.register('spark-dialog', SparkDialog);
//  Polymer.register('spark-dialog-button', SparkDialogButton);
//  Polymer.register('spark-selection', SparkSelection);
//  Polymer.register('spark-selector', SparkSelector);
//  Polymer.register('spark-menu', SparkMenu);
//  Polymer.register('spark-menu-button', SparkMenuButton);
//  Polymer.register('spark-menu-item', SparkMenuItem);
//  Polymer.register('spark-menu-separator', SparkMenuSeparator);
//  Polymer.register('spark-modal', SparkModal);
//  Polymer.register('spark-progress', SparkProgress);
//  Polymer.register('spark-splitter', SparkSplitter);
//  Polymer.register('spark-split-view', SparkSplitView);
//  Polymer.register('spark-status', SparkStatus);
//  Polymer.register('spark-toolbar', SparkToolbar);
//  Polymer.register('commit-message-view', CommitMessageView);
//  Polymer.register('goto-line-view', GotoLineView);
//  Polymer.register('spark-polymer-ui', SparkPolymerUI);
}
