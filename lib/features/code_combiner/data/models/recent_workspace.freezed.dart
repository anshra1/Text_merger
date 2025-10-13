// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_workspace.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecentWorkspace _$RecentWorkspaceFromJson(Map<String, dynamic> json) {
  return _RecentWorkspace.fromJson(json);
}

/// @nodoc
mixin _$RecentWorkspace {
  String get path => throw _privateConstructorUsedError;
  DateTime get lastAccessed => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecentWorkspaceCopyWith<RecentWorkspace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentWorkspaceCopyWith<$Res> {
  factory $RecentWorkspaceCopyWith(
          RecentWorkspace value, $Res Function(RecentWorkspace) then) =
      _$RecentWorkspaceCopyWithImpl<$Res, RecentWorkspace>;
  @useResult
  $Res call({String path, DateTime lastAccessed, bool isFavorite});
}

/// @nodoc
class _$RecentWorkspaceCopyWithImpl<$Res, $Val extends RecentWorkspace>
    implements $RecentWorkspaceCopyWith<$Res> {
  _$RecentWorkspaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? lastAccessed = null,
    Object? isFavorite = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      lastAccessed: null == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentWorkspaceImplCopyWith<$Res>
    implements $RecentWorkspaceCopyWith<$Res> {
  factory _$$RecentWorkspaceImplCopyWith(_$RecentWorkspaceImpl value,
          $Res Function(_$RecentWorkspaceImpl) then) =
      __$$RecentWorkspaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, DateTime lastAccessed, bool isFavorite});
}

/// @nodoc
class __$$RecentWorkspaceImplCopyWithImpl<$Res>
    extends _$RecentWorkspaceCopyWithImpl<$Res, _$RecentWorkspaceImpl>
    implements _$$RecentWorkspaceImplCopyWith<$Res> {
  __$$RecentWorkspaceImplCopyWithImpl(
      _$RecentWorkspaceImpl _value, $Res Function(_$RecentWorkspaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? lastAccessed = null,
    Object? isFavorite = null,
  }) {
    return _then(_$RecentWorkspaceImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      lastAccessed: null == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentWorkspaceImpl extends _RecentWorkspace {
  const _$RecentWorkspaceImpl(
      {required this.path,
      required this.lastAccessed,
      required this.isFavorite})
      : super._();

  factory _$RecentWorkspaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentWorkspaceImplFromJson(json);

  @override
  final String path;
  @override
  final DateTime lastAccessed;
  @override
  final bool isFavorite;

  @override
  String toString() {
    return 'RecentWorkspace(path: $path, lastAccessed: $lastAccessed, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentWorkspaceImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path, lastAccessed, isFavorite);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentWorkspaceImplCopyWith<_$RecentWorkspaceImpl> get copyWith =>
      __$$RecentWorkspaceImplCopyWithImpl<_$RecentWorkspaceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentWorkspaceImplToJson(
      this,
    );
  }
}

abstract class _RecentWorkspace extends RecentWorkspace {
  const factory _RecentWorkspace(
      {required final String path,
      required final DateTime lastAccessed,
      required final bool isFavorite}) = _$RecentWorkspaceImpl;
  const _RecentWorkspace._() : super._();

  factory _RecentWorkspace.fromJson(Map<String, dynamic> json) =
      _$RecentWorkspaceImpl.fromJson;

  @override
  String get path;
  @override
  DateTime get lastAccessed;
  @override
  bool get isFavorite;
  @override
  @JsonKey(ignore: true)
  _$$RecentWorkspaceImplCopyWith<_$RecentWorkspaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
