import 'package:get/state_manager.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';

class SearchController extends GetxController {
  int selectedPosition = 0;
  List<Article> articleList = [];
  List<VideoArticle> videoArticleList = [];

  void updatePosition(value) {
    selectedPosition = value;
    update();
  }

  Future<void> fetchSearchData(searchWord) async {
    var apiResponse = await fetchSearchResults(searchWord);
    articleList = List.from(apiResponse['articles'])
        .map((e) => Article.fromJson(e))
        .toList();

    videoArticleList = List.from(apiResponse['video_articles'])
        .map((e) => VideoArticle.fromJson(e))
        .toList();

    update();
  }
}
