// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  int get fileSplitSizeInMB => throw _privateConstructorUsedError;
  int get maxTokenWarningLimit => throw _privateConstructorUsedError;
  bool get warnOnTokenExceed => throw _privateConstructorUsedError;
  bool get stripCommentsFromCode => throw _privateConstructorUsedError;
  String? get defaultExportLocation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
          AppSettings value, $Res Function(AppSettings) then) =
      _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call(
      {int fileSplitSizeInMB,
      int maxTokenWarningLimit,
      bool warnOnTokenExceed,
      bool stripCommentsFromCode,
      String? defaultExportLocation});
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileSplitSizeInMB = null,
    Object? maxTokenWarningLimit = null,
    Object? warnOnTokenExceed = null,
    Object? stripCommentsFromCode = null,
    Object? defaultExportLocation = freezed,
  }) {
    return _then(_value.copyWith(
      fileSplitSizeInMB: null == fileSplitSizeInMB
          ? _value.fileSplitSizeInMB
          : fileSplitSizeInMB // ignore: cast_nullable_to_non_nullable
              as int,
      maxTokenWarningLimit: null == maxTokenWarningLimit
          ? _value.maxTokenWarningLimit
          : maxTokenWarningLimit // ignore: cast_nullable_to_non_nullable
              as int,
      warnOnTokenExceed: null == warnOnTokenExceed
          ? _value.warnOnTokenExceed
          : warnOnTokenExceed // ignore: cast_nullable_to_non_nullable
              as bool,
      stripCommentsFromCode: null == stripCommentsFromCode
          ? _value.stripCommentsFromCode
          : stripCommentsFromCode // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultExportLocation: freezed == defaultExportLocation
          ? _value.defaultExportLocation
          : defaultExportLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
          _$AppSettingsImpl value, $Res Function(_$AppSettingsImpl) then) =
      __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int fileSplitSizeInMB,
      int maxTokenWarningLimit,
      bool warnOnTokenExceed,
      bool stripCommentsFromCode,
      String? defaultExportLocation});
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
      _$AppSettingsImpl _value, $Res Function(_$AppSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileSplitSizeInMB = null,
    Object? maxTokenWarningLimit = null,
    Object? warnOnTokenExceed = null,
    Object? stripCommentsFromCode = null,
    Object? defaultExportLocation = freezed,
  }) {
    return _then(_$AppSettingsImpl(
      fileSplitSizeInMB: null == fileSplitSizeInMB
          ? _value.fileSplitSizeInMB
          : fileSplitSizeInMB // ignore: cast_nullable_to_non_nullable
              as int,
      maxTokenWarningLimit: null == maxTokenWarningLimit
          ? _value.maxTokenWarningLimit
          : maxTokenWarningLimit // ignore: cast_nullable_to_non_nullable
              as int,
      warnOnTokenExceed: null == warnOnTokenExceed
          ? _value.warnOnTokenExceed
          : warnOnTokenExceed // ignore: cast_nullable_to_non_nullable
              as bool,
      stripCommentsFromCode: null == stripCommentsFromCode
          ? _value.stripCommentsFromCode
          : stripCommentsFromCode // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultExportLocation: freezed == defaultExportLocation
          ? _value.defaultExportLocation
          : defaultExportLocation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl(
      {required this.fileSplitSizeInMB,
      required this.maxTokenWarningLimit,
      required this.warnOnTokenExceed,
      required this.stripCommentsFromCode,
      this.defaultExportLocation});

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  @override
  final int fileSplitSizeInMB;
  @override
  final int maxTokenWarningLimit;
  @override
  final bool warnOnTokenExceed;
  @override
  final bool stripCommentsFromCode;
  @override
  final String? defaultExportLocation;

  @override
  String toString() {
    return 'AppSettings(fileSplitSizeInMB: $fileSplitSizeInMB, maxTokenWarningLimit: $maxTokenWarningLimit, warnOnTokenExceed: $warnOnTokenExceed, stripCommentsFromCode: $stripCommentsFromCode, defaultExportLocation: $defaultExportLocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.fileSplitSizeInMB, fileSplitSizeInMB) ||
                other.fileSplitSizeInMB == fileSplitSizeInMB) &&
            (identical(other.maxTokenWarningLimit, maxTokenWarningLimit) ||
                other.maxTokenWarningLimit == maxTokenWarningLimit) &&
            (identical(other.warnOnTokenExceed, warnOnTokenExceed) ||
                other.warnOnTokenExceed == warnOnTokenExceed) &&
            (identical(other.stripCommentsFromCode, stripCommentsFromCode) ||
                other.stripCommentsFromCode == stripCommentsFromCode) &&
            (identical(other.defaultExportLocation, defaultExportLocation) ||
                other.defaultExportLocation == defaultExportLocation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fileSplitSizeInMB,
      maxTokenWarningLimit,
      warnOnTokenExceed,
      stripCommentsFromCode,
      defaultExportLocation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(
      this,
    );
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings(
      {required final int fileSplitSizeInMB,
      required final int maxTokenWarningLimit,
      required final bool warnOnTokenExceed,
      required final bool stripCommentsFromCode,
      final String? defaultExportLocation}) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  @override
  int get fileSplitSizeInMB;
  @override
  int get maxTokenWarningLimit;
  @override
  bool get warnOnTokenExceed;
  @override
  bool get stripCommentsFromCode;
  @override
  String? get defaultExportLocation;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
