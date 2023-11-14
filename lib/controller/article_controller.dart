import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/state_manager.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';

class ArticleController extends GetxController {
  var totalLikes = '';
  var totalViews = '';
  int isLiked = 0;
  int isSaved = 0;

  double titleFontSize = 28.0;
  double descriptionFontSize = 18.0;

  bool isLoading = true;
  var isSpeaking = false.obs;

  void increaseFontSize() {
    titleFontSize++;
    descriptionFontSize++;
    update();
  }

  void decreaseFontSize() {
    titleFontSize--;
    descriptionFontSize--;
    update();
  }

  final _fluttertts = FlutterTts();

  void initializeTts() async {
    _fluttertts.setStartHandler(() {
      isSpeaking.value = true;
      update();
    });
    _fluttertts.setCompletionHandler(() {
      isSpeaking.value = false;
      update();
    });
    _fluttertts.setErrorHandler((message) {
      isSpeaking.value = false;
      update();
      debugPrint(message);
    });

    await _fluttertts.setLanguage("en-IN");
    await _fluttertts.setSpeechRate(0.5);
    await _fluttertts.setPitch(1);
  }

  Future<void> getArticleDetails(articleId) async {
    var apiResponse = await fetchArticle(articleId);

    var response = jsonDecode(apiResponse);
    if (response['status_code'] == 0) {
      totalLikes = Article.fromJson(response['article']).likes;
      totalViews = Article.fromJson(response['article']).views;

      isLiked = response['is_liked'];
      isSaved = response['is_saved'];
      isLoading = false;
      update();
    }
  }

  void speakArticle(String article) async {
    await _fluttertts.speak(article);
    isSpeaking.value = true;
  }

  void stopArticle() async {
    isSpeaking.value = false;
    await _fluttertts.stop();
  }

  Future<void> updateLikes(articleId) async {
    var refreshLikeApiResponse = await refreshArticleLike(articleId);

    if (refreshLikeApiResponse == 0) {
      var apiResponse = await fetchArticle(articleId);
      var response = jsonDecode(apiResponse);

      if (response['status_code'] == 0) {
        totalLikes = Article.fromJson(response['article']).likes;
        isLiked = response['is_liked'];
        update();
      }
    }
  }

  Future<void> updateSaves(articleId) async {
    var refreshSaveApiResponse = await refreshArticleSave(articleId);

    if (refreshSaveApiResponse == 0) {
      var apiResponse = await fetchArticle(articleId);
      var response = jsonDecode(apiResponse);

      if (response['status_code'] == 0) {
        isSaved = response['is_saved'];
        update();
      }
    }
  }

  @override
  void onInit() {
    initializeTts();
    super.onInit();
  }

  @override
  void onClose() {
    _fluttertts.stop();
    super.onClose();
  }
}
