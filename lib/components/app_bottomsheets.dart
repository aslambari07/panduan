import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/components/neews_text_field.dart';
import 'package:anekapanduan/screens/authentication_screens/sign_in_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/spacer.dart';

class AppBottomSheets {
  static Future<dynamic> showLoginBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.sign_in_to_account,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            getVerticalSpace(20),
            Text(
              AppLocalizations.of(context)!.sign_in_sub_text,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: greyColor),
            ),
            Center(
              child: Image.asset(
                signInIllustration,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            NeewsButton(
                child: Text(
                  AppLocalizations.of(context)!.login,
                  style: primaryButtonTextStyle,
                ),
                onPressed: () {
                  showLoginBottomSheet(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ));
                }),
            getVerticalSpace(20)
          ],
        ),
      ),
    );
  }

  static Future<dynamic> showNoConnectionBottomSheet(
      BuildContext context, VoidCallback onPressed) async {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.no_internet_connection,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            getVerticalSpace(10),
            Image.asset(noInternetIllustration),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                AppLocalizations.of(context)!.please_connect_to_internet,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ),
            NeewsButton(
                onPressed: onPressed,
                child: Text(
                  AppLocalizations.of(context)!.try_again,
                  style: primaryButtonTextStyle,
                ))
          ],
        ),
      ),
    );
  }

  static Future<dynamic> updateUserNameBottomSheet(
      BuildContext context,
      TextEditingController nameTextEditingController,
      VoidCallback onPressed) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.update_your_name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              getVerticalSpace(10),
              NeewsTextField(
                icon: userIcon,
                label: AppLocalizations.of(context)!.name,
                textEditingController: nameTextEditingController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(AppLocalizations.of(context)!.enter_your_name),
              ),
              NeewsButton(
                  onPressed: onPressed,
                  child: Text(
                    AppLocalizations.of(context)!.update,
                    style: primaryButtonTextStyle,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
