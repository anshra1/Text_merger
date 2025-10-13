// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FilterSettings _$FilterSettingsFromJson(Map<String, dynamic> json) {
  return _FilterSettings.fromJson(json);
}

/// @nodoc
mixin _$FilterSettings {
  Set<String> get blockedExtensions => throw _privateConstructorUsedError;
  Set<String> get blockedFilePaths => throw _privateConstructorUsedError;
  Set<String> get blockedFileNames => throw _privateConstructorUsedError;
  Set<String> get blockedFolderNames => throw _privateConstructorUsedError;
  int get maxFileSizeInMB => throw _privateConstructorUsedError;
  bool get includeHiddenFiles => throw _privateConstructorUsedError;
  Set<String> get allowedExtensions => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FilterSettingsCopyWith<FilterSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterSettingsCopyWith<$Res> {
  factory $FilterSettingsCopyWith(
          FilterSettings value, $Res Function(FilterSettings) then) =
      _$FilterSettingsCopyWithImpl<$Res, FilterSettings>;
  @useResult
  $Res call(
      {Set<String> blockedExtensions,
      Set<String> blockedFilePaths,
      Set<String> blockedFileNames,
      Set<String> blockedFolderNames,
      int maxFileSizeInMB,
      bool includeHiddenFiles,
      Set<String> allowedExtensions,
      String? searchQuery});
}

/// @nodoc
class _$FilterSettingsCopyWithImpl<$Res, $Val extends FilterSettings>
    implements $FilterSettingsCopyWith<$Res> {
  _$FilterSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedExtensions = null,
    Object? blockedFilePaths = null,
    Object? blockedFileNames = null,
    Object? blockedFolderNames = null,
    Object? maxFileSizeInMB = null,
    Object? includeHiddenFiles = null,
    Object? allowedExtensions = null,
    Object? searchQuery = freezed,
  }) {
    return _then(_value.copyWith(
      blockedExtensions: null == blockedExtensions
          ? _value.blockedExtensions
          : blockedExtensions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedFilePaths: null == blockedFilePaths
          ? _value.blockedFilePaths
          : blockedFilePaths // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedFileNames: null == blockedFileNames
          ? _value.blockedFileNames
          : blockedFileNames // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedFolderNames: null == blockedFolderNames
          ? _value.blockedFolderNames
          : blockedFolderNames // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      maxFileSizeInMB: null == maxFileSizeInMB
          ? _value.maxFileSizeInMB
          : maxFileSizeInMB // ignore: cast_nullable_to_non_nullable
              as int,
      includeHiddenFiles: null == includeHiddenFiles
          ? _value.includeHiddenFiles
          : includeHiddenFiles // ignore: cast_nullable_to_non_nullable
              as bool,
      allowedExtensions: null == allowedExtensions
          ? _value.allowedExtensions
          : allowedExtensions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterSettingsImplCopyWith<$Res>
    implements $FilterSettingsCopyWith<$Res> {
  factory _$$FilterSettingsImplCopyWith(_$FilterSettingsImpl value,
          $Res Function(_$FilterSettingsImpl) then) =
      __$$FilterSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<String> blockedExtensions,
      Set<String> blockedFilePaths,
      Set<String> blockedFileNames,
      Set<String> blockedFolderNames,
      int maxFileSizeInMB,
      bool includeHiddenFiles,
      Set<String> allowedExtensions,
      String? searchQuery});
}

/// @nodoc
class __$$FilterSettingsImplCopyWithImpl<$Res>
    extends _$FilterSettingsCopyWithImpl<$Res, _$FilterSettingsImpl>
    implements _$$FilterSettingsImplCopyWith<$Res> {
  __$$FilterSettingsImplCopyWithImpl(
      _$FilterSettingsImpl _value, $Res Function(_$FilterSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blockedExtensions = null,
    Object? blockedFilePaths = null,
    Object? blockedFileNames = null,
    Object? blockedFolderNames = null,
    Object? maxFileSizeInMB = null,
    Object? includeHiddenFiles = null,
    Object? allowedExtensions = null,
    Object? searchQuery = freezed,
  }) {
    return _then(_$FilterSettingsImpl(
      blockedExtensions: null == blockedExtensions
          ? _value._blockedExtensions
          : blockedExtensions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedFilePaths: null == blockedFilePaths
          ? _value._blockedFilePaths
          : blockedFilePaths // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedFileNames: null == blockedFileNames
          ? _value._blockedFileNames
          : blockedFileNames // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedFolderNames: null == blockedFolderNames
          ? _value._blockedFolderNames
          : blockedFolderNames // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      maxFileSizeInMB: null == maxFileSizeInMB
          ? _value.maxFileSizeInMB
          : maxFileSizeInMB // ignore: cast_nullable_to_non_nullable
              as int,
      includeHiddenFiles: null == includeHiddenFiles
          ? _value.includeHiddenFiles
          : includeHiddenFiles // ignore: cast_nullable_to_non_nullable
              as bool,
      allowedExtensions: null == allowedExtensions
          ? _value._allowedExtensions
          : allowedExtensions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FilterSettingsImpl implements _FilterSettings {
  const _$FilterSettingsImpl(
      {required final Set<String> blockedExtensions,
      required final Set<String> blockedFilePaths,
      required final Set<String> blockedFileNames,
      required final Set<String> blockedFolderNames,
      required this.maxFileSizeInMB,
      required this.includeHiddenFiles,
      required final Set<String> allowedExtensions,
      this.searchQuery})
      : _blockedExtensions = blockedExtensions,
        _blockedFilePaths = blockedFilePaths,
        _blockedFileNames = blockedFileNames,
        _blockedFolderNames = blockedFolderNames,
        _allowedExtensions = allowedExtensions;

  factory _$FilterSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FilterSettingsImplFromJson(json);

  final Set<String> _blockedExtensions;
  @override
  Set<String> get blockedExtensions {
    if (_blockedExtensions is EqualUnmodifiableSetView)
      return _blockedExtensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_blockedExtensions);
  }

  final Set<String> _blockedFilePaths;
  @override
  Set<String> get blockedFilePaths {
    if (_blockedFilePaths is EqualUnmodifiableSetView) return _blockedFilePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_blockedFilePaths);
  }

  final Set<String> _blockedFileNames;
  @override
  Set<String> get blockedFileNames {
    if (_blockedFileNames is EqualUnmodifiableSetView) return _blockedFileNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_blockedFileNames);
  }

  final Set<String> _blockedFolderNames;
  @override
  Set<String> get blockedFolderNames {
    if (_blockedFolderNames is EqualUnmodifiableSetView)
      return _blockedFolderNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_blockedFolderNames);
  }

  @override
  final int maxFileSizeInMB;
  @override
  final bool includeHiddenFiles;
  final Set<String> _allowedExtensions;
  @override
  Set<String> get allowedExtensions {
    if (_allowedExtensions is EqualUnmodifiableSetView)
      return _allowedExtensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_allowedExtensions);
  }

  @override
  final String? searchQuery;

  @override
  String toString() {
    return 'FilterSettings(blockedExtensions: $blockedExtensions, blockedFilePaths: $blockedFilePaths, blockedFileNames: $blockedFileNames, blockedFolderNames: $blockedFolderNames, maxFileSizeInMB: $maxFileSizeInMB, includeHiddenFiles: $includeHiddenFiles, allowedExtensions: $allowedExtensions, searchQuery: $searchQuery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterSettingsImpl &&
            const DeepCollectionEquality()
                .equals(other._blockedExtensions, _blockedExtensions) &&
            const DeepCollectionEquality()
                .equals(other._blockedFilePaths, _blockedFilePaths) &&
            const DeepCollectionEquality()
                .equals(other._blockedFileNames, _blockedFileNames) &&
            const DeepCollectionEquality()
                .equals(other._blockedFolderNames, _blockedFolderNames) &&
            (identical(other.maxFileSizeInMB, maxFileSizeInMB) ||
                other.maxFileSizeInMB == maxFileSizeInMB) &&
            (identical(other.includeHiddenFiles, includeHiddenFiles) ||
                other.includeHiddenFiles == includeHiddenFiles) &&
            const DeepCollectionEquality()
                .equals(other._allowedExtensions, _allowedExtensions) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_blockedExtensions),
      const DeepCollectionEquality().hash(_blockedFilePaths),
      const DeepCollectionEquality().hash(_blockedFileNames),
      const DeepCollectionEquality().hash(_blockedFolderNames),
      maxFileSizeInMB,
      includeHiddenFiles,
      const DeepCollectionEquality().hash(_allowedExtensions),
      searchQuery);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterSettingsImplCopyWith<_$FilterSettingsImpl> get copyWith =>
      __$$FilterSettingsImplCopyWithImpl<_$FilterSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FilterSettingsImplToJson(
      this,
    );
  }
}

abstract class _FilterSettings implements FilterSettings {
  const factory _FilterSettings(
      {required final Set<String> blockedExtensions,
      required final Set<String> blockedFilePaths,
      required final Set<String> blockedFileNames,
      required final Set<String> blockedFolderNames,
      required final int maxFileSizeInMB,
      required final bool includeHiddenFiles,
      required final Set<String> allowedExtensions,
      final String? searchQuery}) = _$FilterSettingsImpl;

  factory _FilterSettings.fromJson(Map<String, dynamic> json) =
      _$FilterSettingsImpl.fromJson;

  @override
  Set<String> get blockedExtensions;
  @override
  Set<String> get blockedFilePaths;
  @override
  Set<String> get blockedFileNames;
  @override
  Set<String> get blockedFolderNames;
  @override
  int get maxFileSizeInMB;
  @override
  bool get includeHiddenFiles;
  @override
  Set<String> get allowedExtensions;
  @override
  String? get searchQuery;
  @override
  @JsonKey(ignore: true)
  _$$FilterSettingsImplCopyWith<_$FilterSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
