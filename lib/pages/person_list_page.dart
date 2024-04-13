import 'package:flutter/material.dart';
import 'package:peopler/pages/login_page.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/widgets/pluto_person_list.dart';
import 'package:peopler/globals/globals.dart' as globals;
import 'package:provider/provider.dart';

class PersonListPage extends StatefulWidget {
  const PersonListPage({super.key});

  @override
  State<PersonListPage> createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => globals.AppKeys(),
      child: Consumer<globals.AppKeys>(
        builder: (context, keyModel, child) {
          return ScaffoldMessenger(
            key: keyModel.personListMessengerKey,
            child: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Person  list',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    tooltip: 'New Record',
                  ),
                  IconButton(
                    onPressed: () async {
                      await Credentials.deleteToken();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                          return const LoginPage();
                        }), (route) => false);
                      }
                    },
                    icon: const Icon(Icons.logout),
                    tooltip: 'Logout',
                  ),
                ],
              ),
              body: const Center(
                child: PlutoPersonList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
