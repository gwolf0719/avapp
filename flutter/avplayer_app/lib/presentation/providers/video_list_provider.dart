import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/video_list_item.dart';
import '../../data/repositories/video_repository.dart';
import '../../data/providers/video_repository_provider.dart';

class VideoListNotifier extends StateNotifier<AsyncValue<VideoListResponse?>> {
  final VideoRepository _repository;
  int _currentPage = 1;
  bool _hasNextPage = true;
  final List<VideoListItem> _allVideos = [];

  VideoListNotifier(this._repository) : super(const AsyncValue.loading());

  int get currentPage => _currentPage;
  bool get hasNextPage => _hasNextPage;
  List<VideoListItem> get allVideos => List.unmodifiable(_allVideos);

  Future<void> loadInitialVideos() async {
    state = const AsyncValue.loading();
    _currentPage = 1;
    _hasNextPage = true;
    _allVideos.clear();

    await _loadVideos();
  }

  Future<void> loadMoreVideos() async {
    if (!_hasNextPage || state.isLoading) return;

    _currentPage++;
    await _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final response = await _repository.getVideoList(page: _currentPage);
      
      if (response.status == 'success') {
        _allVideos.addAll(response.videos);
        _hasNextPage = _currentPage < response.totalPages;
        
        state = AsyncValue.data(response.copyWith(videos: _allVideos));
      } else {
        state = AsyncValue.error(response.error ?? '獲取影片列表失敗', StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await loadInitialVideos();
  }
}

final videoListProvider = StateNotifierProvider<VideoListNotifier, AsyncValue<VideoListResponse?>>((ref) {
  final repository = ref.watch(videoRepositoryProvider);
  return VideoListNotifier(repository);
});
