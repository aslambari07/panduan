import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/components/category/category_card.dart';
import 'package:anekapanduan/model/categories.dart';
import 'package:anekapanduan/screens/article_screens/category_news_screen.dart';
import 'package:anekapanduan/screens/select_intrest_screen.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categoryList = [];
  Future<void> getCategories() async {
    categoryList = await getArticleCategories();
  }

  @override
  void initState() {
    getCategories();
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
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(backBtnIcon)),
              getVerticalSpace(20),
              Text(
                AppLocalizations.of(context)!.explore_categories,
                style: Theme.of(context).textTheme.titleLarge,
              ),
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
                    return ApiResultWidget(
                        title: AppLocalizations.of(context)!.error_occurred,
                        image: errorIllustration);
                  } else {
                    return Expanded(
                      child: GridView.builder(
                        itemCount: categoryList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.70,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) => CategoryCard(
                            name: categoryList[index].categoryName,
                            image: categoryList[index].image,
                            isSelected: false,
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryArticleScreen(
                                      category: categoryList[index]),
                                ))),
                      ),
                    );
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
