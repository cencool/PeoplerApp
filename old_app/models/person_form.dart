import 'package:flutter/material.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_detail.dart';

class PersonFormModel with ChangeNotifier {
  bool editMode = false;
  Person person;
  PersonDetail personDetail;
  late TextEditingController surnameController;
  late TextEditingController nameController;
  late TextEditingController placeController;
  late TextEditingController genderController;
  late TextEditingController statusController;
  late TextEditingController maidenController;
  late TextEditingController addressController;
  late TextEditingController noteController;
  Map<String, dynamic> personOld = {};
  Map<String, dynamic> detailOld = {};

  PersonFormModel({required this.person, required this.personDetail}) {
    personToCache(person, personOld);
    detailToCache(personDetail, detailOld);
    surnameController = TextEditingController(text: person.surname);
    nameController = TextEditingController(text: person.name);
    placeController = TextEditingController(text: person.place);
    genderController = TextEditingController(text: person.gender);
    statusController = TextEditingController(text: personDetail.maritalStatus);
    maidenController = TextEditingController(text: personDetail.maidenName);
    addressController = TextEditingController(text: personDetail.address);
    noteController = TextEditingController(text: personDetail.note);
  }
  @override
  void dispose() {
    surnameController.dispose();
    nameController.dispose();
    placeController.dispose();
    genderController.dispose();
    statusController.dispose();
    maidenController.dispose();
    addressController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void switchPersonFormMode() {
    editMode = !editMode;
    debugPrint('Editing:$editMode');
    notifyListeners();
  }

  static void detailToCache(PersonDetail personDetail, Map<String, dynamic> detailCache) {
    detailCache['id'] = personDetail.id;
    detailCache['personId'] = personDetail.personId;
    detailCache['maritalStatus'] = personDetail.maritalStatus;
    detailCache['maidenName'] = personDetail.maidenName;
    detailCache['address'] = personDetail.address;
    detailCache['note'] = personDetail.note;
  }

  static void personToCache(Person person, Map<String, dynamic> personCache) {
    personCache['id'] = person.id;
    personCache['surname'] = person.surname;
    personCache['name'] = person.name;
    personCache['place'] = person.place;
    personCache['gender'] = person.gender;
    personCache['owner'] = person.owner;
  }

  static void personFromCache(Person person, Map<String, dynamic> personCache) {
    person.id = personCache['id'] ?? -1;
    person.surname = personCache['surname'] ?? '';
    person.name = personCache['name'] ?? '';
    person.place = personCache['place'] ?? '';
    person.gender = personCache['gender'] ?? '';
    person.owner = personCache['owner'] ?? '';
  }

  static void detailFromCache(PersonDetail personDetail, Map<String, dynamic> detailCache) {
    personDetail.id = detailCache['id'] ?? -1;
    personDetail.personId = detailCache['personId'] ?? -1;
    personDetail.maritalStatus = detailCache['maritalStatus'] ?? '';
    personDetail.maidenName = detailCache['maidenName'] ?? '';
    personDetail.address = detailCache['address'] ?? '';
    personDetail.note = detailCache['note'] ?? '';
  }

  void restoreData() {
    personFromCache(person, personOld);
    detailFromCache(personDetail, detailOld);
    surnameController.text = personOld['surname'];
    nameController.text = personOld['name'];
    placeController.text = personOld['place'];
    genderController.text = personOld['gender'];
    statusController.text = detailOld['maritalStatus'];
    maidenController.text = detailOld['maidenName'];
    addressController.text = detailOld['address'];
    noteController.text = detailOld['note'];
  }

  Future<void> saveData() async {
    //treba zmenit obsah personDetail pred save z controllerov!
    person.name = nameController.text;
    person.surname = surnameController.text;
    person.place = placeController.text;
    person.gender = genderController.text;

    personDetail.maritalStatus = statusController.text;
    personDetail.maidenName = maidenController.text;
    personDetail.address = addressController.text;
    personDetail.note = noteController.text;
    var personResult = await person.save();
    if (personResult["error"] == null) {
      person = await Person.getPerson(id: personResult["id"]);
      personDetail.personId = person.id;
    }
    var detailResult = await personDetail.save();
    if ((personResult["error"] == null) && (detailResult["error"] == null)) {
      personDetail = await PersonDetail.getPersonDetail(id: person.id);
      personToCache(person, personOld);
      detailToCache(personDetail, detailOld);
    } else {
      restoreData();
    }
    // notifyListeners();
  }

  void setActiveData() {
    person.name = nameController.text;
    person.surname = surnameController.text;
    person.place = placeController.text;
    person.gender = genderController.text;

    personDetail.maritalStatus = statusController.text;
    personDetail.maidenName = maidenController.text;
    personDetail.address = addressController.text;
    personDetail.note = noteController.text;
  }
}
