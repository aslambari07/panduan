import 'package:flutter/material.dart';
import 'package:anekapanduan/components/api_result_widget.dart';
import 'package:anekapanduan/components/neews_back_button.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/networking/neews_networking.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  String privacyPolicy = '';

  Future<void> getInfo() async {
    var apiResponse = await fetchAppInformation();

    if (apiResponse['status_code'] == 0) {
      privacyPolicy = apiResponse['privacy_policy'];
    }
  }

  @override
  void initState() {
    super.initState();
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
              getVerticalSpace(20),
              Text(
                AppLocalizations.of(context)!.privacy_policy,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              getVerticalSpace(20),
              FutureBuilder(
                future: getInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  } else if (snapshot.hasError) {
                    return ApiResultWidget(
                        title: AppLocalizations.of(context)!.error_occurred,
                        image: errorIllustration);
                  } else {
                    return Text(
                      privacyPolicy,
                      style: const TextStyle(fontSize: 16),
                    );
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}
