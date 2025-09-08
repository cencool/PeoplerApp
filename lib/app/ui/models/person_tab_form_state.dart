import 'package:peopler/app/domain/models/person.dart';
import 'package:peopler/app/domain/models/person_detail.dart';

class PersonTabFormState {
  final bool isEditing;
  final Person initialPerson;
  final Person currentPerson;
  final PersonDetail initialPersonDetail;
  final PersonDetail currentPersonDetail;

  PersonTabFormState._(
      {required this.isEditing,
      required this.initialPerson,
      required this.initialPersonDetail,
      required this.currentPerson,
      required this.currentPersonDetail});

  factory PersonTabFormState.initial(
      {required Person currentPerson, required PersonDetail currentPersonDetail}) {
    return PersonTabFormState._(
        isEditing: false,
        currentPerson: currentPerson,
        currentPersonDetail: currentPersonDetail,
        initialPerson: currentPerson,
        initialPersonDetail: currentPersonDetail);
  }

  PersonTabFormState update(
      {bool? isEditing, Person? currentPerson, PersonDetail? currentPersonDetail}) {
    return PersonTabFormState._(
        isEditing: isEditing ?? this.isEditing,
        currentPerson: currentPerson ?? this.currentPerson,
        currentPersonDetail: currentPersonDetail ?? this.currentPersonDetail,
        initialPerson: initialPerson,
        initialPersonDetail: initialPersonDetail);
  }

  PersonTabFormState restore() {
    return PersonTabFormState._(
        isEditing: false,
        initialPerson: initialPerson,
        initialPersonDetail: initialPersonDetail,
        currentPerson: initialPerson,
        currentPersonDetail: initialPersonDetail);
  }
}
