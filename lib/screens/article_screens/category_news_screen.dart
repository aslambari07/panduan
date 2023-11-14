import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/components/articles/article_card_four.dart';
import 'package:anekapanduan/components/articles/article_card_three.dart';
import 'package:anekapanduan/components/articles/articles_shimmer.dart';
import 'package:anekapanduan/controller/category_news_ad_controller.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/model/categories.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryArticleScreen extends StatefulWidget {
  final Category category;
  const CategoryArticleScreen({super.key, required this.category});

  @override
  State<CategoryArticleScreen> createState() => _CategoryArticleScreenState();
}

class _CategoryArticleScreenState extends State<CategoryArticleScreen> {
  List<Article> articleList = [];
  BannerAd? mediumBannerAdOne;

  Future<void> getArticles() async {
    articleList = await fetchCategoryArticle(widget.category.id, '0');
  }

  Future<void> getAdInfo() async {
    var apiResponse = await fetchAdInfo();

    if (apiResponse['status_code'] == 0) {
      if (apiResponse['ad_enabled'] == '1') {
        String bannedAdId = Platform.isAndroid
            ? apiResponse['android_banner_ad_id']
            : apiResponse['ios_banner_ad_id'];
        loadMediumAdOne(bannedAdId);
      }
    }
  }

  final CategoryNewsAdController categoryNewsAdController =
      Get.put(CategoryNewsAdController());

  void loadMediumAdOne(adUnitId) {
    mediumBannerAdOne = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          categoryNewsAdController.updateMediumAdLoading(true);
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('Medium BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    mediumBannerAdOne?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getArticles();
    getAdInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalSpace(20),
            InkWell(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(backBtnIcon)),
            getVerticalSpace(20),
            Text(
              widget.category.categoryName,
              style: headlineOneTextStyle.copyWith(color: primaryColor),
            ),
            GetBuilder<CategoryNewsAdController>(
              builder: (controller) {
                if (controller.isMediumAdLoaded && mediumBannerAdOne != null) {
                  return Center(
                    child: SizedBox(
                      height: mediumBannerAdOne!.size.height.toDouble(),
                      width: mediumBannerAdOne!.size.width.toDouble(),
                      child: AdWidget(ad: mediumBannerAdOne!),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            getVerticalSpace(20),
            Expanded(
                child: FutureBuilder(
              future: getArticles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) =>
                        const ArticleCardThreeShimmer(),
                  );
                } else if (snapshot.hasError) {
                  return ApiResultWidget(
                      title: AppLocalizations.of(context)!.error_occurred,
                      image: errorIllustration);
                } else {
                  return ListView.builder(
                      itemCount: articleList.length,
                      itemBuilder: (context, index) =>
                          articleList[index].isBreaking == '1'
                              ? ArticleCardFour(
                                  article: articleList[index],
                                )
                              : ArticleCardThree(
                                  article: articleList[index],
                                ));
                }
              },
            ))
          ],
        ),
      )),
    );
  }
}
