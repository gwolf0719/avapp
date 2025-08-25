class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080';
  static const String apiV1 = '$baseUrl/api/v1/scraper';
  
  // Endpoints
  static const String videos = '$apiV1/videos';
  static const String videoDetail = '$apiV1/video/detail';
  static const String actorVideos = '$apiV1/actor/videos';
  static const String health = '$apiV1/health';
  
  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 30);
}
