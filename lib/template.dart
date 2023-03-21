const supportLocaleTemplate = r'''
// ignore: unused_import
import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/widgets.dart';

abstract class {{CLASS_NAME}} {
  static const supportLocales = [
{{SUPPORT_LOCALES}},
  ];

  static const defaultLocales = {{DEFAULT_LOCALE}};

  static const path = "{{PATH}}";

  Locale get systemOrDefaultLocale {
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

{{EXTENSION}}
''';

const extension = r'''
extension StringExts on String {
  String get tr {
    return e.tr(this);
  }

  String trf(List<String> args) {
    return e.tr(this, args: args);
  }
}
''';

const pluginPath = "/lib/utils";
const pluginClassName = "TranslatePlugin";
const pluginClassFileName = "translate_plugin";
