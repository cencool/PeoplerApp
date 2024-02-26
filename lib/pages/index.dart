import 'package:flutter/material.dart';
import 'package:peopler/widgets/persons_table.dart';
import 'package:peopler/models/persons.dart';
import 'package:peopler/models/person.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Persons? persons;

  void loadPersons(context) {
    Persons.getPersons(context: context).then((r) {
      setState(() {
        persons = r;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'People  list',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            ElevatedButton(
                onPressed: () => loadPersons(context),
                child: const Icon(Icons.download)),
            PersonsTable(persons: persons ?? Persons(rows: <Person>[])),
          ]),
        ),
      ),
    );
  }
}
