// ignore: unused_import
import 'package:easy_localization/easy_localization.dart' as e;
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

  static Locale get systemOrDefaultLocale {
    final systemLocale = WidgetsBinding.instance.window.locale;
    try {
      return TranslatePlugin.supportLocales.firstWhere(
        (element) => element.languageCode == systemLocale.languageCode,
      );
    } catch (e) {
      return defaultLocales;
    }
  }
}

extension StringExts on String {
  String get tr {
    return e.tr(this);
  }

  String trf(List<String> args) {
    return e.tr(this, args: args);
  }
}
