class SettingsInfo {
  final String workDir;
  final String webRoot;
  final String template;
  final String templateIndex;
  final String contentTag;
  final String titleTag;
  final String descriptionTag;
  final String keywordsTag;
  String? templateContents;
  String? templateContentsIndex;

  SettingsInfo({
    required this.workDir,
    required this.webRoot,
    required this.template,
    required this.templateIndex,
    required this.contentTag,
    required this.titleTag,
    required this.descriptionTag,
    required this.keywordsTag,
  });

  factory SettingsInfo.fromJson(Map<String, dynamic> json) {
    return SettingsInfo(
      workDir: json['workdir'],
      webRoot: json['webroot'],
      template: json['template'],
      templateIndex: json['templateindex'],
      contentTag: json['contenttag'],
      titleTag: json['titletag'],
      descriptionTag: json['descriptiontag'],
      keywordsTag: json['keywordstag'],
    );
  }
}

class Article {
  final String path;
  final String file;
  final String markdown;
  String? html;
  String? title;
  bool? isBlog;
  String? url;
  String? pubDate;
  String? description;
  String? tags;

  Article({required this.path, required this.file, required this.markdown});
}
