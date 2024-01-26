import 'package:sitegen/settings.dart';
import 'package:sitegen/processor.dart';
import 'package:sitegen/generator.dart';
import 'package:sitegen/utils.dart';

main() {
  final settings = loadSettings();
  final files = findMarkdownFiles(settings.workDir);
  var articles = generateArticles(files);

  for (var element in articles) {
    processArticle(element, settings);
  }

  generateBlogIndex(articles, settings);
  generateSitemap(articles, settings);
  generateRSSFeed(articles, settings);
}
