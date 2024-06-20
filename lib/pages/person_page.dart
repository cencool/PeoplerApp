import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/widgets/attachment_tab.dart';
import 'package:peopler/widgets/item_tab.dart';
import 'package:peopler/widgets/person_tab.dart';
import 'package:peopler/widgets/relation_tab.dart';
import 'package:provider/provider.dart';

class PersonPage extends StatefulWidget {
  const PersonPage(this.personId, {super.key});
  final int personId;

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  late int _personId = widget.personId;

  void updatePersonId(int newPersonId) {
    setState(() {
      _personId = newPersonId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: (_personId > -1) ? 4 : 1,
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Person Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              bottom: TabBar(
                tabs: (_personId > -1)
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
            body: PersonPageBody(
              personId: _personId,
              updatePersonId: updatePersonId,
            ),
          );
        },
      ),
    );
  }
}

class PersonPageBody extends StatefulWidget {
  const PersonPageBody({
    required this.personId,
    required this.updatePersonId,
    super.key,
  });
  final int personId;
  final void Function(int newPersonId) updatePersonId;

  @override
  State<PersonPageBody> createState() => _PersonPageBodyState();
}

class _PersonPageBodyState extends State<PersonPageBody> {
  // Person activePerson = Person.dummy();
  late GlobalKey<ScaffoldMessengerState> messengerKey = context.read<AppState>().messengerKey;
  late Future<Person> personFuture =
      Person.getPerson(id: widget.personId, messengerKey: messengerKey);
  late Future<PersonDetail> personDetailFuture =
      PersonDetail.getPersonDetail(id: widget.personId, messengerKey: messengerKey);
  late Future<List<dynamic>> personDataFuture = Future.wait([personFuture, personDetailFuture]);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: personDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            context.read<AppState>().activePerson = snapshot.data![0];
            context.read<AppState>().activePersonDetail = snapshot.data![1];
            return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: (widget.personId > 0)
                  ? [
                      PersonTab(
                        updatePersonId: widget.updatePersonId,
                      ),
                      RelationTab(),
                      ItemTab(),
                      AttachmentTab(),
                    ]
                  : [
                      PersonTab(
                        updatePersonId: widget.updatePersonId,
                      ),
                    ],
            );
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}
