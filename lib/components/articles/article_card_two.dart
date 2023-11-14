import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/screens/article_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:timeago/timeago.dart' as time_ago;

class ArticleCardTwo extends StatelessWidget {
  final Article article;
  const ArticleCardTwo({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(articleId: article.id),
            )),
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: 250,
          height: 260,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  article.coverImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Hero(
                            tag: article.coverImage,
                            child: Image.network(
                              adminPanelUrl + article.coverImage,
                              height: 180,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  getVerticalSpace(5),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  getVerticalSpace(5),
                  Text(
                    time_ago.format(DateTime.parse(article.dateCreated)) ==
                            'a day ago'
                        ? DateFormat(shortNewsDateFormat)
                            .format(DateTime.parse(article.dateCreated))
                        : time_ago.format(DateTime.parse(article.dateCreated)),
                    style: const TextStyle(color: greyColor),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
