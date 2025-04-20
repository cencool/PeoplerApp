import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/person_detail.dart';
import 'package:peopler/app/ui/widgets/snack_message.dart';

final personListPageVMProvider = Provider<PeopleListViewModel>((ref) {
  return PeopleListViewModel(ref);
});

class PeopleListViewModel {
  final Ref ref;
  PeopleListViewModel(this.ref);
  void navigateToGeneralSearchPage(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      '/search', // Directly return the page widget
    );
    debugPrint('After app bar pop from general search');
  }

  void activateNewRecord(BuildContext context) {
    // Logic to activate a new record
    ref.read(appStateProvider.notifier).activePerson = Person.dummy();
    ref.read(appStateProvider.notifier).activePersonDetail = PersonDetail.dummy(-1);
    ref.read(appStateProvider.notifier).activePage = ActivePage.person;
    debugPrint('New record activated');
  }

  void logout(BuildContext context) async {
    // Logic to logout
    var result = await ref.read(authRepositoryProvider).deleteCredentials();
    switch (result) {
      case Success(value: _):
        ref.read(appStateProvider.notifier).credentials = null;
        ref.read(appStateProvider.notifier).activePage = ActivePage.login;
        debugPrint('User logged out');
        break;
      case Failure(error: final error):
        ref
            .read(snackMessageProvider)
            .showMessage(message: 'Logout failed: $error', messageType: MessageType.error);
        break;
    }
  }
}
