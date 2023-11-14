import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anekapanduan/components/app_bottomsheets.dart';
import 'package:anekapanduan/components/articles/articles_shimmer.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/components/settings_tile.dart';
import 'package:anekapanduan/screens/user_profile_screens/about_us_screen.dart';
import 'package:anekapanduan/screens/authentication_screens/sign_in_screen.dart';
import 'package:anekapanduan/screens/user_profile_screens/contact_us_screen.dart';
import 'package:anekapanduan/screens/user_profile_screens/manage_user_prefences_screen.dart';
import 'package:anekapanduan/screens/user_profile_screens/privacy_policy_screen.dart';
import 'package:anekapanduan/screens/user_profile_screens/user_saved_articles_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowAppDrawer extends StatefulWidget {
  const ShowAppDrawer({super.key});

  @override
  State<ShowAppDrawer> createState() => _ShowAppDrawerState();
}

class _ShowAppDrawerState extends State<ShowAppDrawer> {
  late String name, email;
  bool isUserRegistered = true;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> getUserData() async {
    var userData = await fetchUserInfo();

    if (userData['status_code'] == 0) {
      name = userData['user_info']['user_name'];
      email = userData['user_info']['email'];
    } else {
      isUserRegistered = false;
    }
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser != null ? getUserData() : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              getVerticalSpace(20),
              FirebaseAuth.instance.currentUser != null
                  ? FutureBuilder(
                      future: getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ShimmerContainer(height: 60);
                        } else if (snapshot.hasError) {
                          return const SizedBox();
                        } else {
                          return isUserRegistered
                              ? Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: primaryColor,
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              profileIcon,
                                              height: 50,
                                              width: 50,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn),
                                            ),
                                            getHorizontalSpace(10),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                          fontSize: 18,
                                                          color: Colors.white),
                                                ),
                                                Text(
                                                  email,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    getVerticalSpace(20),
                                  ],
                                )
                              : const SizedBox();
                        }
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            )),
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  profileIcon,
                                  height: 50,
                                  width: 50,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                                getHorizontalSpace(10),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.login,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontSize: 18,
                                              color: Colors.white),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              SettingsTile(
                text: AppLocalizations.of(context)!.bookmarks,
                icon: saveIcon,
                onPressed: () => firebaseAuth.currentUser != null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserSavedArticlesScreen(),
                        ))
                    : AppBottomSheets.showLoginBottomSheet(context),
                showDivider: true,
                suffixWidget: const SizedBox(),
              ),
              SettingsTile(
                text: AppLocalizations.of(context)!.manage_preferences,
                icon: prefencesIcon,
                onPressed: () => firebaseAuth.currentUser != null
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ManageUserPrefencesScreen(),
                        ))
                    : AppBottomSheets.showLoginBottomSheet(context),
                showDivider: true,
                suffixWidget: const SizedBox(),
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
                suffixWidget: const SizedBox(),
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
                suffixWidget: const SizedBox(),
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
                suffixWidget: const SizedBox(),
              ),
              firebaseAuth.currentUser != null
                  ? SettingsTile(
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
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
