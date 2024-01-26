import 'package:sitegen/settings.dart';
import 'package:sitegen/processor.dart';
import 'package:sitegen/generator.dart';
import 'package:sitegen/utils.dart';

main() async {
  final settings = await loadSettings();
  final files = findMarkdownFiles(settings.workDir);
  final articles = await generateArticles(files);

  await Future.wait(
      articles.map((e) async => await processArticle(e, settings)));

  generateBlogIndex(articles, settings);
  generateSitemap(articles, settings);
  generateRSSFeed(articles, settings);
}
