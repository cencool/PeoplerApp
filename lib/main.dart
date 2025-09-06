import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/core/app_settings.dart';
import 'package:peopler/app/core/app_state_notifier.dart';
// import 'package:peopler/globals/app_state.dart';
// import 'package:peopler/globals/dev_http.dart';
// import 'package:peopler/globals/app_globals.dart';
// import 'package:peopler/pages/start_page.dart';
// import 'package:provider/provider.dart' as provider;
import 'package:peopler/app/data/services/dev_http.dart' as dev_http;
import 'package:peopler/app/ui/pages/general_seach_page.dart';
import 'package:peopler/app/ui/pages/login_page.dart';
import 'package:peopler/app/ui/pages/start_page.dart';

void main() {
  /// Hack to enable using self signed certificate for https
  HttpOverrides.global = dev_http.DevHttpOverrides();
  runApp(ProviderScope(child: PeoplerAppLayered()));
}

class PeoplerAppLayered extends ConsumerWidget {
  const PeoplerAppLayered({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool appStateIsInitialized = ref.watch(appStateProvider.select((state) => state.isInitialized));
    return MaterialApp(
      scaffoldMessengerKey: ref.read(appSettingsProvider).messengerKey,
      routes: {
        '/login': (context) => const LoginPage(),
        '/search': (context) => const GeneralSearchPage(),
      },
      home: (appStateIsInitialized)
          ? StartPage()
          : Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Peopler Starting...',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: const Center(child: CircularProgressIndicator()),
            ),
      debugShowCheckedModeBanner: false,
    );
  }
}
