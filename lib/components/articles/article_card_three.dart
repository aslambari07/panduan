import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/screens/article_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:timeago/timeago.dart' as time_ago;

class ArticleCardThree extends StatelessWidget {
  final Article article;
  const ArticleCardThree({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleScreen(articleId: article.id),
            )),
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              article.coverImage.trim().isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        adminPanelUrl + article.coverImage,
                        width: 160,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: descriptionTextStyle.copyWith(fontSize: 14),
                    ),
                    Text(
                      time_ago.format(DateTime.parse(article.dateCreated)) ==
                              'a day ago'
                          ? DateFormat(shortNewsDateFormat)
                              .format(DateTime.parse(article.dateCreated))
                          : time_ago
                              .format(DateTime.parse(article.dateCreated)),
                      style: const TextStyle(color: greyColor),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
