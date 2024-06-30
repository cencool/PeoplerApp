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
    return switch (context.watch<AppState>().activePage) {
      ActivePage.login => LoginPage(),
      ActivePage.personList => PersonListPage(key: ValueKey('fromStartPage')),
      ActivePage.person => PersonPage(),
    };
  }
}
