import 'package:flutter/material.dart';
import 'package:peopler/models/persons.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/pages/login_page.dart';
import 'package:peopler/models/credentials.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peopler/models/api.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> initRows = [];
  Persons persons = Persons(rows: <Person>[]);

  void loadPersons(context) {
    Persons.getPersons(context: context).then((r) {
      stateManager.removeAllRows();
      stateManager.appendRows(getRows(r));
    });
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
        title: 'Action',
        field: 'id',
        type: PlutoColumnType.text(),
        enableFilterMenuItem: false,
        renderer: (cellContext) {
          return Row(children: [
            Text(cellContext.cell.value.toString()),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.remove_red_eye_sharp),
            ),
            IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => {log('Delete pressed ${cellContext.cell.value}')},
              icon: const Icon(Icons.delete),
            ),
          ]);
        }),
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
        checked: false,
      ));
    }
    return tableRows;
  }

  List<PlutoRow> getPlutoRows(List<Person> persons) {
    var tableRows = <PlutoRow>[];
    for (var person in persons) {
      tableRows.add(PlutoRow(
        cells: {
          'id': PlutoCell(value: person.id),
          'surname': PlutoCell(value: person.surname),
          'name': PlutoCell(value: person.name),
          'gender': PlutoCell(value: person.gender),
          'place': PlutoCell(value: person.place),
          'owner': PlutoCell(value: person.owner),
        },
        checked: false,
      ));
    }
    return tableRows;
  }

  Future<PlutoLazyPaginationResponse> fetchRows(PlutoLazyPaginationRequest request) async {
    String queryString = '?page=${request.page}';
    if (request.filterRows.isNotEmpty) {
      final filterMap = FilterHelper.convertRowsToMap(request.filterRows);
      for (final filter in filterMap.entries) {
        for (final type in filter.value) {
          queryString += '&filter[${filter.key}]';
          final filterType = type.entries.first;
          if (filterType.key == 'Contains') {
            queryString += '[like][]=${filterType.value}';
          } else {
            queryString += '[${filterType.key}][]=${filterType.value}';
          }
        }
      }
    }
    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      var sortDirection = '';
      if (request.sortColumn!.sort.name == 'descending') {
        sortDirection = '-';
      }
      queryString += '&sort=$sortDirection${request.sortColumn!.field}';
    }

    debugPrint(queryString);
    var endpointUrl = '${Api.restUrl}$queryString';
    final int totalPage;
    final List<PlutoRow> rows;
    final String? authString;
    authString = await Credentials.getAuthString();
    final dataFromServer =
        await http.get(Uri.parse(endpointUrl), headers: {'Authorization': 'Basic $authString'});
    if (dataFromServer.statusCode >= 200 && dataFromServer.statusCode < 300) {
      totalPage = int.parse(dataFromServer.headers['x-pagination-page-count'] ?? '');
      rows = getPlutoRows(
          List<Person>.from(json.decode(dataFromServer.body).map((x) => Person.fromJson(x))));
    } else {
      totalPage = 0;
      rows = [];
    }
    return PlutoLazyPaginationResponse(totalPage: totalPage, rows: rows);
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
      body: Center(
        child: PlutoGrid(
            columns: columns,
            rows: initRows,
            mode: PlutoGridMode.readOnly,
            createFooter: (stateManager) {
              return PlutoLazyPagination(
                initialPage: 1,
                initialFetch: true,
                fetchWithSorting: true,
                fetchWithFiltering: true,
                pageSizeToMove: null,
                stateManager: stateManager,
                fetch: fetchRows,
              );
            },
            onLoaded: (PlutoGridOnLoadedEvent event) {
              log('State manager assigned');
              stateManager = event.stateManager;
              stateManager.setShowColumnFilter(true);
            },
            onChanged: (PlutoGridOnChangedEvent event) {
              log(event.toString());
            },
            configuration: const PlutoGridConfiguration()),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // loadPersons(context);
            Credentials.deleteToken();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              return const LoginPage();
            }), (route) => false);
          },
          child: const Icon(Icons.logout)),
    );
  }
}
