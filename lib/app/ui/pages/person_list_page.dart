import 'package:flutter/material.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/domain/models/person_detail.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/core/app_globals.dart';
// import 'package:peopler/widgets/pluto_person_list.dart';
// import 'package:peopler/widgets/sfgrid_person_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/ui/pages/general_seach_page.dart';
import 'package:peopler/app/data/services/auth_service.dart';
import 'package:peopler/app/ui/viewmodels/person_list_page_vm.dart';
import 'package:peopler/app/ui/widgets/pluto.dart';
import 'package:peopler/app/ui/widgets/sf.dart';
import 'package:peopler/app/ui/widgets/snack_message.dart';
import 'package:peopler/config/app_config.dart';

class PersonListPage extends ConsumerWidget {
  const PersonListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PersonListPage build');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Person  list',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () =>
                  ref.read(personListPageVMProvider).navigateToGeneralSearchPage(context)),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Record',
            onPressed: () {
              ref.read(personListPageVMProvider).activateNewRecord(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(personListPageVMProvider).logout(context);
            },
          ),
        ],
      ),
      body: Center(
          // child: PlutoPersonList(),
          child: ref.read(appGlobalsProvider).personListType == PersonListType.pluto

              // ? PlutoPersonList()
              ? Pluto()
              // : SfgridPersonList(),
              : Sf()),
    );
  }
}
