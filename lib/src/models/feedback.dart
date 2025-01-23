import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  final String id;
  final String content;
  final String status;
  final bool pinned;
  final int commentCount;
  final String createdAt;
  final Map<String, dynamic>? clientInfo;
  final Map<String, dynamic>? customInfo;
  final Map<String, dynamic>? mark;

  const Feedback({
    required this.id,
    required this.content,
    required this.status,
    required this.pinned,
    required this.commentCount,
    required this.createdAt,
    this.clientInfo,
    this.customInfo,
    this.mark,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackToJson(this);
} 