import 'package:flutter/material.dart';
import 'package:anekapanduan/components/neews_back_button.dart';
import 'package:anekapanduan/components/neews_button.dart';
import 'package:anekapanduan/utils/constants.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/spacer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ncodeslab@email.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Example Subject & Symbols are allowed!',
      }),
    );

    await launchUrl(emailLaunchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerticalSpace(20),
              const NeewsBackButton(),
              getVerticalSpace(20),
              Text(
                AppLocalizations.of(context)!.contact_us,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              getVerticalSpace(20),
              Center(
                child: Image.asset(
                  contactUsIllustration,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              getVerticalSpace(10),
              Text(
                AppLocalizations.of(context)!.contact_us_description,
                textAlign: TextAlign.center,
                style: descriptionTextStyle.copyWith(fontSize: 16),
              ),
              getVerticalSpace(20),
              NeewsButton(
                  child: Text(
                    AppLocalizations.of(context)!.send_mail,
                    style: primaryButtonTextStyle,
                  ),
                  onPressed: () {
                    sendEmail();
                  })
            ],
          ),
        ),
      )),
    );
  }
}
