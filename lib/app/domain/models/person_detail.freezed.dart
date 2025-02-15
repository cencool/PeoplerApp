// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'person_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PersonDetail _$PersonDetailFromJson(Map<String, dynamic> json) {
  return _PersonDetail.fromJson(json);
}

/// @nodoc
mixin _$PersonDetail {
  int get id => throw _privateConstructorUsedError;
  int get personId => throw _privateConstructorUsedError;
  String? get maritalStatus => throw _privateConstructorUsedError;
  String? get maidenName => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  /// Serializes this PersonDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PersonDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PersonDetailCopyWith<PersonDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PersonDetailCopyWith<$Res> {
  factory $PersonDetailCopyWith(
          PersonDetail value, $Res Function(PersonDetail) then) =
      _$PersonDetailCopyWithImpl<$Res, PersonDetail>;
  @useResult
  $Res call(
      {int id,
      int personId,
      String? maritalStatus,
      String? maidenName,
      String? note,
      String? address});
}

/// @nodoc
class _$PersonDetailCopyWithImpl<$Res, $Val extends PersonDetail>
    implements $PersonDetailCopyWith<$Res> {
  _$PersonDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PersonDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? personId = null,
    Object? maritalStatus = freezed,
    Object? maidenName = freezed,
    Object? note = freezed,
    Object? address = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      personId: null == personId
          ? _value.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as int,
      maritalStatus: freezed == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      maidenName: freezed == maidenName
          ? _value.maidenName
          : maidenName // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PersonDetailImplCopyWith<$Res>
    implements $PersonDetailCopyWith<$Res> {
  factory _$$PersonDetailImplCopyWith(
          _$PersonDetailImpl value, $Res Function(_$PersonDetailImpl) then) =
      __$$PersonDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int personId,
      String? maritalStatus,
      String? maidenName,
      String? note,
      String? address});
}

/// @nodoc
class __$$PersonDetailImplCopyWithImpl<$Res>
    extends _$PersonDetailCopyWithImpl<$Res, _$PersonDetailImpl>
    implements _$$PersonDetailImplCopyWith<$Res> {
  __$$PersonDetailImplCopyWithImpl(
      _$PersonDetailImpl _value, $Res Function(_$PersonDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of PersonDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? personId = null,
    Object? maritalStatus = freezed,
    Object? maidenName = freezed,
    Object? note = freezed,
    Object? address = freezed,
  }) {
    return _then(_$PersonDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      personId: null == personId
          ? _value.personId
          : personId // ignore: cast_nullable_to_non_nullable
              as int,
      maritalStatus: freezed == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      maidenName: freezed == maidenName
          ? _value.maidenName
          : maidenName // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PersonDetailImpl implements _PersonDetail {
  const _$PersonDetailImpl(
      {required this.id,
      required this.personId,
      this.maritalStatus,
      this.maidenName,
      this.note,
      this.address});

  factory _$PersonDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$PersonDetailImplFromJson(json);

  @override
  final int id;
  @override
  final int personId;
  @override
  final String? maritalStatus;
  @override
  final String? maidenName;
  @override
  final String? note;
  @override
  final String? address;

  @override
  String toString() {
    return 'PersonDetail(id: $id, personId: $personId, maritalStatus: $maritalStatus, maidenName: $maidenName, note: $note, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PersonDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.personId, personId) ||
                other.personId == personId) &&
            (identical(other.maritalStatus, maritalStatus) ||
                other.maritalStatus == maritalStatus) &&
            (identical(other.maidenName, maidenName) ||
                other.maidenName == maidenName) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, personId, maritalStatus, maidenName, note, address);

  /// Create a copy of PersonDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PersonDetailImplCopyWith<_$PersonDetailImpl> get copyWith =>
      __$$PersonDetailImplCopyWithImpl<_$PersonDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PersonDetailImplToJson(
      this,
    );
  }
}

abstract class _PersonDetail implements PersonDetail {
  const factory _PersonDetail(
      {required final int id,
      required final int personId,
      final String? maritalStatus,
      final String? maidenName,
      final String? note,
      final String? address}) = _$PersonDetailImpl;

  factory _PersonDetail.fromJson(Map<String, dynamic> json) =
      _$PersonDetailImpl.fromJson;

  @override
  int get id;
  @override
  int get personId;
  @override
  String? get maritalStatus;
  @override
  String? get maidenName;
  @override
  String? get note;
  @override
  String? get address;

  /// Create a copy of PersonDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PersonDetailImplCopyWith<_$PersonDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
