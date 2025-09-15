import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_state.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
import 'package:peopler/app/ui/pages/login_page.dart';
import 'package:peopler/app/ui/pages/person_list_page.dart';
import 'package:peopler/app/ui/pages/person_page.dart';

class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('StartPage build');

    return switch (ref.watch(appStateNotifierProvider.select((state) => state.activePage))) {
      ActivePage.login => LoginPage(),
      ActivePage.personList => PersonListPage(),
      ActivePage.person => PersonPage(),
    };
  }
}
