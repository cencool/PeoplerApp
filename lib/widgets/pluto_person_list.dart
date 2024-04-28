import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:peopler/pages/person_page.dart';
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

  List<PlutoColumn> getColumns(BuildContext context) {
    return <PlutoColumn>[
      PlutoColumn(
          title: 'Id',
          field: 'id',
          type: PlutoColumnType.text(),
          enableFilterMenuItem: true,
          enableContextMenu: false,
          enableSorting: true,
          width: 130,
          minWidth: 130,
          renderer: (cellContext) {
            return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${cellContext.cell.value}'),
              IconButton(
                icon: const Icon(Icons.remove_red_eye_sharp),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Builder(builder: (context) {
                      return PersonPage(cellContext.cell.value);
                    });
                  }));
                },
              ),
              widget.idCallback != null
                  ? IconButton(
                      onPressed: () {
                        widget.idCallback!(cellContext.row.cells);
                      },
                      icon: const Icon(Icons.add))
                  : Container(),
            ]);
          }),
      PlutoColumn(title: 'Surname', field: 'surname', type: PlutoColumnType.text()),
      PlutoColumn(title: 'Name', field: 'name', type: PlutoColumnType.text(), hide: true),
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
          // 'id_action': PlutoCell(value: person.id),
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
    final List<PlutoRow> rows;
    final persons = await Person.getPaginatedPersonList(
        query: queryString, messengerKey: context.read<AppState>().messengerKey);
    rows = getPlutoRows(persons.persons);
    return PlutoLazyPaginationResponse(totalPage: persons.pageCount, rows: rows);
  }

  @override
  Widget build(BuildContext context) {
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
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        debugPrint(event.toString());
      },
      configuration: const PlutoGridConfiguration(
        columnSize: PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale),
      ),
    );
  }
}
