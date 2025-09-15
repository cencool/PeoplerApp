import 'package:flutter/foundation.dart';
import 'package:peopler/app/core/result.dart';
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

  const AppState._({
    this.credentials,
    required this.activePerson,
    required this.activePersonDetail,
    required this.activePage,
    required this.isInitialized,
  });

  factory AppState.initial() => AppState._(
      activePerson: Person.dummy(),
      activePersonDetail: PersonDetail.dummy(-1),
      activePage: ActivePage.login,
      isInitialized: false);

  Result<AppState, String> copyWith(
      {Credentials? credentials,
      Person? activePerson,
      PersonDetail? activePersonDetail,
      ActivePage? activePage,
      bool? isInitialized}) {
    return Success(AppState._(
        credentials: credentials ?? this.credentials,
        activePerson: activePerson ?? this.activePerson,
        activePersonDetail: activePersonDetail ?? this.activePersonDetail,
        activePage: activePage ?? this.activePage,
        isInitialized: isInitialized ?? this.isInitialized));
  }

  Result<AppState, String> clearActivePerson() {
    if (activePage == ActivePage.person) {
      return Failure("Cannot clear active person while on person page");
    }
    return Success(AppState._(
        credentials: credentials,
        activePerson: Person.dummy(),
        activePersonDetail: PersonDetail.dummy(-1),
        activePage: activePage,
        isInitialized: isInitialized));
  }

  Result<AppState, String> setActivePerson(Person person) {
    if (activePersonDetail.id != -1 && person.id != activePersonDetail.personId) {
      return Failure("Person ID mismatch with Person Detail");
    }
    return Success(AppState._(
        credentials: credentials,
        activePerson: person,
        activePersonDetail: activePersonDetail,
        activePage: activePage,
        isInitialized: isInitialized));
  }

  Result<AppState, String> setActivePersonDetail(PersonDetail personDetail) {
    if (activePerson.id != -1 && activePerson.id != personDetail.personId) {
      return Failure("Person ID mismatch with Person Detail");
    }
    return Success(AppState._(
        credentials: credentials,
        activePerson: activePerson,
        activePersonDetail: personDetail,
        activePage: activePage,
        isInitialized: isInitialized));
  }
}
