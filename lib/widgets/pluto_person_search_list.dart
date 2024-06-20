import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/general_search.dart';
import 'package:peopler/models/person.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:peopler/pages/person_page.dart';
import 'package:provider/provider.dart';

class PlutoPersonSearchList extends StatefulWidget {
  const PlutoPersonSearchList({required this.searchParams, this.idCallback, super.key});
  final void Function(Map<String, PlutoCell> rowData)? idCallback;
  final Map<String, dynamic> searchParams;

  @override
  State<PlutoPersonSearchList> createState() => _PlutoPersonSearchListState();
}

class _PlutoPersonSearchListState extends State<PlutoPersonSearchList> {
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> initRows = [];

  List<PlutoColumn> getColumns(BuildContext context) {
    return <PlutoColumn>[
      PlutoColumn(
          title: 'Id',
          field: 'id',
          hide: true,
          type: PlutoColumnType.text(),
          enableFilterMenuItem: false,
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
                  /// TODO check if refresh needed for plutoList here - need to reload real rows after delete...
                  PlutoGridStateManager? currentStateManager =
                      context.read<AppState>().personSearchListStateManager;
                  GlobalKey<ScaffoldMessengerState> messengerKey =
                      context.read<AppState>().messengerKey;
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Builder(builder: (context) {
                      return PersonPage(cellContext.cell.value);
                    });
                  })).then((val) async {
                    List<PlutoRow> rows;
                    var persons = await Person.getPaginatedPersonSearchList(
                        searchParams: searchMapToJson(widget.searchParams),
                        query: '',
                        messengerKey: messengerKey);
                    rows = getPlutoRows(persons.persons);
                    currentStateManager?.removeAllRows();
                    currentStateManager?.appendRows(rows);
                  });
                },
              ),

              /// this callback provides info to relation about ToWhom
              widget.idCallback != null
                  ? IconButton(
                      onPressed: () {
                        widget.idCallback!(cellContext.row.cells);
                      },
                      icon: const Icon(Icons.add))
                  : Container(),
            ]);
          }),
      PlutoColumn(
          title: 'Surname',
          field: 'surname',
          type: PlutoColumnType.text(),
          enableFilterMenuItem: false,
          enableContextMenu: false,
          enableSorting: true,
          renderer: (cellContext) {
            return InkWell(
              onTap: () {
                var personSearchListStateManager =
                    context.read<AppState>().personSearchListStateManager;
                var messengerKey = context.read<AppState>().messengerKey;
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Builder(builder: (context) {
                    return PersonPage(cellContext.row.cells['id']?.value);
                  });
                })).then((popVal) {
                  return Person.getPaginatedPersonList(messengerKey: messengerKey);
                }).then((paginatedPersonList) {
                  var plutoRows = Person.getPlutoRows(paginatedPersonList.persons);
                  personSearchListStateManager?.removeAllRows();
                  personSearchListStateManager?.appendRows(plutoRows);
                });
              },
              child: Text(
                cellContext.cell.value,
                style: TextStyle(color: Colors.blue),
              ),
            );
          }),
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        hide: false,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableSorting: true,
      ),
      PlutoColumn(
        title: 'Gender',
        field: 'gender',
        type: PlutoColumnType.text(),
        hide: true,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableSorting: true,
      ),
      PlutoColumn(
        title: 'Place',
        field: 'place',
        type: PlutoColumnType.text(),
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableSorting: true,
      ),
      PlutoColumn(
        title: 'Owner',
        field: 'owner',
        type: PlutoColumnType.text(),
        hide: true,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableSorting: true,
      ),
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
      widget.searchParams['filter'] = {};
      for (final filter in filterMap.entries) {
        for (final type in filter.value) {
          final filterType = type.entries.first;
          widget.searchParams['filter'][filter.key] = {filterType.key: []};
          widget.searchParams['filter'][filter.key][filterType.key].add(filterType.value);
        }
      }
    }
    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      var sortDirection = '';
      if (request.sortColumn!.sort.name == 'descending') {
        sortDirection = '-';
      }
      widget.searchParams['sort'] =
          '$sortDirection${request.sortColumn!.field}'; // modified to fit sort params in controller
    }

    debugPrint(queryString);
    final List<PlutoRow> rows;
    final persons = await Person.getPaginatedPersonSearchList(
        searchParams: searchMapToJson(widget.searchParams),
        query: queryString,
        messengerKey: context.read<AppState>().messengerKey);
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
        context.read<AppState>().personSearchListStateManager = stateManager;
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
