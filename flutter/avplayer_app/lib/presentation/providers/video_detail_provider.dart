import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/video_detail.dart';
import '../../data/providers/video_repository_provider.dart';

final videoDetailProvider = FutureProvider.family<VideoDetail, String>((ref, videoId) async {
  final repository = ref.watch(videoRepositoryProvider);
  final detail = await repository.getVideoDetail(videoId);
  
  if (detail.status != 'success') {
    throw Exception(detail.error ?? '獲取影片詳情失敗');
  }
  
  return detail;
});

// Cache for keeping video details in memory
final videoDetailCacheProvider = StateProvider<Map<String, VideoDetail>>((ref) => {});

// Combined provider that checks cache first
final cachedVideoDetailProvider = FutureProvider.family<VideoDetail, String>((ref, videoId) async {
  final cache = ref.read(videoDetailCacheProvider);
  
  if (cache.containsKey(videoId)) {
    return cache[videoId]!;
  }
  
  final detail = await ref.watch(videoDetailProvider(videoId).future);
  
  // Update cache
  ref.read(videoDetailCacheProvider.notifier).update((state) => {
    ...state,
    videoId: detail,
  });
  
  return detail;
});
