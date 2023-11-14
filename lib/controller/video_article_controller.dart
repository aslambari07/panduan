import 'dart:convert';
import 'package:get/state_manager.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:http/http.dart' as http;
import 'package:anekapanduan/utils/networking/networking_api.dart';

class VideoArticleController extends GetxController {
  String videoLikes = '';
  String videoSaves = '';
  int isLiked = 0;
  int isSaved = 0;

  bool isSmallBannerAdLoaded = false;

  Future<void> getVideoArticleInfo(videoArticleId) async {
    VideoArticle videoArticle;
    var apiResponse = await fetchVideoArticleInfo(videoArticleId);
    var video = jsonDecode(apiResponse);

    if (video['status_code'] == 0) {
      videoArticle = VideoArticle.fromJson(video['video_articles']);
      videoLikes = videoArticle.likes;
      isLiked = video['is_liked'];
      isSaved = video['is_saved'];
      update();
    }
  }

  Future<void> updateVideLike(uId, videoArticleId) async {
    http.Response response = await http.post(Uri.parse(updateVideoLikeApi),
        body: {'uId': uId, 'video_article_id': videoArticleId});

    if (response.statusCode == 200) {
      var apiResponse = jsonDecode(response.body);

      if (apiResponse['status_code'] == 0) {
        getVideoArticleInfo(videoArticleId);
      }
    }
  }

  Future<void> updateVideoSave(uId, videoArticleId) async {
    http.Response response = await http.post(Uri.parse(updateVideoSaveApi),
        body: {'uId': uId, 'video_article_id': videoArticleId});

    if (response.statusCode == 200) {
      var apiResponse = jsonDecode(response.body);
      if (apiResponse['status_code'] == 0) {
        getVideoArticleInfo(videoArticleId);
      }
    }
  }
}
