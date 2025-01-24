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
      isPinned: json['isPinned'] as bool,
      replyCount: (json['replyCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      status: json['status'] as String,
      mark: json['mark'] == null
          ? null
          : CommentMark.fromJson(json['mark'] as Map<String, dynamic>),
      attachments: json['attachments'] != null
          ? (json['attachments'] as List<dynamic>)
              .map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'author': instance.author,
      'parentId': instance.parentId,
      'isPinned': instance.isPinned,
      'replyCount': instance.replyCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'status': instance.status,
      'mark': instance.mark, 
      'attachments': instance.attachments?.map((e) => e.toJson()).toList(),
    };
