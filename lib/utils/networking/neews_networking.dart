import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/model/categories.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/utils/networking/networking_api.dart';
import 'package:anekapanduan/utils/shared_prefs.dart';

Future<String> registerUser(String uId, name, email, password, language,
    signUpVia, verified, signedIn) async {
  http.Response response = await http.post(Uri.parse(registerUserApi), body: {
    'uId': uId,
    'user_name': name,
    'email': email,
    'password': password,
    'language': language,
    'verified': verified,
    'sign_up_via': signUpVia,
    'signed_in': signedIn
  });

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);
    int apiStatusCode = apiResponse['status_code'];
    if (apiStatusCode == 0) {
      return 'user-registered-successfully';
    } else if (apiStatusCode == 1) {
      return 'user-already-exist';
    } else {
      return apiResponse['message'];
    }
  } else {
    return 'Internal error occurred';
  }
}

Future<String> updateUserVerification(String uId) async {
  http.Response response =
      await http.post(Uri.parse(updateUserVerificationApi), body: {'uId': uId});

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);

    if (apiResponse['status_code'] == 0) {
      return 'user-verified-successfully';
    } else {
      return 'some-error-occurred';
    }
  } else {
    return 'Internal error occurred';
  }
}

Future<List<Category>> getArticleCategories() async {
  List<Category> categories = [];
  http.Response response = await http.post(Uri.parse(getCategoriesApi),
      body: {'language': AppSharedPrefs.getAppLocale()});

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);

    if (apiResponse['status_code'] == 0) {
      categories = List.from(apiResponse['categories'])
          .map((category) => Category.fromJson(category))
          .toList();
    }
  }
  return categories;
}

Future<String> addUserIntrest(String categoryName, categoryId) async {
  http.Response response = await http.post(Uri.parse(addUserIntrestApi), body: {
    'uId': FirebaseAuth.instance.currentUser!.uid,
    'categoryName': categoryName,
    'categoryId': categoryId
  });

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);

    if (apiResponse['status_code'] == 0) {
      return 'intrest-added-successfully';
    } else {
      return 'some-error-occurred';
    }
  } else {
    return 'Internal error occurred';
  }
}

Future<List<Article>> fetchTrendingArticles() async {
  List<Article> trendingArticles = [];
  http.Response response = await http.post(Uri.parse(getTrendingArticleApi),
      body: {'language': AppSharedPrefs.getAppLocale()});

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);

    if (apiResponse['status_code'] == 0) {
      trendingArticles = List.from(apiResponse['trending_articles'])
          .map((article) => Article.fromJson(article))
          .toList();
    }
  }

  return trendingArticles;
}

Future<List<Article>> fetchBreakingArticles() async {
  List<Article> trendingArticles = [];
  http.Response response = await http.post(Uri.parse(getBreakingArticleApi),
      body: {'language': AppSharedPrefs.getAppLocale()});

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);

    if (apiResponse['status_code'] == 0) {
      trendingArticles = List.from(apiResponse['breaking_articles'])
          .map((article) => Article.fromJson(article))
          .toList();
    }
  }

  return trendingArticles;
}

Future<List<Article>> fetchCategoryArticle(String categoryId, var limit) async {
  List<Article> articles = [];
  http.Response response = await http.post(Uri.parse(getCategoryArticleApi),
      body: {'category_id': categoryId, 'limit': limit});

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);
    if (apiResponse['status_code'] == 0) {
      articles = List.from(apiResponse['articles'])
          .map((article) => Article.fromJson(article))
          .toList();
    }
  }

  return articles;
}

Future<List<Article>> fetchUserIntrestArticles(String uId) async {
  List<Article> articles = [];
  http.Response response = await http.post(Uri.parse(getUserIntrestArticleApi),
      body: {'uId': uId, 'language': AppSharedPrefs.getAppLocale()});
  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);

    if (apiResponse['status_code'] == 0) {
      articles = List.from(apiResponse['user_intrest_articles'])
          .map((article) => Article.fromJson(article))
          .toList();
    }
  }

  return articles;
}

Future<dynamic> fetchArticle(articleId) async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  http.Response response = await http.post(Uri.parse(getArticleApi), body: {
    'article_id': articleId,
    'uId': firebaseAuth.currentUser != null ? firebaseAuth.currentUser!.uid : ''
  });

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'Internal error occurred';
  }
}

Future<int> refreshArticleLike(articleId) async {
  http.Response response = await http.post(Uri.parse(updateLikeApi), body: {
    'uId': FirebaseAuth.instance.currentUser!.uid,
    'article_id': articleId
  });

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);
    if (apiResponse['status_code'] == 0) {
      return apiResponse['status_code'];
    } else {
      return apiResponse['status_code'];
    }
  } else {
    return 404;
  }
}

Future<int> refreshArticleSave(articleId) async {
  http.Response response = await http.post(Uri.parse(updateSaveApi), body: {
    'uId': FirebaseAuth.instance.currentUser!.uid,
    'article_id': articleId
  });

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);
    if (apiResponse['status_code'] == 0) {
      return apiResponse['status_code'];
    } else {
      return apiResponse['status_code'];
    }
  } else {
    return 404;
  }
}

Future<List<VideoArticle>> fetchVideoArticle() async {
  List<VideoArticle> videoArticles = [];

  http.Response response = await http.get(Uri.parse(getVideoArticleApi));

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);

    if (apiResponse['status_code'] == 0) {
      videoArticles = List.from(apiResponse['video_articles'])
          .map((videoArticle) => VideoArticle.fromJson(videoArticle))
          .toList();
    }
  }

  return videoArticles;
}

Future<String> updateArticleView(String uId, articleId) async {
  http.Response response = await http.post(Uri.parse(updateArticleViewApi),
      body: {'uId': uId, 'article_id': articleId});

  if (response.statusCode == 200) {
    var apiResponse = jsonDecode(response.body);
    if (apiResponse['status_code'] == 0) {
      return 'view-updated-successfully';
    } else if (apiResponse['status_code'] == 1) {
      return 'already-viewed';
    } else {
      return 'some-error-occurred';
    }
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchVideoArticleInfo(videoArticleId) async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  http.Response response =
      await http.post(Uri.parse(getVideoArticleInfoApi), body: {
    'uId':
        firebaseAuth.currentUser != null ? firebaseAuth.currentUser!.uid : '',
    'video_article_id': videoArticleId
  });

  if (response.statusCode == 200) {
    return response.body;
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchSearchResults(keyword) async {
  http.Response response = await http.post(Uri.parse(searchApi),
      body: {'keyword': keyword, 'language': AppSharedPrefs.getAppLocale()});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchVideoSearchResults(keyword) async {
  http.Response response =
      await http.post(Uri.parse(searchVideoApi), body: {'keyword': keyword});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchUserSavedArticles() async {
  http.Response response = await http.post(Uri.parse(getUserSavedArticlesApi),
      body: {'uId': FirebaseAuth.instance.currentUser!.uid});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchUserSavedVideoArticles() async {
  http.Response response = await http.post(
      Uri.parse(getUserSavedVideoArticlesApi),
      body: {'uId': FirebaseAuth.instance.currentUser!.uid});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchUserPrefences() async {
  http.Response response = await http.post(Uri.parse(getUserPrefencesApi),
      body: {'uId': FirebaseAuth.instance.currentUser!.uid});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occrred';
  }
}

Future<dynamic> deleteUserPrefences(id) async {
  http.Response response = await http.post(Uri.parse(deleteUserPrefencesApi),
      body: {'uId': FirebaseAuth.instance.currentUser!.uid, 'id': id});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchPrefences() async {
  http.Response response = await http.post(Uri.parse(getPrefencesApi),
      body: {'uId': FirebaseAuth.instance.currentUser!.uid});
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchAppInformation() async {
  http.Response response = await http.get(Uri.parse(getAppInformationApi));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchUserInfo() async {
  http.Response response = await http.post(Uri.parse(getUSerInfoApi),
      body: {'uId': FirebaseAuth.instance.currentUser!.uid});

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchAdInfo() async {
  http.Response response = await http.get(Uri.parse(getAdInfoApi));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchCurrentDate() async {
  http.Response response = await http.get(Uri.parse(getCurrentDateApi));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> fetchAppNotifications() async {
  http.Response response = await http.get(Uri.parse(getAppNotificationsApi));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}

Future<dynamic> updateUserData(String field, data) async {
  http.Response response = await http.post(Uri.parse(updateUserDataApi), body: {
    'uId': FirebaseAuth.instance.currentUser!.uid,
    'field': field,
    'data': data
  });

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return 'internal-error-occurred';
  }
}
