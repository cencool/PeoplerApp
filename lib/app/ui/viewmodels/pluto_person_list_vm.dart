import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/core/result.dart';
import 'package:peopler/app/data/query/query_builder.dart';
import 'package:peopler/app/data/query/query_utils.dart';
import 'package:peopler/app/data/query/sort_condition.dart';
import 'package:peopler/app/data/query/yii2_query_formatter.dart';
import 'package:peopler/app/data/repositories/person_repository.dart';
import 'package:peopler/app/domain/models/base/paginated_list.dart';
import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/person_detail.dart';
import 'package:peopler/app/ui/widgets/snack_message.dart';
import 'package:pluto_grid/pluto_grid.dart';

final plutoPersonListVMprovider = Provider<PlutoPersonListVM>((ref) {
  return PlutoPersonListVM(ref);
});

class PlutoPersonListVM {
  final Ref ref;
  final PersonRepository personRepository;
  final AppStateNotifier appStateNotifier;
  final SnackMessage snackMessage;

  PlutoPersonListVM(this.ref)
      : personRepository = ref.read(personRepositoryProvider),
        appStateNotifier = ref.read(appStateNotifierProvider.notifier),
        snackMessage = ref.read(snackMessageProvider);

  List<PlutoColumn> getColumns() {
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

  PlutoColumn idColumn() {
    return PlutoColumn(
        title: 'Id',
        field: 'id',
        hide: true,
        type: PlutoColumnType.text(),
        enableFilterMenuItem: true,
        enableContextMenu: false,
        enableSorting: true,
        width: 80,
        minWidth: 80,
        renderer: (cellContext) {
          return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(),
          ]);
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

  Future<void> activatePersonPage(int personId) async {
    Result<Person, String> personResult = await personRepository.getPerson(id: personId);
    personResult.fold((value) async {
      appStateNotifier.setActivePerson(value);
      await getPersonDetail(personId);
    }, (error) {
      snackMessage.showMessage(
          message: 'ActivatePersonPage:Error fetching person: $error',
          messageType: MessageType.error);
      debugPrint('ActivatePersonPage:Error fetching person: $error');
    });
  }

  Future<void> getPersonDetail(int personId) async {
    Result<PersonDetail, String> personDetailResult =
        await personRepository.getPersonDetail(personId: personId);
    personDetailResult.fold((value) {
      appStateNotifier.setActivePersonDetail(value);
      debugPrint('getPersonDetail:Fetched person detail for personId: $personId');
    }, (error) {
      snackMessage.showMessage(
          message: 'getPersonDetail:Error fetching person detail: $error',
          messageType: MessageType.error);
      debugPrint('ActivatePersonPage:Error fetching person detail: $error');
    });
    // person page activated despite of possible error in fetching person detail
    appStateNotifier.setActivePage(ActivePage.person);
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
      snackMessage.showMessage(
          message: 'fetchRows:Error fetching person list: $error', messageType: MessageType.error);
      return PlutoLazyPaginationResponse(rows: [], totalPage: 0);
    });
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
}
