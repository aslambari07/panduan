import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:anekapanduan/controller/app_ad_controller.dart';
import 'package:anekapanduan/controller/video_article_controller.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/utils/branch_deep_link_service.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VideoScreen extends StatefulWidget {
  final VideoArticle videoArticle;
  const VideoScreen({super.key, required this.videoArticle});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  VideoArticleController videoArticleController =
      Get.put(VideoArticleController());

  BannerAd? smallBannedAd;
  AppAdController adController = Get.put(AppAdController());

  bool isVideoLoaded = false;
  bool isVideoPaused = false;

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
      size: AdSize.banner,
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
    _videoPlayerController =
        VideoPlayerController.network(widget.videoArticle.video);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 9 / 16,
        autoPlay: true,
        showControls: false,
        looping: true);
    videoArticleController.getVideoArticleInfo(widget.videoArticle.id);
    super.initState();
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isInitialized && !isVideoLoaded) {
        setState(() {
          isVideoLoaded = true;
        });
      }
    });

    getAdInfo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            isVideoLoaded
                ? InkWell(
                    onTap: () {
                      if (isVideoPaused) {
                        setState(() {
                          isVideoPaused = false;
                          _chewieController.play();
                        });
                      } else {
                        setState(() {
                          isVideoPaused = true;
                          _chewieController.pause();
                        });
                      }
                    },
                    child: Chewie(controller: _chewieController))
                : Image.network(
                    adminPanelUrl + widget.videoArticle.thumbnail,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
            isVideoPaused
                ? Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              isVideoPaused = false;
                              _chewieController.play();
                            });
                          },
                          icon: const Icon(
                            Icons.pause,
                            color: Colors.white,
                            size: 34,
                          )),
                    ),
                  )
                : const SizedBox(),
            isVideoLoaded
                ? const SizedBox()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 2,
                      child: LinearProgressIndicator(
                        valueColor: const AlwaysStoppedAnimation(primaryColor),
                        backgroundColor: Colors.grey[100],
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 80),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Like Section
                    GetBuilder<VideoArticleController>(builder: (controller) {
                      return InkWell(
                        onTap: () => controller.updateVideLike(
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.videoArticle.id),
                        child: SizedBox(
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                controller.isLiked == 1
                                    ? likeIconFilled
                                    : likeIcon,
                                width: 32,
                                colorFilter: ColorFilter.mode(
                                    controller.isLiked == 1
                                        ? Colors.red
                                        : Colors.white,
                                    BlendMode.srcIn),
                              ),
                              getVerticalSpace(4),
                              Text(
                                controller.videoLikes,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    getVerticalSpace(20),
                    //Save Section
                    GetBuilder<VideoArticleController>(builder: (controller) {
                      return InkWell(
                        onTap: () => controller.updateVideoSave(
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.videoArticle.id),
                        child: SizedBox(
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                controller.isSaved == 1
                                    ? saveIconFilled
                                    : saveIcon,
                                width: 26,
                                colorFilter: ColorFilter.mode(
                                    controller.isSaved == 1
                                        ? primaryColor
                                        : Colors.white,
                                    BlendMode.srcIn),
                              ),
                              getVerticalSpace(4),
                              Text(
                                controller.isSaved == 1
                                    ? AppLocalizations.of(context)!.saved
                                    : AppLocalizations.of(context)!.save,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    getVerticalSpace(20),
                    InkWell(
                      onTap: () async {
                        var url = await BranchDeepLinkService.getShareLink(
                            BranchContentMetaData()
                                .addCustomMetadata(
                                    'path', '/video_article_screen')
                                .addCustomMetadata(
                                    'content_id', widget.videoArticle.id));
                        if (!mounted) return;
                        if (url != 'error-occurred') {
                          await Share.share(
                              '${AppLocalizations.of(context)!.check_out_this} $url');
                        }
                      },
                      child: SvgPicture.asset(
                        sendIcon,
                        width: 30,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 80, right: 75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.videoArticle.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  getVerticalSpace(10),
                  Text(
                    widget.videoArticle.description,
                    maxLines: 10,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Obx(() {
                    if (adController
                            .isVideoNewsScreenSmallBannerAdLoaded.value &&
                        smallBannedAd != null) {
                      return Positioned(
                        bottom: 15,
                        left: 10,
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
            )
          ],
        ));
  }
}
