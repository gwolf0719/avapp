// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VideoListItem _$VideoListItemFromJson(Map<String, dynamic> json) {
  return _VideoListItem.fromJson(json);
}

/// @nodoc
mixin _$VideoListItem {
  String get videoId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get videoUrl => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;

  /// Serializes this VideoListItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoListItemCopyWith<VideoListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoListItemCopyWith<$Res> {
  factory $VideoListItemCopyWith(
    VideoListItem value,
    $Res Function(VideoListItem) then,
  ) = _$VideoListItemCopyWithImpl<$Res, VideoListItem>;
  @useResult
  $Res call({
    String videoId,
    String title,
    String imageUrl,
    String videoUrl,
    String? duration,
  });
}

/// @nodoc
class _$VideoListItemCopyWithImpl<$Res, $Val extends VideoListItem>
    implements $VideoListItemCopyWith<$Res> {
  _$VideoListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? videoUrl = null,
    Object? duration = freezed,
  }) {
    return _then(
      _value.copyWith(
            videoId: null == videoId
                ? _value.videoId
                : videoId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            videoUrl: null == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VideoListItemImplCopyWith<$Res>
    implements $VideoListItemCopyWith<$Res> {
  factory _$$VideoListItemImplCopyWith(
    _$VideoListItemImpl value,
    $Res Function(_$VideoListItemImpl) then,
  ) = __$$VideoListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String videoId,
    String title,
    String imageUrl,
    String videoUrl,
    String? duration,
  });
}

/// @nodoc
class __$$VideoListItemImplCopyWithImpl<$Res>
    extends _$VideoListItemCopyWithImpl<$Res, _$VideoListItemImpl>
    implements _$$VideoListItemImplCopyWith<$Res> {
  __$$VideoListItemImplCopyWithImpl(
    _$VideoListItemImpl _value,
    $Res Function(_$VideoListItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VideoListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoId = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? videoUrl = null,
    Object? duration = freezed,
  }) {
    return _then(
      _$VideoListItemImpl(
        videoId: null == videoId
            ? _value.videoId
            : videoId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        videoUrl: null == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoListItemImpl implements _VideoListItem {
  const _$VideoListItemImpl({
    required this.videoId,
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
    this.duration,
  });

  factory _$VideoListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoListItemImplFromJson(json);

  @override
  final String videoId;
  @override
  final String title;
  @override
  final String imageUrl;
  @override
  final String videoUrl;
  @override
  final String? duration;

  @override
  String toString() {
    return 'VideoListItem(videoId: $videoId, title: $title, imageUrl: $imageUrl, videoUrl: $videoUrl, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoListItemImpl &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, videoId, title, imageUrl, videoUrl, duration);

  /// Create a copy of VideoListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoListItemImplCopyWith<_$VideoListItemImpl> get copyWith =>
      __$$VideoListItemImplCopyWithImpl<_$VideoListItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoListItemImplToJson(this);
  }
}

abstract class _VideoListItem implements VideoListItem {
  const factory _VideoListItem({
    required final String videoId,
    required final String title,
    required final String imageUrl,
    required final String videoUrl,
    final String? duration,
  }) = _$VideoListItemImpl;

  factory _VideoListItem.fromJson(Map<String, dynamic> json) =
      _$VideoListItemImpl.fromJson;

  @override
  String get videoId;
  @override
  String get title;
  @override
  String get imageUrl;
  @override
  String get videoUrl;
  @override
  String? get duration;

  /// Create a copy of VideoListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoListItemImplCopyWith<_$VideoListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideoListResponse _$VideoListResponseFromJson(Map<String, dynamic> json) {
  return _VideoListResponse.fromJson(json);
}

/// @nodoc
mixin _$VideoListResponse {
  String get status => throw _privateConstructorUsedError;
  List<VideoListItem> get videos => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this VideoListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoListResponseCopyWith<VideoListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoListResponseCopyWith<$Res> {
  factory $VideoListResponseCopyWith(
    VideoListResponse value,
    $Res Function(VideoListResponse) then,
  ) = _$VideoListResponseCopyWithImpl<$Res, VideoListResponse>;
  @useResult
  $Res call({
    String status,
    List<VideoListItem> videos,
    int totalCount,
    int currentPage,
    int totalPages,
    String? error,
  });
}

/// @nodoc
class _$VideoListResponseCopyWithImpl<$Res, $Val extends VideoListResponse>
    implements $VideoListResponseCopyWith<$Res> {
  _$VideoListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
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
abstract class _$$VideoListResponseImplCopyWith<$Res>
    implements $VideoListResponseCopyWith<$Res> {
  factory _$$VideoListResponseImplCopyWith(
    _$VideoListResponseImpl value,
    $Res Function(_$VideoListResponseImpl) then,
  ) = __$$VideoListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String status,
    List<VideoListItem> videos,
    int totalCount,
    int currentPage,
    int totalPages,
    String? error,
  });
}

/// @nodoc
class __$$VideoListResponseImplCopyWithImpl<$Res>
    extends _$VideoListResponseCopyWithImpl<$Res, _$VideoListResponseImpl>
    implements _$$VideoListResponseImplCopyWith<$Res> {
  __$$VideoListResponseImplCopyWithImpl(
    _$VideoListResponseImpl _value,
    $Res Function(_$VideoListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VideoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? videos = null,
    Object? totalCount = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? error = freezed,
  }) {
    return _then(
      _$VideoListResponseImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$VideoListResponseImpl implements _VideoListResponse {
  const _$VideoListResponseImpl({
    required this.status,
    required final List<VideoListItem> videos,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    this.error,
  }) : _videos = videos;

  factory _$VideoListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoListResponseImplFromJson(json);

  @override
  final String status;
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
    return 'VideoListResponse(status: $status, videos: $videos, totalCount: $totalCount, currentPage: $currentPage, totalPages: $totalPages, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoListResponseImpl &&
            (identical(other.status, status) || other.status == status) &&
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
    const DeepCollectionEquality().hash(_videos),
    totalCount,
    currentPage,
    totalPages,
    error,
  );

  /// Create a copy of VideoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoListResponseImplCopyWith<_$VideoListResponseImpl> get copyWith =>
      __$$VideoListResponseImplCopyWithImpl<_$VideoListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoListResponseImplToJson(this);
  }
}

abstract class _VideoListResponse implements VideoListResponse {
  const factory _VideoListResponse({
    required final String status,
    required final List<VideoListItem> videos,
    required final int totalCount,
    required final int currentPage,
    required final int totalPages,
    final String? error,
  }) = _$VideoListResponseImpl;

  factory _VideoListResponse.fromJson(Map<String, dynamic> json) =
      _$VideoListResponseImpl.fromJson;

  @override
  String get status;
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

  /// Create a copy of VideoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoListResponseImplCopyWith<_$VideoListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
