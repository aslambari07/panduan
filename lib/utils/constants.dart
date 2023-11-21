import 'package:flutter/material.dart';
import 'package:anekapanduan/model/app_language.dart';
import 'package:anekapanduan/model/onboarding_item.dart';
import 'package:anekapanduan/utils/colors.dart';
import 'package:anekapanduan/utils/images.dart';
import 'package:anekapanduan/utils/strings.dart';

const String appName = 'Aneka Panduan';
const String companyName = 'WEBMEDIA INTERNUSA TATA UTAMA';
const String adminPanelUrl = 'http://192.168.1.11/';
const String firebaseServerKey =
    'AAAAziVUUnY:APA91bFdPBNV-77-HSFo7D1fCNaEZ8Q7slzsby-vZUTMlomgIt8nJ5zbjuDokBpPwhE7iJqOcoupsM8l7fkUbsfMLnxVm-34lzQH8WZmNosPPPMLv0aQ3pyObgqbdLpQZZzpFXSmL3w_';
const Locale defaultAppLanguage = Locale('en');

const List<Locale> appLocales = [
  Locale('en'),
  Locale('hi'),
  Locale('ru'),
  Locale('fr'),
  Locale('de'),
  Locale('id'),
  Locale('ja'),
  Locale('it'),
  Locale('es'),
  Locale('ar')
];

List<AppLanguage> appLanguages = [
  AppLanguage(language: 'Hindi', locale: const Locale('hi')),
  AppLanguage(language: 'English', locale: const Locale('en')),
  AppLanguage(language: 'Russian', locale: const Locale('ru')),
  AppLanguage(language: 'French', locale: const Locale('fr')),
  AppLanguage(language: 'German', locale: const Locale('de')),
  AppLanguage(language: 'Indonesian', locale: const Locale('id')),
  AppLanguage(language: 'Japanese', locale: const Locale('ja')),
  AppLanguage(language: 'Italian', locale: const Locale('it')),
  AppLanguage(language: 'Spanish', locale: const Locale('es')),
  AppLanguage(language: 'Arabic', locale: const Locale('ar')),
];

List<OnboardingItem> onboardingList = [
  OnboardingItem(
      id: 1,
      title: onboardingOneTitle,
      description: onboardingOneDescription,
      image: onboardingIllustrationOne,
      color: const Color(0xFFFFF2C5)),
  OnboardingItem(
      id: 2,
      title: onboardingTwoTitle,
      description: onboardingTwoDescription,
      image: onboardingIllustrationTwo,
      color: const Color(0xFFFBE5E1)),
  OnboardingItem(
      id: 3,
      title: onboardingThreeTitle,
      description: onboardingThreeDescription,
      image: onboardingIllustrationThree,
      color: const Color(0xFFE1F1FF))
];

// TextStyles
const TextStyle primaryButtonTextStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16);

const TextStyle secondaryButtonTextStyle =
    TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16);

const TextStyle headlineOneTextStyle =
    TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.black);

const TextStyle descriptionTextStyle =
    TextStyle(color: greyColor, fontSize: 18);

const TextStyle textButtonTextStyle =
    TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500);
const TextStyle helpingTextStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
const TextStyle trendingNewsHeadlineTextStyle =
    TextStyle(color: Colors.white, fontSize: 18);

const String shortNewsDateFormat = "MMM dd, yyyy";
const String longNewsDateFormat = "MMM dd, yyyy, HH:mm aaa";
