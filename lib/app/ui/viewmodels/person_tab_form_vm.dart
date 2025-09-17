import 'package:flutter/material.dart';
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
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController maidenNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    surnameController.dispose();
    nameController.dispose();
    placeController.dispose();
    genderController.dispose();
    maritalStatusController.dispose();
    maidenNameController.dispose();
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }

  PersonTabFormVM(this.ref)
      : super(PersonTabFormState.initial(
            currentPerson: ref.read(appStateNotifierProvider).activePerson,
            currentPersonDetail: ref.read(appStateNotifierProvider).activePersonDetail)) {
    ref.listen<AppState>(appStateNotifierProvider, (previous, next) {
      if (previous?.activePerson.id != next.activePerson.id) {
        debugPrint('PersonTabFormVM: Active person changed: ${next.activePerson.id}');
        state = PersonTabFormState.initial(
            currentPerson: next.activePerson, currentPersonDetail: next.activePersonDetail);
      }
      if (previous?.activePersonDetail.id != next.activePersonDetail.id) {
        debugPrint('PersonTabFormVM: Active person detail changed: ${next.activePersonDetail.id}');
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
