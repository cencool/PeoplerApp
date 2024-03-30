import 'package:flutter/material.dart';
import 'package:peopler/widgets/person_view.dart';
import 'package:peopler/widgets/pluto_relation_list.dart';

class PersonPage extends StatefulWidget {
  const PersonPage(this.personId, {super.key});
  final int personId;

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Person',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            bottom: const TabBar(tabs: [
              Tooltip(message: 'Person', child: Tab(icon: Icon(Icons.person))),
              Tooltip(
                  message: 'Relations', child: Tab(icon: Icon(Icons.transfer_within_a_station))),
              Tooltip(message: 'Items', child: Tab(icon: Icon(Icons.list))),
              Tooltip(message: 'Attachments', child: Tab(icon: Icon(Icons.attach_file))),
              Tooltip(message: 'Search', child: Tab(icon: Icon(Icons.search))),
            ]),
          ),
          body: TabBarView(
            children: [
              PersonView(widget.personId),
              PlutoRelationList(personId: widget.personId),
              PersonView(widget.personId),
              PersonView(widget.personId),
              PersonView(widget.personId),
            ],
          )),
    );
  }
}
