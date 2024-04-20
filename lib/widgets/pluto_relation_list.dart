import 'package:flutter/material.dart';
import 'package:peopler/pages/person_page.dart';
import 'package:peopler/widgets/pluto_person_list.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:peopler/models/person_relation.dart';
import 'package:peopler/globals/globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:peopler/models/person.dart';

class PlutoRelationList extends StatefulWidget {
  final int personId;
  const PlutoRelationList({required this.personId, super.key});

  @override
  State<PlutoRelationList> createState() => _PlutoRelationListState();
}

class _PlutoRelationListState extends State<PlutoRelationList> {
  // late final PlutoGridStateManager stateManager;
  late PlutoGridStateManager stateManager;
  final List<PlutoRow> initRows = [];
  bool editMode = false;

  void switchMode() {
    editMode = !editMode;
    setState(() => {});
  }

  List<PlutoColumn> getColumns(BuildContext context) {
    return <PlutoColumn>[
      PlutoColumn(
          title: 'Id',
          field: 'relationId',
          type: PlutoColumnType.text(),
          enableContextMenu: false,
          enableSorting: true,
          width: 100,
          minWidth: 100,
          renderer: (cellContext) {
            return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${cellContext.cell.value}'),
              cellContext.cell.value > -1
                  ? IconButton(
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return PersonPage(cellContext.cell.value);
                        }))
                      },
                      icon: const Icon(Icons.edit),
                    )
                  : const Icon(Icons.edit_off),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return PersonPage(cellContext.row.cells["toWhomId"]?.value);
                }));
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
    String queryString = '/${widget.personId}?page=${request.page}';
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
        query: queryString, messengerKey: context.read<globals.AppKeys>().personViewMessengerKey);
    rows = getPlutoRows(relations.relations);
    return PlutoLazyPaginationResponse(totalPage: relations.pageCount, rows: rows);
  }

  @override
  Widget build(BuildContext context) {
    if (!editMode) {
      return Stack(
        children: [
          PlutoGrid(
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
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () {
                  switchMode();
                },
                mini: true,
                child: const Icon(Icons.add_circle_outline),
              ),
            ),
          ),
        ],
      );
    } else {
      return AddRelation(
        personId: widget.personId,
        switchCallback: switchMode,
        messengerKey: context.read<globals.AppKeys>().personViewMessengerKey,
      );
    }
  }
}

class EditRelation extends StatefulWidget {
  const EditRelation({super.key});

  @override
  State<EditRelation> createState() => _EditRelationState();
}

class _EditRelationState extends State<EditRelation> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AddRelation extends StatefulWidget {
  const AddRelation(
      {required this.personId,
      required this.switchCallback,
      required this.messengerKey,
      super.key});
  final int personId;
  final void Function() switchCallback;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  @override
  State<AddRelation> createState() => _AddRelationState();
}

class _AddRelationState extends State<AddRelation> {
  late Future<List<RelationName>> relationNames =
      RelationName.getRelationNames(messengerKey: widget.messengerKey);
  late Future<Person> person =
      Person.getPerson(id: widget.personId, messengerKey: widget.messengerKey);
  late Future futureCollection = Future.wait([relationNames, person]);
  late Map<String, String> newRelation = {
    "id": "",
    "person_a_id": widget.personId.toString(),
    "relation_ab_id": "",
    "person_b_id": ""
  };

  void personIdCallback(int id) {
    newRelation["person_b_id"] = id.toString();
    debugPrint('Id to be related $id');
    print(newRelation);
  }

  List<DropdownMenuEntry> createMenuEntries(List<RelationName> relationNameList) {
    List<DropdownMenuEntry> out = [];
    for (var el in relationNameList) {
      out.add(DropdownMenuEntry(value: el.id, label: el.relationName));
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCollection,
      builder: (context, snapshot) {
        List<RelationName> relationNameList;
        if (snapshot.hasData) {
          relationNameList = (snapshot.data![0] as List<RelationName>)
              .where((element) => element.gender == snapshot.data![1].gender)
              .toList();
          for (var element in relationNameList) {
            debugPrint('RelationId: ${element.id}:${element.relationName}');
          }
          return Stack(children: [
            ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownMenu(
                  dropdownMenuEntries: createMenuEntries(relationNameList),
                  label: Text('Relation for ${widget.personId}'),
                  onSelected: (value) {
                    newRelation["relation_ab_id"] = value.toString();
                    debugPrint('$value');
                  },
                  menuHeight: 200,
                ),
              ),
              LimitedBox(
                  maxHeight: 300,
                  child: PlutoPersonList(
                    idCallback: personIdCallback,
                  )),
              LimitedBox(
                  maxHeight: 300,
                  child: PlutoRelationList(
                    personId: widget.personId,
                  )),
            ]),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    widget.switchCallback();
                  },
                  mini: true,
                  child: const Icon(Icons.check),
                ),
              ),
            ),
          ]);
        } else {
          return const Placeholder();
        }
      },
    );
  }
}
