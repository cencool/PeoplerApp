import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/ui/viewmodels/person_tab_form_vm.dart';
import 'package:peopler/app/ui/widgets/person_delete_dialog.dart';
import 'package:peopler/app/ui/widgets/person_save_dialog.dart';
import 'package:peopler/app/ui/widgets/person_tab_form.dart';

class PersonTab extends ConsumerWidget {
  const PersonTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PersonTab build');
    final personTabFormVM = ref.watch(personTabFormVMProvider.notifier);
    final personTabFormState = ref.watch(personTabFormVMProvider);
    return Stack(children: [
      ListView(
        children: const [
          SizedBox(height: 10.0),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Person Photo')],
            ),
          ),
          SizedBox(height: 10.0),
          PersonTabForm(),
        ],
      ),
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                if (personTabFormState.isEditing) {
                  showDialog(
                          context: context,
                          builder: (context) => PersonSaveDialog(),
                          barrierDismissible: false)
                      .then((_) {
                    /// Pokus na obnovu tab state
                    // context.read<AppState>().activePerson = formModel.person;
                    // context.read<AppState>().activePersonDetail = formModel.personDetail;
                    // context.read<AppState>().activePage = ActivePage.person;
                    // switchPersonTabMode(PersonTabMode.view);
                  });
                }

                // formModel.switchPersonFormMode();
                // switchPersonTabMode(PersonTabMode.editData);
                ref.read(personTabFormVMProvider.notifier).toggleEditing();
              },
              mini: true,
              heroTag: null,
              child: (personTabFormState.isEditing == true)
                  ? const Icon(Icons.done)
                  : const Icon(Icons.edit),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            // to reload original form data from state
            child: FloatingActionButton(
              onPressed: () => {personTabFormVM.restore()},
              mini: true,
              heroTag: null,
              child: const Icon(Icons.undo),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            onPressed: (personTabFormState.isEditing == true)
                ? null
                : () {
                    showDialog(
                        context: context,
                        builder: (context) => PersonDeleteDialog(),
                        barrierDismissible: false);
                    // switchPersonTabMode(PersonTabMode.deletePerson);
                  },
            mini: true,
            heroTag: null,
            child: Icon(
              Icons.delete,
              color: (personTabFormState.isEditing == true) ? Colors.grey : null,
            ),
          ),
        ),
      ),
    ]);
  }
}
