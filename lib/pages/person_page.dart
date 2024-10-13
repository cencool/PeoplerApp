import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/widgets/attachment_tab.dart';
import 'package:peopler/widgets/item_tab.dart';
import 'package:peopler/widgets/person_tab.dart';
import 'package:peopler/widgets/relation_tab.dart';
import 'package:peopler/widgets/sfgrid_person_list.dart';
import 'package:provider/provider.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('PersonPage build');
    return DefaultTabController(
      length: (context.watch<AppState>().activePerson.id > -1) ? 5 : 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Person: ${context.watch<AppState>().activePerson.surname}, ${context.watch<AppState>().activePerson.name}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
                onPressed: () {
                  context.read<AppState>().activePage = ActivePage.personList;
                },
                icon: Icon(Icons.home))
          ],
          bottom: TabBar(
            tabs: (context.watch<AppState>().activePerson.id > -1)
                ? [
                    Tooltip(message: 'Person', child: Tab(icon: Icon(Icons.person))),
                    Tooltip(message: 'Relations', child: Tab(icon: Icon(Icons.people))),
                    Tooltip(message: 'Items', child: Tab(icon: Icon(Icons.list))),
                    Tooltip(message: 'Attachments', child: Tab(icon: Icon(Icons.attach_file))),
                    Tooltip(message: 'PersonList', child: Tab(icon: Icon(Icons.list))),
                  ]
                : [
                    Tooltip(message: 'Person', child: Tab(icon: Icon(Icons.person))),
                    Tooltip(message: 'PersonList', child: Tab(icon: Icon(Icons.list))),
                  ],
          ),
        ),

        /// separated widget so that scaffold is already available for Snack message
        body: PersonPageBody(),
      ),
    );
  }
}

class PersonPageBody extends StatelessWidget {
  const PersonPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('PersonPageBody build');
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: (context.watch<AppState>().activePerson.id > -1)
          ? [
              PersonTab(),
              RelationTab(),
              ItemTab(),
              AttachmentTab(),
              SfgridPersonList(),
            ]
          : [
              PersonTab(),
              SfgridPersonList(),
            ],
    );
  }
}
