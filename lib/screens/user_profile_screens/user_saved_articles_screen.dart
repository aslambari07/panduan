import 'package:flutter/material.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/components/articles/article_card_three.dart';
import 'package:anekapanduan/components/articles/articles_shimmer.dart';
import 'package:anekapanduan/components/neews_back_button.dart';
import 'package:anekapanduan/components/video_articles/video_article_card.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSavedArticlesScreen extends StatelessWidget {
  const UserSavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerticalSpace(20),
                  const NeewsBackButton(),
                  Text(
                    'Saved Articles',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TabBar(
                      labelColor: primaryColor,
                      indicatorColor: primaryColor,
                      unselectedLabelColor: greyColor,
                      tabs: [
                        Tab(
                          text: AppLocalizations.of(context)!.article,
                        ),
                        Tab(
                          text: AppLocalizations.of(context)!.video,
                        )
                      ]),
                  const Expanded(
                      child: TabBarView(children: [
                    SavedArticlesScreen(),
                    SavedVideoArticlesScreen()
                  ]))
                ],
              ),
            ),
          ),
        ));
  }
}

class SavedArticlesScreen extends StatefulWidget {
  const SavedArticlesScreen({super.key});

  @override
  State<SavedArticlesScreen> createState() => _SavedArticlesScreenState();
}

class _SavedArticlesScreenState extends State<SavedArticlesScreen> {
  List<Article> savedArticles = [];
  Future<void> getUserSavedArticles() async {
    var apiResponse = await fetchUserSavedArticles();
    if (apiResponse['status_code'] == 0) {
      savedArticles = List.from(apiResponse['articles'])
          .map((e) => Article.fromJson(e))
          .toList();
    }
  }

  @override
  void initState() {
    getUserSavedArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserSavedArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => const ArticleCardThreeShimmer(),
          );
        } else if (snapshot.hasError) {
          return ApiResultWidget(
              title: AppLocalizations.of(context)!.some_error_occurred,
              image: errorIllustration);
        } else {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 20),
            itemCount: savedArticles.length,
            itemBuilder: (context, index) => ArticleCardThree(
              article: savedArticles[index],
            ),
          );
        }
      },
    );
  }
}

class SavedVideoArticlesScreen extends StatefulWidget {
  const SavedVideoArticlesScreen({super.key});

  @override
  State<SavedVideoArticlesScreen> createState() =>
      _SavedVideoArticlesScreenState();
}

class _SavedVideoArticlesScreenState extends State<SavedVideoArticlesScreen> {
  List<VideoArticle> savedVideoArticles = [];
  Future<void> getUserSavedVideoArticles() async {
    var apiResponse = await fetchUserSavedVideoArticles();
    if (apiResponse['status_code'] == 0) {
      savedVideoArticles = List.from(apiResponse['video_articles'])
          .map((e) => VideoArticle.fromJson(e))
          .toList();
    }
  }

  @override
  void initState() {
    getUserSavedVideoArticles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserSavedVideoArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => const ArticleCardThreeShimmer(),
          );
        } else if (snapshot.hasError) {
          return ApiResultWidget(
              title: AppLocalizations.of(context)!.some_error_occurred,
              image: errorIllustration);
        } else {
          return ListView.builder(
            itemCount: savedVideoArticles.length,
            itemBuilder: (context, index) => VideoArticleCard(
                videoArticle: savedVideoArticles[index], onPressed: () {}),
          );
        }
      },
    );
  }
}
