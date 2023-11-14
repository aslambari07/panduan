import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:anekapanduan/components/video_articles/slide_video_player.dart';
import 'package:anekapanduan/controller/app_ad_controller.dart';
import 'package:anekapanduan/controller/video_article_controller.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoNewsScreen extends StatefulWidget {
  const VideoNewsScreen({super.key});

  @override
  State<VideoNewsScreen> createState() => _VideoNewsScreenState();
}

class _VideoNewsScreenState extends State<VideoNewsScreen> {
  BannerAd? smallBannerAd;
  List<VideoArticle> videoArticles = [];
  VideoArticleController videoArticleController =
      Get.put(VideoArticleController());
  Future<void> getVideoArticles() async {
    videoArticles = await fetchVideoArticle();
  }

  final AppAdController adController = Get.put(AppAdController());

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
    smallBannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          adController.isVideoNewsScreenSmallBannerAdLoaded.value = true;
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
    getVideoArticles();
    getAdInfo();
    super.initState();
  }

  @override
  void dispose() {
    smallBannerAd?.dispose();
    Get.delete<AppAdController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Budidaya Belut',
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              FutureBuilder(
                future: getVideoArticles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return Text(
                      AppLocalizations.of(context)!.error_occurred,
                      style: const TextStyle(color: Colors.white),
                    );
                  } else {
                    return PageView.builder(
                      itemCount: videoArticles.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) => SlideVideoPlayer(
                        videoArticle: videoArticles[index],
                      ),
                    );
                  }
                },
              ),
              Obx(() {
                if (adController.isVideoNewsScreenSmallBannerAdLoaded.value &&
                    smallBannerAd != null) {
                  return Positioned(
                    bottom: 15,
                    left: 10,
                    child: SizedBox(
                      height: smallBannerAd!.size.height.toDouble(),
                      width: smallBannerAd!.size.width.toDouble(),
                      child: AdWidget(ad: smallBannerAd!),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              })
            ],
          ),
        ));
  }
}
