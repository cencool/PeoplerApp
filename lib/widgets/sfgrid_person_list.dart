import 'package:flutter/material.dart';
import 'package:peopler/models/person.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SfgridPersonList extends StatefulWidget {
  const SfgridPersonList({super.key});

  @override
  SfgridPersonListState createState() => SfgridPersonListState();
}

class SfgridPersonListState extends State<SfgridPersonList> {
  final DataGridController _controller = DataGridController();
  final PersonDataSource dataSource = PersonDataSource();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Person.getPaginatedPersonList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dataSource.persons = snapshot.data!.persons;
          return SfDataGrid(
            source: dataSource,
            allowSorting: true,
            rowHeight: 25.0,
            columns: [
              GridColumn(
                columnName: 'id',
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    'ID',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                allowSorting: true,
              ),
              GridColumn(
                columnName: 'surname',
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Surname',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                allowSorting: true,
              ),
              GridColumn(
                columnName: 'name',
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Name',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                allowSorting: true,
              ),
              GridColumn(
                columnName: 'place',
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Place',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                allowSorting: true,
              ),
            ],
            controller: _controller,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class PersonDataSource extends DataGridSource {
  List<Person> persons = [];

  @override
  List<DataGridRow> get rows => persons.map((person) {
        return DataGridRow(
          cells: [
            DataGridCell<int>(columnName: 'id', value: person.id),
            DataGridCell<String>(columnName: 'surname', value: person.surname),
            DataGridCell<String>(columnName: 'name', value: person.name),
            DataGridCell<String>(columnName: 'place', value: person.place),
          ],
        );
      }).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        if (cell.columnName == 'surname') {
          return Text(
            cell.value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        } else if (cell.columnName == 'name') {
          return Text(
            cell.value.toString(),
            style: TextStyle(color: Colors.red),
          );
        } else {
          return Text(cell.value.toString());
        }
      }).toList(),
    );
  }
}
