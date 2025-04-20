import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_globals.dart';

enum MessageType { info, error }

final snackMessageProvider = Provider<SnackMessage>((ref) {
  return SnackMessage(ref);
});

class SnackMessage {
  final Ref ref;
  late final GlobalKey<ScaffoldMessengerState> messengerKey;

  SnackMessage(this.ref) {
    messengerKey = ref.read(appGlobalsProvider).messengerKey;
  }
  void showMessage({
    String message = '',
    MessageType messageType = MessageType.info,
  }) {
    Color? msgColor;
    switch (messageType) {
      case MessageType.info:
        msgColor = Colors.blue;
      case MessageType.error:
        msgColor = Colors.red;
    }
    messengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 0, milliseconds: 1000),
      backgroundColor: msgColor,
    ));
  }
}
