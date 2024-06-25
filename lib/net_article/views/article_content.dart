import 'dart:async';
import '../model/article.dart';
import 'article_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_refresh/easy_refresh.dart';                      //上拉加载,下拉刷新
import 'package:juejinflutter/net_article/api/article_api.dart';      //网络请求


/**
 * 有状态的组件
 */
class ArticleContent extends StatefulWidget {
  const ArticleContent({Key? key}) : super(key: key);
  @override
  State<ArticleContent> createState() => _ArticleContentState();
}
class _ArticleContentState extends State<ArticleContent> {
  bool _loading = false;
  ArticleApi api = ArticleApi();
  List<Article> _articles = [];     //文章列表


  /**
   * 生命周期init 方法
   */
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /**
   * 初始化加载数据
   */
  void _loadData() async {
    _loading = true;
    setState(() {});

    _articles = await api.loadArticles(0);

    _loading = false;
    setState(() {});
  }

  /**
   * 下拉刷新数据
   */
  void _onRefresh() async{
    _articles = await api.loadArticles(0);
    setState(() {});
  }

  /**
   * 加载新的数据
   */
  void _onLoad() async{
    int nextPage              = _articles.length ~/ 20;           //除以整数的部分,获取页面
    List<Article> newArticles = await api.loadArticles(nextPage); //请求页码
    _articles                 = _articles + newArticles;          //dart 通过 加号 合并数据
    setState(() {});
  }

  /**
   * 通过路由跳转到文章详情页面
   */
  void _jumpToPage(Article article) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ArticleDetailPage(article: article),
      ),
    );
  }


  Widget _buildItemByIndex(BuildContext context, int index) {
    return ArticleItem(
      article: _articles[index],
      onTap: _jumpToPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    /*如果是加载中开始*/
    if(_loading){
      return Center(
        child: Wrap(
          spacing: 10,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            CupertinoActivityIndicator(),
            Text("数据加载中，请稍后...",style: TextStyle(color: Colors.grey),)
          ],
        ),
      );
    }
    /*如果是加载中结束*/

    /*简单上拉加载,下拉刷新开始*/
    return EasyRefresh(
      header: const ClassicHeader(
        dragText: "下拉加载",
        armedText: "释放刷新",
        readyText: "开始加载",
        processingText: "正在加载",
        processedText: "刷新成功",
      ),
      footer:const ClassicFooter(
          processingText: "正在加载"
      ),
      onRefresh: _onRefresh,
      onLoad: _onLoad,
      child: ListView.builder(
        itemExtent: 80,                 //每个列表项的高度都固定为80个逻辑像素单位
        itemCount: _articles.length,    //数据长度
        itemBuilder: _buildItemByIndex, //数据索引
      ),
    );
    /*简单上拉加载,下拉刷新结束*/

  }
}

/**
 * 无状态的组件 文章item
 */
class ArticleItem extends StatelessWidget {
  final Article article;              //文章详情item数据
  final ValueChanged<Article> onTap;  //文章跳转到详情页的方法

  /**
   * 构造方法
   */
  const ArticleItem({Key? key, required this.article, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*手势识别开始*/
    return GestureDetector(
      onTap: () => onTap(article),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  /*文字标题开始*/
                  Expanded(
                    child: Text(
                      article.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  /*文字标题结束*/

                  const SizedBox(width: 10),

                  /*文章时间开始*/
                  Text(
                    article.time,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  /*文章时间结束*/
                ],
              ),
              const SizedBox(
                height: 4,
              ),

              /*文章链接开始*/
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    article.url,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              /*文章链接结束*/

            ],
          ),
        ),
      ),
    );
    /*手势识别结束*/
  }
}
