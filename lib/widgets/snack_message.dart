import 'package:flutter/material.dart';

enum MessageType { info, error }

class SnackMessage {
  static void showMessage(
      {required BuildContext context,
      String message = '',
      MessageType messageType = MessageType.info}) {
    Color? msgColor;

    switch (messageType) {
      case MessageType.info:
        msgColor = Colors.blue;
      case MessageType.error:
        msgColor = Colors.red;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 0, milliseconds: 500),
      backgroundColor: msgColor,
    ));
  }
}
