import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/models/person_form.dart';
import 'package:peopler/widgets/person_photo_view.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:provider/provider.dart';

enum PersonTabMode { view, editData, deletePerson, viewPhoto }

class PersonTab extends StatefulWidget {
  const PersonTab({super.key});

  @override
  State<PersonTab> createState() => _PersonTabState();
}

class _PersonTabState extends State<PersonTab> {
  late Person activePerson = context.read<AppState>().activePerson;
  late Future<PersonDetail> personDetailFuture = PersonDetail.getPersonDetail(
      id: activePerson.id, messengerKey: context.read<AppState>().messengerKey);
  PersonTabMode personTabMode = PersonTabMode.view;
  void switchPersonTabMode(PersonTabMode newMode) {
    setState(() {
      personTabMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    var messengerKey = context.read<AppState>().messengerKey;
    switch (personTabMode) {
      case (PersonTabMode.editData):
      case (PersonTabMode.view):
      case (PersonTabMode.deletePerson):
        return PersonView(
            personDetailFuture: personDetailFuture,
            activePerson: activePerson,
            switchPersonTabMode: switchPersonTabMode,
            messengerKey: messengerKey);
      case (PersonTabMode.viewPhoto):
        return PersonPhotoView(
          activePerson: activePerson,
          onModeSwitch: switchPersonTabMode,
        );
      default:
        return const Placeholder();
    }
  }
}

class PersonView extends StatelessWidget {
  const PersonView({
    super.key,
    required this.personDetailFuture,
    required this.activePerson,
    required this.switchPersonTabMode,
    required this.messengerKey,
  });

  final Future<PersonDetail> personDetailFuture;
  final Person activePerson;
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  final void Function(PersonTabMode newMode) switchPersonTabMode;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: personDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PersonDetail activePersonDetail = snapshot.data!;
            context.read<AppState>().activePersonDetail = activePersonDetail;
            return ChangeNotifierProvider(
              create: (context) =>
                  PersonFormModel(person: activePerson, personDetail: activePersonDetail),
              child: Consumer<PersonFormModel>(builder: (context, formModel, child) {
                return Stack(children: [
                  ListView(
                    children: [
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 200,

                        /// TODO check if this can be stateless widget
                        child: PersonPhoto(
                          activePerson.id,
                          onModeSwitch: switchPersonTabMode,
                        ),
                      ),
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
                      ...snapshot.data == null
                          ? []
                          : [
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextField(
                                    readOnly: !formModel.editMode,
                                    controller: formModel.statusController,
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
                                          readOnly: !formModel.editMode,
                                          controller: formModel.maidenController,
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
                                    readOnly: !formModel.editMode,
                                    controller: formModel.addressController,
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
                                    readOnly: !formModel.editMode,
                                    controller: formModel.noteController,
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
                        if (formModel.editMode) {
                          showDialog(
                              context: context,
                              builder: (context) => PersonSaveDialog(
                                    personFormModel: formModel,
                                    messengerKey: messengerKey,
                                  ),
                              barrierDismissible: false);
                          switchPersonTabMode(PersonTabMode.view);
                        }
                        formModel.switchPersonFormMode();
                        switchPersonTabMode(PersonTabMode.editData);
                      },
                      mini: true,
                      heroTag: null,
                      child: (formModel.editMode == true)
                          ? const Icon(Icons.done)
                          : const Icon(Icons.edit),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                        onPressed: (formModel.editMode == true)
                            ? null
                            : () {
                                showDialog(
                                    context: context,
                                    builder: (context) => PersonDeleteDialog(
                                          model: formModel,
                                          onModeSwitch: switchPersonTabMode,
                                          messengerKey: messengerKey,
                                        ),
                                    barrierDismissible: false);
                                switchPersonTabMode(PersonTabMode.deletePerson);
                              },
                        mini: true,
                        heroTag: null,
                        child: Icon(
                          Icons.delete,
                          color: (formModel.editMode == true) ? Colors.grey : null,
                        ),
                      ),
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
  const PersonPhoto(this.personId, {required this.onModeSwitch, super.key});
  final int personId;
  final void Function(PersonTabMode newMode) onModeSwitch;

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
            return GestureDetector(
              onTap: () {
                debugPrint('Image tapped');
                widget.onModeSwitch(PersonTabMode.viewPhoto);
              },
              child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(
                    '${Api.personPhotoReceiveUrl}?id=${widget.personId}&${DateTime.now().millisecondsSinceEpoch}',
                    headers: {'Authorization': 'Basic ${snapshot.data}'},
                  )),
            );
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}
/*
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
    surnameController = TextEditingController(text: person.surname);
    nameController = TextEditingController(text: person.name);
    placeController = TextEditingController(text: person.place);
    genderController = TextEditingController(text: person.gender);
    statusController = TextEditingController(text: personDetail.maritalStatus);
    maidenController = TextEditingController(text: personDetail.maidenName);
    addressController = TextEditingController(text: personDetail.address);
    noteController = TextEditingController(text: personDetail.note);
  }

  void switchPersonFormMode() {
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
    if (personResult["error"] == null) {
      person = await Person.getPerson(id: personResult["id"], messengerKey: messengerKey);
      personDetail.personId = person.id;
    }
    var detailResult = await personDetail.save(messengerKey);
    if ((personResult["error"] == null) && (detailResult["error"] == null)) {
      personDetail = await PersonDetail.getPersonDetail(id: person.id, messengerKey: messengerKey);
      personToCache(person, personOld);
      detailToCache(personDetail, detailOld);
    } else {
      restoreData();
    }
    notifyListeners();
  }
}
*/

class PersonSaveDialog extends StatelessWidget {
  const PersonSaveDialog({required this.personFormModel, required this.messengerKey, super.key});
  final PersonFormModel personFormModel;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300.0,
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
                      personFormModel.saveData(messengerKey);
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('No save pressed');
                      personFormModel.restoreData();
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonDeleteDialog extends StatelessWidget {
  const PersonDeleteDialog(
      {required this.model, required this.onModeSwitch, required this.messengerKey, super.key});
  final PersonFormModel model;
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  final void Function(PersonTabMode newMode) onModeSwitch;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Do you want to delete person ?'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      debugPrint('Yes to delete pressed');
                      Person.delete(model.person.id, messengerKey: messengerKey);
                      onModeSwitch(PersonTabMode.view);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      var personListStateManager = context.read<AppState>().personListStateManager;
                      var personListEventManager = personListStateManager!.eventManager;

                      /// refresh person list after delete
                      if (personListEventManager != null &&
                          !personListEventManager.subject.isClosed) {
                        personListEventManager.addEvent(PlutoGridChangeColumnSortEvent(
                            column: personListStateManager.columns[0],
                            oldSort: PlutoColumnSort.none));
                      }
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('No to delete pressed');
                      model.restoreData();
                      onModeSwitch(PersonTabMode.view);
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
