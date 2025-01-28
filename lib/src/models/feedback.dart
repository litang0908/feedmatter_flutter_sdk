import 'package:json_annotation/json_annotation.dart';
import 'author.dart';
import 'attachment.dart';
import 'feedback_mark.dart';
import 'client_info.dart';
import '../enums/feedback_status.dart';
import '../enums/feedback_type.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  final String id;
  final String content;
  @JsonKey(unknownEnumValue: FeedbackStatus.pending)
  final FeedbackStatus status;
  @JsonKey(unknownEnumValue: FeedbackType.other)
  final FeedbackType? type;
  final Author author;
  @JsonKey(name: 'isPinned', defaultValue: false)
  final bool isPinned;
  @JsonKey(defaultValue: 0)
  final int readCount;
  @JsonKey(defaultValue: 0)
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final bool allowComment;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ClientInfo? clientInfo;
  final Map<String, dynamic>? customInfo;
  final FeedbackMark? mark;
  final List<Attachment>? attachments;

  const Feedback({
    required this.id,
    required this.content,
    required this.status,
    this.type,
    required this.author,
    this.isPinned = false,
    this.readCount = 0,
    this.commentCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.allowComment = true,
    required this.createdAt,
    required this.updatedAt,
    this.clientInfo,
    this.customInfo,
    this.mark,
    this.attachments,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackToJson(this);
}