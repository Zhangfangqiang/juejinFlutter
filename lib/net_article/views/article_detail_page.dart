import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:juejinflutter/net_article/model/article.dart';

/**
 * 有状态的组件
 */
class ArticleDetailPage extends StatefulWidget {
  final Article article;
  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);
  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)    //禁用javascript
      ..setBackgroundColor(const Color(0x00000000))       //设置背景颜色
      ..loadRequest(Uri.parse(widget.article.url));       //设置连接地址
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article.title)),
      body: WebViewWidget(controller: controller),      //webView组件,传入配置好的controller变量
    );
  }
}
