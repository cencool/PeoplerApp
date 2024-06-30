import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/pages/general_seach_page.dart';
import 'package:peopler/widgets/pluto_person_list.dart';
import 'package:provider/provider.dart';

class PersonListPage extends StatelessWidget {
  const PersonListPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('PersonListPage build');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Person  list',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Builder(builder: (context) {
                  return GeneralSearchPage();
                });
              }));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Record',
            onPressed: () {
              // var personListStateManager = context.read<AppState>().personListStateManager;
              // GlobalKey<ScaffoldMessengerState> messengerKey =
              //     context.read<AppState>().messengerKey;
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return Builder(builder: (context) {
              //     return const PersonPage(-1);
              //   });
              // })).then((val) {
              //   return Person.getPaginatedPersonList(messengerKey: messengerKey);
              // }).then((paginatedPersonList) {
              //   var plutoRows = Person.getPlutoRows(paginatedPersonList.persons);
              //   personListStateManager?.removeAllRows();
              //   personListStateManager?.appendRows(plutoRows);
              // });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AppState>().logout();
            },
          ),
        ],
      ),
      body: const Center(
        child: PlutoPersonList(),
      ),
    );
  }
}
