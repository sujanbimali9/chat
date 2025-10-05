/// Application-wide constants for magic numbers, timeouts, and configuration values
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // Theme animation durations
  static const Duration themeTransitionDuration = Duration(milliseconds: 300);
  static const Duration splashFadeDuration = Duration(milliseconds: 500);

  // Network timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration socketTimeout = Duration(seconds: 10);

  // Chat configuration
  static const int defaultChatLimit = 20;
  static const int maxChatLimit = 100;
  static const int maxMessageLength = 5000;
  static const int conversationHistoryLimit = 50;

  // Retry and delay configurations
  static const Duration chatStreamRetryDelay = Duration(seconds: 40);
  static const Duration reconnectionDelay = Duration(milliseconds: 5000);
  static const Duration backgroundTaskDelay = Duration(seconds: 5);

  // Media processing
  static const int maxMediaConcurrency = 5;
  static const int imageCompressionQuality = 85;
  static const int videoThumbnailQuality = 100;
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 50 * 1024 * 1024; // 50MB

  // Notification configuration
  static const int maxNotificationMessages = 5;
  static const String notificationChannelId = 'chat_channel';
  static const String notificationChannelName = 'Chat Notifications';

  // Database configuration
  static const String databaseName = 'chat.db';
  static const int databaseVersion = 1;
  static const int maxDatabaseSize = 500 * 1024 * 1024; // 500MB

  // UI configuration
  static const double defaultToolbarHeight = 75.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;

  // Animation configurations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 250);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 400);

  // Cache configuration
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // Max number of cached items
  static const Duration localCacheTimeout = Duration(minutes: 30);

  // Environment configuration
  static const String defaultBaseUrl = 'http://192.168.1.22:8000/';
  static const String baseUrlKey = 'BASE_URL';
  static const String apiPath = '/api/';

  // Security
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int sessionTimeoutMinutes = 30;

  // File extensions
  static const List<String> imageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
    'svg',
  ];

  static const List<String> videoExtensions = [
    'mp4',
    'avi',
    'mov',
    'wmv',
    'flv',
    'webm',
    'mkv',
    '3gp',
  ];

  static const List<String> audioExtensions = [
    'mp3',
    'wav',
    'aac',
    'ogg',
    'wma',
    'flac',
    'm4a',
  ];
}

/// Error message constants
class ErrorMessages {
  ErrorMessages._();

  // Network errors
  static const String networkError =
      'Network connection failed. Please check your internet connection.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String serverError =
      'Server error occurred. Please try again later.';
  static const String connectionError = 'Failed to connect to server.';

  // Authentication errors
  static const String authError = 'Authentication failed. Please login again.';
  static const String unauthorized = 'Unauthorized access. Please login.';
  static const String forbidden = 'Access forbidden.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String emailNotVerified = 'Please verify your email address.';

  // Chat errors
  static const String messageSendFailed =
      'Failed to send message. Please try again.';
  static const String messageLoadFailed = 'Failed to load messages.';
  static const String chatNotFound = 'Chat conversation not found.';
  static const String messageEmpty = 'Message cannot be empty.';
  static const String messageTooLong = 'Message is too long.';

  // Media errors
  static const String mediaUploadFailed =
      'Failed to upload media. Please try again.';
  static const String mediaProcessingFailed = 'Failed to process media file.';
  static const String fileTooLarge = 'File size is too large.';
  static const String unsupportedFileType = 'Unsupported file type.';
  static const String mediaNotFound = 'Media file not found.';

  // Database errors
  static const String databaseError = 'Database error occurred.';
  static const String dataNotFound = 'Requested data not found.';
  static const String saveFailed = 'Failed to save data.';

  // General errors
  static const String unknownError = 'An unknown error occurred.';
  static const String invalidInput = 'Invalid input provided.';
  static const String operationFailed = 'Operation failed. Please try again.';
  static const String permissionDenied = 'Permission denied.';
}

/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Authentication endpoints
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String logout = 'auth/logout';
  static const String resetPassword = 'auth/reset-password';
  static const String verifyEmail = 'auth/verify-email';

  // User endpoints
  static const String users = 'users';
  static const String currentUser = 'users/me';
  static const String updateProfile = 'users/profile';
  static const String uploadProfileImage = 'users/profile-image';

  // Chat endpoints
  static const String chats = 'chats';
  static const String sendMessage = 'chats/sendChat';
  static const String uploadImages = 'chats/upload/images';
  static const String uploadVideos = 'chats/upload/videos';
  static const String uploadFiles = 'chats/upload/files';
  static const String uploadAudio = 'chats/upload/audio';

  // Media endpoints
  static const String upload = 'upload';
  static const String uploads = 'uploads';
  static const String download = 'download';
}
