// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
      pinned: json['pinned'] as bool,
      parentId: json['parentId'] as String?,
      replyCount: (json['replyCount'] as num).toInt(),
      mark: json['mark'] as Map<String, dynamic>?,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'pinned': instance.pinned,
      'parentId': instance.parentId,
      'replyCount': instance.replyCount,
      'mark': instance.mark,
      'replies': instance.replies,
    };
