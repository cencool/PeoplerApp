import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/ui/models/person_tab_form_state.dart';

final personTabFormVMProvider =
    StateNotifierProvider<PersonTabFormVM, PersonTabFormState>((ref) => PersonTabFormVM(ref));

class PersonTabFormVM extends StateNotifier<PersonTabFormState> {
  final Ref ref;
  PersonTabFormVM(this.ref)
      : super(PersonTabFormState.initial(currentPerson: ref.read(appStateProvider).activePerson));
}
