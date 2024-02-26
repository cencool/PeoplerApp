import 'package:flutter/material.dart';
import 'package:peopler/models/persons.dart';
import 'dart:developer';

class PersonsTable extends StatelessWidget {
  final Persons persons;
  const PersonsTable({required this.persons, super.key});

  String getRows() {
    String result = '';
    for (var element in persons.rows) {
      result += '${element.surname}\n';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // return SelectableText(getRows());
    return MyTable(persons: persons);
  }
}

class MyTable extends StatelessWidget {
  final Persons persons;
  const MyTable({required this.persons, super.key});

  List<DataRow> addRows() {
    var tableRows = <DataRow>[];
    for (var person in persons.rows) {
      tableRows.add(DataRow(
        cells: <DataCell>[
          DataCell(
            SelectableText('${person.id}'),
          ),
          DataCell(
            SelectableText(person.surname),
          ),
          DataCell(
            SelectableText(person.name ?? ''),
          ),
          DataCell(
            SelectableText(person.gender),
          ),
          DataCell(
            SelectableText(person.place ?? ''),
          ),
          DataCell(
            SelectableText(person.owner),
          ),
        ],
      ));
    }
    return tableRows;
  }

  void onEntered(bool status) {
    log('hovered over');
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return Colors.red[200];
        }
        return Colors.green[100]; // Use the default value.
      }),
      columns: [
        const DataColumn(
          label: Text('Id'),
        ),
        DataColumn(
          label: MouseRegion(
              onEnter: (event) => onEntered(true), child: const Text('Surname')),
        ),
        const DataColumn(
          label: Text('Name'),
        ),
        const DataColumn(
          label: Text('Gender'),
        ),
        const DataColumn(
          label: Text('Place'),
        ),
        const DataColumn(
          label: Text('Owner'),
        ),
      ],
      rows: addRows(),
    );
  }
}
