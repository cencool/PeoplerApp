import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/pages/login_page.dart';
import 'package:peopler/pages/person_list_page.dart';
import 'package:peopler/pages/person_page.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('StartPage build');

    /// TODO neviem preco to rapluje s hlaskou 404 ked tam je select...
    // return switch (context.select((AppState appState) => appState.activePage)) {
    return switch (context.watch<AppState>().activePage) {
      ActivePage.login => LoginPage(),
      ActivePage.personList => PersonListPage(),
      ActivePage.person => PersonPage(),
    };
  }
}
