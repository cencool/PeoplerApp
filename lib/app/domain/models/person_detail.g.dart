// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonDetailImpl _$$PersonDetailImplFromJson(Map<String, dynamic> json) =>
    _$PersonDetailImpl(
      id: (json['id'] as num).toInt(),
      personId: (json['person_id'] as num).toInt(),
      maritalStatus: json['marital_status'] as String?,
      maidenName: json['maiden_name'] as String?,
      note: json['note'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$PersonDetailImplToJson(_$PersonDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'person_id': instance.personId,
      'marital_status': instance.maritalStatus,
      'maiden_name': instance.maidenName,
      'note': instance.note,
      'address': instance.address,
    };
