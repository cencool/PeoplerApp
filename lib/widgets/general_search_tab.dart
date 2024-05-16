// pouzit form ako pre person
// submit ako post vsetky polia -> nastavit general search api
// po submite ale musim zobrazit person list s vysledkami

import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/general_search.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/models/person_form.dart';
import 'package:peopler/widgets/pluto_person_search_list.dart';
import 'package:provider/provider.dart';

enum GeneralSearchMode { search, results }

class GeneralSearch extends StatefulWidget {
  const GeneralSearch({super.key});

  @override
  State<GeneralSearch> createState() => _GeneralSearchState();
}

class _GeneralSearchState extends State<GeneralSearch> {
  Person person = Person.dummySearch();
  PersonDetail personDetail = PersonDetail.dummySearch();
  late PersonFormModel formModel = PersonFormModel(person: person, personDetail: personDetail);
  late GlobalKey<ScaffoldMessengerState> messengerKey = context.read<AppState>().messengerKey;
  GeneralSearchMode generalSearchMode = GeneralSearchMode.search;
  Map<String, dynamic> searchParams = {};

  @override
  void initState() {
    super.initState();
    formModel.editMode = true;
  }

  void switchGeneralSearchMode(GeneralSearchMode newMode) {
    setState(() {
      generalSearchMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      generalSearchMode == GeneralSearchMode.search
          ? ListView(
              children: [
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: TextField(
                      readOnly: !formModel.editMode,
                      controller: formModel.surnameController,
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
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: TextField(
                      readOnly: !formModel.editMode,
                      controller: formModel.maidenController,
                      decoration: const InputDecoration(
                          label: Text(
                        'Maiden Name',
                      )),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
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
                ),
              ],
            )
          : PlutoPersonSearchList(searchParams: searchParams),
      Align(
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () async {
            formModel.setActiveData();
            searchParams = searchDataToMap(person, personDetail);
            debugPrint('Search Json: ${searchMapToJson(searchParams)}');
            // PaginatedPersonList personList = await Person.getPaginatedPersonSearchList(
            //     searchParams: searchMapToJson(searchParams), messengerKey: messengerKey);
            if (generalSearchMode == GeneralSearchMode.search) {
              switchGeneralSearchMode(GeneralSearchMode.results);
            } else {
              switchGeneralSearchMode(GeneralSearchMode.search);
            }
            // // for (var person in personList.persons) {
            // //   debugPrint(person.surname);
            // }
          },
          mini: true,
          heroTag: null,
          child: generalSearchMode == GeneralSearchMode.search
              ? const Icon(Icons.check)
              : const Icon(Icons.search),
        ),
      )
    ]);
  }
}
