import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

/// Link to the website of the source API docs.
const site = 'https://dart.dev/tools/linter-rules';

typedef Rules = Map<String, RuleStatus>;

Future<Rules> spider({String site = site, bool showDetails = false}) async {
  final response = await http.get(Uri.parse(site));
  if (response.statusCode != HttpStatus.ok) {
    throw Exception('cannot spider: $site, code: ${response.statusCode}');
  }

  final document = html.parse(response.body);
  final handler = <String, RuleStatus>{};
  for (final element in document.querySelectorAll('p')) {
    try {
      handler[parseRuleName(element)] = RuleStatus.parse(element);
    } on InvalidDomStructure catch (e) {
      if (showDetails) print(e);
    }
  }
  return handler;
}

String parseRuleName(Element element) {
  final link = element.getElementsByTagName('a').firstOrNull;
  const linkPrefix = '/tools/linter-rules/';
  if (link?.attributes['href']?.startsWith(linkPrefix) ?? false) {
    final name = link!.getElementsByTagName('code').firstOrNull?.text;
    if (name != null) return name;
  }
  throw InvalidDomStructure(element);
}

class RuleStatus {
  const RuleStatus({
    this.hasFix = false,
    this.styleCore = false,
    this.styleFlutter = false,
    this.styleRecommended = false,
    this.removed = false,
    this.unreleased = false,
    this.experimental = false,
  });

  factory RuleStatus.parse(Element element) {
    String imgSrc(String key) => '/assets/img/tools/linter/$key.svg';
    var hasFix = false;
    var styleCore = false;
    var styleFlutter = false;
    var styleRecommended = false;
    for (final item in element.querySelectorAll('a>img')) {
      final src = item.attributes['src'];
      if (src == imgSrc('has-fix')) hasFix = true;
      if (src == imgSrc('style-core')) styleCore = true;
      if (src == imgSrc('style-flutter')) styleFlutter = true;
      if (src == imgSrc('style-recommended')) styleRecommended = true;
    }

    String emContent(String key) => '($key)';
    var removed = false;
    var unreleased = false;
    var experimental = false;
    for (final item in element.querySelectorAll('em')) {
      final text = item.text;
      if (text == emContent('Removed')) removed = true;
      if (text == emContent('Unreleased')) unreleased = true;
      if (text == emContent('Experimental')) experimental = true;
    }

    return RuleStatus(
      hasFix: hasFix,
      styleCore: styleCore,
      styleFlutter: styleFlutter,
      styleRecommended: styleRecommended,
      removed: removed,
      unreleased: unreleased,
      experimental: experimental,
    );
  }

  // Status decorated with icons.
  final bool hasFix;
  final bool styleCore;
  final bool styleFlutter;
  final bool styleRecommended;

  // Status decorated with inline italic text.
  final bool removed;
  final bool unreleased;
  final bool experimental;

  String get format => [
        if (hasFix) 'has-fix',
        if (styleCore) 'style-core',
        if (styleFlutter) 'style-flutter',
        if (styleRecommended) 'style-recommended',
        if (removed) 'removed',
        if (unreleased) 'unreleased',
        if (experimental) 'experimental',
      ].join(', ');

  @override
  String toString() => '$RuleStatus($format)';
}

class InvalidDomStructure implements Exception {
  const InvalidDomStructure(this.element);

  final Element element;

  @override
  String toString() => 'invalid dom structure ${element.innerHtml}';
}
