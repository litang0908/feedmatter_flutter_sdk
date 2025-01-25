// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feedback _$FeedbackFromJson(Map<String, dynamic> json) => Feedback(
      id: json['id'] as String,
      content: json['content'] as String,
      status: $enumDecode(_$FeedbackStatusEnumMap, json['status'],
          unknownValue: FeedbackStatus.pending),
      type: $enumDecodeNullable(_$FeedbackTypeEnumMap, json['type'],
          unknownValue: FeedbackType.other),
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      isPinned: json['isPinned'] as bool? ?? false,
      readCount: (json['readCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      clientInfo: json['clientInfo'] == null
          ? null
          : ClientInfo.fromJson(json['clientInfo'] as Map<String, dynamic>),
      customInfo: json['customInfo'] as Map<String, dynamic>?,
      mark: json['mark'] == null
          ? null
          : FeedbackMark.fromJson(json['mark'] as Map<String, dynamic>),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FeedbackToJson(Feedback instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'status': _$FeedbackStatusEnumMap[instance.status]!,
      'type': instance.type,
      'author': instance.author,
      'isPinned': instance.isPinned,
      'readCount': instance.readCount,
      'commentCount': instance.commentCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'clientInfo': instance.clientInfo,
      'customInfo': instance.customInfo,
      'mark': instance.mark,
      'attachments': instance.attachments,
    };

const _$FeedbackStatusEnumMap = {
  FeedbackStatus.pending: 'PENDING',
  FeedbackStatus.open: 'OPEN',
  FeedbackStatus.inProgress: 'IN_PROGRESS',
  FeedbackStatus.resolved: 'RESOLVED',
  FeedbackStatus.closed: 'CLOSED',
  FeedbackStatus.hidden: 'HIDDEN',
  FeedbackStatus.deleted: 'DELETED',
};

const _$FeedbackTypeEnumMap = {
  FeedbackType.advice: 'advice',
  FeedbackType.error: 'error',
  FeedbackType.ask: 'ask',
  FeedbackType.help: 'help',
  FeedbackType.notice: 'notice',
  FeedbackType.other: 'other',
};
