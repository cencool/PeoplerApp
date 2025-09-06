import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/services/auth_service.dart';
import 'package:peopler/app/ui/models/login_page_state.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/ui/widgets/snack_message.dart';

final loginPageVMProvider = StateNotifierProvider<LoginPageVM, LoginPageState>(
  (ref) => LoginPageVM(ref),
);

class LoginPageVM extends StateNotifier<LoginPageState> {
  final Ref ref;
  final SnackMessage snackMessage;

  LoginPageVM(this.ref)
      : snackMessage = ref.read(snackMessageProvider),
        super(LoginPageState.initial());

  void togglePasswordVisibility() {
    state = state.copyWith(hidePassword: !state.hidePassword);
  }

  void setProcessing(bool processing) {
    state = state.copyWith(isProcessing: processing);
  }

  Future<void> login({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    var repository = ref.read(authRepositoryProvider);
    if (state.isProcessing) return;

    setProcessing(true);
    snackMessage.showMessage(message: 'Processing', messageType: MessageType.info);

    final result =
        await AuthService().login(repository: repository, userName: username, password: password);

    setProcessing(false);

    switch (result) {
      case Success(value: final credentials):
        snackMessage.showMessage(message: 'Login Successful', messageType: MessageType.info);
        ref.read(appStateProvider.notifier).credentials = credentials;
        ref.read(appStateProvider.notifier).activePage = ActivePage.personList;
        break;
      case Failure(error: final error):
        snackMessage.showMessage(message: 'Login failed: $error', messageType: MessageType.error);
        ref.read(appStateProvider.notifier).credentials = null;
        ref.read(appStateProvider.notifier).activePage = ActivePage.login;
        break;
    }
  }
}
