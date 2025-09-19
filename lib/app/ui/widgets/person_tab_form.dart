import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/ui/viewmodels/person_tab_form_vm.dart';

class PersonTabForm extends ConsumerWidget {
  const PersonTabForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PersonTabForm build');
    return SizedBox(
      height: 600,
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: TextField(
              readOnly: !ref.watch(personTabFormVMProvider).isEditing,
              controller: ref.watch(personTabFormVMProvider.notifier).surnameController,
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
              controller: ref.watch(personTabFormVMProvider.notifier).nameController,
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
              controller: ref.watch(personTabFormVMProvider.notifier).placeController,
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
              controller: ref.watch(personTabFormVMProvider.notifier).genderController,
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
              controller: ref.watch(personTabFormVMProvider.notifier).maritalStatusController,
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
                    controller: ref.watch(personTabFormVMProvider.notifier).maidenNameController,
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
              controller: ref.watch(personTabFormVMProvider.notifier).addressController,
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
              controller: ref.watch(personTabFormVMProvider.notifier).noteController,
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
