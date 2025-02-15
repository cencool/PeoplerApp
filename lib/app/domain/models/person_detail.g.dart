// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonDetailImpl _$$PersonDetailImplFromJson(Map<String, dynamic> json) =>
    _$PersonDetailImpl(
      id: (json['id'] as num).toInt(),
      personId: (json['personId'] as num).toInt(),
      maritalStatus: json['maritalStatus'] as String?,
      maidenName: json['maidenName'] as String?,
      note: json['note'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$PersonDetailImplToJson(_$PersonDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'personId': instance.personId,
      'maritalStatus': instance.maritalStatus,
      'maidenName': instance.maidenName,
      'note': instance.note,
      'address': instance.address,
    };
