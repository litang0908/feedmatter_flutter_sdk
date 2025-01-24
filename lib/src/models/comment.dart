import 'package:feedmatter_flutter_sdk/src/models/attachment.dart';
import 'package:json_annotation/json_annotation.dart';

import 'author.dart';
import 'comment_mark.dart';
import 'client_info.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String id;
  final String feedbackId;
  final String content;
  final Author author;
  final String? parentId;
  @JsonKey(defaultValue: false)
  final bool isPinned;
  @JsonKey(defaultValue: 0)
  final int replyCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final ClientInfo? clientInfo;
  final CommentMark? mark;
  final List<Attachment>? attachments;

  const Comment({
    required this.id,
    required this.feedbackId,
    required this.content,
    required this.author,
    this.parentId,
    this.isPinned = false,
    this.replyCount = 0,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.clientInfo,
    this.mark,
    this.attachments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}