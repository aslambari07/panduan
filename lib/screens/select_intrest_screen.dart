import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:anekapanduan/components/category/category_card.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/components/neews_snackbar.dart';
import 'package:anekapanduan/controller/category_controller.dart';
import 'package:anekapanduan/model/categories.dart';
import 'package:anekapanduan/screens/main_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectIntrestScreen extends StatefulWidget {
  const SelectIntrestScreen({super.key});

  @override
  State<SelectIntrestScreen> createState() => _SelectIntrestScreenState();
}

class _SelectIntrestScreenState extends State<SelectIntrestScreen> {
  List<Category> categoryList = [];
  Future<void> getCategories() async {
    categoryList = await getArticleCategories();
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void validateData(List<String> selectedCategories) {}

  final CategoryController categoryController = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(authenticationScreenBg), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerticalSpace(20),
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.select_your_intrest,
                    style: headlineOneTextStyle,
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.skip,
                        style: textButtonTextStyle.copyWith(color: greyColor),
                      ))
                ],
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
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 20),
                      itemCount: 6,
                      itemBuilder: (context, index) => const CategoryShimmer(),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Some error occurred');
                  } else {
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: 0.75),
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
                      showNeewsSnackBar(
                          AppLocalizations.of(context)!.select_your_intrest,
                          errorColor,
                          context);
                    } else {
                      for (int i = 0;
                          i < categoryController.selectedCategoryList.length;
                          i++) {
                        await addUserIntrest(
                            categoryController
                                .selectedCategoryList[i].categoryName,
                            categoryController.selectedCategoryList[i].id);
                        if (!mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainScreen(),
                            ));
                      }
                    }
                  })
            ],
          ),
        )),
      ),
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        child: Container(
          height: 170,
          width: 170,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
        ));
  }
}
