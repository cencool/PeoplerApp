import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/config/app_config.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Provider definition
final appGlobalsProvider = Provider<AppGlobals>((ref) {
  // Creates a single instance when first read
  return AppGlobals();
});

class AppGlobals {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _sfDataGridKey = GlobalKey<SfDataGridState>();
  final _personListType = AppConfig.personListType;

  get personListType => _personListType;
  get messengerKey => _messengerKey;
  get sfDataGridKey => _sfDataGridKey;
}
