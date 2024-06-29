import 'package:flutter/material.dart';
import 'package:peopler/models/credentials.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/models/person_item.dart';
import 'package:peopler/models/relation_record.dart';
import 'package:pluto_grid/pluto_grid.dart';

enum ActivePage { login, personList, person }

class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  ActivePage activePage = ActivePage.login;
  late GlobalKey<ScaffoldMessengerState> _messengerKey;

  AppState() {
    messengerKey = GlobalKey<ScaffoldMessengerState>();
    Credentials.isLoggedIn().then((loginStatus) {
      isLoggedIn = loginStatus;
      if (isLoggedIn) {
        Credentials.getUserName().then((name) {
          _userName = name!;
        });
        activePage = ActivePage.personList;
      } else {
        activePage = ActivePage.login;
      }
    });
  }

  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool val) {
    _isLoggedIn = val;
    notifyListeners();
  }

  String get userName => _userName;
  set userName(String val) {
    _userName = val;
    notifyListeners();
  }

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

  String _authString = '';
  String get authString => _authString;
  set authString(String auth) {
    _authString = auth;
    notifyListeners();
  }

  void logout() async {
    await Credentials.deleteToken();
    _userName = '';
    activePage = ActivePage.login;
    isLoggedIn = false;
  }

  void login() {
    activePage = ActivePage.personList;
    isLoggedIn = true;
  }
}
