import 'dart:io';
import 'data.dart';
import 'utils.dart';

void generateBlogIndex(List<Article> articles, SettingsInfo settings) {
  var html = "<table>";
  List<Article> blogPosts = articles.where((a) => a.isBlog!).toList();
  blogPosts.sort((Article a, Article b) => b.pubDate!.compareTo(a.pubDate!));

  for (var blog in blogPosts) {
    html =
        "$html<tr><td>${pubDateForBlogIndex(blog.pubDate!)}</td><td><a href='${blog.url!}'>${blog.title!}</a></td><td>&nbsp;</td></tr>\n";
  }

  html = "$html</table>";

  final file = File("${settings.workDir}/index.html");
  var index = file.readAsStringSync();
  index = index.replaceFirst('<x-blog-index/>', html);
  file.writeAsStringSync(index);
}

void generateSitemap(articles, settings) {
  var html = """<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
  xmlns:xhtml="http://www.w3.org/1999/xhtml">""";

  for (var page in articles) {
    html =
        "$html\n<url><loc>${page.url!}</loc><lastmod>${pubDateForSitemap(page.pubDate!)}</lastmod></url>";
  }

  html = "$html\n</urlset>";
  final file = File("${settings.workDir}/sitemap.xml");
  file.writeAsStringSync(html);
}

void generateRSSFeed(articles, settings) {
  var html = """<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>NobenLog</title>
    <link>https://noben.org/blog/</link>
    <description>Recent content on NobenLog</description>
    <generator>site-gen-dart -- https://github.com/keyle/site-gen-dart</generator>
    <language>en-us</language>""";

  List<Article> blogPosts =
      articles.where((Article art) => art.isBlog!).toList();
  blogPosts.sort((Article a, Article b) => b.pubDate!.compareTo(a.pubDate!));

  for (var blog in blogPosts) {
    html =
        "$html<item><title>${blog.title}</title><link>${blog.url}</link><pubDate>${blog.pubDate}</pubDate><guid>${blog.url}</guid><description><![CDATA[ ${blog.description} ]]></description></item>\n";
  }
  html = "$html</channel></rss>\n";

  final file = File("${settings.workDir}/index.xml");
  file.writeAsStringSync(html);
}
