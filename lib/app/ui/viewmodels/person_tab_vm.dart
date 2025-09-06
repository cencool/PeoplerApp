import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peopler/app/ui/models/person_tab_state.dart';

class PersonTabVM extends StateNotifier<PersonTabState> {
  PersonTabVM() : super(PersonTabState());
}
