
library notifier;

import 'dart:async';

abstract class Notifier {
  Notifier();

  void displaySuccess(String message);

  void displayError(String message);

  Future<bool> askUserOkCancel(String title, String message,
      {String okButtonLabel, String cancelButtonLabel});
}
