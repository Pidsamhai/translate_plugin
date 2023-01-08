# translate_plugin

Translate plugin to generate translate json file

Detect translate function end with .tr or .trf

ex.

```dart
"hello".tr 
"hello {}".trf(args: ["Jhon"])
```

## Getting Started

- Generate Json file

```bash
flutter pub run translate_plugin
```

- Option
    - --t call translate after generate json
    - --api-key={KEY} google translate api-key if you not define in yml

- Config add to pubspec.yml

```yml
translate_plugin: 
  path: assets/translations // output path
  api-key: // for auto translate from google translate
  skip-translate: // for skip some language when auto translate
  langs:  // support locale
    - en-US
    - th-TH
    - ms-MS
    - zh-ZH
  default: en-US
```

- Generate Utilclass

```dart
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
```

- Basic Use with EasyLocalization

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: TranslatePlugin.supportLocales,
      path: TranslatePlugin.path,
      fallbackLocale: TranslatePlugin.defaultLocales,
      useFallbackTranslations: true,
      child: const MyApp(),
    ),
  );
}
```

