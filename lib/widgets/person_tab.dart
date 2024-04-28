import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/models/credentials.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:provider/provider.dart';

class PersonTab extends StatefulWidget {
  // const PersonTab(this.activePerson, {super.key});
  const PersonTab({super.key});
  // final Person activePerson;

  @override
  State<PersonTab> createState() => _PersonTabState();
}

class _PersonTabState extends State<PersonTab> {
  late Person activePerson = context.read<Person>();
  late Future<PersonDetail> personDetailFuture = PersonDetail.getPersonDetail(
      // id: widget.activePerson.id,
      id: activePerson.id,
      messengerKey: context.read<AppState>().messengerKey);

  @override
  Widget build(BuildContext context) {
    var messengerKey = context.read<AppState>().messengerKey;
    return FutureBuilder(
        future: personDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ChangeNotifierProvider(
              create: (context) =>
                  PersonFormModel(person: activePerson, personDetail: snapshot.data!),
              child: Consumer<PersonFormModel>(builder: (context, model, child) {
                return Stack(children: [
                  ListView(
                    children: [
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 200,
                        child: PersonPhoto(activePerson.id),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                            readOnly: !model.editMode,
                            controller: model.surnameController,
                            decoration: const InputDecoration(
                                label: Text(
                              'Surname',
                            )),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                            readOnly: !model.editMode,
                            controller: model.nameController,
                            decoration: const InputDecoration(
                                label: Text(
                              'Name',
                            )),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                            readOnly: !model.editMode,
                            controller: model.placeController,
                            decoration: const InputDecoration(
                                label: Text(
                              'Place',
                            )),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: TextField(
                            readOnly: !model.editMode,
                            controller: model.genderController,
                            decoration: const InputDecoration(
                                label: Text(
                              'Gender',
                            )),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      ...snapshot.data == null
                          ? []
                          : [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextField(
                                    readOnly: !model.editMode,
                                    controller: model.statusController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                      'Status',
                                    )),
                                    style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              activePerson.gender == 'f'
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: TextField(
                                          readOnly: !model.editMode,
                                          controller: model.maidenController,
                                          decoration: const InputDecoration(
                                              label: Text(
                                            'Maiden Name',
                                          )),
                                          style: const TextStyle(
                                              fontSize: 20, fontWeight: FontWeight.bold)),
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextField(
                                    maxLines: 2,
                                    readOnly: !model.editMode,
                                    controller: model.addressController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                      'Address',
                                    )),
                                    style:
                                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextField(
                                    maxLength: 250,
                                    maxLines: 8,
                                    readOnly: !model.editMode,
                                    controller: model.noteController,
                                    decoration: const InputDecoration(
                                        label: Text(
                                      'Note',
                                    )),
                                    style:
                                        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              ),
                            ],
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        if (model.editMode) {
                          showDialog(
                              context: context,
                              builder: (context) => PersonSaveDialog(
                                    model: model,
                                    messengerKey: messengerKey,
                                  ),
                              barrierDismissible: false);
                        }
                        model.switchMode();
                      },
                      mini: true,
                      child: (model.editMode == true)
                          ? const Icon(Icons.done)
                          : const Icon(Icons.edit),
                    ),
                  ),
                ]);
              }),
            );
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}

class PersonPhoto extends StatefulWidget {
  const PersonPhoto(this.personId, {super.key});
  final int personId;

  @override
  State<PersonPhoto> createState() => _PersonPhotoState();
}

class _PersonPhotoState extends State<PersonPhoto> {
  Future<String> authString = Credentials.getAuthString();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authString,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                  '${Api.personPhotoUrl}?id=${widget.personId}',
                  headers: {'Authorization': 'Basic ${snapshot.data}'},
                ));
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}

class PersonFormModel with ChangeNotifier {
  bool editMode = false;
  Person person;
  PersonDetail personDetail;
  late TextEditingController surnameController;
  late TextEditingController nameController;
  late TextEditingController placeController;
  late TextEditingController genderController;
  late TextEditingController statusController;
  late TextEditingController maidenController;
  late TextEditingController addressController;
  late TextEditingController noteController;
  Map<String, dynamic> personOld = {};
  Map<String, dynamic> detailOld = {};

  PersonFormModel({required this.person, required this.personDetail}) {
    personToCache(person, personOld);
    detailToCache(personDetail, detailOld);
    // personOld = person;
    // detailOld = personDetail;
    surnameController = TextEditingController(text: person.surname);
    nameController = TextEditingController(text: person.name);
    placeController = TextEditingController(text: person.place);
    genderController = TextEditingController(text: person.gender);
    statusController = TextEditingController(text: personDetail.maritalStatus);
    maidenController = TextEditingController(text: personDetail.maidenName);
    addressController = TextEditingController(text: personDetail.address);
    noteController = TextEditingController(text: personDetail.note);
  }

  void switchMode() {
    editMode = !editMode;
    debugPrint('Editing:$editMode');
    notifyListeners();
  }

  static void detailToCache(PersonDetail personDetail, Map<String, dynamic> detailCache) {
    detailCache['id'] = personDetail.id;
    detailCache['personId'] = personDetail.personId;
    detailCache['maritalStatus'] = personDetail.maritalStatus;
    detailCache['maidenName'] = personDetail.maidenName;
    detailCache['address'] = personDetail.address;
    detailCache['note'] = personDetail.note;
  }

  static void personToCache(Person person, Map<String, dynamic> personCache) {
    personCache['id'] = person.id;
    personCache['surname'] = person.surname;
    personCache['name'] = person.name;
    personCache['place'] = person.place;
    personCache['gender'] = person.gender;
    personCache['owner'] = person.owner;
  }

  static void personFromCache(Person person, Map<String, dynamic> personCache) {
    person.id = personCache['id'] ?? -1;
    person.surname = personCache['surname'] ?? '';
    person.name = personCache['name'] ?? '';
    person.place = personCache['place'] ?? '';
    person.gender = personCache['gender'] ?? '';
    person.owner = personCache['owner'] ?? '';
  }

  static void detailFromCache(PersonDetail personDetail, Map<String, dynamic> detailCache) {
    personDetail.id = detailCache['id'] ?? -1;
    personDetail.personId = detailCache['personId'] ?? -1;
    personDetail.maritalStatus = detailCache['maritalStatus'] ?? '';
    personDetail.maidenName = detailCache['maidenName'] ?? '';
    personDetail.address = detailCache['address'] ?? '';
    personDetail.note = detailCache['note'] ?? '';
  }

  void restoreData() {
    personFromCache(person, personOld);
    detailFromCache(personDetail, detailOld);
    surnameController.text = personOld['surname'];
    nameController.text = personOld['name'];
    placeController.text = personOld['place'];
    genderController.text = personOld['gender'];
    statusController.text = detailOld['maritalStatus'];
    maidenController.text = detailOld['maidenName'];
    addressController.text = detailOld['address'];
    noteController.text = detailOld['note'];
  }

  void saveData(GlobalKey<ScaffoldMessengerState> messengerKey) async {
    //treba zmenit obsah personDetail pred save z controllerov!
    person.name = nameController.text;
    person.surname = surnameController.text;
    person.place = placeController.text;
    person.gender = genderController.text;

    personDetail.maritalStatus = statusController.text;
    personDetail.maidenName = maidenController.text;
    personDetail.address = addressController.text;
    personDetail.note = noteController.text;
    var personResult = await person.save(messengerKey);
    var detaileResult = await personDetail.save(messengerKey);
    if (personResult && detaileResult) {
      person = await Person.getPerson(id: person.id, messengerKey: messengerKey);
      personDetail = await PersonDetail.getPersonDetail(id: person.id, messengerKey: messengerKey);
      personToCache(person, personOld);
      detailToCache(personDetail, detailOld);
    } else {
      restoreData();
    }
    notifyListeners();
  }
}

class PersonSaveDialog extends StatelessWidget {
  const PersonSaveDialog({required this.model, required this.messengerKey, super.key});
  final PersonFormModel model;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Do you want to save changes ?'),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    debugPrint('Yes save pressed');
                    model.saveData(messengerKey);
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    debugPrint('No save pressed');
                    model.restoreData();
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
