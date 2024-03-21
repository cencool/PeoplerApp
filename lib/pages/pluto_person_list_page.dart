import 'package:flutter/material.dart';
import 'package:peopler/models/persons.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/pages/login_page.dart';
import 'package:peopler/models/credentials.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'dart:convert';
import 'package:peopler/models/api.dart';

class PlutoPersonListPage extends StatefulWidget {
  const PlutoPersonListPage({super.key});

  @override
  State<PlutoPersonListPage> createState() => _PlutoPersonListPageState();
}

class _PlutoPersonListPageState extends State<PlutoPersonListPage> {
  late final PlutoGridStateManager stateManager;
  final paginationKey = GlobalKey();
  final List<PlutoRow> initRows = [];
  Persons persons = Persons(rows: <Person>[]);

  void loadPersons(context) {
    Persons.getPersons(context: context).then((r) {
      stateManager.removeAllRows();
      stateManager.appendRows(getRows(r));
    });
  }

  List<PlutoColumn> getInitColumns(BuildContext context) {
    return <PlutoColumn>[
      PlutoColumn(title: 'Id', field: 'id', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Surname', field: 'surname', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Gender', field: 'gender', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Place', field: 'place', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Owner', field: 'owner', type: PlutoColumnType.text()),
      PlutoColumn(
          title: 'Action',
          field: 'id_action',
          type: PlutoColumnType.text(),
          enableFilterMenuItem: false,
          enableContextMenu: false,
          enableSorting: false,
          width: 100,
          minWidth: 100,
          renderer: (cellContext) {
            return Row(children: [
              IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.remove_red_eye_sharp),
              ),
              IconButton(
                onPressed: () {
                  deleteAlert(
                      buildContext: context,
                      cellContext: cellContext,
                      paginationKey: paginationKey);
                },
                icon: const Icon(Icons.delete),
              ),
            ]);
          }),
    ];
  }

  deleteAlert(
      {required buildContext,
      required PlutoColumnRendererContext cellContext,
      required paginationKey}) {
    debugPrint('Delete pressed ${cellContext.cell.value}');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Delete: '),
        content: Text(
          'Id:${cellContext.cell.value} "${cellContext.row.cells['surname']?.value} ${cellContext.row.cells['name']?.value}" ?',
          style: const TextStyle(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () => {Navigator.of(context).pop()},
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              var serverResponse = await Api.deletePerson(id: cellContext.cell.value);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${serverResponse.statusCode}'),
                  duration: const Duration(seconds: 0, milliseconds: 500),
                ));
                // refresh table
                stateManager.eventManager?.addEvent(PlutoGridChangeColumnSortEvent(
                    column: getInitColumns(context)[0], oldSort: PlutoColumnSort.none));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Yes'),
          )
        ],
        elevation: 20.0,
      ),
    );
  }

  List<PlutoRow> myFilterRows = [
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
      },
      checked: false,
    ),
    PlutoRow(
      cells: {
        'id_action': PlutoCell(value: 1),
      },
      checked: false,
    ),
    PlutoRow(
      cells: {
        'surname': PlutoCell(value: 'x'),
      },
      checked: false,
    ),
    PlutoRow(
      cells: {
        'name': PlutoCell(value: 'x'),
      },
      checked: false,
    ),
    PlutoRow(
      cells: {
        'gender': PlutoCell(value: 'x'),
      },
      checked: false,
    ),
    PlutoRow(
      cells: {
        'place': PlutoCell(value: 'x'),
      },
      checked: false,
    ),
    PlutoRow(
      cells: {
        'owner': PlutoCell(value: 'x'),
      },
      checked: false,
    ),
  ];
  List<PlutoRow> getRows(Persons persons) {
    var tableRows = <PlutoRow>[];
    for (var person in persons.rows) {
      tableRows.add(PlutoRow(
        cells: {
          'id_action': PlutoCell(value: person.id),
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
          'id_action': PlutoCell(value: person.id),
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
    // constructing filtering and pagination query
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
      queryString +=
          '&sort=$sortDirection${request.sortColumn!.field}'; // modified to fit yii grid sorting query
    }

    debugPrint(queryString);
    final int totalPage;
    final List<PlutoRow> rows;
    final dataFromServer = await Api.getPersons(query: queryString);
    if (dataFromServer.statusCode >= 200 && dataFromServer.statusCode < 300) {
      debugPrint('page header is:${dataFromServer.headers['x-pagination-page-count']}');
      totalPage = int.parse(dataFromServer.headers['x-pagination-page-count'] ?? '0');
      debugPrint('parsed page count: $totalPage');
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
          columns: getInitColumns(context),
          rows: initRows,
          mode: PlutoGridMode.readOnly,
          createFooter: (stateManager) {
            return PlutoLazyPagination(
              key: paginationKey,
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
            debugPrint('State manager assigned');
            stateManager = event.stateManager;
            stateManager.setShowColumnFilter(true);
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            debugPrint(event.toString());
          },
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale),
          ),
        ),
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
