import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonTabForm extends ConsumerStatefulWidget {
  const PersonTabForm({super.key});
  @override
  ConsumerState<PersonTabForm> createState() => _MyPersonTabFormState();
}

class _MyPersonTabFormState extends ConsumerState<PersonTabForm> {
  final surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('PersonTabForm build');
    return  ListView(children: [

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                    readOnly: !formModel.editMode,
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
                    readOnly: !formModel.editMode,
                    controller: formModel.nameController,
                    decoration: const InputDecoration(
                        label: Text(
                      'Name',
                    )),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                    readOnly: !formModel.editMode,
                    controller: formModel.placeController,
                    decoration: const InputDecoration(
                        label: Text(
                      'Place',
                    )),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                    readOnly: !formModel.editMode,
                    controller: formModel.genderController,
                    decoration: const InputDecoration(
                        label: Text(
                      'Gender',
                    )),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TextField(
                    readOnly: !formModel.editMode,
                    controller: formModel.statusController,
                    decoration: const InputDecoration(
                        label: Text(
                      'Status',
                    )),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              activePerson.gender == 'f'
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: TextField(
                          readOnly: !formModel.editMode,
                          controller: formModel.maidenController,
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
                    readOnly: !formModel.editMode,
                    controller: formModel.addressController,
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
                    readOnly: !formModel.editMode,
                    controller: formModel.noteController,
                    decoration: const InputDecoration(
                        label: Text(
                      'Note',
                    )),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    ],)
    );
  }
}

