import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/pages/start_page.dart';
import 'package:provider/provider.dart';
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
  void initState() {
    super.initState();
    dataSource.addListener(pokus);
  }

  void pokus() {
    debugPrint('from pokus:${dataSource.pageCount}');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('from build:${dataSource.pageCount}');
    dataSource.context = context;
    return Column(children: [
      Expanded(
        child: SfDataGrid(
          source: dataSource,
          allowSorting: true,
          rowHeight: 25.0,
          columnWidthMode: ColumnWidthMode.auto,
          columns: [
            GridColumn(
              columnName: 'id',
              visible: false,
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
        ),
      ),
      PersonListPager(dataSource: dataSource),
    ]);
  }
}

class PersonDataSource extends DataGridSource {
  List<Person> persons = [];
  int pageCount = 1;
  int totalCount = 0;
  int pageSize = 0;
  int currentPage = 0;
  BuildContext? context;

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
    var id = -1;
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        if (cell.columnName == 'id') {
          id = cell.value as int;
        }
        if (cell.columnName == 'surname') {
          return InkWell(
            onTap: () {
              var appState = context?.read<AppState>();
              debugPrint('$id tapped');
              Person.getPerson(id: id).then((person) {
                appState?.activePerson = person;
                PersonDetail.getPersonDetail(id: person.id).then((personDetail) {
                  appState?.activePersonDetail = personDetail;
                  appState?.activePage = ActivePage.person;
                  if (context != null && context!.mounted) {
                    Navigator.of(context!).pushReplacement(MaterialPageRoute(builder: (context) {
                      return StartPage();
                    }));
                  }
                });
              });
            },
            child: Text(cell.value.toString(), style: TextStyle(color: Colors.blue)),
          );
        } else if (cell.columnName == 'name') {
          return Text(
            cell.value.toString(),
          );
        } else {
          return Text(cell.value.toString());
        }
      }).toList(),
    );
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    var paginatedPersonList =
        await Person.getPaginatedPersonList(query: '?page=${newPageIndex + 1}');
    persons = paginatedPersonList.persons;
    pageCount = paginatedPersonList.pageCount;
    totalCount = paginatedPersonList.totalCount;
    pageSize = paginatedPersonList.pageSize;
    currentPage = paginatedPersonList.currentPage;
    notifyListeners();
    return true;
  }
}

class PersonListPager extends StatefulWidget {
  const PersonListPager({required this.dataSource, super.key});
  final PersonDataSource dataSource;

  @override
  State<PersonListPager> createState() => _PersonListPagerState();
}

class _PersonListPagerState extends State<PersonListPager> {
  void updatePager() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.dataSource.addListener(updatePager);
  }

  @override
  Widget build(BuildContext context) {
    return SfDataPager(
        pageCount: widget.dataSource.pageCount.toDouble(), delegate: widget.dataSource);
  }

  @override
  dispose() {
    widget.dataSource.removeListener(updatePager);
    super.dispose();
  }
}
