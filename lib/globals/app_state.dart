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
  String _authString = '';

  Person _activePerson = Person.dummy();
  PersonDetail _activePersonDetail = PersonDetail.dummy(-1);
  RelationRecord _activeRelationRecord = RelationRecord.dummy();
  PersonItem _activePersonItem = PersonItem.dummy();

  PlutoGridStateManager? _personListStateManager;
  PlutoGridStateManager? _relationTableStateManager;
  PlutoGridStateManager? _personSearchListStateManager;

  ActivePage _activePage = ActivePage.login;
  late GlobalKey<ScaffoldMessengerState> _messengerKey;

  AppState() {
    messengerKey = GlobalKey<ScaffoldMessengerState>();
    Credentials.isLoggedIn().then((loginStatus) {
      isLoggedIn = loginStatus;
      if (isLoggedIn) {
        Credentials.getUserName().then((name) {
          _userName = name!;
        });
        _activePage = ActivePage.personList;
      } else {
        _activePage = ActivePage.login;
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

  Person get activePerson => _activePerson;
  set activePerson(Person person) {
    _activePerson = person;
    notifyListeners();
  }

  PersonDetail get activePersonDetail => _activePersonDetail;
  set activePersonDetail(PersonDetail detail) {
    _activePersonDetail = detail;
    notifyListeners();
  }

  RelationRecord get activeRelationRecord => _activeRelationRecord;
  set activeRelationRecord(RelationRecord record) {
    _activeRelationRecord = record;
    notifyListeners();
  }

  PersonItem get activePersonItem => _activePersonItem;
  set activePersonItem(PersonItem item) {
    _activePersonItem = item;
    notifyListeners();
  }

  PlutoGridStateManager? get relationTableStateManager => _relationTableStateManager;
  set relationTableStateManager(PlutoGridStateManager? manager) {
    _relationTableStateManager = manager;
    notifyListeners();
  }

  PlutoGridStateManager? get personListStateManager => _personListStateManager;
  set personListStateManager(PlutoGridStateManager? manager) {
    _personListStateManager = manager;
    notifyListeners();
  }

  PlutoGridStateManager? get personSearchListStateManager => _personSearchListStateManager;
  set personSearchListStateManager(PlutoGridStateManager? manager) {
    _personSearchListStateManager = manager;
    notifyListeners();
  }

  String get authString => _authString;
  set authString(String auth) {
    _authString = auth;
    notifyListeners();
  }

  ActivePage get activePage => _activePage;
  set activePage(ActivePage val) {
    _activePage = val;
    notifyListeners();
  }

  void logout() async {
    await Credentials.deleteToken();
    _userName = '';
    _activePage = ActivePage.login;
    isLoggedIn = false;
  }

  void login() {
    _activePage = ActivePage.personList;
    isLoggedIn = true;
    Credentials.getUserName().then((name) {
      _userName = name!;
    });
  }
}
