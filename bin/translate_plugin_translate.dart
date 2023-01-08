// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:translate_plugin/parser.dart';

const translateApiUrl =
    "https://translation.googleapis.com/language/translate/v2";

Future<String?> translateKey({
  required String target,
  required String source,
  required String query,
  required String key,
}) async {
  final res = await http.get(
    Uri.parse(
      "$translateApiUrl?source=$source&target=$target&key=$key&q=$query",
    ),
  );
  if (res.statusCode >= 400) {
    return null;
  }
  final result = jsonDecode(res.body);
  return result["data"]["translations"][0]["translatedText"];
}

Future<void> translate(String apiKey) async {
  final yaml = Parser.fromPathToMap(File("pubspec.yaml").path);

  final languages = List.from(yaml["translate_plugin"]["langs"] as List? ?? []);
  final defaultLanguage = yaml["translate_plugin"]["default"];
  final path = yaml["translate_plugin"]["path"];
  final skipTranslate =
      yaml["translate_plugin"]["skip-translate"] as List? ?? [];

  languages.remove(defaultLanguage);
  languages.removeWhere((element) => skipTranslate.contains(element));

  final fallbackJson =
      await (File("$path/$defaultLanguage.json").readAsString());
  final fallback = jsonDecode(fallbackJson);

  for (var lang in languages) {
    final localeString = File("$path/$lang.json");
    await localeString.create(recursive: true);
    final existTranslate = await localeString.readAsString();
    Map<String, dynamic> target = {};
    if (existTranslate.isNotEmpty) {
      target = jsonDecode(existTranslate);
    }
    for (var e in target.keys.toList()) {
      if (target[e] == e) {
        final translateValue = await translateKey(
          target: (lang as String).split("-").first,
          source: (defaultLanguage as String).split("-").first,
          query: fallback[e],
          key: apiKey,
        );
        if (translateValue != null) {
          target[e] = translateValue;
        }
      }
    }
    final sorted = Map.fromEntries(
        target.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    const encoder = JsonEncoder.withIndent("  ");
    await localeString.writeAsString(encoder.convert(sorted));
  }
}
