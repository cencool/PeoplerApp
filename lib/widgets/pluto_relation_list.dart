import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:peopler/models/person_relation.dart';

class PlutoRelationList extends StatefulWidget {
  final int personId;
  const PlutoRelationList({required this.personId, super.key});

  @override
  State<PlutoRelationList> createState() => _PlutoRelationListState();
}

class _PlutoRelationListState extends State<PlutoRelationList> {
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> initRows = [];

  List<PlutoColumn> getColumns(BuildContext context) {
    return <PlutoColumn>[
      PlutoColumn(title: 'Relation', field: 'relation', type: PlutoColumnType.text()),
      PlutoColumn(
          title: 'To',
          field: 'relationToWhom',
          type: PlutoColumnType.text(),
          enableFilterMenuItem: true,
          enableContextMenu: false,
          enableSorting: true,
          renderer: (cellContext) {
            return Text('${cellContext.cell.value}');
          }),
    ];
  }

  List<PlutoRow> getPlutoRows(List<PersonRelation> relations) {
    var tableRows = <PlutoRow>[];
    for (var relation in relations) {
      tableRows.add(PlutoRow(
        cells: {
          'relation': PlutoCell(value: relation.relation),
          'relationToWhom': PlutoCell(value: relation.relationToWhom),
        },
        checked: false,
      ));
    }
    return tableRows;
  }

  Future<PlutoLazyPaginationResponse> fetchRows(PlutoLazyPaginationRequest request) async {
    // constructing filtering and pagination query
    String queryString = '/${widget.personId}?page=${request.page}';
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
      var apiField = PersonRelation.apiFieldNames[request.sortColumn!.field];
      queryString += '&sort=$sortDirection$apiField'; // modified to fit yii grid sorting query
    }

    debugPrint(queryString);
    final List<PlutoRow> rows;
    final relations =
        await PersonRelation.getPaginatedRelationList(query: queryString, context: context);
    rows = getPlutoRows(relations.relations);
    return PlutoLazyPaginationResponse(totalPage: relations.pageCount, rows: rows);
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
