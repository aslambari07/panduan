import 'package:get/state_manager.dart';

class ArticleAdController extends GetxController {
  bool isSmallBannerAdLoaded = false;
  bool isMediumBannerAdLoaded = false;
  bool isBottomBannerAdLoaded = false;

  void updateAdLoading(value) {
    isSmallBannerAdLoaded = value;
    update();
  }

  void updateMediumAdLoading(value) {
    isMediumBannerAdLoaded = value;
    update();
  }

  void updateBottomBannerAdLoading(value) {
    isBottomBannerAdLoaded = value;
    update();
  }
}
