import 'package:flutter/material.dart';
import 'package:peopler/config/app_config.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AppGlobals {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _sfDataGridKey = GlobalKey<SfDataGridState>();
  final _personListType = AppConfig.personListType;

  get personListType => _personListType;
  get messengerKey => _messengerKey;
  get sfDataGridKey => _sfDataGridKey;
}
