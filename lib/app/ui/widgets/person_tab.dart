import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/ui/viewmodels/person_tab_form_vm.dart';
import 'package:peopler/app/ui/widgets/person_tab_form.dart';

class PersonTab extends ConsumerWidget {
  const PersonTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PersonTab build');
    return Stack(children: [
      ListView(
        children: [
          const SizedBox(height: 10.0),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Person Photo')],
            ),
          ),
          const SizedBox(height: 10.0),
          PersonTabForm(),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            if (ref.watch(personTabFormVMProvider).isEditing) {
              showDialog(
                      context: context,
                      builder: (context) => PersonSaveDialog(personFormModel: formModel),
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
          child: (ref.watch(personTabFormVMProvider).isEditing == true)
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
                        builder: (context) =>
                            PersonDeleteDialog(model: formModel, onModeSwitch: switchPersonTabMode),
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
  }
}
