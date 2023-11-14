import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/components/category/category_card.dart';
import 'package:anekapanduan/components/neews_back_button.dart';
import 'package:anekapanduan/controller/prefences_controller.dart';
import 'package:anekapanduan/screens/user_profile_screens/add_prefences_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageUserPrefencesScreen extends StatefulWidget {
  const ManageUserPrefencesScreen({super.key});

  @override
  State<ManageUserPrefencesScreen> createState() =>
      _ManageUserPrefencesScreenState();
}

class _ManageUserPrefencesScreenState extends State<ManageUserPrefencesScreen> {
  @override
  Widget build(BuildContext context) {
    Get.put(PrefencesController());
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getVerticalSpace(20),
                const NeewsBackButton(),
                getVerticalSpace(20),
                Text(
                  AppLocalizations.of(context)!.manage_preferences,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                getVerticalSpace(20),
                Expanded(
                  child: GetBuilder<PrefencesController>(builder: (controller) {
                    return FutureBuilder(
                      future: controller.getUserPrefences(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        } else if (snapshot.hasError) {
                          return ApiResultWidget(
                              title:
                                  AppLocalizations.of(context)!.error_occurred,
                              image: errorIllustration);
                        } else {
                          return GridView.builder(
                            itemCount: controller.userPrefencesList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 0.65),
                            itemBuilder: (context, index) => Column(
                              children: [
                                CategoryCard(
                                    name: controller
                                        .userPrefencesList[index].categoryName,
                                    image: controller
                                        .userPrefencesList[index].image,
                                    isSelected: false,
                                    onPressed: () {}),
                                TextButton(
                                    onPressed: () {
                                      {
                                        controller.deletePrefences(
                                            controller
                                                .userPrefencesList[index].id,
                                            context);
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.remove,
                                      style: const TextStyle(color: errorColor),
                                    ))
                              ],
                            ),
                          );
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
            GetBuilder<PrefencesController>(builder: (controller) {
              return Positioned(
                right: 20,
                bottom: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPrefencesScreen(
                              selectedCategoryList:
                                  controller.userPrefencesList),
                        ));
                  },
                  backgroundColor: primaryColor,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              );
            })
          ],
        ),
      )),
    );
  }
}
