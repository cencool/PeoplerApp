import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/pages/start_page.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class PlutoPersonList extends StatefulWidget {
  const PlutoPersonList({this.idCallback, super.key});
  final void Function(Map<String, PlutoCell> rowData)? idCallback;

  @override
  State<PlutoPersonList> createState() => _PlutoPersonListState();
}

class _PlutoPersonListState extends State<PlutoPersonList> {
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> initRows = [];

  PlutoColumn idColumn() {
    return PlutoColumn(
        title: 'Id',
        field: 'id',
        hide: (widget.idCallback == null) ? true : false,
        type: PlutoColumnType.text(),
        enableFilterMenuItem: true,
        enableContextMenu: false,
        enableSorting: true,
        width: 80,
        minWidth: 80,
        renderer: (cellContext) {
          return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Text(
            //   '${cellContext.cell.value}',
            //   style: TextStyle(fontSize: 10),
            // ),

            /// this callback provides info to relation about ToWhom
            widget.idCallback != null
                ? IconButton(
                    onPressed: () {
                      widget.idCallback!(cellContext.row.cells);
                    },
                    icon: const Icon(Icons.add, size: 13))
                : Container(),
          ]);
        });
  }

  PlutoColumn surnameColumn() {
    return PlutoColumn(
        title: 'Surname',
        field: 'surname',
        type: PlutoColumnType.text(),
        renderer: (cellContext) {
          return InkWell(
            onTap: () {
              // var personListStateManager = context.read<AppState>().personListStateManager;
              Person.getPerson(id: cellContext.row.cells['id']?.value).then((person) {
                context.read<AppState>().activePerson = person;
                PersonDetail.getPersonDetail(id: person.id).then((personDetail) {
                  context.read<AppState>().activePersonDetail = personDetail;
                  context.read<AppState>().activePage = ActivePage.person;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                    return StartPage();
                  }));
                });
              });
            },
            child: Text(
              cellContext.cell.value,
              style: TextStyle(color: Colors.blue),
            ),
          );
        });
  }

  List<PlutoColumn> getColumns(BuildContext context) {
    return <PlutoColumn>[
      idColumn(),
      surnameColumn(),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text(), hide: false),
      PlutoColumn(title: 'Gender', field: 'gender', type: PlutoColumnType.text(), hide: true),
      PlutoColumn(title: 'Place', field: 'place', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Owner', field: 'owner', type: PlutoColumnType.text(), hide: true),
    ];
  }

  List<PlutoRow> getPlutoRows(List<Person> persons) {
    var tableRows = <PlutoRow>[];
    for (var person in persons) {
      tableRows.add(PlutoRow(
        cells: {
          'id': PlutoCell(value: person.id),
          'name': PlutoCell(value: person.name),
          'surname': PlutoCell(value: person.surname),
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

    /// Modification to match Yii api
    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      var sortDirection = '';
      if (request.sortColumn!.sort.name == 'descending') {
        sortDirection = '-';
      }
      queryString +=
          '&sort=$sortDirection${request.sortColumn!.field}'; // modified to fit yii grid sorting query
    }

    debugPrint(queryString);
    List<PlutoRow> rows;
    PaginatedPersonList persons = await Person.getPaginatedPersonList(
      query: queryString,
    );
    rows = getPlutoRows(persons.persons);
    return PlutoLazyPaginationResponse(totalPage: persons.pageCount, rows: rows);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('PlutPersonList build');
    return PlutoGrid(
      columns: getColumns(context),
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
        debugPrint('State manager assigned');
        stateManager = event.stateManager;
        stateManager.setShowColumnFilter(true);
        context.read<AppState>().personListStateManager = stateManager;
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        debugPrint('change event in plutoGrid: ${event.toString()}');
      },
      configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale),
          style: PlutoGridStyleConfig(
            cellTextStyle: TextStyle(fontSize: 12),
            rowHeight: 24,
          )),
    );
  }
}
