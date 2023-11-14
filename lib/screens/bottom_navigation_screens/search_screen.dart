import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:anekapanduan/components/articles/article_card_two.dart';
import 'package:anekapanduan/controller/app_ad_controller.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/screens/search_result_screen.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Article> userRecommendations = [];
  BannerAd? smallBannedAd;
  AppAdController adController = Get.put(AppAdController());
  Future<void> getUserRecommendedArticles() async {
    userRecommendations =
        await fetchUserIntrestArticles(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<void> getAdInfo() async {
    var apiResponse = await fetchAdInfo();

    if (apiResponse['status_code'] == 0) {
      if (apiResponse['ad_enabled'] == '1') {
        String bannedAdId = Platform.isAndroid
            ? apiResponse['android_banner_ad_id']
            : apiResponse['ios_banner_ad_id'];
        loadSmallBannerAd(bannedAdId);
      }
    }
  }

  void loadSmallBannerAd(adUnitId) {
    smallBannedAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          adController.isSearchScreenBannerAdLoaded.value = true;
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
  void initState() {
    FirebaseAuth.instance.currentUser != null
        ? getUserRecommendedArticles()
        : '';
    getAdInfo();
    super.initState();
  }

  @override
  void dispose() {
    smallBannedAd?.dispose();
    Get.delete<AppAdController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.search,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              getVerticalSpace(15),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SearchResultScreen(searchWord: value),
                            ));
                      }
                    },
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!
                            .search_articles_videos,
                        fillColor: Colors.grey,
                        border: InputBorder.none),
                  ),
                ),
              ),
              getVerticalSpace(20),
              FirebaseAuth.instance.currentUser != null
                  ? Text(
                      AppLocalizations.of(context)!.recommended_for_you,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  : const SizedBox(),
              getVerticalSpace(10),
              FirebaseAuth.instance.currentUser != null
                  ? SizedBox(
                      height: 270,
                      child: FutureBuilder(
                        future: getUserRecommendedArticles(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          } else if (snapshot.hasError) {
                            return const SizedBox();
                          } else {
                            return ListView.builder(
                              itemCount: userRecommendations.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => ArticleCardTwo(
                                article: userRecommendations[index],
                              ),
                            );
                          }
                        },
                      ),
                    )
                  : const SizedBox(),
              Obx(() {
                if (adController.isSearchScreenBannerAdLoaded.value &&
                    smallBannedAd != null) {
                  return Center(
                    child: SizedBox(
                      height: smallBannedAd!.size.height.toDouble(),
                      width: smallBannedAd!.size.width.toDouble(),
                      child: AdWidget(ad: smallBannedAd!),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              })
            ],
          ),
        ),
      ),
    ));
  }
}
