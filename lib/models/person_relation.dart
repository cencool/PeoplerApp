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
  static Future<PaginatedRelationList> getPaginatedRelationList(
      {String query = '', required GlobalKey<ScaffoldMessengerState> messengerKey}) async {
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
            messengerKey: messengerKey,
            message: 'Unexpected response code:${serverResponse.statusCode} ',
            messageType: MessageType.error);
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
          message: e.message, messageType: MessageType.error, messengerKey: messengerKey);
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
