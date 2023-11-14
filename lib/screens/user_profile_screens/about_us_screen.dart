import 'dart:async';
import 'package:flutter/material.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/components/neews_back_button.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String aboutUs = '';

  Future<void> getInfo() async {
    var apiResponse = await fetchAppInformation();

    if (apiResponse['status_code'] == 0) {
      aboutUs = apiResponse['about_us'];
    }
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getVerticalSpace(20),
                const NeewsBackButton(),
                getVerticalSpace(10),
                Text(
                  AppLocalizations.of(context)!.about_us,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                getVerticalSpace(20),
                FutureBuilder(
                  future: getInfo(),
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
                      return Text(
                        aboutUs,
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    }
                  },
                ),
                getVerticalSpace(20),
                InkWell(
                  onTap: () async {
                    await launchUrl(Uri.parse('https://icons8.com/'));
                  },
                  child: const Text(
                    'Beautiful Illustrations by Icons8',
                    style: TextStyle(
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: primaryColor),
                  ),
                ),
                getVerticalSpace(20),
              ],
            )),
      )),
    );
  }
}

class TextShimmer extends StatelessWidget {
  const TextShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Shimmer.fromColors(
        baseColor: getShimmerBaseColor(context),
        highlightColor: getShimmerHighlightColor(context),
        child: Container(
          width: double.infinity,
          height: 30,
          decoration: BoxDecoration(
              color: shimmerHighlightColor,
              borderRadius: BorderRadius.circular(5)),
        ),
      ),
    );
  }
}
