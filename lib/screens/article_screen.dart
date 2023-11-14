import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/components/app_bottomsheets.dart';
import 'package:anekapanduan/components/articles/articles_shimmer.dart';
import 'package:anekapanduan/components/neews_snackbar.dart';
import 'package:anekapanduan/controller/article_ad_controller.dart';
import 'package:anekapanduan/controller/article_controller.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/model/categories.dart';
import 'package:anekapanduan/utils/branch_deep_link_service.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArticleScreen extends StatefulWidget {
  final String articleId;
  const ArticleScreen({
    super.key,
    required this.articleId,
  });

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  BannerAd? smallBannerAd, mediumBannerAd, bottomBannerAd;
  late Article article;
  late Category category;
  ArticleController articleController = Get.put(ArticleController());
  ArticleAdController articleAdController = Get.put(ArticleAdController());
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> getArticle() async {
    var apiResponse = await fetchArticle(widget.articleId);
    var response = jsonDecode(apiResponse);

    if (response['status_code'] == 0) {
      article = Article.fromJson(response['article']);
      category = Category.fromJson(response['category']);
      await articleController.getArticleDetails(article.id);
    }
  }

  Future<void> updateView() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await updateArticleView(
          FirebaseAuth.instance.currentUser!.uid, widget.articleId);
    }
  }

  Future<void> getAdInfo() async {
    var apiResponse = await fetchAdInfo();

    if (apiResponse['status_code'] == 0) {
      if (apiResponse['ad_enabled'] == '1') {
        String bannedAdId = Platform.isAndroid
            ? apiResponse['android_banner_ad_id']
            : apiResponse['ios_banner_ad_id'];
        loadSmallAd(bannedAdId);
        loadMediumAd(bannedAdId);
        loadBottomBannerAd(bannedAdId);
      }
    }
  }

  void loadSmallAd(adUnitId) {
    smallBannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          articleAdController.updateAdLoading(true);
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('Small BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadMediumAd(adUnitId) {
    mediumBannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          articleAdController.updateMediumAdLoading(true);
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('Medium BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadBottomBannerAd(adUnitId) {
    bottomBannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          articleAdController.updateBottomBannerAdLoading(true);
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('Bottom BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    getArticle();
    getAdInfo();
    updateView();
    super.initState();
  }

  @override
  void dispose() {
    articleController.stopArticle();
    mediumBannerAd?.dispose();
    smallBannerAd?.dispose();
    bottomBannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(
              backIcon,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).iconTheme.color!, BlendMode.srcIn),
            )),
        actions: [
          IconButton(
            onPressed: () {
              if (articleController.titleFontSize == 38) {
                showNeewsSnackBar(
                    AppLocalizations.of(context)!.max_font_size_reached_message,
                    secondaryColor,
                    context);
              } else {
                articleController.increaseFontSize();
              }
            },
            icon: Icon(
              Icons.text_increase,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          IconButton(
            onPressed: () {
              if (articleController.titleFontSize == 28) {
                showNeewsSnackBar(
                    AppLocalizations.of(context)!.min_font_size_reached_message,
                    secondaryColor,
                    context);
              } else {
                articleController.decreaseFontSize();
              }
            },
            icon: Icon(
              Icons.text_decrease,
              color: Theme.of(context).iconTheme.color!,
            ),
          ),
          Platform.isAndroid
              ? IconButton(
                  onPressed: () async {
                    var url = await BranchDeepLinkService.getShareLink(
                        BranchContentMetaData()
                          ..addCustomMetadata('path', '/article_screen')
                          ..addCustomMetadata('content_id', widget.articleId));
                    if (!mounted) return;
                    if (url != 'error-occurred') {
                      await Share.share(
                          '${AppLocalizations.of(context)!.read_out_this} $url');
                    }
                  },
                  icon: SvgPicture.asset(sendIcon),
                )
              : const SizedBox(),
          getHorizontalSpace(20)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: FutureBuilder(
            future: getArticle(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ArticleScreenShimmer();
              } else if (snapshot.hasError) {
                return ApiResultWidget(
                    title: AppLocalizations.of(context)!.error_occurred,
                    image: errorIllustration);
              } else {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GetBuilder<ArticleController>(builder: (controller) {
                            return Text(
                              article.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontSize: controller.titleFontSize),
                            );
                          }),
                          getVerticalSpace(10),
                          GetBuilder<ArticleAdController>(
                            builder: (controller) {
                              if (controller.isSmallBannerAdLoaded) {
                                return Center(
                                  child: SizedBox(
                                    height:
                                        smallBannerAd!.size.height.toDouble(),
                                    width: smallBannerAd!.size.width.toDouble(),
                                    child: AdWidget(ad: smallBannerAd!),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          getVerticalSpace(10),
                          Row(
                            children: [
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.purple[50],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Text(
                                    category.categoryName,
                                    style: const TextStyle(
                                        color: Colors.purple, fontSize: 16),
                                  ),
                                ),
                              ),
                              getHorizontalSpace(20),
                              Text(
                                DateFormat(shortNewsDateFormat).format(
                                    DateTime.parse(article.dateCreated)),
                                style:
                                    descriptionTextStyle.copyWith(fontSize: 16),
                              ),
                              const Spacer(),
                              Obx(() => InkWell(
                                    onTap: () {
                                      articleController.isSpeaking.value == true
                                          ? articleController.stopArticle()
                                          : articleController.speakArticle(
                                              article.title +
                                                  article.description);
                                    },
                                    child: Container(
                                      height: 34,
                                      width: 34,
                                      decoration: BoxDecoration(
                                          color: articleController
                                                      .isSpeaking.value ==
                                                  true
                                              ? primaryColor
                                              : Colors.transparent,
                                          border: Border.all(color: greyColor),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: SvgPicture.asset(
                                          articleController.isSpeaking.value ==
                                                  true
                                              ? speakIconFilled
                                              : speakIcon,
                                          colorFilter: ColorFilter.mode(
                                              articleController
                                                          .isSpeaking.value ==
                                                      true
                                                  ? Colors.white
                                                  : greyColor,
                                              BlendMode.srcIn),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          getVerticalSpace(20),
                          article.coverImage.trim().isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    adminPanelUrl + article.coverImage,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    height: 220,
                                  ),
                                )
                              : const SizedBox(),
                          getVerticalSpace(20),
                          GetBuilder<ArticleController>(builder: (controller) {
                            return Text(
                              article.description.substring(
                                  0, article.description.length ~/ 2),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: controller.descriptionFontSize),
                            );
                          }),
                          GetBuilder<ArticleAdController>(
                            builder: (controller) {
                              if (controller.isMediumBannerAdLoaded) {
                                return Center(
                                  child: SizedBox(
                                    height:
                                        mediumBannerAd!.size.height.toDouble(),
                                    width:
                                        mediumBannerAd!.size.width.toDouble(),
                                    child: AdWidget(ad: mediumBannerAd!),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          GetBuilder<ArticleController>(builder: (controller) {
                            return Text(
                              article.description
                                  .substring(article.description.length ~/ 2),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      fontSize: controller.descriptionFontSize),
                            );
                          }),
                          getVerticalSpace(20),
                          GetBuilder<ArticleAdController>(
                            builder: (controller) {
                              if (controller.isBottomBannerAdLoaded) {
                                return Center(
                                  child: SizedBox(
                                    height:
                                        bottomBannerAd!.size.height.toDouble(),
                                    width:
                                        bottomBannerAd!.size.width.toDouble(),
                                    child: AdWidget(ad: bottomBannerAd!),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                          getVerticalSpace(100)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 45,
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GetBuilder<ArticleController>(
                                  builder: (controller) {
                                return InkWell(
                                  onTap: () => firebaseAuth.currentUser != null
                                      ? controller.updateLikes(widget.articleId)
                                      : AppBottomSheets.showLoginBottomSheet(
                                          context),
                                  child: Row(children: [
                                    SvgPicture.asset(
                                      controller.isLiked == 1
                                          ? likeIconFilled
                                          : likeIcon,
                                      colorFilter: ColorFilter.mode(
                                          controller.isLiked == 1
                                              ? Colors.red
                                              : Theme.of(context)
                                                  .iconTheme
                                                  .color!,
                                          BlendMode.srcIn),
                                      height: 24,
                                    ),
                                    getHorizontalSpace(10),
                                    Text(
                                      controller.totalLikes,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ]),
                                );
                              }),
                              Container(
                                width: 2,
                                height: 20,
                                color: greyColor,
                              ),
                              GetBuilder<ArticleController>(
                                  builder: (controller) {
                                return InkWell(
                                  onTap: () => firebaseAuth.currentUser != null
                                      ? controller.updateSaves(widget.articleId)
                                      : AppBottomSheets.showLoginBottomSheet(
                                          context),
                                  child: Row(children: [
                                    SvgPicture.asset(
                                      controller.isSaved == 1
                                          ? saveIconFilled
                                          : saveIcon,
                                      colorFilter: ColorFilter.mode(
                                          Theme.of(context).iconTheme.color!,
                                          BlendMode.srcIn),
                                      height: 24,
                                    ),
                                    getHorizontalSpace(10),
                                    Text(
                                      controller.isSaved == 1
                                          ? AppLocalizations.of(context)!.saved
                                          : AppLocalizations.of(context)!.save,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ]),
                                );
                              }),
                              Container(
                                width: 2,
                                height: 20,
                                color: greyColor,
                              ),
                              Row(children: [
                                SvgPicture.asset(
                                  showIcon,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).iconTheme.color!,
                                      BlendMode.srcIn),
                                ),
                                getHorizontalSpace(10),
                                Text(
                                  articleController.totalViews,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ])
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
