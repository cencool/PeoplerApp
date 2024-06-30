import 'dart:io';

import 'package:flutter/material.dart';
import 'package:peopler/globals/app_state.dart';
import 'package:peopler/globals/dev_http.dart';
import 'package:peopler/pages/start_page.dart';
import 'package:provider/provider.dart';

void main() {
  /// Hack to enable using self signed certificate for https
  HttpOverrides.global = DevHttpOverrides();
  runApp(const PeoplerApp());
}

class PeoplerApp extends StatelessWidget {
  const PeoplerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: Builder(builder: (context) {
        return MaterialApp(
          scaffoldMessengerKey: context.read<AppState>().messengerKey,
          debugShowCheckedModeBanner: false,
          title: 'Peopler',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
          ),
          // home: (context.watch<AppState>().isLoggedIn) ? PersonListPage() : LoginPage(),
          home: StartPage(),
        );
      }),
    );
  }
}
