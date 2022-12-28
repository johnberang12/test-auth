import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueUI on AsyncValue {
  void showAlertDialogOnError(BuildContext context) {
    if (!isRefreshing && hasError) {
      showExceptionAlertDialog(
        context: context,
        title: 'Error',
        exception: error,
      );
    }
  }
}

const kDialogDefaultKey = Key('dialog-default-key');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showAlertDialog(
    {required BuildContext context,
    required String title,
    String? content,
    String? cancelActionText,
    String defaultActionText = 'OK',
    TextAlign contentAlignment = TextAlign.start}) async {
  if (kIsWeb || !Platform.isIOS) {
    return showDialog(
      context: context,
      barrierDismissible: cancelActionText != null,
      builder: (context) => AlertDialog(
        title: Text(title),
        content:
            content != null ? Text(content, textAlign: contentAlignment) : null,
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText,
                  style: const TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          TextButton(
            key: kDialogDefaultKey,
            child: Text(defaultActionText,
                style: const TextStyle(color: Colors.green)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    barrierDismissible: cancelActionText != null,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content:
          content != null ? Text(content, textAlign: contentAlignment) : null,
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText,
                style: const TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          key: kDialogDefaultKey,
          child: Text(
            defaultActionText,
            style: const TextStyle(color: Colors.blue),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'Ok',
    );
