// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) {
  return _SettingsModel.fromJson(json);
}

/// @nodoc
mixin _$SettingsModel {
  int get maxTokenCount => throw _privateConstructorUsedError;
  bool get stripComments => throw _privateConstructorUsedError;
  bool get warnOnTokenLimit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingsModelCopyWith<SettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsModelCopyWith<$Res> {
  factory $SettingsModelCopyWith(
          SettingsModel value, $Res Function(SettingsModel) then) =
      _$SettingsModelCopyWithImpl<$Res, SettingsModel>;
  @useResult
  $Res call({int maxTokenCount, bool stripComments, bool warnOnTokenLimit});
}

/// @nodoc
class _$SettingsModelCopyWithImpl<$Res, $Val extends SettingsModel>
    implements $SettingsModelCopyWith<$Res> {
  _$SettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxTokenCount = null,
    Object? stripComments = null,
    Object? warnOnTokenLimit = null,
  }) {
    return _then(_value.copyWith(
      maxTokenCount: null == maxTokenCount
          ? _value.maxTokenCount
          : maxTokenCount // ignore: cast_nullable_to_non_nullable
              as int,
      stripComments: null == stripComments
          ? _value.stripComments
          : stripComments // ignore: cast_nullable_to_non_nullable
              as bool,
      warnOnTokenLimit: null == warnOnTokenLimit
          ? _value.warnOnTokenLimit
          : warnOnTokenLimit // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsModelImplCopyWith<$Res>
    implements $SettingsModelCopyWith<$Res> {
  factory _$$SettingsModelImplCopyWith(
          _$SettingsModelImpl value, $Res Function(_$SettingsModelImpl) then) =
      __$$SettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int maxTokenCount, bool stripComments, bool warnOnTokenLimit});
}

/// @nodoc
class __$$SettingsModelImplCopyWithImpl<$Res>
    extends _$SettingsModelCopyWithImpl<$Res, _$SettingsModelImpl>
    implements _$$SettingsModelImplCopyWith<$Res> {
  __$$SettingsModelImplCopyWithImpl(
      _$SettingsModelImpl _value, $Res Function(_$SettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maxTokenCount = null,
    Object? stripComments = null,
    Object? warnOnTokenLimit = null,
  }) {
    return _then(_$SettingsModelImpl(
      maxTokenCount: null == maxTokenCount
          ? _value.maxTokenCount
          : maxTokenCount // ignore: cast_nullable_to_non_nullable
              as int,
      stripComments: null == stripComments
          ? _value.stripComments
          : stripComments // ignore: cast_nullable_to_non_nullable
              as bool,
      warnOnTokenLimit: null == warnOnTokenLimit
          ? _value.warnOnTokenLimit
          : warnOnTokenLimit // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingsModelImpl implements _SettingsModel {
  const _$SettingsModelImpl(
      {required this.maxTokenCount,
      required this.stripComments,
      required this.warnOnTokenLimit});

  factory _$SettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsModelImplFromJson(json);

  @override
  final int maxTokenCount;
  @override
  final bool stripComments;
  @override
  final bool warnOnTokenLimit;

  @override
  String toString() {
    return 'SettingsModel(maxTokenCount: $maxTokenCount, stripComments: $stripComments, warnOnTokenLimit: $warnOnTokenLimit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsModelImpl &&
            (identical(other.maxTokenCount, maxTokenCount) ||
                other.maxTokenCount == maxTokenCount) &&
            (identical(other.stripComments, stripComments) ||
                other.stripComments == stripComments) &&
            (identical(other.warnOnTokenLimit, warnOnTokenLimit) ||
                other.warnOnTokenLimit == warnOnTokenLimit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, maxTokenCount, stripComments, warnOnTokenLimit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsModelImplCopyWith<_$SettingsModelImpl> get copyWith =>
      __$$SettingsModelImplCopyWithImpl<_$SettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsModelImplToJson(
      this,
    );
  }
}

abstract class _SettingsModel implements SettingsModel {
  const factory _SettingsModel(
      {required final int maxTokenCount,
      required final bool stripComments,
      required final bool warnOnTokenLimit}) = _$SettingsModelImpl;

  factory _SettingsModel.fromJson(Map<String, dynamic> json) =
      _$SettingsModelImpl.fromJson;

  @override
  int get maxTokenCount;
  @override
  bool get stripComments;
  @override
  bool get warnOnTokenLimit;
  @override
  @JsonKey(ignore: true)
  _$$SettingsModelImplCopyWith<_$SettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
