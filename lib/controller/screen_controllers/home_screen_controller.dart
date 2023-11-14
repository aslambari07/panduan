import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  bool isTrendingArticlesLoaded = true;
  bool isBreakingArticlesLoaded = true;
  bool isCategoriesLoaded = true;
  bool isCategoryArticlesLoaded = true;
  bool isUserIntrestedArticlesLoaded = true;

  void updateTrendingArticlesLoading(value) {
    isTrendingArticlesLoaded = value;
  }

  void updateBreakingArticlesLoading(value) {
    isBreakingArticlesLoaded = value;
  }

  void updateCategoriesLoading(value) {
    isCategoriesLoaded = value;
  }

  void updateCategoryArticlesLoading(value) {
    isCategoryArticlesLoaded = value;
  }

  void updateUserIntrestedArticlesLoading(value) {
    isUserIntrestedArticlesLoaded = value;
  }
}
