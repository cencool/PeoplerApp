import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/widgets/attachment_tab.dart';
import 'package:peopler/widgets/item_tab.dart';
import 'package:peopler/widgets/person_tab.dart';
import 'package:peopler/widgets/relation_tab.dart';
import 'package:provider/provider.dart';

class PersonPage extends StatelessWidget {
  const PersonPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('PersonPage build');
    return DefaultTabController(
      length: (context.watch<AppState>().activePerson.id > -1) ? 4 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Person Data',
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

class PersonPageBody extends StatefulWidget {
  const PersonPageBody({super.key});

  @override
  State<PersonPageBody> createState() => _PersonPageBodyState();
}

class _PersonPageBodyState extends State<PersonPageBody> {
  // Person activePerson = Person.dummy();
  late GlobalKey<ScaffoldMessengerState> messengerKey;
  late Future<Person> personFuture;
  late Future<PersonDetail> personDetailFuture;
  late Future<List<dynamic>> personDataFuture;

  @override
  Widget build(BuildContext context) {
    debugPrint('PersonPageBody build');
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: (context.watch<AppState>().activePerson.id > 0)
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
