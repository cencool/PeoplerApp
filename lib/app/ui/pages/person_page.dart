import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/ui/widgets/attachment_tab.dart';
import 'package:peopler/app/ui/widgets/item_tab.dart';
import 'package:peopler/app/ui/widgets/person_tab.dart';
import 'package:peopler/app/ui/widgets/relation_tab.dart';

class PersonPage extends ConsumerWidget {
  const PersonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PersonPage building...');
    return DefaultTabController(
      length: (ref.watch(appStateProvider).activePerson.id! > -1) ? 4 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Person: ${ref.watch(appStateProvider).activePerson.surname}, ${ref.watch(appStateProvider).activePerson.name}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              onPressed: () {
                ref.read(appStateProvider.notifier).setActivePage(ActivePage.personList);
                ref.read(appStateProvider.notifier).resetActivePerson();
              },
              icon: Icon(Icons.home),
              tooltip: 'Person List',
            ),
          ],
          bottom: TabBar(
            tabs: (ref.watch(appStateProvider).activePerson.id! > -1)
                ? [
                    Tooltip(message: 'Person', child: Tab(icon: Icon(Icons.person))),
                    Tooltip(message: 'Relations', child: Tab(icon: Icon(Icons.people))),
                    Tooltip(message: 'Items', child: Tab(icon: Icon(Icons.list))),
                    Tooltip(message: 'Attachments', child: Tab(icon: Icon(Icons.attach_file))),
                  ]
                : [
                    Tooltip(message: 'Person', child: Tab(icon: Icon(Icons.person))),
                  ],
          ),
        ),

        /// separated widget so that scaffold is already available for Snack message
        body: PersonPageBody(),
      ),
    );
  }
}

class PersonPageBody extends ConsumerWidget {
  const PersonPageBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('PersonPageBody build');
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: (ref.watch(appStateProvider).activePerson.id! > -1)
          ? [
              PersonTab(),
              RelationTab(),
              ItemTab(),
              AttachmentTab(),
            ]
          : [
              PersonTab(),
            ],
    );
  }
}
