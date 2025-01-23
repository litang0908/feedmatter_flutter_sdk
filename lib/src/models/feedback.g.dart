// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feedback _$FeedbackFromJson(Map<String, dynamic> json) => Feedback(
      id: json['id'] as String,
      content: json['content'] as String,
      status: json['status'] as String,
      pinned: json['pinned'] as bool,
      commentCount: (json['commentCount'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      clientInfo: json['clientInfo'] as Map<String, dynamic>?,
      customInfo: json['customInfo'] as Map<String, dynamic>?,
      mark: json['mark'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$FeedbackToJson(Feedback instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'status': instance.status,
      'pinned': instance.pinned,
      'commentCount': instance.commentCount,
      'createdAt': instance.createdAt,
      'clientInfo': instance.clientInfo,
      'customInfo': instance.customInfo,
      'mark': instance.mark,
    };
