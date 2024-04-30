import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_relation.dart';
import 'package:peopler/models/relation_record.dart';
import 'package:peopler/widgets/pluto_person_list.dart';
import 'package:peopler/widgets/snack_message.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class RelationAdd extends StatefulWidget {
  const RelationAdd({required this.activePerson, super.key});
  final Person activePerson;

  @override
  State<RelationAdd> createState() => _RelationAddState();
}

class _RelationAddState extends State<RelationAdd> {
  late GlobalKey<ScaffoldMessengerState> messengerKey = context.read<AppState>().messengerKey;
  late Future<List<RelationName>> relationNames =
      RelationName.getRelationNames(messengerKey: messengerKey);
  // late Future futureCollection = Future.wait([relationNames, person]);
  late Map<String, String> newRelation = {
    "id": "",
    "person_a_id": widget.activePerson.id.toString(),
    "relation_ab_id": "",
    "person_b_id": ""
  };
  late RelationRecord activeRelationRecord = context.read<AppState>().activeRelationRecord;

  @override
  void initState() {
    super.initState();
    activeRelationRecord.personAId = widget.activePerson.id;
    debugPrint(activeRelationRecord.toString());
  }

  String toWhom = '';

  List<DropdownMenuEntry> createDropdownEntries(List<RelationName> relationNameList) {
    List<DropdownMenuEntry> out = [];
    for (var el in relationNameList) {
      out.add(DropdownMenuEntry(value: el.id, label: el.relationName));
    }
    return out;
  }

  void personIdCallback(Map<String, PlutoCell> rowData) {
    var id = rowData['id']!.value;
    var surname = rowData['surname']!.value;
    var name = rowData['name']?.value;
    if (id != widget.activePerson.id) {
      // newRelation["person_b_id"] = id.toString();
      activeRelationRecord.personBId = id;
      toWhom = '$surname  $name';
      debugPrint('Id to be related $id');
      debugPrint('Surname:$surname');
      debugPrint('Name:$name');
      debugPrint(activeRelationRecord.toString());
      setState(() {});
    } else {
      SnackMessage.showMessage(
          messengerKey: messengerKey,
          message: "Can't assign relation to same person!",
          messageType: MessageType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: relationNames,
        builder: (context, snapshot) {
          List<RelationName> relationNameList;
          if (snapshot.hasData) {
            relationNameList = (snapshot.data as List<RelationName>)
                .where((element) => element.gender == widget.activePerson.gender)
                .toList();
            for (var element in relationNameList) {
              debugPrint(element.relationName);
            }
            return ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    DropdownMenu(
                      dropdownMenuEntries: createDropdownEntries(relationNameList),
                      label: Text('New Relation'),
                      onSelected: (value) {
                        // newRelation["relation_ab_id"] = value.toString();
                        activeRelationRecord.relationAbId = value;
                        debugPrint('$value');
                        print(activeRelationRecord.toString());
                      },
                      menuHeight: 200,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Icon(Icons.arrow_forward),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      '$toWhom',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
              LimitedBox(
                  maxHeight: 300,
                  child: PlutoPersonList(
                    idCallback: personIdCallback,
                  )),
            ]);
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}

/*
class AddRelation extends StatefulWidget {
  const AddRelation(
      {required this.personId,
      required this.switchCallback,
      required this.messengerKey,
      super.key});
  final int personId;
  final void Function() switchCallback;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  @override
  State<AddRelation> createState() => _AddRelationState();
}

class _AddRelationState extends State<AddRelation> {
  late Future<List<RelationName>> relationNames =
      RelationName.getRelationNames(messengerKey: widget.messengerKey);
  late Future<Person> person =
      Person.getPerson(id: widget.personId, messengerKey: widget.messengerKey);
  late Future futureCollection = Future.wait([relationNames, person]);
  late Map<String, String> newRelation = {
    "id": "",
    "person_a_id": widget.personId.toString(),
    "relation_ab_id": "",
    "person_b_id": ""
  };

  void personIdCallback(int id) {
    newRelation["person_b_id"] = id.toString();
    debugPrint('Id to be related $id');
    print(newRelation);
  }

  List<DropdownMenuEntry> createMenuEntries(List<RelationName> relationNameList) {
    List<DropdownMenuEntry> out = [];
    for (var el in relationNameList) {
      out.add(DropdownMenuEntry(value: el.id, label: el.relationName));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCollection,
      builder: (context, snapshot) {
        List<RelationName> relationNameList;
        if (snapshot.hasData) {
          relationNameList = (snapshot.data![0] as List<RelationName>)
              .where((element) => element.gender == snapshot.data![1].gender)
              .toList();
          for (var element in relationNameList) {
            debugPrint('RelationId: ${element.id}:${element.relationName}');
          }
          return Stack(children: [
            ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownMenu(
                  dropdownMenuEntries: createMenuEntries(relationNameList),
                  label: Text('Relation for ${widget.personId}'),
                  onSelected: (value) {
                    newRelation["relation_ab_id"] = value.toString();
                    debugPrint('$value');
                  },
                  menuHeight: 200,
                ),
              ),
              LimitedBox(
                  maxHeight: 300,
                  child: PlutoPersonList(
                    idCallback: personIdCallback,
                  )),
              LimitedBox(
                  maxHeight: 300,
                  child: PlutoRelationList(
                    personId: widget.personId,
                  )),
            ]),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    widget.switchCallback();
                  },
                  mini: true,
                  child: const Icon(Icons.check),
                ),
              ),
            ),
          ]);
        } else {
          return const Placeholder();
        }
      },
    );
  }
}
*/