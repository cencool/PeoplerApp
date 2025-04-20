import 'package:flutter/foundation.dart';
import 'package:peopler/app/domain/models/credentials.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/person_detail.dart';

enum ActivePage { login, personList, person }

@immutable
class AppState {
  final Credentials? credentials;
  final Person activePerson;
  final PersonDetail activePersonDetail;
  final ActivePage activePage;
  final bool isInitialized;

  const AppState({
    this.credentials,
    required this.activePerson,
    required this.activePersonDetail,
    required this.activePage,
    required this.isInitialized,
  });

  factory AppState.initial() => AppState(
      activePerson: Person.dummy(),
      activePersonDetail: PersonDetail.dummy(-1),
      activePage: ActivePage.login,
      isInitialized: false);
  AppState copyWith(
      {Credentials? credentials,
      Person? activePerson,
      PersonDetail? activePersonDetail,
      ActivePage? activePage,
      bool? isInitialized}) {
    return AppState(
        credentials: credentials ?? this.credentials,
        activePerson: activePerson ?? this.activePerson,
        activePersonDetail: activePersonDetail ?? this.activePersonDetail,
        activePage: activePage ?? this.activePage,
        isInitialized: isInitialized ?? this.isInitialized);
  }
}
