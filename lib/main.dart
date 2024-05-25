import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/pages/login_page.dart';
import 'package:peopler/pages/person_list_page.dart';
import 'package:peopler/models/credentials.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const PeoplerApp());
}

class PeoplerApp extends StatefulWidget {
  const PeoplerApp({super.key});

  @override
  State<PeoplerApp> createState() => _PeoplerAppState();
}

class _PeoplerAppState extends State<PeoplerApp> {
  // This widget is the root of your application.
  final Future<bool> loginStatus = Credentials.isLoggedIn();
  final Future<String> authString = Credentials.getAuthString();
  late Future<List<dynamic>> futureResults = Future.wait([loginStatus, authString]);
  @override
  Widget build(BuildContext context) {
    return Provider<AppState>(
      create: (_) => AppState(),
      child: Builder(builder: (context) {
        return MaterialApp(
          scaffoldMessengerKey: context.read<AppState>().messengerKey,
          debugShowCheckedModeBanner: true,
          title: 'Peopler',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
          ),
          home: FutureBuilder(
              future: futureResults,
              builder: (context, snapshot) {
                ///TODO check if data content should be checked before using
                if (snapshot.connectionState == ConnectionState.done && snapshot.data?[0]) {
                  context.read<AppState>().authString = snapshot.data?[1];
                  return const PersonListPage();
                } else {
                  return const LoginPage();
                }
              }),
        );
      }),
    );
  }
}
