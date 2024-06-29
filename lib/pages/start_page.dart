import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/pages/login_page.dart';
import 'package:peopler/pages/person_list_page.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MaterialApp(
        scaffoldMessengerKey: context.read<AppState>().messengerKey,
        debugShowCheckedModeBanner: false,
        title: 'Peopler',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        // home: (context.watch<AppState>().isLoggedIn) ? PersonListPage() : LoginPage(),
        home: switch (context.watch<AppState>().activePage) {
          ActivePage.login => LoginPage(),
          ActivePage.personList => PersonListPage(),
          _ => Placeholder()
        },
      );
    });
  }
}
