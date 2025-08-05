class ApiConstants {
  // Development
  static const String devBaseUrl = 'http://localhost:5280/api';
  
  // Production - Backend URL'inizi buraya yazın
  static const String prodBaseUrl = 'https://your-backend-url.com/api';
  
  // Environment'a göre URL seçimi
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: devBaseUrl,
  );
  
  // API Endpoints
  static const String news = '/news';
  static const String announcements = '/announcements';
  static const String events = '/events';
  static const String projects = '/projects';
  static const String cityServices = '/city-services';
  static const String search = '/search';
  static const String auth = '/auth';
} 