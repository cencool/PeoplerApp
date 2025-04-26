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
  late Future<List<RelationName>> relationNames = RelationName.getRelationNames();
  // late Future futureCollection = Future.wait([relationNames, person]);
  late RelationRecord activeRelationRecord = context.read<AppState>().activeRelationRecord;

  @override
  void initState() {
    super.initState();
    activeRelationRecord.reset();
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
          message: "Can't assign relation to same person!", messageType: MessageType.error);
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
                padding: const EdgeInsets.fromLTRB(8, 40.0, 8.0, 8.0),
                child: Row(
                  children: [
                    DropdownMenu(
                      dropdownMenuEntries: createDropdownEntries(relationNameList),
                      textStyle: TextStyle(fontSize: 15),
                      width: 135.0,
                      label: const Text('New Relation'),
                      onSelected: (value) {
                        // newRelation["relation_ab_id"] = value.toString();
                        activeRelationRecord.relationAbId = value;
                        debugPrint('$value');
                        debugPrint(activeRelationRecord.toString());
                      },
                      menuHeight: 200,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const Icon(Icons.arrow_forward),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Text(
                        toWhom,
                        style: const TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
              ),
              LimitedBox(
                  maxHeight: 400,
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
