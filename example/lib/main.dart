import 'package:feedmatter_flutter_sdk/feedmatter_flutter_sdk.dart' as feedmatter;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FeedMatter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _feedbackController = TextEditingController();
  late feedmatter.FeedMatterClient client;
  List<feedmatter.Feedback> _feedbacks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 初始化 SDK
    client = feedmatter.FeedMatterClient(const feedmatter.FeedMatterConfig(
      baseUrl: 'https://fmapi.feedmatter.com',
      apiKey: 'your-api-key',
      debug: true,
    ));

    // 设置用户信息
    client.setUser(
      userId: 'test-user-id',
      username: 'Test User',
      avatar: 'https://example.com/avatar.png',
    );

    // 加载反馈列表
    _loadFeedbacks();
  }

  Future<void> _loadFeedbacks() async {
    try {
      // 获取所有反馈
      final feedbacks = await client.getFeedbacks();
      print('All feedbacks: $feedbacks');

      // 获取用户自己的反馈
      final myFeedbacks = await client.getMyFeedbacks();
      print('My feedbacks: $myFeedbacks');

      setState(() {
        _feedbacks = feedbacks;
      });
    } catch (e) {
      print('Error loading feedbacks: $e');
    }
  }

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      _showError('请输入反馈内容');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await client.submitFeedback(
        _feedbackController.text,
        customInfo: {'source': 'example_app'},
      );
      _feedbackController.clear();
      await _loadFeedbacks();  // 重新加载列表
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('反馈提交成功')),
        );
      }
    } catch (e) {
      _showError('提交反馈失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FeedMatter Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadFeedbacks,
          ),
        ],
      ),
      body: Column(
        children: [
          // 提交反馈区域
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(
                      hintText: '请输入反馈内容...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitFeedback,
                  child: const Text('提交'),
                ),
              ],
            ),
          ),

          // 反馈列表
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _feedbacks.length,
                    itemBuilder: (context, index) {
                      final feedback = _feedbacks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(feedback.content),
                          subtitle: Text(
                            '状态: ${feedback.status} · ${feedback.commentCount} 条评论',
                          ),
                          trailing: Text(feedback.createdAt),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
} 