import 'package:get/get_state_manager/get_state_manager.dart';

class CategoryNewsAdController extends GetxController {
  bool isMediumAdLoaded = false;

  void updateMediumAdLoading(value) {
    isMediumAdLoaded = value;
    update();
  }
}
