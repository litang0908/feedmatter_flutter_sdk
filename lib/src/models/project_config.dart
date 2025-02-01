import 'package:json_annotation/json_annotation.dart';

part 'project_config.g.dart';

@JsonSerializable()
class ProjectConfig {
  /// 反馈提示词
  final String? feedbackPrompt;

  /// 评论提示词
  final String? commentPrompt;

  /// 反馈是否支持附件
  final bool feedbackAttachmentEnabled;

  /// 评论是否支持附件
  final bool commentAttachmentEnabled;

  /// 回调URL
  final String? callbackUrl;

  /// 回调Token
  final String? callbackToken;

  /// 是否启用回调
  final bool callbackEnabled;

  const ProjectConfig({
    this.feedbackPrompt,
    this.commentPrompt,
    this.feedbackAttachmentEnabled = true,
    this.commentAttachmentEnabled = true,
    this.callbackUrl,
    this.callbackToken,
    this.callbackEnabled = false,
  });

  factory ProjectConfig.fromJson(Map<String, dynamic> json) =>
      _$ProjectConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectConfigToJson(this);

  @override
  String toString() {
    return 'ProjectConfig('
        'feedbackPrompt: $feedbackPrompt, '
        'commentPrompt: $commentPrompt, '
        'feedbackAttachmentEnabled: $feedbackAttachmentEnabled, '
        'commentAttachmentEnabled: $commentAttachmentEnabled, '
        'callbackUrl: $callbackUrl, '
        'callbackToken: $callbackToken, '
        'callbackEnabled: $callbackEnabled)';
  }
} 