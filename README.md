# Strict Lints

A strict linter config that enable as much rules as possible,
and this package also contains the infrastructure to spider all latest APIs
from the official documentation website of dart lints.

A strict coding rule will help you to prevent 💩 from your code.
Although there are existing official linter options such as
the packages [lints](https://pub.dev/packages/lints)
and [flutter_lints](https://pub.dev/packages/flutter_lints),
those rules are too loose to be productive.
That's why this package exists,
which enables as much rules as possible.

## How to use

Add this package into `dev_dependencies`
and `include` it inside the `analysis_options.yaml` file.
Followings are the example codes.
But please pay attention that the following codes may just
be a part of the file rather than the full file.
And the version code are marked as `x.y.z`,
please replace it with the exact version that you require.

```yaml
# pubspec.yaml
dev_dependencies:
  strict_lints: ^x.y.z
```

```yaml
# analysis_options.yaml
include: package:aprosail_lints/lints.yaml
```

This package is similar to the `lints` and `flutter_lints` package.
Once add this package into `dev_dependencies`,
those two packages can be removed from the `dev_dependencies` list.

## Principle

This package copies all possible options from the API
on the [official site](https://pub.dev/packages/lints)
except they are deprecated, conflicted,
or already enabled in the `flutter_lints` package,
which is already a dependency of current package.

All options except the ones enabled in `flutter_lints`
are listed in the [source file](./lib/ilnts.yaml).
And all disabled options will be commented the reason.

You can read the documentation
on the [official site](https://pub.dev/packages/lints) carefully.
And you can click into the option titles,
which are links to the more detailed doc with examples.
All the linter options are well designed and useful.
So that the author of this package is willing to enable them
as much as possible.
