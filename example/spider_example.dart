import 'package:strict_lints/strict_lints.dart';

void main() async {
  final rules = await spider();
  for (final name in rules.keys) {
    print('$name: ${rules[name]!.format}');
  }
}
