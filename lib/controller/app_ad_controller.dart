import 'package:get/state_manager.dart';

class AppAdController extends GetxController {
  //Home Screen Ads
  RxBool isHomeScreenMediumBannerAdOneLoaded = false.obs;
  RxBool isHomeScreenMediumBannerAdTwoLoaded = false.obs;
  RxBool isHomeScreenLargeBannerAdOneLoaded = false.obs;
  RxBool isHomeScreenLargeBannerAdTwoLoaded = false.obs;

  //Article Screen Ads
  RxBool isArticleScreenSmallBannerAdOneLoaded = false.obs;
  RxBool isArticleScreenSmallBannerAdTwoLoaded = false.obs;
  RxBool isArticleScreenLargeBannerAdLoaded = false.obs;

  //Category News Screen Ads
  RxBool isCategoryNewsScreenMediumBannerAdLoaded = false.obs;

  //Video News Screen Ads
  RxBool isVideoNewsScreenSmallBannerAdLoaded = false.obs;

  //Search Screen Ads
  RxBool isSearchScreenBannerAdLoaded = false.obs;
}
