import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:anekapanduan/components/app_drawer.dart';
import 'package:anekapanduan/components/articles/article_card_four.dart';
import 'package:anekapanduan/components/articles/article_card_one.dart';
import 'package:anekapanduan/components/articles/article_card_three.dart';
import 'package:anekapanduan/components/articles/article_card_two.dart';
import 'package:anekapanduan/components/articles/articles_shimmer.dart';
import 'package:anekapanduan/components/category/category_button.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/controller/app_ad_controller.dart';
import 'package:anekapanduan/controller/home_screen_category_controller.dart';
import 'package:anekapanduan/controller/screen_controllers/home_screen_controller.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/model/categories.dart';
import 'package:anekapanduan/screens/categories_screen.dart';
import 'package:anekapanduan/screens/article_screens/category_news_screen.dart';
import 'package:anekapanduan/screens/notifications_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Lists
  List<Article> trendingArticleList = [];
  List<Article> breakingArticleList = [];
  List<Category> categoryList = [];
  List<Article> userIntrestArticleList = [];

  //Controllers
  final HomeScreenCategoryController categoryController =
      Get.put(HomeScreenCategoryController());
  final AppAdController adController = Get.put(AppAdController());
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  BannerAd? mediumBannerAdOne,
      mediumBannerAdTwo,
      largeBannerAd,
      largeBannerAdTwo;
  late String appDate;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Data fetching methods
  Future<void> getTrendingArticles() async {
    trendingArticleList = await fetchTrendingArticles();
    if (trendingArticleList.isEmpty) {
      homeScreenController.updateTrendingArticlesLoading(false);
    }
  }

  Future<void> getBreakingArticles() async {
    breakingArticleList = await fetchBreakingArticles();
    if (breakingArticleList.isEmpty) {
      homeScreenController.updateBreakingArticlesLoading(false);
    }
  }

  Future<void> getCategories() async {
    categoryList = await getArticleCategories();

    if (categoryList.isEmpty) {
      homeScreenController.updateCategoriesLoading(false);
    }
  }

  Future<void> getUserIntrestArticles() async {
    firebaseAuth.currentUser != null
        ? userIntrestArticleList = await fetchUserIntrestArticles(
            FirebaseAuth.instance.currentUser!.uid)
        : debugPrint('User not logged in');

    if (userIntrestArticleList.isEmpty) {
      homeScreenController.updateUserIntrestedArticlesLoading(false);
    }
  }

  Future<void> getAppDate() async {
    var data = await fetchCurrentDate();
    DateTime dateTime = DateTime.parse(data['date']);
    appDate = DateFormat('EEEE, dd MMM yyyy').format(dateTime);
  }

  //Ad Loading and fetching
  Future<void> getAdInfo() async {
    var apiResponse = await fetchAdInfo();
    if (apiResponse['status_code'] == 0) {
      if (apiResponse['ad_enabled'] == '1') {
        String bannedAdId = Platform.isAndroid
            ? apiResponse['android_banner_ad_id']
            : apiResponse['ios_banner_ad_id'];
        loadMediumAdOne(bannedAdId);
        loadMediumAdTwo(bannedAdId);
        loadLargeBannerAd(bannedAdId);
        loadLargeBannerAdTwo(bannedAdId);
      }
    }
  }

  void loadMediumAdOne(adUnitId) {
    mediumBannerAdOne = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          adController.isHomeScreenMediumBannerAdOneLoaded.value = true;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('Medium BannerAd One failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadMediumAdTwo(adUnitId) {
    mediumBannerAdTwo = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          adController.isHomeScreenMediumBannerAdTwoLoaded.value = true;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('Medium Banner Ad One failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadLargeBannerAd(adUnitId) {
    largeBannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          adController.isHomeScreenLargeBannerAdOneLoaded.value = true;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('Large Banner Ad One failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  void loadLargeBannerAdTwo(adUnitId) {
    largeBannerAdTwo = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          adController.isHomeScreenLargeBannerAdTwoLoaded.value = true;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('Large Banner Ad Two failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    getTrendingArticles();
    getBreakingArticles();
    getCategories();
    getUserIntrestArticles();
    getAdInfo();
    getAppDate();
    super.initState();
  }

  @override
  void dispose() {
    mediumBannerAdOne?.dispose();
    mediumBannerAdTwo?.dispose();
    largeBannerAd?.dispose();
    largeBannerAdTwo?.dispose();
    Get.delete<AppAdController>();
    Get.delete<HomeScreenCategoryController>();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: const ShowAppDrawer(),
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer(); // Open the drawer
              },
              icon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SvgPicture.asset(
                  drawerIcon,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color!, BlendMode.srcIn),
                ),
              )),
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    )),
                icon: SvgPicture.asset(notificationIcon,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).iconTheme.color!, BlendMode.srcIn))),
            getHorizontalSpace(10)
          ],
          title: Center(
              child: Image.asset(
            appLogoLinear,
            width: 40,
            height: 40,
          )),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GetBuilder<HomeScreenController>(builder: (controller) {
            if (!controller.isTrendingArticlesLoaded &&
                !controller.isBreakingArticlesLoaded &&
                !controller.isCategoriesLoaded) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ApiResultWidget(
                  title: AppLocalizations.of(context)!.no_articles_available,
                  image: emptyIllustration,
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getVerticalSpace(30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    AppLocalizations.of(context)!.discover_the_world,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 32),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: FutureBuilder(
                      future: getAppDate(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        } else if (snapshot.hasError) {
                          return const SizedBox();
                        } else {
                          return Text(
                            appDate,
                            style: descriptionTextStyle,
                          );
                        }
                      }),
                ),
                getVerticalSpace(20),
                controller.isTrendingArticlesLoaded
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "🔥 ${AppLocalizations.of(context)!.trending_news}",
                          style: helpingTextStyle,
                        ),
                      )
                    : const SizedBox(),
                getVerticalSpace(10),
                controller.isTrendingArticlesLoaded
                    ? SizedBox(
                        height: 280,
                        child: FutureBuilder(
                          future: getTrendingArticles(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                physics: const BouncingScrollPhysics(),
                                itemCount: 5,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    const ArticleCardOneShimmer(),
                              );
                            } else if (snapshot.hasError) {
                              return const SizedBox();
                            } else {
                              return trendingArticleList.isNotEmpty
                                  ? ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: trendingArticleList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) =>
                                          ArticleCardOne(
                                        article: trendingArticleList[index],
                                      ),
                                    )
                                  : const SizedBox();
                            }
                          },
                        ),
                      )
                    : const SizedBox(),
                getVerticalSpace(10),
                Obx(() {
                  if (adController.isHomeScreenMediumBannerAdOneLoaded.value &&
                      mediumBannerAdOne != null) {
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
                }),
                getVerticalSpace(10),
                controller.isBreakingArticlesLoaded
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          AppLocalizations.of(context)!.breaking_news,
                          style: helpingTextStyle,
                        ),
                      )
                    : const SizedBox(),
                getVerticalSpace(10),
                controller.isBreakingArticlesLoaded
                    ? SizedBox(
                        height: 260,
                        child: FutureBuilder(
                          future: getBreakingArticles(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                itemCount: 5,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    const ArticleCardTwoShimmer(),
                              );
                            } else if (snapshot.hasError) {
                              return const SizedBox();
                            } else {
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                itemCount: breakingArticleList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => ArticleCardTwo(
                                  article: breakingArticleList[index],
                                ),
                              );
                            }
                          },
                        ),
                      )
                    : const SizedBox(),
                getVerticalSpace(10),
                Obx(() {
                  if (adController.isHomeScreenMediumBannerAdTwoLoaded.value &&
                      mediumBannerAdTwo != null) {
                    return Center(
                      child: SizedBox(
                        height: mediumBannerAdTwo!.size.height.toDouble(),
                        width: mediumBannerAdTwo!.size.width.toDouble(),
                        child: AdWidget(ad: mediumBannerAdTwo!),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
                getVerticalSpace(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.explore_categories,
                        style: helpingTextStyle,
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoriesScreen(),
                                ));
                          },
                          child: Text(
                            AppLocalizations.of(context)!.more,
                            style:
                                textButtonTextStyle.copyWith(color: greyColor),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: FutureBuilder(
                    future: getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox();
                      } else if (snapshot.hasError) {
                        return const SizedBox();
                      } else {
                        return GetBuilder<HomeScreenCategoryController>(
                          builder: (controller) => ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) {
                              return CategoryButton(
                                  category: categoryList[index],
                                  onPressed: () {
                                    controller.updateCategory(
                                        categoryList[index].id, index);
                                  },
                                  isActive: categoryList[index].id ==
                                      categoryController.selectedCategory);
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                getVerticalSpace(10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Obx(() => ListView.builder(
                        itemCount: categoryController.articleList.length < 5
                            ? categoryController.articleList.length
                            : 5,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => categoryController
                                    .articleList[index].isBreaking ==
                                '1'
                            ? ArticleCardFour(
                                article: categoryController.articleList[index],
                              )
                            : ArticleCardThree(
                                article: categoryController.articleList[index],
                              ),
                      )),
                ),
                Center(
                  child: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryArticleScreen(
                                category: categoryList[
                                    categoryController.selectedCategoryIndex]),
                          )),
                      child: Text(
                        AppLocalizations.of(context)!.explore_more,
                        style: textButtonTextStyle.copyWith(color: greyColor),
                      )),
                ),
                Obx(() {
                  if (adController.isHomeScreenLargeBannerAdOneLoaded.value &&
                      largeBannerAd != null) {
                    return Center(
                      child: SizedBox(
                        height: largeBannerAd!.size.height.toDouble(),
                        width: largeBannerAd!.size.width.toDouble(),
                        child: AdWidget(ad: largeBannerAd!),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
                getVerticalSpace(20),
                firebaseAuth.currentUser != null
                    ? controller.isUserIntrestedArticlesLoaded
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              AppLocalizations.of(context)!.selected_for_you,
                              style: helpingTextStyle.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox(),
                getVerticalSpace(20),
                firebaseAuth.currentUser != null
                    ? controller.isUserIntrestedArticlesLoaded
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: FutureBuilder(
                              future: getUserIntrestArticles(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListView.builder(
                                    itemCount: 5,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        const ArticleCardThreeShimmer(),
                                  );
                                } else if (snapshot.hasError) {
                                  return const SizedBox();
                                } else {
                                  return ListView.builder(
                                      itemCount: userIntrestArticleList.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) =>
                                          userIntrestArticleList[index]
                                                      .isBreaking ==
                                                  '1'
                                              ? ArticleCardFour(
                                                  article:
                                                      userIntrestArticleList[
                                                          index],
                                                )
                                              : ArticleCardThree(
                                                  article:
                                                      userIntrestArticleList[
                                                          index],
                                                ));
                                }
                              },
                            ),
                          )
                        : const SizedBox()
                    : const SizedBox(),
                Obx(() {
                  if (adController.isHomeScreenLargeBannerAdTwoLoaded.value &&
                      largeBannerAdTwo != null) {
                    return Center(
                      child: SizedBox(
                        height: largeBannerAdTwo!.size.height.toDouble(),
                        width: largeBannerAdTwo!.size.width.toDouble(),
                        child: AdWidget(ad: largeBannerAdTwo!),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ],
            );
          }),
        ));
  }
}
