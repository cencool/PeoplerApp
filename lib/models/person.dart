import 'package:peopler/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:peopler/models/credentials.dart';
import 'package:flutter/material.dart';
import 'package:peopler/widgets/snack_message.dart';
import 'dart:convert';

class Person {
  int id;
  String surname;
  String? name;
  String gender;
  String? place;
  String owner;

  Person(
      {this.id = -1,
      required this.surname,
      this.name,
      this.place,
      required this.gender,
      required this.owner});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["id"],
        surname: json["surname"],
        name: json["name"],
        place: json["place"],
        gender: json["gender"],
        owner: json["owner"],
      );

  factory Person.dummy() => Person(
        id: -1,
        surname: "N/A",
        gender: "?",
        owner: "N/A",
      );

  /// deletes person with given id
  static Future<http.Response> deletePerson(
      {required int id, required BuildContext context}) async {
    final String url = '${Api.personRestUrl}/$id';
    final String authString = await Credentials.getAuthString();
    try {
      return await http.delete(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
    } on http.ClientException catch (e) {
      if (context.mounted) {
        SnackMessage.showMessage(
            context: context, message: e.message, messageType: MessageType.error);
      }
      return http.Response('', 599);
    }
  }

  /// returns [PaginatedPersonList] based on query
  static Future<PaginatedPersonList> getPaginatedPersonList(
      {String query = '', required BuildContext context}) async {
    final String url = Api.personRestUrl + query;
    final String authString = await Credentials.getAuthString();
    try {
      http.Response serverResponse =
          await http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode == 200) {
        final int pageCount = int.parse(serverResponse.headers['x-pagination-page-count'] ?? '0');
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        final List<Person> personList =
            List<Person>.from(jsonObject.map((el) => Person.fromJson(el)));
        return PaginatedPersonList(persons: personList, pageCount: pageCount);
      } else {
        if (context.mounted) {
          SnackMessage.showMessage(
              context: context,
              message: 'Unexpected response code:${serverResponse.statusCode} ',
              messageType: MessageType.error);
        }
      }
    } on http.ClientException catch (e) {
      if (context.mounted) {
        SnackMessage.showMessage(
            context: context, message: e.message, messageType: MessageType.error);
      }
    }
    return PaginatedPersonList(persons: <Person>[]);
  }

  static Future<Person?> getPerson({required int id, required BuildContext context}) async {
    String url = '${Api.personRestUrl}/$id';
    final String authString = await Credentials.getAuthString();
    try {
      http.Response serverResponse =
          await http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode == 200) {
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        return Person.fromJson(jsonObject);
      } else {
        if (context.mounted) {
          SnackMessage.showMessage(
              context: context,
              message: 'Unexpected response code:${serverResponse.statusCode} ',
              messageType: MessageType.error);
        }
      }
    } on http.ClientException catch (e) {
      if (context.mounted) {
        SnackMessage.showMessage(
            context: context, message: e.message, messageType: MessageType.error);
      }
    }
    return null;
  }
}

class PaginatedPersonList {
  final int pageCount;
  final List<Person> persons;
  PaginatedPersonList({required this.persons, this.pageCount = 1});
}
