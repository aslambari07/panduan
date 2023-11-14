import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:anekapanduan/components/articles/article_card_three.dart';
import 'package:anekapanduan/components/video_articles/video_article_card.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/screens/video_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:anekapanduan/utils/spacer.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchWord;
  const SearchResultScreen({super.key, required this.searchWord});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  SearchController searchController = Get.put(SearchController());

  @override
  void initState() {
    super.initState();
  }

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
            Text(
              AppLocalizations.of(context)!.search_result_for,
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              widget.searchWord,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 28),
            ),
            getVerticalSpace(10),
            TabBar(
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey[500],
                indicatorColor: primaryColor,
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.article,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.video,
                  ),
                ]),
            getVerticalSpace(20),
            Expanded(
                child: TabBarView(children: [
              SearchArticleResult(searchWord: widget.searchWord),
              SearchVideoArticleResult(searchWord: widget.searchWord)
            ]))
          ],
        ),
      ))),
    );
  }
}

class SearchArticleResult extends StatefulWidget {
  final String searchWord;
  const SearchArticleResult({super.key, required this.searchWord});

  @override
  State<SearchArticleResult> createState() => _SearchArticleResultState();
}

class _SearchArticleResultState extends State<SearchArticleResult> {
  List<Article> articleList = [];
  Future<void> getArticleSearchResults() async {
    var apiResponse = await fetchSearchResults(widget.searchWord);
    if (apiResponse['status_code'] == 0) {
      articleList = List.from(apiResponse['articles'])
          .map((e) => Article.fromJson(e))
          .toList();
    }
  }

  @override
  void initState() {
    getArticleSearchResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getArticleSearchResults(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ApiResultWidget(
              title: 'Searching', image: searchingIllustration);
        } else if (snapshot.hasError) {
          return ApiResultWidget(
              title: AppLocalizations.of(context)!.some_error_occurred,
              image: errorIllustration);
        } else {
          return articleList.isNotEmpty
              ? ListView.builder(
                  itemCount: articleList.length,
                  itemBuilder: (context, index) => ArticleCardThree(
                    article: articleList[index],
                  ),
                )
              : ApiResultWidget(
                  title: AppLocalizations.of(context)!.no_articles_found,
                  image: emptyIllustration,
                );
        }
      },
    );
  }
}

class SearchVideoArticleResult extends StatefulWidget {
  final String searchWord;
  const SearchVideoArticleResult({super.key, required this.searchWord});

  @override
  State<SearchVideoArticleResult> createState() =>
      _SearchVideoArticleResultState();
}

class _SearchVideoArticleResultState extends State<SearchVideoArticleResult> {
  List<VideoArticle> videoArticlesList = [];
  Future<void> getVideoArticlesSearchResults() async {
    var apiResponse = await fetchVideoSearchResults(widget.searchWord);

    if (apiResponse['status_code'] == 0) {
      videoArticlesList = List.from(apiResponse['video_articles'])
          .map((e) => VideoArticle.fromJson(e))
          .toList();
    }
  }

  @override
  void initState() {
    getVideoArticlesSearchResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getVideoArticlesSearchResults(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ApiResultWidget(
              title: 'Searching', image: searchingIllustration);
        } else if (snapshot.hasError) {
          return ApiResultWidget(
              title: AppLocalizations.of(context)!.some_error_occurred,
              image: errorIllustration);
        } else {
          return videoArticlesList.isNotEmpty
              ? ListView.builder(
                  itemCount: videoArticlesList.length,
                  itemBuilder: (context, index) => VideoArticleCard(
                        videoArticle: videoArticlesList[index],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoScreen(
                                    videoArticle: videoArticlesList[index]),
                              ));
                        },
                      ))
              : ApiResultWidget(
                  title: AppLocalizations.of(context)!.no_articles_found,
                  image: emptyIllustration,
                );
        }
      },
    );
  }
}
