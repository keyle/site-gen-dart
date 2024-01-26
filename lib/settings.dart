import 'dart:io';
import 'dart:convert';
import 'package:sitegen/utils.dart';

import 'data.dart';

String? get userHome =>
    Platform.environment['HOME'] ?? // linux/macOS
    Platform.environment['USERPROFILE']; // Windows

SettingsInfo loadSettings() {
  try {
    String contents = glob("${userHome!}/.config/site-gen/settings.json");
    Map<String, dynamic> settingsMap = jsonDecode(contents);
    SettingsInfo s = SettingsInfo.fromJson(settingsMap);
    s.templateContents = glob(s.template);
    s.templateContentsIndex = glob(s.templateIndex);
    return s;
  } catch (e) {
    print("Could not load settings.json, error: $e");
    exit(1);
  }
}
