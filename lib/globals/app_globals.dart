import 'package:flutter/material.dart';

class AppGlobals {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();

  get messengerKey => _messengerKey;
}
