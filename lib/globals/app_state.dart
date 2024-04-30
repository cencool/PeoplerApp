import 'package:flutter/material.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/models/relation_record.dart';

class AppState {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  Person activePerson = Person.dummy();
  PersonDetail activePersonDetail = PersonDetail.dummy(-1);
  RelationRecord activeRelationRecord = RelationRecord.dummy();
}
