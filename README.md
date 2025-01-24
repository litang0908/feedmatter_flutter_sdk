<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# FeedMatter Flutter SDK

FeedMatter Flutter SDK 是一个用于快速集成用户反馈功能的工具包。它提供了一套简单易用的 API，帮助开发者在 Flutter 应用中实现反馈收集、评论互动等功能。

## 安装

将以下依赖添加到你的 `pubspec.yaml` 文件中：

```yaml
dependencies:
  feedmatter_flutter_sdk: ^1.0.0
```

然后运行：

```bash
flutter pub get
```

## 快速开始

### 1. 初始化 SDK

在使用 SDK 之前，需要先进行初始化。建议在应用启动时（比如在 `main.dart` 或首页的 `initState` 中）进行：

```dart
import 'package:feedmatter_flutter_sdk/feedmatter_flutter_sdk.dart' as feedmatter;

// 获取 SDK 实例
final client = feedmatter.FeedMatterClient.instance;

// 初始化配置
client.init(
  feedmatter.FeedMatterConfig(
    baseUrl: 'https://fmapi.litangkj.com',  // API 地址
    apiKey: 'your-api-key',                 // 项目 API Key
    timeout: 30,                            // 超时时间（秒）
    debug: true,                            // 是否开启调试模式
  ),
  feedmatter.FeedMatterUser(
    userId: 'user-id',                      // 用户 ID
    userName: 'User Name',                  // 用户名
    userAvatar: 'https://example.com/avatar.png',  // 用户头像（可选）
  ),
  onError: (error) {
    // 全局错误处理
    print('FeedMatter Error: $error');
  },
);
```

### 2. 提交反馈

```dart
try {
  final feedback = await client.createFeedback(
    '这是一条反馈内容',
    customInfo: {
      'source': 'home_page',  // 自定义信息（可选）
    },
  );
  print('反馈已提交: ${feedback.id}');
} catch (e) {
  print('提交反馈失败: $e');
}
```

### 3. 获取反馈列表

```dart
// 获取所有反馈
final feedbacks = await client.getFeedbacks(
  page: 0,    // 页码（从 0 开始）
  size: 20,   // 每页数量
);

// 获取用户自己的反馈
final myFeedbacks = await client.getMyFeedbacks(
  page: 0,
  size: 20,
);
```

### 4. 评论功能

```dart
// 添加评论
final comment = await client.createComment(
  'feedback-id',    // 反馈 ID
  '这是一条评论',    // 评论内容
);

// 获取评论列表
final comments = await client.getComments(
  'feedback-id',
  page: 0,
  size: 20,
);
```

## 文件上传

SDK 提供了安全的文件上传功能，包括以下特性：
- 文件大小限制（默认最大 10MB）
- 文件名安全处理
- 支持公开和私密两种上传方式

### 上传公开文件

公开文件上传后可以直接通过返回的 URL 访问：

```dart
try {
  final url = await client.uploadPublicFile(File('path/to/file.jpg'));
  print('文件已上传：$url');
} on FeedMatterApiException catch (e) {
  if (e.code == 'FILE_TOO_LARGE') {
    print('文件太大：${e.originalError}');
  } else if (e.code == 'FILE_NOT_FOUND') {
    print('文件不存在');
  }
  print('上传失败：${e.message}');
}
```

### 上传私密文件

私密文件需要通过签名 URL 访问：

```dart
try {
  // 1. 上传文件，获取文件 key
  final key = await client.uploadPrivateFile(File('path/to/private.pdf'));
  
  // 2. 使用 key 获取签名访问 URL
  final signedUrl = await client.getSignedUrl(key);
  print('文件访问链接：$signedUrl');
} catch (e) {
  print('操作失败：$e');
}
```

### 文件上传注意事项

1. 文件大小限制
   - 默认限制为 10MB
   - 超过限制会抛出 `FILE_TOO_LARGE` 错误

2. 文件名处理
   - SDK 会自动处理文件名，移除特殊字符
   - 如果处理后文件名为空，会生成带时间戳的随机文件名

3. 错误处理
   - `FILE_TOO_LARGE`: 文件超过大小限制
   - `FILE_NOT_FOUND`: 文件不存在
   - `NETWORK_ERROR`: 网络请求失败

4. 安全建议
   - 私密文件建议使用 `uploadPrivateFile`
   - 及时处理过期的签名 URL
   - 不要在客户端保存私密文件的 key

## 错误处理

SDK 定义了以下几种异常类型：

1. `FeedMatterConfigException`: 配置错误
   - 未初始化 SDK
   - 配置信息不完整

2. `FeedMatterAuthException`: 认证错误
   - API Key 无效
   - 权限不足

3. `FeedMatterApiException`: API 调用错误
   - 网络错误
   - 服务器错误
   - 请求参数错误

你可以通过以下两种方式处理错误：

1. 全局错误处理：
```dart
client.init(
  config,
  user,
  onError: (error) {
    if (error is FeedMatterAuthException) {
      // 处理认证错误
    } else if (error is FeedMatterApiException) {
      // 处理 API 错误
    }
  },
);
```

2. 局部错误处理：
```dart
try {
  await client.createFeedback('反馈内容');
} on FeedMatterAuthException catch (e) {
  // 处理认证错误
} on FeedMatterApiException catch (e) {
  // 处理 API 错误
}
```

## 最佳实践

1. 初始化时机
   - 建议在应用启动时进行初始化
   - 确保在使用 SDK 功能前完成初始化

2. 错误处理
   - 建议设置全局错误处理函数
   - 对重要操作使用局部错误处理
   - 在 UI 层展示友好的错误提示

3. 用户信息
   - 在用户登录后更新用户信息
   - 在用户登出时调用 `clearUser()`

4. 调试模式
   - 开发时开启 debug 模式查看详细日志
   - 生产环境建议关闭 debug 模式

## API 参考

### FeedMatterConfig

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| baseUrl | String | 是 | API 服务器地址 |
| apiKey | String | 是 | 项目 API Key |
| timeout | int | 否 | 请求超时时间（秒），默认 30 |
| debug | bool | 否 | 是否开启调试模式，默认 false |

### FeedMatterUser

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| userId | String | 是 | 用户唯一标识 |
| userName | String | 是 | 用户名称 |
| userAvatar | String | 否 | 用户头像 URL |

## 数据模型

### Feedback

反馈信息模型。

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 反馈 ID |
| content | String | 反馈内容 |
| status | String | 反馈状态（PENDING/OPEN/IN_PROGRESS/RESOLVED/CLOSED/DELETED） |
| author | Author | 作者信息 |
| attachments | List<Attachment>? | 附件列表 |
| isPinned | bool | 是否置顶 |
| commentCount | int | 评论数量 |
| readCount | int | 阅读数量 |
| createdAt | DateTime | 创建时间 |
| updatedAt | DateTime | 更新时间 |
| clientInfo | Map<String, dynamic>? | 客户端信息（设备、系统、应用版本等） |
| customInfo | Map<String, dynamic>? | 自定义信息（由开发者定义） |
| mark | FeedbackMark? | 标记信息 |

### Comment

评论信息模型。

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 评论 ID |
| content | String | 评论内容 |
| author | Author | 作者信息 |
| parentId | String? | 父评论 ID（用于回复） |
| isPinned | bool | 是否置顶 |
| replyCount | int | 回复数量 |
| createdAt | DateTime | 创建时间 |
| updatedAt | DateTime | 更新时间 |
| status | String | 评论状态 |
| mark | CommentMark? | 标记信息 |

### Author

用户信息模型。

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 用户 ID |
| username | String | 用户名 |
| avatar | String? | 头像 URL |

### Attachment

附件信息模型。

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 附件 ID |
| fileName | String | 文件名 |
| fileUrl | String | 文件 URL |
| fileType | String | 文件类型 |
| createdAt | DateTime | 创建时间 |

### FeedbackMark

反馈标记信息模型。

| 字段 | 类型 | 说明 |
|------|------|------|
| isAdmin | bool | 是否管理员发布的反馈 |

### CommentMark

评论标记信息模型。

| 字段 | 类型 | 说明 |
|------|------|------|
| isAdminReply | bool | 是否管理员回复 |

## 状态码说明

### 反馈状态（FeedbackStatus）

| 状态 | 说明 |
|------|------|
| PENDING | 审核中 |
| OPEN | 已公开 |
| IN_PROGRESS | 处理中 |
| RESOLVED | 已解决 |
| CLOSED | 已关闭 |
| DELETED | 已删除 |

### 错误码

| 错误码 | 说明 |
|--------|------|
| CONFIG_NOT_SET | 配置未设置 |
| INVALID_API_KEY | API Key 无效 |
| FORBIDDEN | 没有权限 |
| NOT_FOUND | 资源不存在 |
| NETWORK_ERROR | 网络错误 |
| SERVER_ERROR | 服务器错误 |
| BAD_REQUEST | 请求参数错误 |
| RATE_LIMIT_EXCEEDED | 请求频率超限 |

## 示例项目

完整的示例项目请参考 [example](example) 目录。

## 许可证

MIT License
