import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/data/repositories/auth_repository.dart';
import 'package:peopler/app/data/repositories/person_repository.dart';
import 'package:peopler/app/data/services/auth_service.dart';
import 'package:peopler/app/domain/models/credentials.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/person_detail.dart';

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
  AppStateNotifier({required this.ref}) : super(AppState.initial());

  final Ref ref;

  Future<bool> initialize() async {
    var userRepository = ref.read(authRepositoryProvider);
    Credentials? credentials = await AuthService.autoLogin(userRepository: userRepository);
    if (credentials != null) {
      state = state.copyWith(
          isInitialized: true, credentials: credentials, activePage: ActivePage.personList);
      debugPrint(
          'AppStateNotifier.initialize: user: ${state.credentials!.userName}, token: ${state.credentials!.token}');
    } else {
      state = state.copyWith(isInitialized: true, activePage: ActivePage.login);
      debugPrint('AppStateNotifier.initialize: isInitialized: ${state.isInitialized}');
    }

    return true;
  }

  set isInitialized(bool isInitialized) {
    state = state.copyWith(isInitialized: isInitialized);
  }

  set credentials(Credentials? credentials) {
    state = state.copyWith(credentials: credentials);
  }

  set activePage(ActivePage activePage) {
    state = state.copyWith(activePage: activePage);
  }

  set activePerson(Person person) {
    state = state.copyWith(activePerson: person);
  }

  set activePersonDetail(PersonDetail personDetail) {
    state = state.copyWith(activePersonDetail: personDetail);
  }
}
