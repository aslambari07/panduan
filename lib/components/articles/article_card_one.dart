import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/screens/article_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:timeago/timeago.dart' as time_ago;

class ArticleCardOne extends StatelessWidget {
  final Article article;
  const ArticleCardOne({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(articleId: article.id),
            )),
        child: Container(
            width: 200,
            height: 250,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(adminPanelUrl + article.coverImage),
                    fit: BoxFit.cover),
                color: greyColor,
                borderRadius: BorderRadius.circular(25)),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          maxLines: 2,
                          style: trendingNewsHeadlineTextStyle,
                        ),
                        Text(
                          time_ago.format(
                                      DateTime.parse(article.dateCreated)) ==
                                  'a day ago'
                              ? DateFormat(shortNewsDateFormat)
                                  .format(DateTime.parse(article.dateCreated))
                              : time_ago
                                  .format(DateTime.parse(article.dateCreated)),
                          style: const TextStyle(color: greyLight),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
