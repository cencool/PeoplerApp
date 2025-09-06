import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/config/app_config.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Provider definition
final appSettingsProvider = Provider<AppSetup>((ref) {
  // Creates a single instance when first read
  return AppSetup();
});

class AppSetup {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _sfDataGridKey = GlobalKey<SfDataGridState>();
  final _personListType = AppConfig.personListType;
  final _apiService = AppConfig.apiService;

  get personListType => _personListType;
  get messengerKey => _messengerKey;
  get sfDataGridKey => _sfDataGridKey;
  get apiService => _apiService;
}
