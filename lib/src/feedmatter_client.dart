import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'config.dart';
import 'models/comment.dart';
import 'models/feedback.dart';

class FeedMatterClient {
  final FeedMatterConfig config;
  late final Dio _dio;
  String? _userId;
  String? _username;
  String? _userAvatar;

  FeedMatterClient(this.config) {
    _dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: Duration(seconds: config.timeout),
      receiveTimeout: Duration(seconds: config.timeout),
      headers: {
        'X-API-Key': config.apiKey,
      },
    ));

    if (config.debug) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  /// 设置用户信息
  void setUser({
    required String userId,
    required String username,
    String? avatar,
  }) {
    _userId = userId;
    _username = username;
    _userAvatar = avatar;
    
    // 更新 dio 的默认 headers
    _dio.options.headers.addAll({
      'X-User-Id': userId,
      'X-User-Name': username,
      if (avatar != null) 'X-User-Avatar': avatar,
    });
  }

  /// 清除用户信息
  void clearUser() {
    _userId = null;
    _username = null;
    _userAvatar = null;
    
    // 移除用户相关的 headers
    _dio.options.headers.remove('X-User-Id');
    _dio.options.headers.remove('X-User-Name');
    _dio.options.headers.remove('X-User-Avatar');
  }

  /// 获取设备和应用信息
  Future<Map<String, dynamic>> _getClientInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final Map<String, dynamic> info = {
      'appVersionCode': int.tryParse(packageInfo.buildNumber) ?? 0,
      'appVersionName': packageInfo.version,
      'packageName': packageInfo.packageName,
    };

    if (config.debug) {
      print('Client info: $info');
    }

    return info;
  }

  /// 提交反馈
  Future<Feedback> submitFeedback(String content,
      {Map<String, dynamic>? customInfo}) async {
    if (_userId == null || _username == null) {
      throw Exception('User not set. Please call setUser() first.');
    }

    final clientInfo = await _getClientInfo();

    final response = await _dio.post(
      '/api/v1/feedback',
      data: {
        'content': content,
        'clientInfo': clientInfo,
        'customInfo': customInfo,
      },
    );

    return Feedback.fromJson(response.data);
  }

  /// 获取反馈列表
  Future<List<Feedback>> getFeedbacks({
    int page = 0,
    int size = 20,
    String? status,
  }) async {
    final response = await _dio.get(
      '/api/v1/feedback',
      queryParameters: {
        'page': page,
        'size': size,
        if (status != null) 'status': status,
      },
    );

    final List<dynamic> items = response.data['content'];
    return items.map((item) => Feedback.fromJson(item)).toList();
  }

  /// 添加评论
  Future<Comment> addComment(String feedbackId, String content,
      {String? parentId}) async {
    if (_userId == null || _username == null) {
      throw Exception('User not set. Please call setUser() first.');
    }

    final response = await _dio.post(
      '/api/v1/feedback/$feedbackId/comments',
      data: {
        'content': content,
        if (parentId != null) 'parentId': parentId,
      },
    );

    return Comment.fromJson(response.data);
  }

  /// 获取评论列表
  Future<List<Comment>> getComments(
    String feedbackId, {
    int page = 0,
    int size = 20,
  }) async {
    final response = await _dio.get(
      '/api/v1/feedback/$feedbackId/comments',
      queryParameters: {
        'page': page,
        'size': size,
      },
    );

    final List<dynamic> items = response.data['content'];
    return items.map((item) => Comment.fromJson(item)).toList();
  }

  /// 获取用户自己的反馈列表
  Future<List<Feedback>> getMyFeedbacks({
    int page = 0,
    int size = 20,
  }) async {
    if (_userId == null) {
      throw Exception('User not set. Please call setUser() first.');
    }

    final response = await _dio.get(
      '/api/v1/feedback/my',
      queryParameters: {
        'page': page,
        'size': size,
      },
    );

    final List<dynamic> items = response.data['content'];
    return items.map((item) => Feedback.fromJson(item)).toList();
  }
}
