// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectConfig _$ProjectConfigFromJson(Map<String, dynamic> json) =>
    ProjectConfig(
      feedbackPrompt: json['feedbackPrompt'] as String?,
      commentPrompt: json['commentPrompt'] as String?,
      feedbackAttachmentEnabled:
          json['feedbackAttachmentEnabled'] as bool? ?? true,
      commentAttachmentEnabled:
          json['commentAttachmentEnabled'] as bool? ?? true,
      maxAttachments: (json['maxAttachments'] as num?)?.toInt() ?? 8,
      maxUploadFileSize:
          (json['maxUploadFileSize'] as num?)?.toInt() ?? 10 * 1024 * 1024,
    );

Map<String, dynamic> _$ProjectConfigToJson(ProjectConfig instance) =>
    <String, dynamic>{
      'feedbackPrompt': instance.feedbackPrompt,
      'commentPrompt': instance.commentPrompt,
      'feedbackAttachmentEnabled': instance.feedbackAttachmentEnabled,
      'commentAttachmentEnabled': instance.commentAttachmentEnabled,
      'maxAttachments': instance.maxAttachments,
      'maxUploadFileSize': instance.maxUploadFileSize,
    };
