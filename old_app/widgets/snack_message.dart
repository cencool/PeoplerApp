import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_globals.dart';

enum MessageType { info, error }

class SnackMessage {
  static void showMessage({
    required Ref ref,
    // required GlobalKey<ScaffoldMessengerState> messengerKey,
    String message = '',
    MessageType messageType = MessageType.info,
  }) {
    GlobalKey<ScaffoldMessengerState> messengerKey = ref.read(appGlobalsProvider).messengerKey;

    Color? msgColor;
    switch (messageType) {
      case MessageType.info:
        msgColor = Colors.blue;
      case MessageType.error:
        msgColor = Colors.red;
    }
    messengerKey.currentState!.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 0, milliseconds: 1000),
      backgroundColor: msgColor,
    ));
  }
}
