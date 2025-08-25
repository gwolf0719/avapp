import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/api_client.dart';
import '../repositories/video_repository.dart';

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return VideoRepository(apiClient);
});
