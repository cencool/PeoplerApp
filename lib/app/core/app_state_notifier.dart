import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/domain/models/user.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState.initial());

  Future<bool> initialize() async {
    User? user = await User.autoLogin();
    if (user != null) {
      state = state.copyWith(user: user, isLoggedIn: true, isInitialized: true);
      debugPrint(
          'AppStateNotifier.initialize: user: ${state.user.id}, isLoggedIn: ${state.isLoggedIn}');
    } else {
      state = state.copyWith(isInitialized: true);
      debugPrint('AppStateNotifier.initialize: isInitialized: ${state.isInitialized}');
    }

    return true;
  }

  set user(User user) {
    state = state.copyWith(user: user);
  }

  set isLoggedIn(bool isLoggedIn) {
    state = state.copyWith(isLoggedIn: isLoggedIn);
  }
}
