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
      callbackUrl: json['callbackUrl'] as String?,
      callbackToken: json['callbackToken'] as String?,
      callbackEnabled: json['callbackEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$ProjectConfigToJson(ProjectConfig instance) =>
    <String, dynamic>{
      'feedbackPrompt': instance.feedbackPrompt,
      'commentPrompt': instance.commentPrompt,
      'feedbackAttachmentEnabled': instance.feedbackAttachmentEnabled,
      'commentAttachmentEnabled': instance.commentAttachmentEnabled,
      'callbackUrl': instance.callbackUrl,
      'callbackToken': instance.callbackToken,
      'callbackEnabled': instance.callbackEnabled,
    };
