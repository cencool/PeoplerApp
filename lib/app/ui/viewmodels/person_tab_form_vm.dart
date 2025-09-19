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

  void _updateControllersFromState() {
    surnameController.text = state.currentPerson.surname ?? '';
    nameController.text = state.currentPerson.name ?? '';
    placeController.text = state.currentPerson.place ?? '';
    genderController.text = state.currentPerson.gender;
    maritalStatusController.text = state.currentPersonDetail.maritalStatus ?? '';
    maidenNameController.text = state.currentPersonDetail.maidenName ?? '';
    addressController.text = state.currentPersonDetail.address ?? '';
    noteController.text = state.currentPersonDetail.note ?? '';
  }

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
    _updateControllersFromState();
    ref.listen<AppState>(appStateNotifierProvider, (previous, next) {
      bool personChanged = previous?.activePerson.id != next.activePerson.id;
      bool detailChanged = previous?.activePersonDetail.id != next.activePersonDetail.id;
      if (personChanged || detailChanged) {
        if (personChanged) {
          debugPrint('PersonTabFormVM: Active person changed: ${next.activePerson.id}');
        }
        if (detailChanged) {
          debugPrint(
              'PersonTabFormVM: Active person detail changed: ${next.activePersonDetail.id}');
        }
        state = PersonTabFormState.initial(
            currentPerson: next.activePerson, currentPersonDetail: next.activePersonDetail);
        _updateControllersFromState();
      }
    });
  }

  update({Person? person, PersonDetail? personDetail}) {
    state = state.update(currentPerson: person, currentPersonDetail: personDetail);
    _updateControllersFromState();
  }

  restore() {
    state = state.restore();
    _updateControllersFromState();
  }

  toggleEditing() {
    state = state.update(isEditing: !state.isEditing);
  }
}
