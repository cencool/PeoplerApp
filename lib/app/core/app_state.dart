import 'package:flutter/foundation.dart';
import 'package:peopler/app/domain/models/user.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/person_detail.dart';

enum ActivePage { login, personList, person }

@immutable
class AppState {
  final bool isLoggedIn;
  final String userName;
  final String authString;
  final User user;
  final Person activePerson;
  final PersonDetail activePersonDetail;
  final ActivePage activePage;
  final bool isInitialized;

  const AppState({
    required this.isLoggedIn,
    required this.userName,
    required this.authString,
    required this.user,
    required this.activePerson,
    required this.activePersonDetail,
    required this.activePage,
    required this.isInitialized,
  });

  factory AppState.initial() => AppState(
      isLoggedIn: false,
      userName: '',
      authString: '',
      user: User(id: ''),
      activePerson: Person.dummy(),
      activePersonDetail: PersonDetail.dummy(-1),
      activePage: ActivePage.login,
      isInitialized: false);
  AppState copyWith(
      {bool? isLoggedIn,
      User? user,
      String? userName,
      String? authString,
      Person? activePerson,
      PersonDetail? activePersonDetail,
      ActivePage? activePage,
      bool? isInitialized}) {
    return AppState(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        userName: userName ?? this.userName,
        authString: authString ?? this.authString,
        user: user ?? this.user,
        activePerson: activePerson ?? this.activePerson,
        activePersonDetail: activePersonDetail ?? this.activePersonDetail,
        activePage: activePage ?? this.activePage,
        isInitialized: isInitialized ?? this.isInitialized);
  }
}
