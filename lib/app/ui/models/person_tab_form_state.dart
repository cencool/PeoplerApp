import 'package:peopler/app/domain/models/person.dart';

class PersonTabFormState {
  final bool isEditing;
  final Person previousPerson;
  final Person currentPerson;

  PersonTabFormState._({required this.isEditing, required this.previousPerson})
      : currentPerson = previousPerson;

  factory PersonTabFormState.initial({required Person currentPerson}) {
    return PersonTabFormState._(isEditing: false, previousPerson: currentPerson);
  }

  PersonTabFormState copyWith({bool? isEditing, Person? currentPerson})
  {return PersonTabFormState._(isEditing: isEditing ?? this.isEditing,)}
}
