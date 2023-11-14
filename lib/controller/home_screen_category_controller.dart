import 'package:get/state_manager.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';

class HomeScreenCategoryController extends GetxController {
  var articleList = <Article>[].obs;
  String selectedCategory = '1';

  bool isMediumAdOneLoaded = false;
  bool isMediumAdTwoLoaded = false;
  bool isLargeAdLoaded = false;
  bool isLargeAdTwoLoaded = false;

  void updateMediumAdOneLoading(value) {
    isMediumAdOneLoaded = value;
    update();
  }

  void updateMediumAdTwoLoading(value) {
    isMediumAdTwoLoaded = value;
    update();
  }

  void updateLargeAdLoading(value) {
    isLargeAdLoaded = value;
    update();
  }

  void updateLargeAdTwoLoading(value) {
    isLargeAdTwoLoaded = value;
    update();
  }

  int selectedCategoryIndex = 0;

  void updateCategory(categoryId, index) {
    selectedCategory = categoryId;
    selectedCategoryIndex = index;
    getCategoryArticle(categoryId);
    update();
  }

  Future<void> getCategoryArticle(categoryId) async {
    var articles = await fetchCategoryArticle(categoryId, '5');

    if (articles.isNotEmpty) {
      articleList.value = articles;
    }
  }

  @override
  void onInit() {
    getCategoryArticle(selectedCategory);
    super.onInit();
  }
}
