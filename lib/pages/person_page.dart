import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/widgets/attachment_tab.dart';
import 'package:peopler/widgets/item_tab.dart';
import 'package:peopler/widgets/person_tab.dart';
import 'package:peopler/widgets/relation_tab.dart';
import 'package:provider/provider.dart';

enum PersonPageMode { normal, search }

class PersonPage extends StatefulWidget {
  const PersonPage(this.personId, {super.key});
  final int personId;

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  PersonPageMode personPageMode = PersonPageMode.normal;

  void switchMode(PersonPageMode newMode) {
    setState(() {
      personPageMode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Person Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              bottom: const TabBar(tabs: [
                Tooltip(message: 'Person', child: Tab(icon: Icon(Icons.person))),
                Tooltip(message: 'Relations', child: Tab(icon: Icon(Icons.people))),
                Tooltip(message: 'Items', child: Tab(icon: Icon(Icons.list))),
                Tooltip(message: 'Attachments', child: Tab(icon: Icon(Icons.attach_file))),
              ]),
            ),

            /// separated widget so that scaffold is already available for Snack message
            body: PersonPageBody(
              personId: widget.personId,
            ),
          );
        },
      ),
    );
  }
}

class PersonPageBody extends StatefulWidget {
  final int personId;
  const PersonPageBody({required this.personId, super.key});

  @override
  State<PersonPageBody> createState() => _PersonPageBodyState();
}

class _PersonPageBodyState extends State<PersonPageBody> {
  // Person activePerson = Person.dummy();
  late GlobalKey<ScaffoldMessengerState> messengerKey = context.read<AppState>().messengerKey;
  late Future<Person> personFuture =
      Person.getPerson(id: widget.personId, messengerKey: messengerKey);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: personFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            context.read<AppState>().activePerson = snapshot.data!;
            return TabBarView(children: const [
              PersonTab(),
              RelationTab(),
              ItemTab(),
              AttachmentTab(),
            ]);
          } else {
            return const SpinKitPouringHourGlass(color: Colors.blue);
          }
        });
  }
}
