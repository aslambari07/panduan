import 'package:get/state_manager.dart';
import 'package:anekapanduan/components/neews_snackbar.dart';
import 'package:anekapanduan/model/categories.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';

class PrefencesController extends GetxController {
  List<Category> userPrefencesList = [];

  Future<void> getUserPrefences() async {
    var apiResponse = await fetchUserPrefences();

    if (apiResponse['status_code'] == 0) {
      userPrefencesList = List.from(apiResponse['user_prefences'])
          .map((e) => Category.fromJson(e))
          .toList();
    } else {
      userPrefencesList = [];
    }
  }

  Future<void> deletePrefences(id, context) async {
    var apiResponse = await deleteUserPrefences(id);

    if (apiResponse['status_code'] == 0) {
      getUserPrefences();
      update();
    } else {
      showNeewsSnackBar(
          'Some error occurred while deleting', errorColor, context);
    }
  }

  @override
  void onInit() {
    getUserPrefences();
    super.onInit();
  }
}
