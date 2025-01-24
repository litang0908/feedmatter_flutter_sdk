import 'package:feedmatter_flutter_sdk/src/models/attachment.dart';
import 'package:json_annotation/json_annotation.dart';

import 'author.dart';
import 'comment_mark.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String id;
  final String content;
  final Author author;
  final String? parentId;
  final bool isPinned;
  final int replyCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final CommentMark? mark;
  final List<Attachment>? attachments;

  const Comment({
    required this.id,
    required this.content,
    required this.author,
    this.parentId,
    required this.isPinned,
    required this.replyCount,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.mark,
    this.attachments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}