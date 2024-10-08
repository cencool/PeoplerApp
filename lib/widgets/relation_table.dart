import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/pages/start_page.dart';
import 'package:peopler/widgets/relation_tab.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:peopler/models/person_relation.dart';
import 'package:provider/provider.dart';

class RelationTable extends StatefulWidget {
  final Person activePerson;
  final void Function(RelationTabMode mode) switchMode;
  const RelationTable({required this.activePerson, required this.switchMode, super.key});

  @override
  State<RelationTable> createState() => _RelationTableState();
}

class _RelationTableState extends State<RelationTable> {
  // late final PlutoGridStateManager stateManager;
  late PlutoGridStateManager stateManager;
  final List<PlutoRow> initRows = [];

  List<PlutoColumn> getColumns(BuildContext context) {
    return <PlutoColumn>[
      PlutoColumn(
          title: 'Id',
          field: 'relationId',
          type: PlutoColumnType.text(),
          enableContextMenu: false,
          enableSorting: true,
          width: 120,
          minWidth: 120,
          renderer: (cellContext) {
            return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // Text('${cellContext.cell.value}'),
              cellContext.cell.value > -1
                  ? IconButton(
                      iconSize: 20.0,
                      padding: EdgeInsets.all(0),
                      icon: const Icon(
                        Icons.edit,
                      ),
                      onPressed: () {
                        debugPrint('Edit button pressed:${cellContext.cell.value}');
                        context.read<AppState>().activeRelationRecord.id = cellContext.cell.value;
                        widget.switchMode(RelationTabMode.edit);
                      })
                  : SizedBox(),
              // : const Icon(
              //     Icons.edit_off,
              //     size: 20.0,
              //   ),
              cellContext.cell.value > -1
                  ? IconButton(
                      iconSize: 20.0,
                      padding: EdgeInsets.all(0),
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        debugPrint('Delete button pressed:${cellContext.cell.value}');
                        print(cellContext.row.cells);
                        context.read<AppState>().activeRelationRecord.id = cellContext.cell.value;
                        widget.switchMode(RelationTabMode.delete);
                      })
                  : SizedBox(),
              // : const Icon(
              //     Icons.delete_forever,
              //     size: 20.0,
              //   ),
            ]);
          }),
      PlutoColumn(
          title: 'Relation',
          field: 'relation',
          type: PlutoColumnType.text(),
          enableContextMenu: false),
      PlutoColumn(
          title: 'To',
          field: 'relationToWhom',
          type: PlutoColumnType.text(),
          enableFilterMenuItem: true,
          enableContextMenu: false,
          enableSorting: true,
          renderer: (cellContext) {
            return InkWell(
              onTap: () {
                debugPrint('tapped:${cellContext.row.cells["toWhomId"]?.value}');
                Person.getPerson(id: cellContext.row.cells['toWhomId']?.value).then((person) {
                  context.read<AppState>().activePerson = person;
                  PersonDetail.getPersonDetail(id: person.id).then((personDetail) {
                    context.read<AppState>().activePersonDetail = personDetail;
                    // context.read<AppState>().activePage = ActivePage.person;
                  }).then((_) {
                    context.read<AppState>().activePage = ActivePage.person;
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      return StartPage();
                    }));
                  });
                });
              },
              child: Text(
                '${cellContext.cell.value}',
                style: const TextStyle(color: Colors.blue),
              ),
            );
          }),
      PlutoColumn(
          title: 'toWhomId',
          field: 'toWhomId',
          type: PlutoColumnType.number(),
          hide: true,
          enableHideColumnMenuItem: false),
    ];
  }

  List<PlutoRow> getPlutoRows(List<PersonRelation> relations) {
    var tableRows = <PlutoRow>[];
    for (var relation in relations) {
      tableRows.add(PlutoRow(
        cells: {
          'relationId': PlutoCell(value: relation.relationId),
          'relation': PlutoCell(value: relation.relation),
          'relationToWhom': PlutoCell(value: relation.relationToWhom),
          'toWhomId': PlutoCell(value: relation.toWhomId),
        },
        checked: false,
      ));
    }
    return tableRows;
  }

  Future<PlutoLazyPaginationResponse> fetchRows(PlutoLazyPaginationRequest request) async {
    // constructing filtering and pagination query
    String queryString = '/${widget.activePerson.id}?page=${request.page}';
    if (request.filterRows.isNotEmpty) {
      final filterMap = FilterHelper.convertRowsToMap(request.filterRows);
      for (final filter in filterMap.entries) {
        for (final type in filter.value) {
          var filterKey = PersonRelation.apiFieldNames[filter.key];
          queryString += '&filter[$filterKey]';
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
    final relations = await PersonRelation.getPaginatedRelationList(
      query: queryString,
    );
    rows = getPlutoRows(relations.relations);
    return PlutoLazyPaginationResponse(totalPage: relations.pageCount, rows: rows);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Relation Table build");
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
        if (mounted) {
          context.read<AppState>().relationTableStateManager = stateManager;
        }
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        debugPrint(event.toString());
      },
      configuration: const PlutoGridConfiguration(
        columnSize: PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale),
        style: PlutoGridStyleConfig(
          rowHeight: 24,
          cellTextStyle: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
