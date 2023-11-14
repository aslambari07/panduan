import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:anekapanduan/model/article.dart';
import 'package:anekapanduan/screens/article_screen.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:timeago/timeago.dart' as time_ago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArticleCardFour extends StatelessWidget {
  final Article article;
  const ArticleCardFour({
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
          height: article.coverImage.isNotEmpty ? 270 : 150,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  article.coverImage.trim().isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            adminPanelUrl + article.coverImage,
                            height: 190,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const SizedBox(),
                  getVerticalSpace(article.coverImage.isNotEmpty ? 5 : 40),
                  Text(
                    article.title,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
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
              article.isBreaking == '1'
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.breaking_news,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
