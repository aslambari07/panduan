import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/components/category/category_card.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/controller/category_controller.dart';
import 'package:anekapanduan/model/categories.dart';
import 'package:anekapanduan/screens/user_profile_screens/manage_user_prefences_screen.dart';
import 'package:anekapanduan/screens/select_intrest_screen.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddPrefencesScreen extends StatefulWidget {
  final List<Category> selectedCategoryList;
  const AddPrefencesScreen({super.key, required this.selectedCategoryList});

  @override
  State<AddPrefencesScreen> createState() => _AddPrefencesScreenState();
}

class _AddPrefencesScreenState extends State<AddPrefencesScreen> {
  List<Category> categoryList = [];
  Future<void> getCategories() async {
    var apiResponse = await fetchPrefences();
    print(apiResponse);
    if (apiResponse['status_code'] == 0) {
      categoryList = List.from(apiResponse['category_list'])
          .map((e) => Category.fromJson(e))
          .toList();
    }
  }

  final CategoryController categoryController = Get.put(CategoryController());

  void resetList() {
    if (categoryController.selectedCategoryList.isNotEmpty) {
      categoryController.selectedCategoryList = [];
    }
  }

  @override
  void initState() {
    getCategories();
    resetList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVerticalSpace(20),
            Text(
              AppLocalizations.of(context)!.add_preferences,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            getVerticalSpace(5),
            Text(
              AppLocalizations.of(context)!.select_your_intrest_subtext,
              style: descriptionTextStyle,
            ),
            getVerticalSpace(5),
            getVerticalSpace(20),
            Expanded(
                child: FutureBuilder(
              future: getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10),
                    itemCount: 6,
                    itemBuilder: (context, index) => const CategoryShimmer(),
                  );
                } else if (snapshot.hasError) {
                  return ApiResultWidget(
                      title: AppLocalizations.of(context)!.error_occurred,
                      image: errorIllustration);
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.65),
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) =>
                        GetBuilder<CategoryController>(builder: (controller) {
                      return CategoryCard(
                          name: categoryList[index].categoryName,
                          image: categoryList[index].image,
                          isSelected: controller.selectedCategoryList
                              .contains(categoryList[index]),
                          onPressed: () {
                            if (controller.selectedCategoryList
                                .contains(categoryList[index])) {
                              controller.removeCategory(categoryList[index]);
                            } else {
                              controller.addCategory(categoryList[index]);
                            }
                          });
                    }),
                  );
                }
              },
            )),
            NeewsButton(
                child: Text(
                  AppLocalizations.of(context)!.choose,
                  style: primaryButtonTextStyle,
                ),
                onPressed: () async {
                  if (categoryController.selectedCategoryList.isEmpty) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ManageUserPrefencesScreen(),
                        ));
                  } else {
                    for (Category category
                        in categoryController.selectedCategoryList) {
                      await addUserIntrest(category.categoryName, category.id);
                    }
                    if (!mounted) return;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ManageUserPrefencesScreen(),
                        ));
                  }
                })
          ],
        ),
      )),
    );
  }
}
