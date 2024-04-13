import 'package:flutter/material.dart';

class AppKeys {
  final _personViewMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _personListMessengerKey = GlobalKey<ScaffoldMessengerState>();
  get personViewMessengerKey {
    return _personViewMessengerKey;
  }

  get personListMessengerKey {
    return _personListMessengerKey;
  }
}
