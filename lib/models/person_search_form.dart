import 'package:flutter/material.dart';
import 'package:peopler/models/person.dart';
import 'package:peopler/models/person_attachment.dart';
import 'package:peopler/models/person_detail.dart';
import 'package:peopler/models/person_item.dart';

class PersonSearchFormModel {
  bool editMode = false;
  Person person;
  PersonDetail personDetail;
  PersonAttachment personAttachment;
  PersonItem personItem;
  late TextEditingController surnameController;
  late TextEditingController nameController;
  late TextEditingController placeController;
  late TextEditingController genderController;
  late TextEditingController statusController;
  late TextEditingController maidenController;
  late TextEditingController addressController;
  late TextEditingController noteController;
  late TextEditingController captionController;
  late TextEditingController itemController;

  PersonSearchFormModel(
      {required this.person,
      required this.personDetail,
      required this.personAttachment,
      required this.personItem}) {
    surnameController = TextEditingController(text: person.surname);
    nameController = TextEditingController(text: person.name);
    placeController = TextEditingController(text: person.place);
    genderController = TextEditingController(text: person.gender);
    statusController = TextEditingController(text: personDetail.maritalStatus);
    maidenController = TextEditingController(text: personDetail.maidenName);
    addressController = TextEditingController(text: personDetail.address);
    noteController = TextEditingController(text: personDetail.note);
    captionController = TextEditingController(text: personAttachment.fileCaption);
    itemController = TextEditingController(text: personItem.item);
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

    personAttachment.fileCaption = captionController.text;

    personItem.item = itemController.text;
  }
}
