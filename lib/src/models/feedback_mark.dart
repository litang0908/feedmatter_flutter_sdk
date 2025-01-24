import 'package:json_annotation/json_annotation.dart';

part 'feedback_mark.g.dart';

@JsonSerializable()
class FeedbackMark {
  final bool? isAdmin; //是否管理员发布的反馈
  final bool? isAdminReply; //是否管理员回复的评论

  const FeedbackMark({
    this.isAdmin,
    this.isAdminReply,
  });

  factory FeedbackMark.fromJson(Map<String, dynamic> json) =>
      _$FeedbackMarkFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackMarkToJson(this);
}
