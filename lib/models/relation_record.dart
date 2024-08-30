import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peopler/models/api.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/widgets/snack_message.dart';

RelationRecord relationRecordFromJson(String str) => RelationRecord.fromJson(json.decode(str));

String relationRecordToJson(RelationRecord data) => json.encode(data.toJson());

class RelationRecord {
  int personAId;
  int personBId;
  int relationAbId;
  int id;

  RelationRecord({
    required this.personAId,
    required this.personBId,
    required this.relationAbId,
    required this.id,
  });

  factory RelationRecord.fromJson(Map<String, dynamic> json) => RelationRecord(
        personAId: json["person_a_id"],
        personBId: json["person_b_id"],
        relationAbId: json["relation_ab_id"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "person_a_id": personAId,
        "person_b_id": personBId,
        "relation_ab_id": relationAbId,
        "id": id,
      };

  factory RelationRecord.dummy() => RelationRecord(
        id: -1,
        personAId: -1,
        personBId: -1,
        relationAbId: -1,
      );

  void reset() {
    id = -1;
    personAId = -1;
    personBId = -1;
    relationAbId = -1;
  }

  @override
  String toString() {
    return 'id:$id\npersonAid:$personAId\npersonBid:$personBId\nrelationAbId:$relationAbId';
  }

  Future<bool> save() async {
    if (id > -1) {
      // update
      String url = '${Api.relationUrl}/${id.toString()}';
      var serverResponse = await Api.request(
          url: url,
          callerId: 'RelUpdate',
          method: RequestMethod.put,
          headers: {"Content-Type": "application/json"},
          body: relationRecordToJson(this));
      if (serverResponse != null) {
        String jsonString = serverResponse.body;
        if (jsonString == "null") {
          return false;
        }
        SnackMessage.showMessage(
          message: 'Relation :$id saved',
          messageType: MessageType.info,
        );
        return true;
      }
    } else {
      // create new record
      String url = Api.relationUrl;
      var serverResponse = await Api.request(
          url: url,
          callerId: 'RelUpdate',
          method: RequestMethod.post,
          headers: {"Content-Type": "application/json"},
          body: relationRecordToJson(this));
      if (serverResponse != null) {
        String jsonString = serverResponse.body;
        if (jsonString == "null") {
          return false;
        }
        var responseRelationRecord = RelationRecord.fromJson(jsonDecode(jsonString));
        SnackMessage.showMessage(
            message: 'Relation: ${responseRelationRecord.id} saved', messageType: MessageType.info);
        return true;
      }
    }
    return false;
  }

  static Future<RelationRecord> getRelationRecord(int id) async {
    String url = '${Api.relationRecordUrl}?relationId=$id';
    var serverResponse =
        await Api.request(url: url, callerId: 'GetRelRecord', method: RequestMethod.get);
    if (serverResponse != null) {
      String jsonString = serverResponse.body;
      if (jsonString == "null") {
        return RelationRecord.dummy();
      }
      var responseRelationRecord = RelationRecord.fromJson(jsonDecode(jsonString));
      SnackMessage.showMessage(
          message: 'Relation: ${responseRelationRecord.id} received',
          messageType: MessageType.info);
      return responseRelationRecord;
    }
    /*
    try {
      http.Response serverResponse =
          await http.get(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode == 200) {
        String jsonString = serverResponse.body;
        if (jsonString == "null") {
          return RelationRecord.dummy();
        }
        var responseRelationRecord = RelationRecord.fromJson(jsonDecode(jsonString));
        SnackMessage.showMessage(
            message: 'Relation: ${responseRelationRecord.id} received',
            messageType: MessageType.info);
        return responseRelationRecord;
      } else if (serverResponse.statusCode == 404) {
        SnackMessage.showMessage(
            message: 'No relation data available...', messageType: MessageType.info);
      } else {
        SnackMessage.showMessage(
            message: 'RelationRecord get - Unexpected response code:${serverResponse.statusCode} ',
            messageType: MessageType.error);
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
        message: e.message,
        messageType: MessageType.error,
      );
    } catch (e) {
      debugPrint(e.toString());
      SnackMessage.showMessage(
          message: 'Exceptions:${e.toString()}', messageType: MessageType.error);
    }
    */
    return RelationRecord.dummy();
  }

  static Future<bool> delete(int id) async {
    final String authString = await Credentials.getAuthString();
    String url = '${Api.relationUrl}/$id';
    try {
      http.Response serverResponse =
          await http.delete(Uri.parse(url), headers: {'Authorization': 'Basic $authString'});
      if (serverResponse.statusCode == 200) {
        String jsonString = serverResponse.body;
        if (jsonString == "null") {
          return false;
        }
        var response = jsonDecode(jsonString);
        SnackMessage.showMessage(
            message: 'Relation: ${response['deleted_id']} deleted', messageType: MessageType.info);
        return true;
      } else if (serverResponse.statusCode == 404) {
        SnackMessage.showMessage(
            message: 'No relation data available...', messageType: MessageType.info);
      } else {
        SnackMessage.showMessage(
            message:
                'RelationRecord delete - Unexpected response code:${serverResponse.statusCode} ',
            messageType: MessageType.error);
      }
    } on http.ClientException catch (e) {
      SnackMessage.showMessage(
        message: e.message,
        messageType: MessageType.error,
      );
    } catch (e) {
      debugPrint(e.toString());
      SnackMessage.showMessage(
          message: 'Exceptions:${e.toString()}', messageType: MessageType.error);
    }
    return false;
  }
}
