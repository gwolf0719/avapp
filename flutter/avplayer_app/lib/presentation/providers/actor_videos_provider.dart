import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/video_repository.dart';
import '../../data/providers/video_repository_provider.dart';
import '../../data/models/actor_videos.dart';

final actorVideosProvider = FutureProvider.family<ActorVideos, String>(
  (ref, actorUrl) async {
    final repository = ref.read(videoRepositoryProvider);
    return await repository.getActorVideos(actorUrl);
  },
);
