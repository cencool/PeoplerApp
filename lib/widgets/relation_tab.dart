// relation list
// mode button (add, save)
// mode (view, edit, add)  ako stav
// skusit ci ten messenger nemoze byt active
// ako refreshnut po uspesnom SAVE relation list ?
// relation page
// relation selector widget (select box + name selected) -> data update newRelation
// person list in ADD mode
// relation list updating on success save

// RELATION TAB
// relation list with EDIT button in row (view mode ?)
// mode button ADD
// ako  sa budu editovat relacie a ako mazat ?
// klucove slovo ACTIVE RELATION (ACTIVE DATA OBJECT) - ten bude reflektovat aktualne data na/s ktorymi robim
// activeRelation bude bud prazdna alebo obsahovat uz existujuce data
//

import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/widgets/relation_table.dart';
import 'package:peopler/widgets/relation_add.dart';
import 'package:peopler/widgets/snack_message.dart';
import 'package:provider/provider.dart';

enum RelationTabMode { view, add, edit, delete }

class RelationTab extends StatefulWidget {
  const RelationTab({super.key});
  @override
  State<RelationTab> createState() => _RelationTabState();
}

class _RelationTabState extends State<RelationTab> {
  late Person activePerson = context.read<Person>();
  RelationTabMode mode = RelationTabMode.view;
  late Map<String, String> activeRelation = {
    "id": "",
    "person_a_id": activePerson.id.toString(),
    "relation_ab_id": "",
    "person_b_id": ""
  };
  late GlobalKey<ScaffoldMessengerState> messengerKey = context.read<AppState>().messengerKey;

  void switchMode() {
    switch (mode) {
      case (RelationTabMode.view):
        {
          debugPrint('Switiching to add mode');
          SnackMessage.showMessage(messengerKey: messengerKey, message: 'Switching to add mode');
          setState(() {
            mode = RelationTabMode.add;
          });
        }
      case (RelationTabMode.add):
        {
          debugPrint('Switiching to view mode');
          SnackMessage.showMessage(messengerKey: messengerKey, message: 'Switching to view mode');
          setState(() {
            mode = RelationTabMode.view;
          });
        }
      default:
        {
          setState(() {});
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ActiveContent(activePerson: activePerson, mode: mode),
      Align(
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () {
            switchMode();
          },
          mini: true,
          child: ButtonIcon(mode: mode),
        ),
      ),
    ]);
  }
}

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({required this.mode, super.key});
  final RelationTabMode mode;

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case (RelationTabMode.view):
        return const Icon(Icons.add);
      case (RelationTabMode.add):
        return const Icon(Icons.check);
      default:
        return const Icon(Icons.question_mark);
    }
  }
}

class ActiveContent extends StatefulWidget {
  const ActiveContent({required this.activePerson, required this.mode, super.key});
  final RelationTabMode mode;
  final Person activePerson;

  @override
  State<ActiveContent> createState() => _ActiveContentState();
}

class _ActiveContentState extends State<ActiveContent> {
  @override
  Widget build(BuildContext context) {
    switch (widget.mode) {
      case (RelationTabMode.view):
        {
          return RelationTable(activePerson: widget.activePerson);
        }
      case (RelationTabMode.add):
        {
          return RelationAdd(activePerson: widget.activePerson);
        }
      default:
        {
          return const Text('Nothing to display');
        }
    }
  }
}
