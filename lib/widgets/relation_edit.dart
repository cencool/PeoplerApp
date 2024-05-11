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

class RelationEdit extends StatefulWidget {
  const RelationEdit({required this.activePerson, super.key});
  final Person activePerson;

  @override
  State<RelationEdit> createState() => _RelationEditState();
}

class _RelationEditState extends State<RelationEdit> {
  /// tu nepotrebujeme async premenne, tie budu v async init funkcii
  late GlobalKey<ScaffoldMessengerState> messengerKey = context.read<AppState>().messengerKey;
  late RelationRecord activeRelationRecord;
  late List<RelationName> relationNames;
  late Future<bool> init;
  late String toWhom;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    init = initData(context);
  }

  Future<bool> initData(BuildContext context) async {
    activeRelationRecord = await RelationRecord.getRelationRecord(
        context.read<AppState>().activeRelationRecord.id,
        messengerKey: messengerKey);
    relationNames = await RelationName.getRelationNames(messengerKey: messengerKey);
    var toWhomPerson =
        await Person.getPerson(id: activeRelationRecord.personBId, messengerKey: messengerKey);
    toWhom = '${toWhomPerson.surname} ${toWhomPerson.name}';
    if (context.mounted) {
      context.read<AppState>().activeRelationRecord = activeRelationRecord;
    }
    return true;
  }

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
        future: init,
        builder: (context, snapshot) {
          List<RelationName> relationNameList;
          if (snapshot.hasData && snapshot.data!) {
            relationNameList = (relationNames)
                .where((element) => element.gender == widget.activePerson.gender)
                .toList();
            for (var element in relationNameList) {
              debugPrint(element.relationName);
            }
            return ListView(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 40, 8, 8),
                child: Row(
                  children: [
                    DropdownMenu(
                      dropdownMenuEntries: createDropdownEntries(relationNameList),
                      label: const Text('New Relation'),
                      onSelected: (value) {
                        // newRelation["relation_ab_id"] = value.toString();
                        activeRelationRecord.relationAbId = value;
                        debugPrint('$value');
                        debugPrint(activeRelationRecord.toString());
                      },
                      initialSelection: activeRelationRecord.relationAbId,
                      menuHeight: 200,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    const Icon(Icons.arrow_forward),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      toWhom,
                      style: const TextStyle(fontSize: 15.0),
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
