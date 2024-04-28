import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/pages/login_page.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/widgets/pluto_person_list.dart';
import 'package:provider/provider.dart';

class PersonListPage extends StatefulWidget {
  const PersonListPage({super.key});

  @override
  State<PersonListPage> createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Person  list',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'New Record',
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () async {
                  await Credentials.deleteToken();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }), (route) => false);
                  }
                },
              ),
            ],
          ),
          body: const Center(
            child: PlutoPersonList(),
          ),
        );
      },
    );
  }
}
