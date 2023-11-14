import 'package:get/state_manager.dart';
import 'package:anekapanduan/model/categories.dart';

class CategoryController extends GetxController {
  List<Category> selectedCategoryList = [];

  void addCategory(value) {
    selectedCategoryList.add(value);
    update();
  }

  void removeCategory(value) {
    selectedCategoryList.remove(value);
    update();
  }

  @override
  void onInit() {
    selectedCategoryList.clear();
    super.onInit();
  }
}
