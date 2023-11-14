import 'package:flutter/material.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/components/neews_back_button.dart';
import 'package:anekapanduan/components/notification_card.dart';
import 'package:anekapanduan/model/app_notifications.dart';
import 'package:anekapanduan/screens/user_profile_screens/about_us_screen.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AppNotifications> appNotifications = [];
  Future<void> getNotifications() async {
    var data = await fetchAppNotifications();

    if (data['status_code'] == 0) {
      appNotifications = List.from(data['notifications'])
          .map((e) => AppNotifications.fromJson(e))
          .toList();
    }
  }

  @override
  void initState() {
    getNotifications();
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
            const NeewsBackButton(),
            getVerticalSpace(10),
            Text(
              AppLocalizations.of(context)!.notifications,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            getVerticalSpace(20),
            Expanded(
              child: FutureBuilder(
                future: getNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 20,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => const TextShimmer(),
                    );
                  } else if (snapshot.hasError) {
                    return ApiResultWidget(
                        title: AppLocalizations.of(context)!.error_occurred,
                        image: errorIllustration);
                  } else {
                    return ListView.builder(
                      itemCount: appNotifications.length,
                      itemBuilder: (context, index) => NotificationCard(
                          appNotifications: appNotifications[index]),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      )),
    );
  }
}
