import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/query/query_builder.dart';
import 'package:peopler/app/data/query/query_formatter.dart';
import 'package:peopler/app/data/query/query_utils.dart';
import 'package:peopler/app/data/query/sort_condition.dart';
import 'package:peopler/app/data/query/yii2_query_formatter.dart';
import 'package:peopler/app/data/repositories/person_repository.dart';
import 'package:peopler/app/domain/models/common/paginated_list.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/person_detail.dart';
import 'package:peopler/app/ui/pages/start_page.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';

class PlutoPersonList extends ConsumerStatefulWidget {
  const PlutoPersonList({this.idCallback, super.key});
  final void Function(Map<String, PlutoCell> rowData)? idCallback;

  @override
  ConsumerState<PlutoPersonList> createState() => _PlutoPersonListState();
}

class _PlutoPersonListState extends ConsumerState<PlutoPersonList> {
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> initRows = [];
  late final PersonRepository personRepository;
  late final AppStateNotifier appStateNotifier;

  @override
  void initState() {
    super.initState();
    personRepository = ref.read(personRepositoryProvider);
    appStateNotifier = ref.read(appStateProvider.notifier);
  }

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

  Future<void> activatePersonPage(int personId) async {
    Result<Person, String> personResult = await personRepository.getPerson(id: personId);
    personResult.fold((value) async {
      appStateNotifier.activePerson = value;
      await getPersonDetail(personId);
    }, (error) {
      debugPrint('ActivatePersonPage:Error fetching person: $error');
    });
  }

  Future<void> getPersonDetail(int personId) async {
    Result<PersonDetail, String> personDetailResult =
        await personRepository.getPersonDetail(personId: personId);
    personDetailResult.fold((value) {
      appStateNotifier.activePersonDetail = value;
      appStateNotifier.activePage = ActivePage.person;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
        return StartPage();
      }));
    }, (error) {
      debugPrint('ActivatePersonPage:Error fetching person detail: $error');
    });
  }

  PlutoColumn surnameColumn() {
    return PlutoColumn(
        title: 'Surname',
        field: 'surname',
        type: PlutoColumnType.text(),
        enableSorting: true,
        enableContextMenu: false,
        renderer: (cellContext) {
          return InkWell(
            onTap: () => activatePersonPage(cellContext.row.cells['id']?.value),
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
      PlutoColumn(
          title: 'Name',
          field: 'name',
          type: PlutoColumnType.text(),
          hide: false,
          enableContextMenu: false),
      PlutoColumn(title: 'Gender', field: 'gender', type: PlutoColumnType.text(), hide: true),
      PlutoColumn(
          title: 'Place', field: 'place', type: PlutoColumnType.text(), enableContextMenu: false),
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
    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.page(request.page);

    // Convert filter rows to map
    Map<String, List<Map<String, String>>> filterMap =
        FilterHelper.convertRowsToMap(request.filterRows);

    // Process each filter condition
    filterMap.forEach((columnField, conditions) {
      for (var condition in conditions) {
        // The actual keys in condition map are:
        // 'Contains' or 'Equal' etc (filter operation)
        // The first (and only) key is the operation
        String filterOperation = condition.keys.first;
        String filterValue = condition[filterOperation] ?? '';
        debugPrint('Filter: $columnField, $filterOperation, $filterValue');
        queryBuilder.filter(
            columnField, mapPlutoFilterTitleToOperator(filterOperation)!, filterValue);
      }
    });

    // Sort column
    if (request.sortColumn != null && !request.sortColumn!.sort.isNone) {
      queryBuilder.sort(request.sortColumn!.field, SortDirection.asc);
      if (request.sortColumn!.sort.name == 'descending') {
        queryBuilder.sort(request.sortColumn!.field, SortDirection.desc);
      }
    }
    // Build the query
    Map<String, String> queryString = queryBuilder.build<Map<String, String>>(Yii2QueryFormatter());

    Result<PaginatedList<Person>, String> personsListResult =
        await personRepository.getPaginatedPersonList(query: queryString);
    return personsListResult.fold((value) {
      List<PlutoRow> rows = getPlutoRows(value.items);
      return PlutoLazyPaginationResponse(rows: rows, totalPage: value.pageCount);
    }, (error) {
      return PlutoLazyPaginationResponse(rows: [], totalPage: 0);
    });
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
