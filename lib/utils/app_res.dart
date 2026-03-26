import 'package:bubbly/utils/const_res.dart';

class AppRes {
  static const String emptyName = 'Unknown';
  static const String fiftySecond = '15s';
  static const String thirtySecond = '30s';
  static const String imageMessage = '🖼️ Image';
  static const String videoMessage = '🎥 Video';
  static const String hashTag = '#';
  static const String atSign = '@';
  static const String look = 'Look';
  static const String maxLengthText = '175'; // upload video sheet maxLength

  static String redeemTitle(String value) {
    return '1000 $appName = $value USD';
  }

  static String whatReport(int type) {
    return 'Report ${type == 1 ? 'Post' : 'User'}';
  }

  static String checkOutThisAmazingProfile(dynamic result) {
    return 'Check out this amazing profile $result 😋😋';
  }

  static String minimumFansForLive(int coin) =>
      'Minimum $coin fans required to start livestream!';
  static const String policy1 = 'By continuing, you agree to ';
  static const String policy2 = 'Terms of use ';
  static const String policy3 = 'and confirm that you have read our ';
  static const String policy4 = 'Privacy policy.';

  static List<Map<String, dynamic>> languages = [
    {
      'title': 'عربي',
      'subHeading': 'Arabic',
      'key': 'ar',
    },
    {
      'title': 'dansk',
      'subHeading': 'Danish',
      'key': 'da',
    },
    {
      'title': 'Nederlands',
      'subHeading': 'Dutch',
      'key': 'nl',
    },
    {
      'title': 'English',
      'subHeading': 'English',
      'key': 'en',
    },
    {
      'title': 'Français',
      'subHeading': 'French',
      'key': 'fr',
    },
    {
      'title': 'Deutsch',
      'subHeading': 'German',
      'key': 'de',
    },
    {
      'title': 'Ελληνικά',
      'subHeading': 'Greek',
      'key': 'el',
    },
    {
      'title': 'हिंदी',
      'subHeading': 'Hindi',
      'key': 'hi',
    },
    {
      'title': 'bahasa Indonesia',
      'subHeading': 'Indonesian',
      'key': 'id',
    },
    {
      'title': 'Italiano',
      'subHeading': 'Italian',
      'key': 'it',
    },
    {
      'title': '日本',
      'subHeading': 'Japanese',
      'key': 'ja',
    },
    {
      'title': '한국인',
      'subHeading': 'Korean',
      'key': 'ko',
    },
    {
      'title': 'Norsk Bokmal',
      'subHeading': 'Norwegian Bokmal',
      'key': 'nb',
    },
    {
      'title': 'Polski',
      'subHeading': 'Polish',
      'key': 'pl',
    },
    {
      'title': 'Português',
      'subHeading': 'Portuguese',
      'key': 'pt',
    },
    {
      'title': 'Русский',
      'subHeading': 'Russian',
      'key': 'ru',
    },
    {
      'title': '简体中文',
      'subHeading': 'Simplified Chinese',
      'key': 'zh',
    },
    {
      'title': 'Español',
      'subHeading': 'Spanish',
      'key': 'es',
    },
    {
      'title': 'แบบไทย',
      'subHeading': 'Thai',
      'key': 'th',
    },
    {
      'title': 'Türkçe',
      'subHeading': 'Turkish',
      'key': 'tr',
    },
    {
      'title': 'Tiếng Việt',
      'subHeading': 'Vietnamese',
      'key': 'vi',
    },
  ];
}
