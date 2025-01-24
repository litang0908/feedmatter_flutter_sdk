import 'package:json_annotation/json_annotation.dart';

part 'comment_mark.g.dart';

@JsonSerializable()
class CommentMark {
  final bool? isAdmin; //是否管理员发布的评论
  final bool? isAdminReply; //是否管理员回复的评论

  const CommentMark({
    this.isAdmin,
    this.isAdminReply,
  });

  factory CommentMark.fromJson(Map<String, dynamic> json) =>
      _$CommentMarkFromJson(json);

  Map<String, dynamic> toJson() => _$CommentMarkToJson(this);
}
