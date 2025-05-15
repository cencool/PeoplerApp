import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/ui/viewmodels/pluto_person_list_vm.dart';
import 'package:pluto_grid/pluto_grid.dart';

class PlutoPersonList extends ConsumerStatefulWidget {
  const PlutoPersonList({this.idCallback, super.key});
  final void Function(Map<String, PlutoCell> rowData)? idCallback;

  @override
  ConsumerState<PlutoPersonList> createState() => _PlutoPersonListState();
}

class _PlutoPersonListState extends ConsumerState<PlutoPersonList> {
  late final PlutoGridStateManager stateManager;
  final List<PlutoRow> initRows = [];
  late final PlutoPersonListViewModel plutoPersonListViewModel;

  @override
  void initState() {
    super.initState();
    plutoPersonListViewModel = ref.read(plutoPersonListVMprovider);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('PlutPersonList build');
    return PlutoGrid(
      columns: plutoPersonListViewModel.getColumns(),
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
          fetch: plutoPersonListViewModel.fetchRows,
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
