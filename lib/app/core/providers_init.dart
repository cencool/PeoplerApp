import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/core/app_state_notifier.dart';

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  final notifier = AppStateNotifier();
  notifier.initialize(); // Call initialization
  return notifier;
});
