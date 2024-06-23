import 'package:flutter/material.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/models/person_item.dart';
import 'package:peopler/models/relation_record.dart';
import 'package:pluto_grid/pluto_grid.dart';

class AppState {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  Person activePerson = Person.dummy();
  PersonDetail activePersonDetail = PersonDetail.dummy(-1);
  RelationRecord activeRelationRecord = RelationRecord.dummy();
  PersonItem activePersonItem = PersonItem.dummy();
  PlutoGridStateManager? relationTableStateManager;
  PlutoGridStateManager? personListStateManager;
  PlutoGridStateManager? personSearchListStateManager;
  String authString = '';
}

/*
class AppState extends ChangeNotifier {
  GlobalKey<ScaffoldMessengerState> _messengerKey = GlobalKey<ScaffoldMessengerState>();
  get messengerKey => _messengerKey;
  set messengerKey(val) {
    _messengerKey = val;
    notifyListeners();
  }

  Person _activePerson = Person.dummy();
  Person get activePerson => _activePerson;
  set activePerson(Person person) {
    _activePerson = person;
    notifyListeners();
  }

  PersonDetail _activePersonDetail = PersonDetail.dummy(-1);
  PersonDetail get activePersonDetail => _activePersonDetail;
  set activePersonDetail(PersonDetail detail) {
    _activePersonDetail = detail;
    notifyListeners();
  }

  RelationRecord _activeRelationRecord = RelationRecord.dummy();
  RelationRecord get activeRelationRecord => _activeRelationRecord;
  set activeRelationRecord(RelationRecord record) {
    _activeRelationRecord = record;
    notifyListeners();
  }

  PersonItem _activePersonItem = PersonItem.dummy();
  PersonItem get activePersonItem => _activePersonItem;
  set activePersonItem(PersonItem item) {
    _activePersonItem = item;
    notifyListeners();
  }

  PlutoGridStateManager? _relationTableStateManager;
  PlutoGridStateManager? get relationTableStateManager => _relationTableStateManager;
  set relationTableStateManager(PlutoGridStateManager? manager) {
    _relationTableStateManager = manager;
    notifyListeners();
  }

  PlutoGridStateManager? _personListStateManager;
  PlutoGridStateManager? get personListStateManager => _personListStateManager;
  set personListStateManager(PlutoGridStateManager? manager) {
    _personListStateManager = manager;
    notifyListeners();
  }

  PlutoGridStateManager? _personSearchListStateManager;
  PlutoGridStateManager? get personSearchListStateManager => _personSearchListStateManager;
  set personSearchListStateManager(PlutoGridStateManager? manager) {
    _personSearchListStateManager = manager;
    notifyListeners();
  }

  String authString = '';
}
*/