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

  /// 最大附件数量
  final int maxAttachments;

  /// 最大上传文件大小
  final int maxUploadFileSize;

  const ProjectConfig({
    this.feedbackPrompt,
    this.commentPrompt,
    this.feedbackAttachmentEnabled = true,
    this.commentAttachmentEnabled = true,
    this.maxAttachments = 8,
    this.maxUploadFileSize = 10 * 1024 * 1024,
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
        'maxAttachments: $maxAttachments, '
        'maxUploadFileSize: $maxUploadFileSize)';
  }
}
