import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'config.dart';
import 'enums/feedback_type.dart';
import 'exceptions/feedmatter_exception.dart';
import 'models/attachment.dart';
import 'models/client_info.dart';
import 'models/comment.dart';
import 'models/feedback.dart';

/// FeedMatter SDK 客户端
class FeedMatterClient {
  FeedMatterConfig? config;
  FeedMatterUser? _user;
  late Dio _dio;
  void Function(FeedMatterException)? onError;

  // 私有静态实例
  static FeedMatterClient? _instance;

  // 私有构造函数
  FeedMatterClient._();

  // 工厂构造方法
  factory FeedMatterClient() {
    _instance ??= FeedMatterClient._();
    return _instance!;
  }

  // 获取实例的静态方法
  static FeedMatterClient get instance {
    _instance ??= FeedMatterClient._();
    return _instance!;
  }

  void init(
    FeedMatterConfig config,
    FeedMatterUser user, {
    void Function(FeedMatterException)? onError,
  }) {
    this.config = config;
    _user = user;
    this.onError = onError;

    _dio = Dio(BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: Duration(seconds: config.timeout),
      receiveTimeout: Duration(seconds: config.timeout),
      headers: _headers,
    ));

    if (config.debug) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    if (config.debug) {
      //打印配置信息
      print('FeedMatterConfig: $config');
      print('FeedMatterUser: $_user');
    }

    // 添加错误处理拦截器
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) {
        if (e.response != null) {
          final response = e.response!;
          Map<String, dynamic> errorBody;
          try {
            errorBody = response.data as Map<String, dynamic>;
          } catch (_) {
            errorBody = {'message': response.data?.toString() ?? '未知错误'};
          }

          final message = errorBody['message'] as String? ?? '请求失败';
          final code = errorBody['code'] as String?;

          if (config?.debug ?? false) {
            print('FeedMatter API Error:');
            print('Status Code: ${response.statusCode}');
            print('Headers: ${response.requestOptions.headers}');
            print('URL: ${response.requestOptions.uri}');
            print('Method: ${response.requestOptions.method}');
            print('Error Body: $errorBody');
          }

          final error = response.statusCode == 401 || response.statusCode == 403
              ? FeedMatterAuthException(
                  message,
                  code: code,
                  originalError: errorBody,
                )
              : FeedMatterApiException(
                  message,
                  statusCode: response.statusCode,
                  code: code,
                  originalError: errorBody,
                );

          onError?.call(error);
          handler.reject(DioException(
            requestOptions: e.requestOptions,
            error: error,
          ));
          return;
        }

        final error = FeedMatterApiException(
          '网络请求失败',
          code: 'NETWORK_ERROR',
          originalError: e,
        );
        onError?.call(error);
        handler.reject(DioException(
          requestOptions: e.requestOptions,
          error: error,
        ));
      },
    ));
  }

  /// 清除用户信息
  void clearUser() {
    _user = null;
    // 移除用户相关的 headers
    _dio.options.headers.remove('X-User-Id');
    _dio.options.headers.remove('X-User-Name');
    _dio.options.headers.remove('X-User-Avatar');
  }

  String _getAppType() => Platform.operatingSystem.toUpperCase();

  /// 获取设备和应用信息
  Future<ClientInfo> _getClientInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfoPlugin = DeviceInfoPlugin();

    String? deviceModel;
    String? deviceBrand;
    String? deviceSysVersion; //版本名称
    String? deviceSysVersionInt; //版本号

    // 获取设备信息
    if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceModel = iosInfo.model;
      deviceBrand = iosInfo.name;
      deviceSysVersion = iosInfo.systemName;
      deviceSysVersionInt = iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceModel = androidInfo.model;
      deviceBrand = androidInfo.brand;
      deviceSysVersion = androidInfo.version.release;
      deviceSysVersionInt = androidInfo.version.sdkInt.toString();
    } else if (Platform.isMacOS) {
      final macOsInfo = await deviceInfoPlugin.macOsInfo;
      deviceModel = macOsInfo.model;
      deviceBrand = 'Apple';
      deviceSysVersion = macOsInfo.osRelease;
      deviceSysVersionInt = macOsInfo.majorVersion.toString();
    }

    return ClientInfo(
      appVersionCode: int.tryParse(packageInfo.buildNumber) ?? 0,
      appVersionName: packageInfo.version,
      appPackage: packageInfo.packageName,
      appType: _getAppType(),
      deviceModel: deviceModel,
      deviceBrand: deviceBrand,
      deviceSysVersion: deviceSysVersion,
      deviceSysVersionInt: deviceSysVersionInt,
    );
  }

  Map<String, String> get _headers {
    if (_user == null || config == null) {
      throw FeedMatterConfigException(
        '请先调用 init 方法设置配置信息',
        code: 'CONFIG_NOT_SET',
      );
    }
    return {
      'X-API-Key': config!.apiKey,
      'X-User-Id': _user!.userId,
      'X-User-Name': Uri.encodeComponent(_user!.userName),
      if (_user!.userAvatar != null)
        'X-User-Avatar': Uri.encodeComponent(_user!.userAvatar!),
      'Content-Type': 'application/json',
    };
  }

  Future<T> _handleResponse<T>(Future<Response<T>> Function() request) async {
    try {
      final response = await request();
      return response.data as T;
    } on DioException catch (e) {
      if (e.error is FeedMatterException) {
        throw e.error!;
      }
      rethrow;
    }
  }

  /// 创建反馈
  Future<Feedback> createFeedback({
    required String content,
    FeedbackType? type,
    Map<String, dynamic>? customInfo,
    List<Attachment>? attachments,
  }) async {
    final clientInfo = await _getClientInfo();
    final response = await _handleResponse(() => _dio.post(
      '/api/v1/feedback',
      data: {
        'content': content,
        if (type != null) 'type': type.value,
        'clientInfo': clientInfo.toJson(),
        if (customInfo != null) 'customInfo': customInfo,
        if (attachments != null && attachments.isNotEmpty)
          'attachments': attachments.map((a) => a.toJson()).toList(),
      },
    ));

    return Feedback.fromJson(response.data);
  }

  Future<List<Feedback>> getFeedbacks({
    int page = 0,
    int size = 20,
    String? keyword,
  }) async {
    final response = await _handleResponse(() => _dio.get(
          '/api/v1/feedback',
          queryParameters: {
            'page': page,
            'size': size,
            if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          },
        ));

    return (response['content'] as List)
        .map((item) => Feedback.fromJson(item))
        .toList();
  }

  Future<List<Feedback>> getMyFeedbacks({
    int page = 0,
    int size = 20,
    String? keyword,
  }) async {
    final response = await _handleResponse(() => _dio.get(
          '/api/v1/feedback/my',
          queryParameters: {
            'page': page,
            'size': size,
            if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
          },
        ));

    return (response['content'] as List)
        .map((item) => Feedback.fromJson(item))
        .toList();
  }

  Future<Feedback> getFeedback(String id) async {
    return _handleResponse(() => _dio.get(
          '/api/v1/feedback/$id',
        )).then((json) => Feedback.fromJson(json));
  }

  Future<Comment> createComment(
    String feedbackId,
    String content, {
    List<Attachment>? attachments,
    String? parentCommentId,
  }) async {
    final Map<String, dynamic> data = {
      'content': content,
      'clientInfo': (await _getClientInfo()).toJson(),
      if (attachments != null && attachments.isNotEmpty)
        'attachments': attachments.map((a) => a.toJson()).toList(),
      if (parentCommentId?.isNotEmpty ?? false) 'parentId': parentCommentId!,
    };

    return _handleResponse(() => _dio.post(
          '/api/v1/feedback/$feedbackId/comments',
          data: data,
        )).then((json) => Comment.fromJson(json));
  }

  Future<List<Comment>> getComments(
    String feedbackId, {
    int page = 0,
    int size = 20,
    String? sortBy,
  }) async {
    final response = await _handleResponse(() => _dio.get(
          '/api/v1/feedback/$feedbackId/comments',
          queryParameters: {
            'page': page,
            'size': size,
            if (sortBy != null) 'sort': sortBy,
          },
        ));

    return (response['content'] as List)
        .map((item) => Comment.fromJson(item))
        .toList();
  }

  /// 验证文件
  void _validateFile(File file, {int maxSize = 10 * 1024 * 1024}) {
    // 检查文件大小（默认最大10MB）
    final size = file.lengthSync();
    if (size > maxSize) {
      throw FeedMatterApiException(
        '文件大小超过限制',
        code: 'FILE_TOO_LARGE',
        originalError: {'maxSize': maxSize, 'actualSize': size},
      );
    }

    // 检查文件是否存在
    if (!file.existsSync()) {
      throw FeedMatterApiException(
        '文件不存在',
        code: 'FILE_NOT_FOUND',
      );
    }
  }

  /// 获取安全的文件名
  String _getSafeFileName(String fileName) {
    // 移除路径分隔符和特殊字符
    final name = fileName
        .split(Platform.pathSeparator)
        .last
        .replaceAll(RegExp(r'[^\w\s\-\.]'), '');

    // 如果文件名为空，生成随机文件名
    if (name.isEmpty) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'file_$timestamp';
    }

    return name;
  }

  /// 上传公开文件
  Future<String> uploadPublicFile(File file) async {
    _validateFile(file);

    final fileName = _getSafeFileName(file.path);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _handleResponse(() => _dio.post(
          '/api/v1/upload/public',
          data: formData,
        ));

    return response['url'];
  }

  /// 上传私密文件
  Future<String> uploadPrivateFile(File file) async {
    _validateFile(file);

    final fileName = _getSafeFileName(file.path);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _handleResponse(() => _dio.post(
          '/api/v1/upload/private',
          data: formData,
        ));

    return response['key'];
  }

  /// 获取私密文件的签名URL
  Future<String> getSignedUrl(String key) async {
    final response = await _handleResponse(() => _dio.get(
          '/api/v1/upload/private/$key',
        ));
    return response['url'];
  }

  /// 点赞反馈
  Future<void> likeFeedback(String feedbackId) async {
    await _handleResponse(() => _dio.post(
      '/api/v1/feedback/$feedbackId/like',
    ));
  }

  /// 取消点赞反馈
  Future<void> unlikeFeedback(String feedbackId) async {
    await _handleResponse(() => _dio.delete(
      '/api/v1/feedback/$feedbackId/like',
    ));
  }
}
