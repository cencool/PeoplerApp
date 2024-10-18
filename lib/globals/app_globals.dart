import 'package:flutter/material.dart';
import 'package:peopler/config/app_config.dart';

class AppGlobals {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _personListType = AppConfig.personListType;

  get personListType => _personListType;
  get messengerKey => _messengerKey;
}
