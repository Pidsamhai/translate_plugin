// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:translate_plugin/parser.dart';
import 'package:translate_plugin/template.dart';

import 'translate_plugin_translate.dart';

const translateApiUrl =
    "https://translation.googleapis.com/language/translate/v2";

List<String> matchString(String input) {
// Create a regular expression to detect either of the strings ".tr" or ".tx"
  final regex = RegExp(
    r'''\"+[A-Za-z0-9\-\s{}\[\],$:()]+".tr|\'+[A-Za-z0-9\-\s{}\[\],$:()]+'.tr|''',
  );

  // Use the "allMatches" method to get a list of all matches of the regular expression in the input string
  final matches = regex.allMatches(input).toList();

  // Extract the matched strings from the Match objects and store them in a new list
  final matchedStrings = matches.map((match) => match.group(0)).toList();
  final List<String> result = [];
  for (var e in matchedStrings) {
    if (e != null) {
      result.add(e);
    }
  }
  return result
      .map((e) => e
          .replaceAll('.trf', '')
          .replaceAll('.tr', '')
          .replaceAll("'", "")
          .replaceAll('"', ""))
      .where((element) => element.isNotEmpty)
      .toList();
}

Future<void> generateSupportLocale(
  List<dynamic> supportLocalse,
  String defaultLocale,
  String path,
) async {
  final file = File("lib/utils/translate_plugin.dart");
  await file.create(recursive: true);
  final _supportLocalse = supportLocalse.map((e) {
    final locale = e.split("-");
    return '    Locale("${locale.first}", "${locale.last}")';
  }).join(",\n");
  final _defaultLocale = defaultLocale.split("-");
  final template = supportLocaleTemplate
      .replaceFirst(
        "{{SUPPORT_LOCALES}}",
        _supportLocalse,
      )
      .replaceFirst(
        "{{DEFAULT_LOCALE}}",
        'Locale("${_defaultLocale.first}", "${_defaultLocale.last}")',
      )
      .replaceFirst(
        "{{PATH}}",
        path,
      );
  file.writeAsString(template);
}

void main(List<String> arguments) async {
  bool mustTranslate = arguments.contains("--t");
  final file = Glob("./lib/**.dart");

  final List<String> keys = [];
  List<String> sortSetKey() {
    final setKeys = keys.toSet().toList();
    setKeys.sort();
    return setKeys;
  }

  for (var f in file.listSync()) {
    final input = await File(f.path).readAsString();
    final match = matchString(input);
    keys.addAll(match);
  }

  final Map<String, String> keyValues = {};

  for (var e in sortSetKey()) {
    keyValues[e] = e;
  }

  final yaml = Parser.fromPathToMap(File("pubspec.yaml").path);

  final languages = yaml["translate_plugin"]["langs"];
  final defaultLanguage = yaml["translate_plugin"]["default"];
  final apiKey = yaml["translate_plugin"]["api-key"] ??
      arguments
          .firstWhere(
            (element) => element.startsWith("--api-key"),
            orElse: () => "",
          )
          .split("=")
          .last;
  final path = yaml["translate_plugin"]["path"];

  print("Languages: $languages");
  print("Default Language: $defaultLanguage");
  print("Translate: $mustTranslate");

  for (var lang in languages) {
    final targetString = File("$path/$lang.json");
    await targetString.create(recursive: true);
    final targetExistTranslate = await targetString.readAsString();
    Map<String, dynamic> targetTranslate = {};
    if (targetExistTranslate.isNotEmpty) {
      targetTranslate = jsonDecode(targetExistTranslate);
    }
    for (var e in targetTranslate.keys.toList()) {
      if (keyValues[e] == null) {
        targetTranslate.remove(e);
      }
    }
    for (var e in keyValues.keys.toList()) {
      // print("${translate[e]} ${keyValues}");
      if (targetTranslate[e] == null) {
        targetTranslate[e] = keyValues[e];
      }
    }
    final sorted = Map.fromEntries(targetTranslate.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    const encoder = JsonEncoder.withIndent("  ");
    await targetString.writeAsString(encoder.convert(sorted));
  }

  if (mustTranslate) {
    if (apiKey == null || (apiKey as String).isEmpty) {
      throw Exception("Please provide api key in pubspec.yml or --api-key=KEY");
    }
    await translate(apiKey);
  }

  await generateSupportLocale(
    languages,
    defaultLanguage,
    path,
  );
}
