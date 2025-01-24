import 'package:json_annotation/json_annotation.dart';
import 'author.dart';
import 'attachment.dart';
import 'feedback_mark.dart';
import 'client_info.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  final String id;
  final String content;
  final String status;
  final Author author;
  final List<Attachment>? attachments;
  @JsonKey(defaultValue: false)
  final bool isPinned;
  @JsonKey(defaultValue: 0)
  final int commentCount;
  @JsonKey(defaultValue: 0)
  final int readCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ClientInfo? clientInfo;
  final FeedbackMark? mark;

  const Feedback({
    required this.id,
    required this.content,
    required this.status,
    required this.author,
    this.attachments,
    this.isPinned = false,
    this.commentCount = 0,
    this.readCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.clientInfo,
    this.mark,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackToJson(this);
}