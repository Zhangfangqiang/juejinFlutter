import 'package:dio/dio.dart';

import '../model/article.dart';

class ArticleApi {
  /**
   * 请求uri声明
   */
  static const String kBaseUrl = 'https://www.wanandroid.com';

  /**
   * 请求客户端声明
   */
  final Dio _client = Dio(BaseOptions(baseUrl: kBaseUrl));


  /**
   * 加载文章请求方法
   */
  Future<List<Article>> loadArticles(int page) async {
    var rep = await _client.get('/article/list/$page/json');

    if (rep.statusCode == 200) {
      if (rep.data != null) {
        var data = rep.data['data']['datas'] as List;
        return data.map(Article.formMap).toList();
      }
    }

    return [];
  }
}
