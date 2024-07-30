//
//     final personRelation = personRelationFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peopler/models/api.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/widgets/snack_message.dart';

List<PersonRelation> personRelationFromJson(String str) =>
    List<PersonRelation>.from(json.decode(str).map((x) => PersonRelation.fromJson(x)));

String personRelationToJson(List<PersonRelation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PersonRelation {
  String? aOwner;
  String? bOwner;
  int relationId;
  String relation;
  int toWhomId;
  String relationToWhom;

  PersonRelation({
    this.aOwner,
    this.bOwner,
    required this.relationId,
    required this.relation,
    required this.toWhomId,
    required this.relationToWhom,
  });

  PersonRelation.dummy()
      : relationId = -1,
        relation = '',
        toWhomId = -1,
        relationToWhom = '',
        aOwner = '',
        bOwner = '';

  factory PersonRelation.fromJson(Map<String, dynamic> json) => PersonRelation(
        aOwner: json["a_owner"],
        bOwner: json["b_owner"],
        relationId: json["relation_id"],
        relation: json["relation"],
        toWhomId: json["to_whom_id"],
        relationToWhom: json["relation_to_whom"],
      );

  Map<String, dynamic> toJson() => {
        "a_owner": aOwner,
        "b_owner": bOwner,
        "relation_id": relationId,
        "relation": relation,
        "to_whom_id": toWhomId,
        "relation_to_whom": relationToWhom,
      };

  /// returns [PaginatedRelationList] based on query
  static Future<PaginatedRelationList> getPaginatedRelationList({String query = ''}) async {
    final String url = Api.relationUrl + query;
    final String authString = await Credentials.getAuthString();
    try {
      http.Response serverResponse =
          await http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode == 200) {
        final int pageCount = int.parse(serverResponse.headers['x-pagination-page-count'] ?? '0');
        String jsonString = serverResponse.body;
        var jsonObject = json.decode(jsonString);
        final List<PersonRelation> relationList =
            List<PersonRelation>.from(jsonObject.map((el) => PersonRelation.fromJson(el)));
        return PaginatedRelationList(relations: relationList, pageCount: pageCount);
      } else {
        SnackMessage.showMessage(
            message: 'Relation :${serverResponse.statusCode} ', messageType: MessageType.error);
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
        message: e.message,
        messageType: MessageType.error,
      );
    }
    return PaginatedRelationList(relations: <PersonRelation>[]);
  }

  static final apiFieldNames = {
    "aOwner": "a_owner",
    "bOwner": "b_owner",
    "relationId": "relation_id",
    "relation": "relation",
    "toWhomId": "to_whom_id",
    "relationToWhom": "relation_to_whom",
  };
}

class PaginatedRelationList {
  final int pageCount;
  final List<PersonRelation> relations;
  PaginatedRelationList({required this.relations, this.pageCount = 1});
}

List<RelationName> relationNamesFromJson(String str) =>
    List<RelationName>.from(json.decode(str).map((x) => RelationName.fromJson(x)));

String relationNamesToJson(List<RelationName> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RelationName {
  int id;
  String gender;
  String relationName;
  String token;

  RelationName({
    required this.id,
    required this.gender,
    required this.relationName,
    required this.token,
  });

  factory RelationName.fromJson(Map<String, dynamic> json) => RelationName(
        id: json["id"],
        gender: json["gender"],
        relationName: json["relation_name"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gender": gender,
        "relation_name": relationName,
        "token": token,
      };

  static Future<List<RelationName>> getRelationNames() async {
    const url = Api.relationNamesUrl;
    final String authString = await Credentials.getAuthString();

    try {
      http.Response serverResponse =
          await http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode == 200) {
        // final int pageCount = int.parse(serverResponse.headers['x-pagination-page-count'] ?? '0');
        String jsonString = serverResponse.body;
        List<RelationName> relationNames = relationNamesFromJson(jsonString);
        return relationNames;
      } else {
        SnackMessage.showMessage(
            message: 'Relation names :${serverResponse.statusCode} ',
            messageType: MessageType.error);
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
        message: e.message,
        messageType: MessageType.error,
      );
    }
    return [];
  }
}
