import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anekapanduan/components/app_bottomsheets.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/components/neews_snackbar.dart';
import 'package:anekapanduan/components/settings_tile.dart';
import 'package:anekapanduan/manager/theme_manager.dart';
import 'package:anekapanduan/model/neews_user.dart';
import 'package:anekapanduan/screens/user_profile_screens/about_us_screen.dart';
import 'package:anekapanduan/screens/authentication_screens/sign_in_screen.dart';
import 'package:anekapanduan/screens/user_profile_screens/change_language_screen.dart';
import 'package:anekapanduan/screens/user_profile_screens/contact_us_screen.dart';
import 'package:anekapanduan/screens/user_profile_screens/manage_user_prefences_screen.dart';
import 'package:anekapanduan/screens/user_profile_screens/privacy_policy_screen.dart';
import 'package:anekapanduan/screens/user_profile_screens/user_saved_articles_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  late NeewsUser user;
  Future<void> getInfo() async {
    var userData = await fetchUserInfo();

    if (userData['status_code'] == 0) {
      user = NeewsUser.fromJson(userData['user_info']);
    }
  }

  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: FirebaseAuth.instance.currentUser != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getVerticalSpace(20),
                    Text(
                      AppLocalizations.of(context)!.account,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    getVerticalSpace(20),
                    //User Info Box
                    SizedBox(
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: primaryColor, width: 1)),
                            child: Center(
                              child: SvgPicture.asset(
                                profileIcon,
                                height: 60,
                                width: 60,
                                colorFilter: const ColorFilter.mode(
                                    primaryColor, BlendMode.srcIn),
                              ),
                            ),
                          ),
                          getHorizontalSpace(10),
                          FutureBuilder(
                            future: getInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              } else if (snapshot.hasError) {
                                return const SizedBox();
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.welcome,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      user.userName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontSize: 20),
                                    ),
                                    Text(
                                      user.email,
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                AppBottomSheets.updateUserNameBottomSheet(
                                    context, nameTextEditingController,
                                    () async {
                                  String name = nameTextEditingController.text;

                                  if (name.trim().isEmpty) {
                                    showNeewsSnackBar(
                                        AppLocalizations.of(context)!
                                            .enter_your_name,
                                        errorColor,
                                        context);
                                  } else {
                                    var updateName =
                                        await updateUserData('user_name', name);
                                    if (!mounted) return;
                                    if (updateName['status_code'] == 0) {
                                      showNeewsSnackBar(
                                          'Name updated successfully',
                                          successColor,
                                          context);
                                      Navigator.pop(context);
                                      setState(() {
                                        nameTextEditingController.text = '';
                                      });
                                    } else {
                                      showNeewsSnackBar(
                                          AppLocalizations.of(context)!
                                              .error_occurred,
                                          errorColor,
                                          context);

                                      Navigator.pop(context);

                                      setState(() {});
                                    }
                                  }
                                });
                              },
                              icon: SvgPicture.asset(
                                editIcon,
                                colorFilter: const ColorFilter.mode(
                                    Colors.grey, BlendMode.srcIn),
                              ))
                        ],
                      ),
                    ),
                    getVerticalSpace(10),
                    Text(
                      AppLocalizations.of(context)!.settings,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    getVerticalSpace(20),
                    SettingsTile(
                      text: AppLocalizations.of(context)!.bookmarks,
                      icon: saveIcon,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const UserSavedArticlesScreen(),
                          )),
                      showDivider: true,
                    ),
                    SettingsTile(
                      text: AppLocalizations.of(context)!.manage_preferences,
                      icon: prefencesIcon,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ManageUserPrefencesScreen(),
                          )),
                      showDivider: true,
                    ),
                    Consumer(
                      builder:
                          (context, AppSettingsManager themeManager, child) =>
                              SettingsTile(
                        text: AppLocalizations.of(context)!.dark_mode,
                        icon: darkModeIcon,
                        onPressed: () {},
                        showDivider: true,
                        suffixWidget: CupertinoSwitch(
                            value: themeManager.isDarkMode,
                            onChanged: (value) {
                              themeManager.updateTheme(value);
                            }),
                      ),
                    ),
                    SettingsTile(
                      text: AppLocalizations.of(context)!.change_language,
                      icon: languageIcon,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangeLanguageScreen(),
                          )),
                      showDivider: true,
                    ),

                    SettingsTile(
                      text: AppLocalizations.of(context)!.privacy_policy,
                      icon: privacyPolicyIcon,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen(),
                          )),
                      showDivider: true,
                    ),
                    SettingsTile(
                      text: AppLocalizations.of(context)!.about_us,
                      icon: aboutUsIcon,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutUsScreen(),
                          )),
                      showDivider: true,
                    ),
                    SettingsTile(
                      text: AppLocalizations.of(context)!.contact_us,
                      icon: contactUsIcon,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactUsScreen(),
                          )),
                      showDivider: true,
                    ),
                    SettingsTile(
                      text: AppLocalizations.of(context)!.logout,
                      icon: logoutIcon,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (context) {
                            return SizedBox(
                              height: 500,
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.logout_text,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    getVerticalSpace(40),
                                    Center(
                                      child: SvgPicture.asset(
                                        logoutDualToneIcon,
                                        width: 175,
                                        colorFilter: const ColorFilter.mode(
                                            errorColor, BlendMode.srcIn),
                                      ),
                                    ),
                                    getVerticalSpace(50),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                        ),
                                        getHorizontalSpace(20),
                                        Expanded(
                                            child: NeewsButton(
                                                backgroundColor: errorColor,
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .logout,
                                                  style: primaryButtonTextStyle,
                                                ),
                                                onPressed: () async {
                                                  await FirebaseAuth.instance
                                                      .signOut();
                                                  if (!mounted) return;
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignInScreen(),
                                                      ));
                                                }))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      colorTheme: Colors.red,
                      showDivider: false,
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getVerticalSpace(20),
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
                    Image.asset(signInIllustration),
                    NeewsButton(
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: primaryButtonTextStyle,
                        ),
                        onPressed: () {
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
      )),
    );
  }
}
