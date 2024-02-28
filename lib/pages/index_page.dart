import 'package:flutter/material.dart';
import 'package:peopler/models/persons.dart';
import 'package:peopler/models/person.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:developer';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late final PlutoGridStateManager stateManager;
  Persons persons = Persons(rows: <Person>[]);

  void loadPersons(context) {
    Persons.getPersons(context: context).then((r) {
      stateManager.removeAllRows();
      stateManager.appendRows(getRows(r));
    });
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(title: 'Id', field: 'id', type: PlutoColumnType.text()),
    PlutoColumn(title: 'Surname', field: 'surname', type: PlutoColumnType.text()),
    PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
    PlutoColumn(title: 'Gender', field: 'gender', type: PlutoColumnType.text()),
    PlutoColumn(title: 'Place', field: 'place', type: PlutoColumnType.text()),
    PlutoColumn(title: 'Owner', field: 'owner', type: PlutoColumnType.text())
  ];

  List<PlutoRow> getRows(Persons persons) {
    var tableRows = <PlutoRow>[];
    for (var person in persons.rows) {
      tableRows.add(PlutoRow(
        cells: {
          'id': PlutoCell(value: person.id),
          'surname': PlutoCell(value: person.surname),
          'name': PlutoCell(value: person.name),
          'gender': PlutoCell(value: person.gender),
          'place': PlutoCell(value: person.place),
          'owner': PlutoCell(value: person.owner),
        },
      ));
    }
    return tableRows;
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
      body: PlutoGrid(
        columns: columns,
        rows: getRows(persons),
        onLoaded: (PlutoGridOnLoadedEvent event) {
          log('State manager assigned');
          stateManager = event.stateManager;
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          log(event.toString());
        },
        configuration: const PlutoGridConfiguration(),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            loadPersons(context);
          },
          child: const Icon(Icons.download)),
    );
  }
}
