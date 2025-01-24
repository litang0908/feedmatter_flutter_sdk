import 'package:json_annotation/json_annotation.dart';
import 'author.dart';
import 'attachment.dart';
import 'feedback_mark.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  final String id;
  final String content;
  final String status;
  final Author author;
  final List<Attachment>? attachments;
  final bool isPinned;
  final int commentCount;
  final int readCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? clientInfo;
  final Map<String, dynamic>? customInfo;
  final FeedbackMark? mark;

  const Feedback({
    required this.id,
    required this.content,
    required this.status,
    required this.author,
    this.attachments,
    required this.isPinned,
    required this.commentCount,
    required this.readCount,
    required this.createdAt,
    required this.updatedAt,
    this.clientInfo,
    this.customInfo,
    this.mark,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackToJson(this);
}