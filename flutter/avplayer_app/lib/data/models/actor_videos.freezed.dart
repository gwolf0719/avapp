// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'actor_videos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActorVideos _$ActorVideosFromJson(Map<String, dynamic> json) {
  return _ActorVideos.fromJson(json);
}

/// @nodoc
mixin _$ActorVideos {
  String get status => throw _privateConstructorUsedError;
  String? get actorName => throw _privateConstructorUsedError;
  List<VideoListItem> get videos => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this ActorVideos to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActorVideos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActorVideosCopyWith<ActorVideos> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActorVideosCopyWith<$Res> {
  factory $ActorVideosCopyWith(
    ActorVideos value,
    $Res Function(ActorVideos) then,
  ) = _$ActorVideosCopyWithImpl<$Res, ActorVideos>;
  @useResult
  $Res call({
    String status,
    String? actorName,
    List<VideoListItem> videos,
    int totalCount,
    int currentPage,
    int totalPages,
    String? error,
  });
}

/// @nodoc
class _$ActorVideosCopyWithImpl<$Res, $Val extends ActorVideos>
    implements $ActorVideosCopyWith<$Res> {
  _$ActorVideosCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActorVideos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? actorName = freezed,
    Object? videos = null,
    Object? totalCount = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            actorName: freezed == actorName
                ? _value.actorName
                : actorName // ignore: cast_nullable_to_non_nullable
                      as String?,
            videos: null == videos
                ? _value.videos
                : videos // ignore: cast_nullable_to_non_nullable
                      as List<VideoListItem>,
            totalCount: null == totalCount
                ? _value.totalCount
                : totalCount // ignore: cast_nullable_to_non_nullable
                      as int,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActorVideosImplCopyWith<$Res>
    implements $ActorVideosCopyWith<$Res> {
  factory _$$ActorVideosImplCopyWith(
    _$ActorVideosImpl value,
    $Res Function(_$ActorVideosImpl) then,
  ) = __$$ActorVideosImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    String? actorName,
    List<VideoListItem> videos,
    int totalCount,
    int currentPage,
    int totalPages,
    String? error,
  });
}

/// @nodoc
class __$$ActorVideosImplCopyWithImpl<$Res>
    extends _$ActorVideosCopyWithImpl<$Res, _$ActorVideosImpl>
    implements _$$ActorVideosImplCopyWith<$Res> {
  __$$ActorVideosImplCopyWithImpl(
    _$ActorVideosImpl _value,
    $Res Function(_$ActorVideosImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActorVideos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? actorName = freezed,
    Object? videos = null,
    Object? totalCount = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? error = freezed,
  }) {
    return _then(
      _$ActorVideosImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        actorName: freezed == actorName
            ? _value.actorName
            : actorName // ignore: cast_nullable_to_non_nullable
                  as String?,
        videos: null == videos
            ? _value._videos
            : videos // ignore: cast_nullable_to_non_nullable
                  as List<VideoListItem>,
        totalCount: null == totalCount
            ? _value.totalCount
            : totalCount // ignore: cast_nullable_to_non_nullable
                  as int,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActorVideosImpl implements _ActorVideos {
  const _$ActorVideosImpl({
    required this.status,
    this.actorName,
    required final List<VideoListItem> videos,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    this.error,
  }) : _videos = videos;

  factory _$ActorVideosImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActorVideosImplFromJson(json);

  @override
  final String status;
  @override
  final String? actorName;
  final List<VideoListItem> _videos;
  @override
  List<VideoListItem> get videos {
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videos);
  }

  @override
  final int totalCount;
  @override
  final int currentPage;
  @override
  final int totalPages;
  @override
  final String? error;

  @override
  String toString() {
    return 'ActorVideos(status: $status, actorName: $actorName, videos: $videos, totalCount: $totalCount, currentPage: $currentPage, totalPages: $totalPages, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActorVideosImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.actorName, actorName) ||
                other.actorName == actorName) &&
            const DeepCollectionEquality().equals(other._videos, _videos) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    actorName,
    const DeepCollectionEquality().hash(_videos),
    totalCount,
    currentPage,
    totalPages,
    error,
  );

  /// Create a copy of ActorVideos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActorVideosImplCopyWith<_$ActorVideosImpl> get copyWith =>
      __$$ActorVideosImplCopyWithImpl<_$ActorVideosImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActorVideosImplToJson(this);
  }
}

abstract class _ActorVideos implements ActorVideos {
  const factory _ActorVideos({
    required final String status,
    final String? actorName,
    required final List<VideoListItem> videos,
    required final int totalCount,
    required final int currentPage,
    required final int totalPages,
    final String? error,
  }) = _$ActorVideosImpl;

  factory _ActorVideos.fromJson(Map<String, dynamic> json) =
      _$ActorVideosImpl.fromJson;

  @override
  String get status;
  @override
  String? get actorName;
  @override
  List<VideoListItem> get videos;
  @override
  int get totalCount;
  @override
  int get currentPage;
  @override
  int get totalPages;
  @override
  String? get error;

  /// Create a copy of ActorVideos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActorVideosImplCopyWith<_$ActorVideosImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActorVideosRequest _$ActorVideosRequestFromJson(Map<String, dynamic> json) {
  return _ActorVideosRequest.fromJson(json);
}

/// @nodoc
mixin _$ActorVideosRequest {
  String get actorUrl => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;

  /// Serializes this ActorVideosRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActorVideosRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActorVideosRequestCopyWith<ActorVideosRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActorVideosRequestCopyWith<$Res> {
  factory $ActorVideosRequestCopyWith(
    ActorVideosRequest value,
    $Res Function(ActorVideosRequest) then,
  ) = _$ActorVideosRequestCopyWithImpl<$Res, ActorVideosRequest>;
  @useResult
  $Res call({String actorUrl, int page});
}

/// @nodoc
class _$ActorVideosRequestCopyWithImpl<$Res, $Val extends ActorVideosRequest>
    implements $ActorVideosRequestCopyWith<$Res> {
  _$ActorVideosRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActorVideosRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actorUrl = null, Object? page = null}) {
    return _then(
      _value.copyWith(
            actorUrl: null == actorUrl
                ? _value.actorUrl
                : actorUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActorVideosRequestImplCopyWith<$Res>
    implements $ActorVideosRequestCopyWith<$Res> {
  factory _$$ActorVideosRequestImplCopyWith(
    _$ActorVideosRequestImpl value,
    $Res Function(_$ActorVideosRequestImpl) then,
  ) = __$$ActorVideosRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String actorUrl, int page});
}

/// @nodoc
class __$$ActorVideosRequestImplCopyWithImpl<$Res>
    extends _$ActorVideosRequestCopyWithImpl<$Res, _$ActorVideosRequestImpl>
    implements _$$ActorVideosRequestImplCopyWith<$Res> {
  __$$ActorVideosRequestImplCopyWithImpl(
    _$ActorVideosRequestImpl _value,
    $Res Function(_$ActorVideosRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActorVideosRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actorUrl = null, Object? page = null}) {
    return _then(
      _$ActorVideosRequestImpl(
        actorUrl: null == actorUrl
            ? _value.actorUrl
            : actorUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActorVideosRequestImpl implements _ActorVideosRequest {
  const _$ActorVideosRequestImpl({required this.actorUrl, this.page = 1});

  factory _$ActorVideosRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActorVideosRequestImplFromJson(json);

  @override
  final String actorUrl;
  @override
  @JsonKey()
  final int page;

  @override
  String toString() {
    return 'ActorVideosRequest(actorUrl: $actorUrl, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActorVideosRequestImpl &&
            (identical(other.actorUrl, actorUrl) ||
                other.actorUrl == actorUrl) &&
            (identical(other.page, page) || other.page == page));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, actorUrl, page);

  /// Create a copy of ActorVideosRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActorVideosRequestImplCopyWith<_$ActorVideosRequestImpl> get copyWith =>
      __$$ActorVideosRequestImplCopyWithImpl<_$ActorVideosRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActorVideosRequestImplToJson(this);
  }
}

abstract class _ActorVideosRequest implements ActorVideosRequest {
  const factory _ActorVideosRequest({
    required final String actorUrl,
    final int page,
  }) = _$ActorVideosRequestImpl;

  factory _ActorVideosRequest.fromJson(Map<String, dynamic> json) =
      _$ActorVideosRequestImpl.fromJson;

  @override
  String get actorUrl;
  @override
  int get page;

  /// Create a copy of ActorVideosRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActorVideosRequestImplCopyWith<_$ActorVideosRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
