// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonImpl _$$PersonImplFromJson(Map<String, dynamic> json) => _$PersonImpl(
      id: (json['id'] as num?)?.toInt(),
      surname: json['surname'] as String?,
      name: json['name'] as String?,
      place: json['place'] as String?,
      gender: json['gender'] as String,
      owner: json['owner'] as String,
    );

Map<String, dynamic> _$$PersonImplToJson(_$PersonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'surname': instance.surname,
      'name': instance.name,
      'place': instance.place,
      'gender': instance.gender,
      'owner': instance.owner,
    };
