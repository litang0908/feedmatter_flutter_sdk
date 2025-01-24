class FeedMatterConfig {
  /// API 服务器地址
  final String baseUrl;

  /// API Key
  final String apiKey;

  /// 是否启用调试模式
  final bool debug;

  /// 超时时间（秒）
  final int timeout;

  const FeedMatterConfig({
    required this.baseUrl,
    required this.apiKey,
    this.debug = false,
    this.timeout = 30,
  });
}

class FeedMatterUser {
  final String userId;
  final String userName;
  final String? userAvatar;

  FeedMatterUser({
    required this.userId,
    required this.userName,
    this.userAvatar,
  });
}
