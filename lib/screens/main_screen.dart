import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anekapanduan/components/app_bottomsheets.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/screens/bottom_navigation_screens/account_screen.dart';
import 'package:anekapanduan/screens/article_screen.dart';
import 'package:anekapanduan/screens/bottom_navigation_screens/home_screen.dart';
import 'package:anekapanduan/screens/bottom_navigation_screens/search_screen.dart';
import 'package:anekapanduan/screens/bottom_navigation_screens/video_news_screen.dart';
import 'package:anekapanduan/screens/video_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String defaultLocale = Platform.localeName;
  StreamSubscription<Map>? streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  late StreamSubscription<ConnectivityResult> connectivityResult;

  int selectedPage = 0;

  void _onTap(value) {
    setState(() {
      selectedPage = value;
    });
  }

  var navigationScreens = const [
    HomeScreen(),
    VideoNewsScreen(),
    SearchScreen(),
    AccountScreen()
  ];

  var appBarColors = [Colors.white, Colors.black, Colors.white, Colors.white];

  @override
  void initState() {
    checkConnection();
    listenDynamicLinks();
    super.initState();
  }

  @override
  void dispose() {
    connectivityResult.cancel();
    super.dispose();
  }

  void checkConnection() async {
    connectivityResult = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        AppBottomSheets.showNoConnectionBottomSheet(context, () async {
          final connectivityResult = await (Connectivity().checkConnectivity());
          if (!mounted) return;
          if (connectivityResult != ConnectivityResult.none) {
            Navigator.pop(context);
            setState(() {});
          }
        });
      }
    });
  }

  void listenDynamicLinks() async {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) async {
      controllerData.sink.add((data.toString()));
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        String path = data['path'];
        String contentId = data['content_id'];
        if (path == '/article_screen') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleScreen(articleId: contentId),
              ));
        } else if (path == '/video_article_screen') {
          var data = await fetchVideoArticleInfo(contentId);

          if (data != 'internal-error-occurred') {
            var apiResponse = jsonDecode(data);
            if (!mounted) return;
            if (apiResponse['status_code'] == 0) {
              VideoArticle videoArticle =
                  VideoArticle.fromJson(apiResponse['video_articles']);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoScreen(videoArticle: videoArticle),
                  ));
            }
          }
        }
      }
    }, onError: (error) {
      debugPrint('InitSesseion error: ${error.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    var bottomNavBarItems = [
      BottomNavigationBarItem(
          icon: SvgPicture.asset(homeIcon,
              colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn)),
          activeIcon: SvgPicture.asset(
            homeIconFilled,
            colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          ),
          label: AppLocalizations.of(context)!.home),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(videoIcon,
              colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn)),
          activeIcon: SvgPicture.asset(
            videoIconFilled,
            colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          ),
          label: AppLocalizations.of(context)!.video),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(searchIcon,
              colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn)),
          activeIcon: SvgPicture.asset(
            searchIconFilled,
            colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          ),
          label: AppLocalizations.of(context)!.search),
      BottomNavigationBarItem(
          icon: SvgPicture.asset(userIcon,
              colorFilter: const ColorFilter.mode(greyColor, BlendMode.srcIn)),
          activeIcon: SvgPicture.asset(
            userIconFilled,
            colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          ),
          label: AppLocalizations.of(context)!.account)
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: selectedPage != 1
            ? Theme.of(context).bottomAppBarTheme.color
            : Colors.black,
        items: bottomNavBarItems,
        currentIndex: selectedPage,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        elevation: 0.0,
        selectedItemColor: primaryColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: greyColor,
      ),
      body: navigationScreens[selectedPage],
    );
  }
}
