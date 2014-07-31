
import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_toast.dart';
import 'package:paper_elements/paper_dialog.dart';

import 'nano/nano.dart';
import 'services/jobs.dart';
import 'services/notifier.dart';

@CustomTag('playground-app')
class PlaygroundApp extends PolymerElement {
  NanoContainer nano;

  JobManager get jobManager => nano[JobManager];
  Notifier get notifier => nano[Notifier];

  PlaygroundApp.created() : super.created();

  void init() {
    nano = new NanoContainer();
    NanoContainer.setGlobalInstance(nano);
    nano.runInNewZone(_init);
  }

  void _init() {
    nano[JobManager] = new JobManager();
    nano[Notifier] = new UINotifier(this);
  }

  void showMenu() {
    showMessage('TODO: show menu');
  }

  void handleRun() {
    //showMessage('TODO: handle run');
    jobManager.schedule(new RunJob());
  }

  void handleAdd() {
    showMessage('TODO: handle add');
  }

  void handleBack() {
    showMessage('TODO: handleBack()');
  }

  void handleForward() {
    showMessage('TODO: handleForward()');
  }

  void openSettings() {
    // TODO:
    notifier.askUserOkCancel('Foo Bar', 'Some message.');

//    PaperDialog dialog = $['okCancelDialog'];
//    dialog.heading = 'Settings';
//    dialog.toggle();
  }

  void showMessage(String message) {
    PaperToast toast = $['toast'];
    toast.text = message;
    toast.show();
  }
}

class RunJob extends Job {
  RunJob() : super('Running...');

  Future<JobStatus> run(ProgressMonitor monitor) {
    Notifier notifier = NanoContainer.instance.getService(Notifier);

    notifier.displaySuccess('Started job...');

    new Timer(new Duration(seconds: 5), () {
      notifier.displaySuccess('Finished job.');
      completer.complete(new JobStatus());
    });

    return future;
  }
}

class UINotifier extends Notifier {
  final PlaygroundApp app;

  UINotifier(this.app);

  void displaySuccess(String message) {
    app.showMessage(message);
  }

  void displayError(String message) {
    // TODO: Handle error message.
    app.showMessage(message);
  }

  Future<bool> askUserOkCancel(String title, String message,
      {String okButtonLabel: "OK", String cancelButtonLabel: "Cancel"}) {
    PaperDialog dialog = app.$['okCancelDialog'];
    dialog.heading = title;
    dialog.querySelector('p').text = message;
    dialog.querySelector('paper-button[autofocus]').attributes['label'] =
        okButtonLabel;
    dialog.querySelector('paper-button:not([autofocus])').attributes['label'] =
        cancelButtonLabel;
    dialog.opened = true;

    // TODO: Implement - return a value.
    return new Future.value(true);
  }
}
