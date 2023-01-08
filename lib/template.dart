const supportLocaleTemplate = r'''
import 'package:flutter/widgets.dart';

abstract class TranslatePlugin {
  static const supportLocales = [
{{SUPPORT_LOCALES}},
  ];

  static const defaultLocales = {{DEFAULT_LOCALE}};

  static const path = "{{PATH}}";
}
''';
