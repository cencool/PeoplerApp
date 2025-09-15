import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/person_detail.dart';
import 'package:peopler/app/ui/models/person_tab_form_state.dart';

final personTabFormVMProvider =
    StateNotifierProvider<PersonTabFormVM, PersonTabFormState>((ref) => PersonTabFormVM(ref));

class PersonTabFormVM extends StateNotifier<PersonTabFormState> {
  final Ref ref;
  PersonTabFormVM(this.ref)
      : super(PersonTabFormState.initial(
            currentPerson: ref.read(appStateProvider).activePerson,
            currentPersonDetail: ref.read(appStateProvider).activePersonDetail)) {
    ref.listen<AppState>(appStateProvider, (previous, next) {
      if (previous?.activePerson.id != next.activePerson.id) {
        state = PersonTabFormState.initial(
            currentPerson: next.activePerson, currentPersonDetail: next.activePersonDetail);
      }
    });
  }

  update({Person? person, PersonDetail? personDetail}) {
    state = state.update(currentPerson: person, currentPersonDetail: personDetail);
  }

  restore() {
    state = state.restore();
  }
}
