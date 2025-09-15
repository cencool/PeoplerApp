import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/ui/models/person_tab_form_state.dart';
import 'package:peopler/app/ui/viewmodels/person_tab_form_vm.dart';

class PersonTabForm extends ConsumerStatefulWidget {
  const PersonTabForm({super.key});
  @override
  ConsumerState<PersonTabForm> createState() => _MyPersonTabFormState();
}

class _MyPersonTabFormState extends ConsumerState<PersonTabForm> {
  late final TextEditingController surnameController;
  late final TextEditingController nameController;
  late final TextEditingController placeController;
  late final TextEditingController genderController;
  late final TextEditingController maritalStatusController;
  late final TextEditingController maidenController;
  late final TextEditingController addressController;
  late final TextEditingController noteController;
  late ProviderSubscription<PersonTabFormState> _formStateSubscription;

  @override
  void initState() {
    super.initState();
    final state = ref.read(personTabFormVMProvider);
    surnameController = TextEditingController(
      text: state.currentPerson.surname,
    );
    nameController = TextEditingController(
      text: state.currentPerson.name,
    );
    placeController = TextEditingController(
      text: state.currentPerson.place,
    );
    genderController = TextEditingController(
      text: state.currentPerson.gender,
    );
    maritalStatusController = TextEditingController(
      text: state.currentPersonDetail.maritalStatus,
    );
    maidenController = TextEditingController(
      text: state.currentPersonDetail.maidenName,
    );
    addressController = TextEditingController(
      text: state.currentPersonDetail.address,
    );
    noteController = TextEditingController(
      text: state.currentPersonDetail.note,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formStateSubscription =
        ref.listenManual<PersonTabFormState>(personTabFormVMProvider, (previous, next) {
      surnameController.text = next.currentPerson.surname ?? '';
      nameController.text = next.currentPerson.name ?? '';
      placeController.text = next.currentPerson.place ?? '';
      genderController.text = next.currentPerson.gender;
      maritalStatusController.text = next.currentPersonDetail.maritalStatus ?? '';
      maidenController.text = next.currentPersonDetail.maidenName ?? '';
      addressController.text = next.currentPersonDetail.address ?? '';
      noteController.text = next.currentPersonDetail.note ?? '';
    });
  }

  @override
  void dispose() {
    surnameController.dispose();
    nameController.dispose();
    placeController.dispose();
    genderController.dispose();
    maritalStatusController.dispose();
    maidenController.dispose();
    addressController.dispose();
    noteController.dispose();
    _formStateSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('PersonTabForm build');
    return SizedBox(
      height: 600,
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextField(
              readOnly: !ref.watch(personTabFormVMProvider).isEditing,
              controller: surnameController,
              decoration: const InputDecoration(
                  label: Text(
                'Surname',
              )),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextField(
              readOnly: !ref.watch(personTabFormVMProvider).isEditing,
              controller: nameController,
              decoration: const InputDecoration(
                  label: Text(
                'Name',
              )),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextField(
              readOnly: !ref.watch(personTabFormVMProvider).isEditing,
              controller: placeController,
              decoration: const InputDecoration(
                  label: Text(
                'Place',
              )),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextField(
              readOnly: !ref.watch(personTabFormVMProvider).isEditing,
              controller: genderController,
              decoration: const InputDecoration(
                  label: Text(
                'Gender',
              )),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextField(
              readOnly: !ref.watch(personTabFormVMProvider).isEditing,
              controller: maritalStatusController,
              decoration: const InputDecoration(
                  label: Text(
                'Status',
              )),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ref.watch(personTabFormVMProvider).currentPerson.gender == 'f'
            ? Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                    readOnly: !ref.watch(personTabFormVMProvider).isEditing,
                    controller: maidenController,
                    decoration: const InputDecoration(
                        label: Text(
                      'Maiden Name',
                    )),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextField(
              maxLines: 2,
              readOnly: !ref.watch(personTabFormVMProvider).isEditing,
              controller: addressController,
              decoration: const InputDecoration(
                  label: Text(
                'Address',
              )),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextField(
              maxLength: 250,
              maxLines: 8,
              readOnly: !ref.watch(personTabFormVMProvider).isEditing,
              controller: noteController,
              decoration: const InputDecoration(
                  label: Text(
                'Note',
              )),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }
}
