import 'dart:io';
import 'package:intl/intl.dart';

Iterable<FileSystemEntity> findMarkdownFiles(String path) {
  var directory = Directory(path);

  if (!directory.existsSync()) {
    print('Could not find directory to parse: $path');
    exit(1);
  }

  var markdownFiles = directory
      .listSync(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.md'));

  return markdownFiles;
}

Future<String> glob(String filePath) async {
  final file = File(filePath);
  return await file.readAsString();
}

String globSync(String filePath) {
  final file = File(filePath);
  return file.readAsStringSync();
}

String parseSelector(String selector, String haystack) {
  return haystack.split("<$selector>").last.split("</$selector>").first;
}

// Now as 2023-06-06 22:45
String pubDateFromNow() {
  return DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
}

// "2023-06-18" -> "Jun 18, 2023"
String pubDateForBlogIndex(String date) {
  DateTime dt = DateTime.parse(date);
  return DateFormat('MMM dd, yyyy').format(dt);
}

// 2023-06-06 22:45 -> 2023-06-06
String pubDateForSitemap(String date) {
  return date.split(' ').first;
}
