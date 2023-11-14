import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:anekapanduan/model/app_notifications.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/screens/article_screen.dart';
import 'package:anekapanduan/screens/video_screen.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';

class NotificationCard extends StatefulWidget {
  final AppNotifications appNotifications;
  const NotificationCard({
    super.key,
    required this.appNotifications,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () async {
          if (widget.appNotifications.type == 'TEXT') {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ArticleScreen(articleId: widget.appNotifications.data),
                ));
          } else if (widget.appNotifications.type == 'VIDEO') {
            var data =
                await fetchVideoArticleInfo(widget.appNotifications.data);

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
        },
        child: SizedBox(
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      adminPanelUrl + widget.appNotifications.image,
                      fit: BoxFit.cover,
                      height: 75,
                      width: 75,
                    ),
                  ),
                  getHorizontalSpace(10),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.appNotifications.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        widget.appNotifications.title,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                      ),
                      Text(
                        DateFormat('dd MMM hh:mm a').format(
                            DateTime.parse(widget.appNotifications.date)),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ))
                ],
              ),
              getVerticalSpace(5),
              Container(
                height: 0.5,
                width: double.infinity,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
