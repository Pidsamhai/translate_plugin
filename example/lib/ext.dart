import 'package:easy_localization/easy_localization.dart' as e;

extension StringExts on String {
  String get tr {
    return e.tr(this);
  }

  String trf(List<String> args) {
    return e.tr(this, args: args);
  }
}
