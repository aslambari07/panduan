import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:anekapanduan/model/video_article.dart';
import 'package:anekapanduan/screens/video_screen.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/spacer.dart';

class VideoArticleCard extends StatelessWidget {
  final VideoArticle videoArticle;
  final VoidCallback onPressed;
  const VideoArticleCard({
    super.key,
    required this.videoArticle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoScreen(videoArticle: videoArticle),
              ));
        },
        child: Row(children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  adminPanelUrl + videoArticle.thumbnail,
                  width: 170,
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(
                    videoIconFilled,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              )
            ],
          ),
          getHorizontalSpace(5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videoArticle.title,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                getVerticalSpace(5),
                Text(
                  videoArticle.description,
                  maxLines: 3,
                ),
                getVerticalSpace(10),
                Text(DateFormat(shortNewsDateFormat)
                    .format(DateTime.parse(videoArticle.dateCreated)))
              ],
            ),
          )
        ]),
      ),
    );
  }
}
