import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/repositories/auth_repository.dart';
import 'package:peopler/app/data/repositories/person_repository.dart';
import 'package:peopler/app/data/services/auth_service.dart';
import 'package:peopler/app/domain/models/credentials.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/person_detail.dart';
import 'package:peopler/app/ui/widgets/snack_message.dart';

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  final notifier = AppStateNotifier(ref: ref);
  notifier.initialize(); // Call initialization
  return notifier;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref));

final personRepositoryProvider = Provider<PersonRepository>((ref) {
  return PersonRepository(ref);
});

class AppStateNotifier extends StateNotifier<AppState> {
  final Ref ref;
  late final SnackMessage snackMessage;

  AppStateNotifier({required this.ref}) : super(AppState.initial()) {
    snackMessage = ref.read(snackMessageProvider);
  }

  Future<bool> initialize() async {
    var userRepository = ref.read(authRepositoryProvider);
    Credentials? credentials = await AuthService.autoLogin(userRepository: userRepository);
    if (credentials != null) {
      var resultState = state.copyWith(
          isInitialized: true, credentials: credentials, activePage: ActivePage.personList);
      switch (resultState) {
        case Success(value: final stateValue):
          state = stateValue;
          debugPrint(
              'AppStateNotifier.initialize: user: ${stateValue.credentials!.userName}, token: ${stateValue.credentials!.token}');
        case Failure(error: final error):
          snackMessage.showMessage(message: error, messageType: MessageType.error);
      }
    } else {
      var resultState = state.copyWith(isInitialized: true, activePage: ActivePage.login);
      switch (resultState) {
        case Success(value: final stateValue):
          state = stateValue;
          debugPrint('AppStateNotifier.initialize: isInitialized: ${stateValue.isInitialized}');
        case Failure(error: final error):
          snackMessage.showMessage(message: error, messageType: MessageType.error);
      }
    }

    return true;
  }

  set isInitialized(bool isInitialized) {
    var resultState = state.copyWith(isInitialized: isInitialized);
    switch (resultState) {
      case Success(value: final stateValue):
        state = stateValue;
        debugPrint('AppStateNotifier.isInitialized: ${stateValue.isInitialized}');
      case Failure(error: final error):
        snackMessage.showMessage(message: error, messageType: MessageType.error);
    }
  }

  set credentials(Credentials? credentials) {
    var resultState = state.copyWith(credentials: credentials);
    switch (resultState) {
      case Success(value: final stateValue):
        state = stateValue;
        debugPrint('AppStateNotifier.credentials: ${stateValue.credentials}');
      case Failure(error: final error):
        snackMessage.showMessage(message: error, messageType: MessageType.error);
    }
  }

  set activePage(ActivePage activePage) {
    var resultState = state.copyWith(activePage: activePage);
    switch (resultState) {
      case Success(value: final stateValue):
        state = stateValue;
        debugPrint('AppStateNotifier.activePage: ${stateValue.activePage}');
      case Failure(error: final error):
        snackMessage.showMessage(message: error, messageType: MessageType.error);
    }
  }

  set activePerson(Person person) {
    var resultState = state.copyWith(activePerson: person);
    switch (resultState) {
      case Success(value: final stateValue):
        state = stateValue;
        debugPrint('AppStateNotifier.activePerson: ${stateValue.activePerson}');
      case Failure(error: final error):
        snackMessage.showMessage(message: error, messageType: MessageType.error);
    }
  }

  set activePersonDetail(PersonDetail personDetail) {
    var resultState = state.copyWith(activePersonDetail: personDetail);
    switch (resultState) {
      case Success(value: final stateValue):
        state = stateValue;
        debugPrint('AppStateNotifier.activePersonDetail: ${stateValue.activePersonDetail}');
      case Failure(error: final error):
        snackMessage.showMessage(message: error, messageType: MessageType.error);
    }
  }
}
