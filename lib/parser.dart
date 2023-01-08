import 'dart:io';

import 'package:yaml/yaml.dart';

abstract class Parser {
  static Map fromPathToMap(String path) {
    final File file = File(path);
    final String yamlString = file.readAsStringSync();
    final Map yamlMap = loadYaml(yamlString);
    return yamlMap;
  }
}
