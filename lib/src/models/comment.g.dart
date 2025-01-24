// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      content: json['content'] as String,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      parentId: json['parentId'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      clientInfo: json['clientInfo'] == null
          ? null
          : ClientInfo.fromJson(json['clientInfo'] as Map<String, dynamic>),
      mark: json['mark'] == null
          ? null
          : CommentMark.fromJson(json['mark'] as Map<String, dynamic>),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'author': instance.author,
      'parentId': instance.parentId,
      'isPinned': instance.isPinned,
      'replyCount': instance.replyCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'clientInfo': instance.clientInfo,
      'mark': instance.mark,
      'attachments': instance.attachments,
    };
