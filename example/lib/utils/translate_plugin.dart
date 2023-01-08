import 'package:flutter/widgets.dart';

abstract class TranslatePlugin {
  static const supportLocales = [
    Locale("en", "US"),
    Locale("th", "TH"),
    Locale("ms", "MS"),
    Locale("zh", "ZH"),
  ];

  static const defaultLocales = Locale("en", "US");

  static const path = "assets/translations";
}
