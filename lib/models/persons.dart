import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peopler/models/person.dart';
import 'dart:convert';
import 'dart:developer';

class Persons {
  static Uri apiUri = Uri.http('peopler.localhost:8000', 'api1/person');
  List<Person> rows = [];

  Persons({required this.rows});

  static Future<Persons> getPersons({required BuildContext context}) async {
    try {
      var response = await http.get(apiUri);
      if (response.statusCode == 200) {
        const snackBar = SnackBar(content: Text('Server response OK'));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        log('Server response OK');
        var jsonString = response.body;
        var rows = List<Person>.from(
            json.decode(jsonString).map((x) => Person.fromJson(x)));
        return Persons(rows: rows);
      } else {
        var snackBar = SnackBar(
            content: Text('Server response not OK ${response.statusCode}'));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        log('Server response not OK ${response.statusCode}');
        return Persons(rows: []);
      }
    } on http.ClientException catch (e) {
      log(e.message);
      return Persons(rows: []);
    }
  }
}
