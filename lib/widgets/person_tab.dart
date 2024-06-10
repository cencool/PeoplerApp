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

enum PersonTabMode { view, editData, deletePerson, editPhoto }

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
      case (PersonTabMode.editPhoto):
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
          String urlVal =
              '${Api.personPhotoReceiveUrl}?id=${widget.personId}&${DateTime.now().millisecondsSinceEpoch}';
          if (snapshot.hasData) {
            return GestureDetector(
              onTap: () {
                debugPrint('Image tapped');
                widget.onModeSwitch(PersonTabMode.editPhoto);
              },
              child: FadeInImage(
                  key: ValueKey(urlVal),
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(
                    urlVal,
                    headers: {'Authorization': 'Basic ${snapshot.data}'},
                  )),
            );
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}

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
