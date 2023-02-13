import 'package:flutter/widgets.dart';

abstract class TranslatePlugin {
  static const supportLocales = [
    Locale("en"),
    Locale("th"),
    Locale("ms"),
    Locale("zh"),
  ];

  static const defaultLocales = Locale("en");

  static const path = "assets/translations";
}
