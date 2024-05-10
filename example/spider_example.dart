import 'package:strict_lints/strict_lints.dart';
import 'package:terminal_decorate/terminal_decorate.dart';

void main() async {
  print('getting from: ${site.cyan}'.blue);
  print('...'.dim);

  final rules = await spider();
  var count = 0;
  for (final name in rules.keys) {
    final status = rules[name]!;
    print([
      () {
        if (status.hasReuse) return name.dim;
        if (status.removed) return name.red.crossLine;
        if (status.unreleased) return name.yellow.crossLine;
        count++;
        if (status.hasFix) return name.green;
        return name;
      }(),
      if (status.isNotEmpty) '(${status.format})'.dim,
    ].join(' '));
  }
  print(
    '\n'
    'all ${rules.keys.length.toString().blue} rules, '
    '${count.toString().green} configurable rules.'
    '\n',
  );
}
