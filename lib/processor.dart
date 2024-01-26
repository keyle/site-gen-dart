import 'dart:io';
import 'package:markdown/markdown.dart';
import 'data.dart';
import 'utils.dart';

List<Article> generateArticles(Iterable<FileSystemEntity> files) {
  final List<Article> list = [];

  for (var filePath in files) {
    final file = File(filePath.path);
    final article = Article(
        path: file.path,
        file: file.path.split('/').last,
        markdown: file.readAsStringSync());
    list.add(article);
  }
  return list;
}

Article processArticle(Article article, SettingsInfo settings) {
  article.isBlog = article.markdown.contains('<x-blog-title>');

  // convert and place new html in place of content tag in template
  article.html = article.markdown.contains('<x-index/>')
      ? settings.templateContentsIndex!
      : settings.templateContents!;

  final converted = markdownToHtml(article.markdown,
      extensionSet: ExtensionSet.gitHubFlavored);

  article.html = article.html!.replaceFirst(settings.contentTag, converted);

  // place the new title in place of titleTag
  final mdTitleTag = article.isBlog! ? 'x-blog-title' : 'x-title';
  article.title = parseSelector(mdTitleTag, article.markdown);
  article.html = article.html!.replaceFirst(settings.titleTag, article.title!);

  // set class blog if needed, set pub date to date of blog post or today for pages
  if (article.isBlog!) {
    article.html = article.html!.replaceFirst('<body>', "<body class='blog'>");
    article.pubDate = parseSelector('sub', article.markdown);
  } else {
    article.pubDate = pubDateFromNow();
  }

  // parse and get tags/keywords
  article.tags = parseSelector('x-tags', article.markdown);
  // parse and get description
  article.description = parseSelector('x-desc', article.markdown);

  // populate the vanity urls
  article.url = (settings.webRoot + article.path)
      .split(settings.workDir)
      .join('')
      .split(article.file)
      .join('');

  // replace title in template
  article.html = article.html!.replaceFirst(settings.titleTag, article.title!);
  // replace meta keywords in template
  article.html =
      article.html!.replaceFirst(settings.keywordsTag, article.tags!);
  // replace description in template

  article.html =
      article.html!.replaceAll(settings.descriptionTag, article.description!);

  // save contents of html into the filepath folder / index.html
  final target = article.path.split(article.file).join('index.html');
  final file = File(target);
  file.writeAsStringSync(article.html!);

  return article;
}
