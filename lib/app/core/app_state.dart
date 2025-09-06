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
    // Check if both parameters are provided and their IDs mismatch
    if (activePerson != null && activePersonDetail != null) {
      if (activePerson.id != activePersonDetail.personId) {
        return Failure("Person ID mismatch with Person Detail");
      }
    }
    // Check if provided activePerson mismatches with current activePersonDetail
    else if (activePerson != null) {
      if (activePerson.id != this.activePersonDetail.personId) {
        return Failure("Person ID mismatch with Person Detail");
      }
    }
    // Check if provided activePersonDetail mismatches with current activePerson
    else if (activePersonDetail != null) {
      if (activePersonDetail.personId != this.activePerson.id) {
        return Failure("Person ID mismatch with Person Detail");
      }
    }
    return Success(AppState._(
        credentials: credentials ?? this.credentials,
        activePerson: activePerson ?? this.activePerson,
        activePersonDetail: activePersonDetail ?? this.activePersonDetail,
        activePage: activePage ?? this.activePage,
        isInitialized: isInitialized ?? this.isInitialized));
  }
}
