import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
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
              })).then((_) {
                debugPrint('After app bar pop from general search');
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Record',
            onPressed: () {
              context.read<AppState>().activePerson = Person.dummy();
              context.read<AppState>().activePersonDetail = PersonDetail.dummy(-1);
              context.read<AppState>().activePage = ActivePage.person;
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
