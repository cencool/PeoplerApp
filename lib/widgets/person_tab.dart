import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/api.dart';
import 'package:peopler/models/person_form.dart';
import 'package:peopler/widgets/person_photo_view.dart';
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
  PersonTabMode personTabMode = PersonTabMode.view;
  void switchPersonTabMode(PersonTabMode newMode) {
    if (newMode == PersonTabMode.deletePerson) {
      context.read<AppState>().activePerson = Person.dummy();
      context.read<AppState>().activePersonDetail = PersonDetail.dummy(-1);
      context.read<AppState>().activePage = ActivePage.personList;
    } else {
      setState(() {
        personTabMode = newMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('PersonTab build');
    var messengerKey = context.read<AppState>().messengerKey;
    switch (personTabMode) {
      case (PersonTabMode.editData):
      case (PersonTabMode.view):
        return PersonView(
            personDetail: context.watch<AppState>().activePersonDetail,
            activePerson: context.watch<AppState>().activePerson,
            switchPersonTabMode: switchPersonTabMode,
            messengerKey: messengerKey);
      case (PersonTabMode.editPhoto):
        return PersonPhotoView(
          activePerson: context.watch<AppState>().activePerson,
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
    required this.personDetail,
    required this.activePerson,
    required this.switchPersonTabMode,
    required this.messengerKey,
  });

  final PersonDetail personDetail;
  final Person activePerson;
  final GlobalKey<ScaffoldMessengerState> messengerKey;
  final void Function(PersonTabMode newMode) switchPersonTabMode;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PersonFormModel(person: activePerson, personDetail: personDetail),
      child: Consumer<PersonFormModel>(builder: (context, formModel, child) {
        return Stack(children: [
          ListView(
            children: [
              const SizedBox(height: 10.0),
              SizedBox(
                height: 200,

                /// TODO check if this whole form widget can be stateless widget
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PersonPhoto(
                      activePerson.id,
                      onModeSwitch: switchPersonTabMode,
                    ),
                  ],
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
              ),
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
                          barrierDismissible: false)
                      .then((_) {
                    /// Pokus na obnovu tab state
                    context.read<AppState>().activePerson = formModel.person;
                    context.read<AppState>().activePersonDetail = formModel.personDetail;
                    context.read<AppState>().activePage = ActivePage.person;
                    // switchPersonTabMode(PersonTabMode.view);
                  });
                }

                formModel.switchPersonFormMode();
                switchPersonTabMode(PersonTabMode.editData);
              },
              mini: true,
              heroTag: null,
              child: (formModel.editMode == true) ? const Icon(Icons.done) : const Icon(Icons.edit),
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
                        // switchPersonTabMode(PersonTabMode.deletePerson);
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
  Future<String> authStringFuture = Credentials.getAuthString();
  // late String authString = context.read<AppState>().authString;
  @override
  Widget build(BuildContext context) {
    String urlVal =
        '${Api.personPhotoReceiveUrl}?id=${widget.personId}&${DateTime.now().millisecondsSinceEpoch}';
    return FutureBuilder(
        future: authStringFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String authString = snapshot.data!;
            return GestureDetector(
              onTap: () {
                debugPrint('Image tapped');
                widget.onModeSwitch(PersonTabMode.editPhoto);
              },
              child: FadeInImage(
                  key: ValueKey('fadeInImagw'),
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(
                    urlVal,
                    headers: {'Authorization': 'Basic $authString'},
                  )),
            );
          } else {
            return SpinKitPouringHourGlass(color: Colors.blue);
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
                      personFormModel.saveData(messengerKey).then((_) {
                        Navigator.pop(context);
                      });
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
                      Navigator.pop(context);
                      onModeSwitch(PersonTabMode.deletePerson);
                      // Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('No to delete pressed');
                      model.restoreData();
                      Navigator.pop(context);
                      onModeSwitch(PersonTabMode.view);
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
