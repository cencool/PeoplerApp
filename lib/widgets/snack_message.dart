import 'package:flutter/material.dart';
import 'package:peopler/globals/app_globals.dart';
import 'package:peopler/main.dart';

enum MessageType { info, error }

class SnackMessage {
  static void showMessage({
    // required GlobalKey<ScaffoldMessengerState> messengerKey,
    String message = '',
    MessageType messageType = MessageType.info,
  }) {
    GlobalKey<ScaffoldMessengerState> messengerKey = getIt<AppGlobals>().messengerKey;

    Color? msgColor;
    switch (messageType) {
      case MessageType.info:
        msgColor = Colors.blue;
      case MessageType.error:
        msgColor = Colors.red;
    }
    messengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 0, milliseconds: 500),
      backgroundColor: msgColor,
    ));
  }
}
