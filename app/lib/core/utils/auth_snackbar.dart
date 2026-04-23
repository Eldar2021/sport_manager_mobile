import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

const _erroDuraition = Duration(seconds: 5);
const _successDuraition = Duration(seconds: 2);
const _infoDuraition = Duration(seconds: 5);

extension AuthSnackBarX on BuildContext {
  static void hideCurrentSnackbar() {
    toastification.dismissAll();
  }

  void showErrorSnackBar(String title, [String? message]) {
    toastification.show(
      context: this,
      title: Text(
        title.trim(),
        maxLines: 5,
        textAlign: TextAlign.left,
      ),
      description: message == null ? null : Text(message),
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: _erroDuraition,
      showProgressBar: false,
      icon: const Icon(Icons.error_outline),
    );
  }

  void showSuccessSnackBar(String title, [String? message]) {
    toastification.show(
      context: this,
      title: Text(
        title.trim(),
        maxLines: 5,
        textAlign: TextAlign.left,
      ),
      description: message == null ? null : Text(message),
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: _successDuraition,
      showProgressBar: false,
      icon: const Icon(Icons.check_circle_outline),
    );
  }

  void showInfoSnackBar(String title, [String? message]) {
    toastification.show(
      context: this,
      title: Text(
        title.trim(),
        maxLines: 2,
        textAlign: TextAlign.left,
      ),
      description: message == null ? null : Text(message),
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      alignment: Alignment.topCenter,
      autoCloseDuration: _infoDuraition,
      showProgressBar: false,
      icon: const Icon(Icons.info_outline),
    );
  }
}
