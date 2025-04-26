import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_detail.freezed.dart';
part 'person_detail.g.dart';

@freezed
@JsonSerializable(fieldRename: FieldRename.snake)
class PersonDetail with _$PersonDetail {
  const factory PersonDetail({
    required int id,
    required int personId,
    String? maritalStatus,
    String? maidenName,
    String? note,
    String? address,
  }) = _PersonDetail;

  factory PersonDetail.fromJson(Map<String, dynamic> json) => _$PersonDetailFromJson(json);

  factory PersonDetail.dummy(int pId) => PersonDetail(
        id: -1,
        personId: pId,
        maritalStatus: '',
        maidenName: '',
        note: '',
        address: '',
      );

  factory PersonDetail.dummySearch() => PersonDetail(
        id: -1,
        personId: -1,
        maritalStatus: '',
        maidenName: '',
        note: '',
        address: '',
      );
}
