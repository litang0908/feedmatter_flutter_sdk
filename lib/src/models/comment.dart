import 'package:feedmatter_flutter_sdk/src/models/attachment.dart';
import 'package:json_annotation/json_annotation.dart';

import 'author.dart';
import 'client_info.dart';
import 'comment_mark.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final String id;
  final String content;
  final Author author;
  final String? parentId;
  final String? parentUserName;
  @JsonKey(name: 'isPinned', defaultValue: false)
  final bool isPinned;
  @JsonKey(defaultValue: 0)
  final int replyCount;
  final DateTime createdAt;
  final ClientInfo? clientInfo;
  final CommentMark? mark;
  final List<Attachment>? attachments;

  const Comment({
    required this.id,
    required this.content,
    required this.author,
    this.parentId,
    this.parentUserName,
    this.isPinned = false,
    this.replyCount = 0,
    required this.createdAt,
    this.clientInfo,
    this.mark,
    this.attachments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}