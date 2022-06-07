#### flutter_expandable_table
# Expandable Table
[![Pub Package](https://img.shields.io/pub/v/flutter_expandable_table.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_expandable_table)
[![likes](https://badges.bar/flutter_expandable_table/likes)](https://pub.dev/packages/flutter_expandable_table/score)
[![popularity](https://badges.bar/flutter_expandable_table/popularity)](https://pub.dev/packages/flutter_expandable_table/score)
[![pub points](https://badges.bar/flutter_expandable_table/pub%20points)](https://pub.dev/packages/flutter_expandable_table/score)

 [![Package Issue](https://img.shields.io/github/issues/rickypid/flutter_expandable_table)](https://github.com/rickypid/flutter_expandable_table/issues)
![Package License](https://img.shields.io/github/license/rickypid/flutter_expandable_table)

`ExpandableTable` is a widget for Flutter that create a Table with header and first column fixed. You can create a nested Rows/Columns grouped in expandable Row/Column

| ![Image](https://github.com/rickypid/flutter_expandable_table/blob/master/doc/.media/example.gif?raw=true) |
| :------------: |
| **ExpandableTable** |

## Features
* Header and first column fixed
* Supports vertical and horizontal scroll
* Customizable animation Duration and Curve

&nbsp;

## Usage
Make sure to check out the [examples on GitHub](https://github.com/rickypid/flutter_expandable_table/tree/master/example).

### Installation
Add the following line to `pubspec.yaml`:
```yaml
dependencies:
  flutter_expandable_table: <last-release>
```

### Basic setup
*Complete example [available here](https://github.com/rickypid/flutter_expandable_table/blob/master/example/lib/main.dart).*

```dart
ExpandableTable(
      rows: rows,
      header: header,
      scrollShadowColor: accentColor,
    );
```

### ExpandableTable Properties
* `header`: Contain a table header widget.
* `rows`: Contain a table body rows widget.
* `cellWidth`: determines default cell width size, this is overwritable with cell property.
* `cellHeight`: determines default cell height size, this is overwritable with row property.
* `headerHeight`: determines Header Row height size.
* `firstColumnWidth`: determines first Column width size.
* `duration`: determines duration rendered animation of Rows/Columns expansion.
* `curve`: determines rendered curve animation of Rows/Columns expansion.
* `scrollShadowDuration`: determines duration rendered animation of shadows.
* `scrollShadowCurve`: determines rendered curve animation of shadows.
* `scrollShadowColor`: determines rendered color of shadows.
* `visibleScrollbar`: determines visibility of scrollbar.

&nbsp;

## 📚 My other packages

### Flutter

| Package | Verison | Score | Likes | Test | Coverage |
|--|--|--|--|--|--|
| [![](https://img.shields.io/static/v1?label=flutter&message=flutter_expandable_table&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/flutter_expandable_table) | [![Pub Package](https://img.shields.io/pub/v/flutter_expandable_table.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_expandable_table) | [![pub points](https://badges.bar/flutter_expandable_table/pub%20points)](https://pub.dev/packages/flutter_expandable_table/score) | [![likes](https://badges.bar/flutter_expandable_table/likes)](https://pub.dev/packages/flutter_expandable_table/score) |  |  |
| [![](https://img.shields.io/static/v1?label=flutter&message=widget_tree_depth_counter&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/widget_tree_depth_counter) | [![Pub Package](https://img.shields.io/pub/v/widget_tree_depth_counter.svg?style=flat-square)](https://pub.dartlang.org/packages/widget_tree_depth_counter) | [![pub points](https://badges.bar/widget_tree_depth_counter/pub%20points)](https://pub.dev/packages/widget_tree_depth_counter/score) | [![likes](https://badges.bar/widget_tree_depth_counter/likes)](https://pub.dev/packages/widget_tree_depth_counter/score) |  |  |
| [![](https://img.shields.io/static/v1?label=flutter&message=flutter_scroll_shadow&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/flutter_scroll_shadow) | [![Pub Package](https://img.shields.io/pub/v/flutter_scroll_shadow.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_scroll_shadow) | [![pub points](https://badges.bar/flutter_scroll_shadow/pub%20points)](https://pub.dev/packages/flutter_scroll_shadow/score) | [![likes](https://badges.bar/flutter_scroll_shadow/likes)](https://pub.dev/packages/flutter_scroll_shadow/score) |  |  |
| [![](https://img.shields.io/static/v1?label=flutter&message=flutter_bargraph&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/flutter_bargraph) | [![Pub Package](https://img.shields.io/pub/v/flutter_bargraph.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_bargraph) | [![pub points](https://badges.bar/flutter_bargraph/pub%20points)](https://pub.dev/packages/flutter_bargraph/score) | [![likes](https://badges.bar/flutter_bargraph/likes)](https://pub.dev/packages/flutter_bargraph/score) |  |  |


### Dart

| Package | Verison | Score | Likes | Test | Coverage |
|--|--|--|--|--|--|
| [![](https://img.shields.io/static/v1?label=dart&message=cowsay&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/cowsay) | [![Pub Package](https://img.shields.io/pub/v/cowsay.svg?style=flat-square)](https://pub.dartlang.org/packages/cowsay) | [![pub points](https://badges.bar/cowsay/pub%20points)](https://pub.dev/packages/cowsay/score) | [![likes](https://badges.bar/cowsay/likes)](https://pub.dev/packages/cowsay/score) | [![Test CI](https://github.com/rickypid/cowsay/actions/workflows/test.yml/badge.svg)](https://github.com/rickypid/cowsay/actions/workflows/test.yml) | [![codecov](https://codecov.io/gh/rickypid/cowsay/branch/master/graph/badge.svg?token=Z65KEB9SAX)](https://codecov.io/gh/rickypid/cowsay) |
| [![](https://img.shields.io/static/v1?label=dart&message=telegram_link&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/telegram_link) | [![Pub Package](https://img.shields.io/pub/v/telegram_link.svg?style=flat-square)](https://pub.dartlang.org/packages/telegram_link) | [![pub points](https://badges.bar/telegram_link/pub%20points)](https://pub.dev/packages/telegram_link/score) | [![likes](https://badges.bar/telegram_link/likes)](https://pub.dev/packages/telegram_link/score) | [![Test CI](https://github.com/rickypid/telegram_link/actions/workflows/test.yml/badge.svg)](https://github.com/rickypid/telegram_link/actions/workflows/test.yml) | [![codecov](https://codecov.io/gh/rickypid/telegram_link/branch/main/graph/badge.svg?token=Z65KEB9SAX)](https://codecov.io/gh/rickypid/telegram_link) |