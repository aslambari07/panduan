import 'package:flutter/material.dart';
import 'package:anekapanduan/components/neews_back_button.dart';
import 'package:anekapanduan/manager/theme_manager.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ChangeLanguageScreen extends StatelessWidget {
  const ChangeLanguageScreen({super.key});

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
            const NeewsBackButton(),
            getVerticalSpace(10),
            Text(
              AppLocalizations.of(context)!.change_language,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            getVerticalSpace(20),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: appLanguages.length,
                itemBuilder: (context, index) => Consumer(
                  builder:
                      (context, AppSettingsManager appSettingsManager, child) =>
                          Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        appSettingsManager
                            .updateAppLocale(appLanguages[index].locale);
                        await updateUserData('language',
                            appLanguages[index].locale.languageCode);
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: appSettingsManager.appLocale ==
                                    appLanguages[index].locale
                                ? primaryColor
                                : Colors.white,
                            border: Border.all(color: greyColor, width: 0.3),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text(
                                appLanguages[index].language,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: appSettingsManager.appLocale ==
                                                appLanguages[index].locale
                                            ? Colors.white
                                            : Colors.black),
                              ),
                              const Spacer(),
                              appSettingsManager.appLocale ==
                                      appLanguages[index].locale
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
