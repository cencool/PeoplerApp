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
import 'package:peopler/models/relation_record.dart';
import 'package:peopler/widgets/relation_edit.dart';
import 'package:peopler/widgets/relation_table.dart';
import 'package:peopler/widgets/relation_add.dart';
import 'package:peopler/widgets/snack_message.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

enum RelationTabMode { view, add, edit, delete }

class RelationTab extends StatefulWidget {
  const RelationTab({super.key});
  @override
  State<RelationTab> createState() => _RelationTabState();
}

class _RelationTabState extends State<RelationTab> {
  late Person activePerson = context.read<AppState>().activePerson;
  RelationTabMode mode = RelationTabMode.view;
  late GlobalKey<ScaffoldMessengerState> messengerKey = context.read<AppState>().messengerKey;

  void switchMode(RelationTabMode newMode) {
    switch (newMode) {
      case (RelationTabMode.add):
        {
          debugPrint('Switiching to add mode');
          SnackMessage.showMessage(messengerKey: messengerKey, message: 'Switching to add mode');
          setState(() {
            mode = RelationTabMode.add;
          });
        }
      case (RelationTabMode.view):
        {
          debugPrint('Switiching to view mode');
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (dialogContext) {
                return const RelationSaveDialog();
              }).then((r) {
            SnackMessage.showMessage(messengerKey: messengerKey, message: 'Switching to view mode');
          }).then((r) {
            setState(() {
              mode = RelationTabMode.view;
            });
          });
        }
      case (RelationTabMode.edit):
        {
          debugPrint('received mode $newMode,  switch mode: $mode');
          setState(() {
            mode = RelationTabMode.edit;
          });
        }
      case (RelationTabMode.delete):
        {
          debugPrint('received mode $newMode,  switch mode: $mode');
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (dialogContext) {
                return const RelationDeleteDialog();
              });
        }
      default:
        {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ActiveContent(
        activePerson: activePerson,
        mode: mode,
        switchMode: switchMode,
      ),
      Align(
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () {
            if (mode != RelationTabMode.view) {
              switchMode(RelationTabMode.view);
            } else {
              switchMode(RelationTabMode.add);
            }
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
      case (RelationTabMode.edit):
        return const Icon(Icons.check);
      default:
        return const Icon(Icons.question_mark);
    }
  }
}

class ActiveContent extends StatefulWidget {
  const ActiveContent(
      {required this.activePerson, required this.mode, required this.switchMode, super.key});
  final RelationTabMode mode;
  final void Function(RelationTabMode mode) switchMode;
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
          return RelationTable(activePerson: widget.activePerson, switchMode: widget.switchMode);
        }
      case (RelationTabMode.add):
        {
          return RelationAdd(activePerson: widget.activePerson);
        }
      case (RelationTabMode.edit):
        {
          return RelationEdit(activePerson: widget.activePerson);
        }
      default:
        {
          return const Text('Nothing to display - default Mode');
        }
    }
  }
}

class RelationSaveDialog extends StatelessWidget {
  const RelationSaveDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 250.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Do you want to save changes ?'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      debugPrint('Yes save pressed');
                      // model.saveData(messengerKey);
                      await context
                          .read<AppState>()
                          .activeRelationRecord
                          .save(messengerKey: context.read<AppState>().messengerKey);
                      if (context.mounted) {
                        Navigator.pop(context);
                        context.read<AppState>().activeRelationRecord.reset();
                      }
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('No save pressed');
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

class RelationDeleteDialog extends StatelessWidget {
  const RelationDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 250.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Do you want to delete relation ?'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      debugPrint('Yes delete pressed');
                      await RelationRecord.delete(context.read<AppState>().activeRelationRecord.id,
                          messengerKey: context.read<AppState>().messengerKey);
                      if (context.mounted) {
                        Navigator.pop(context);
                        var stMngr = context.read<AppState>().relationTableStateManager;
                        var eventMnger = stMngr!.eventManager;
                        eventMnger?.addEvent(PlutoGridChangeColumnSortEvent(
                            column: stMngr.columns[0], oldSort: PlutoColumnSort.none));
                      }
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint('No delete pressed');
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
