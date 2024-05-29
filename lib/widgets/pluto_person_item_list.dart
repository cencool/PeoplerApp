import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person_item.dart';
import 'package:peopler/widgets/item_tab.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class PlutoPersonItemList extends StatefulWidget {
  const PlutoPersonItemList({required this.onSwitch, super.key});
  final Function(ItemTabMode newMode) onSwitch;

  @override
  State<PlutoPersonItemList> createState() => _PlutoPersonItemListState();
}

class _PlutoPersonItemListState extends State<PlutoPersonItemList> {
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> initRows = [];
  late final activePerson = context.read<AppState>().activePerson;
  Map<String, dynamic> searchParams = {};

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
          width: 60,
          minWidth: 60,
          renderer: (cellContext) {
            return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${cellContext.cell.value}'),
            ]);
          }),
      PlutoColumn(
          title: 'Item',
          field: 'item',
          type: PlutoColumnType.text(),
          enableFilterMenuItem: false,
          enableContextMenu: false,
          enableSorting: true,
          renderer: (cellContext) {
            return InkWell(
                onTap: () {
                  debugPrint('item tapped');
                  context.read<AppState>().activePersonItem.id = cellContext.row.cells['id']?.value;
                  context.read<AppState>().activePersonItem.personId =
                      context.read<AppState>().activePerson.id;
                  context.read<AppState>().activePersonItem.item =
                      cellContext.row.cells['item']?.value;
                  widget.onSwitch(ItemTabMode.edit);
                },
                child: Text(
                  cellContext.cell.value,
                  style: TextStyle(color: Colors.blue),
                ));
          }),
    ];
  }

  List<PlutoRow> getPlutoRows(List<PersonItem> items) {
    var tableRows = <PlutoRow>[];
    for (var item in items) {
      tableRows.add(PlutoRow(
        cells: {
          'id': PlutoCell(value: item.id),
          'item': PlutoCell(value: item.item),
        },
        checked: false,
      ));
    }
    return tableRows;
  }

  Future<PlutoLazyPaginationResponse> fetchRows(PlutoLazyPaginationRequest request) async {
    // constructing filtering and pagination query
    String queryString = '?id=${activePerson.id}&page=${request.page}';
    if (request.filterRows.isNotEmpty) {
      final filterMap = FilterHelper.convertRowsToMap(request.filterRows);
      searchParams['filter'] = {};
      for (final filter in filterMap.entries) {
        for (final type in filter.value) {
          final filterType = type.entries.first;
          searchParams['filter'][filter.key] = {filterType.key: []};
          searchParams['filter'][filter.key][filterType.key].add(filterType.value);
        }
      }
    }
    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      var sortDirection = '';
      if (request.sortColumn!.sort.name == 'descending') {
        sortDirection = '-';
      }
      searchParams['sort'] =
          '$sortDirection${request.sortColumn!.field}'; // modified to fit sort params in controller
    }

    debugPrint(queryString);
    final List<PlutoRow> rows;
    final items = await PersonItem.getPaginatedPersonItemList(
        query: queryString, messengerKey: context.read<AppState>().messengerKey);
    rows = getPlutoRows(items.items);
    return PlutoLazyPaginationResponse(totalPage: items.pageCount, rows: rows);
  }

  @override
  Widget build(BuildContext context) {
    context.read<AppState>().activePersonItem = PersonItem.dummy();
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
