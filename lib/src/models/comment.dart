import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String id;
  final String content;
  final String createdAt;
  final bool pinned;
  final String? parentId;
  final int replyCount;
  final Map<String, dynamic>? mark;
  final List<Comment>? replies;

  const Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.pinned,
    this.parentId,
    required this.replyCount,
    this.mark,
    this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
} 