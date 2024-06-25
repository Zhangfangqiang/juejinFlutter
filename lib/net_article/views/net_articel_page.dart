import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'article_content.dart';

/**
 * 无状态的组件
 */
class NetArticlePage extends StatelessWidget {
  const NetArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网络请求测试'),
      ),
      body: ArticleContent(),
    );
  }
}
