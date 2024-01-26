import 'dart:io';
import 'dart:convert';
import 'package:sitegen/utils.dart';

import 'data.dart';

String? get userHome =>
    Platform.environment['HOME'] ?? // linux/macOS
    Platform.environment['USERPROFILE']; // Windows

Future<SettingsInfo> loadSettings() async {
  try {
    String path = "${userHome!}/.config/site-gen/settings.json";
    final file = File(path);
    String contents = await file.readAsString();
    Map<String, dynamic> settingsMap = jsonDecode(contents);
    SettingsInfo s = SettingsInfo.fromJson(settingsMap);
    s.templateContents = await glob(s.template);
    s.templateContentsIndex = await glob(s.templateIndex);
    return s;
  } catch (e) {
    print("Could not load settings.json, error: $e");
    exit(1);
  }
}
