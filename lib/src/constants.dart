/// 评论排序方式
class CommentSort {
  /// 按创建时间降序（默认）
  static const String createdDesc = 'created_desc';
  
  /// 按创建时间升序
  static const String createdAsc = 'created_asc';
  
  /// 按回复数降序
  static const String replyDesc = 'reply_desc';
} 

class AttachmentConstants {

  //目前写死，服务器限制了上传文件最大为10M
  static const int maxUploadFileSize = 10 * 1024 * 1024;

  /// 附件最大数量
  static const int maxAttachments = 10;

  /// 附件最大图片数量
  static const int maxImages = 8;
}
