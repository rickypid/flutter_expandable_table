#### flutter_expandable_table
# Expandable Table

[![](https://img.shields.io/static/v1?label=flutter&message=flutter_expandable_table&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/flutter_expandable_table)
[![Pub Package](https://img.shields.io/pub/v/flutter_expandable_table.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_expandable_table)
[![Pub Points](https://img.shields.io/pub/points/flutter_expandable_table)](https://pub.dev/packages/flutter_expandable_table/score)
[![Pub Likes](https://img.shields.io/pub/likes/flutter_expandable_table)](https://pub.dev/packages/flutter_expandable_table/score)

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
* Specific height definition for each single row
* Specific width definition for each single column
* Access to cell address when building cell content
* Access to the parent rows and columns of the cell while building the contents of a cell

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
    return ExpandableTable(
      firstHeaderCell: ExpandableTableCell(
        child: Text('Simple\nTable'),
      ),
      headers: headers,
      rows: rows,
    );
```

### Use with the controller

You can create an external controller to be able to dynamically manage the table, for example to add or remove rows within it.

Here is an example:

```dart
    //... Inside Widget State
    late ExpandableTableController controller;
    //....
    @override
    void initState() {
      controller = ExpandableTableController(
        firstHeaderCell: ExpandableTableCell(child: Container()),
        headers: [],
        rows: [],
        headerHeight: 263,
        defaultsColumnWidth: 200,
        firstColumnWidth: 300,
        scrollShadowColor: AppColors.black,
      );
      super.initState();
    }
    void _onEvent(){    
      controller.rows.add(...your code...);
    }
    @override
    Widget build(BuildContext context) {
      return ExpandableTable(
        controller: controller,
      );
    }
//....
```

### ExpandableTable Properties
* `firstHeaderCell`: Is the top left cell, i.e. the first header cell.
* `headers`: contains the list of all column headers, each one of these can contain a list of further headers, this allows you to create nested and expandable columns.
* `rows`: ontains the list of all the rows of the table, each of these can contain a list of further rows, this allows you to create nested and expandable rows.
* `headerHeight`: is the height of each column header, i.e. the first row.
* `firstColumnWidth`: determines first Column width size.
* `defaultsColumnWidth`: defines the default width of all columns, it is possible to redefine it for each individual column.
* `defaultsRowHeight`: defines the default height of all rows, it is possible to redefine it for every single row.
* `duration`: determines duration rendered animation of Rows/Columns expansion.
* `curve`: determines rendered curve animation of Rows/Columns expansion.
* `scrollShadowDuration`: determines duration rendered animation of shadows.
* `scrollShadowFadeInCurve`: determines rendered curve animation of shadows appearance.
* `scrollShadowFadeOutCurve`: determines rendered curve animation of shadows disappearance.
* `scrollShadowColor`: determines rendered color of shadows.
* `scrollShadowSize`: determines size of shadows.
* `visibleScrollbar`: determines visibility of scrollbar.

&nbsp;

## 📚 My open source projects

### Flutter

| Package | Verison | Score | Likes | Test | Coverage |
|--|--|--|--|--|--|
| [![](https://img.shields.io/static/v1?label=flutter&message=flutter_expandable_table&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/flutter_expandable_table) | [![Pub Package](https://img.shields.io/pub/v/flutter_expandable_table.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_expandable_table) | [![Pub Points](https://img.shields.io/pub/points/flutter_expandable_table)](https://pub.dev/packages/flutter_expandable_table/score) | [![Pub Likes](https://img.shields.io/pub/likes/flutter_expandable_table)](https://pub.dev/packages/flutter_expandable_table/score) |  |  |
| [![](https://img.shields.io/static/v1?label=flutter&message=widget_tree_depth_counter&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/widget_tree_depth_counter) | [![Pub Package](https://img.shields.io/pub/v/widget_tree_depth_counter.svg?style=flat-square)](https://pub.dartlang.org/packages/widget_tree_depth_counter) | [![Pub Points](https://img.shields.io/pub/points/widget_tree_depth_counter)](https://pub.dev/packages/widget_tree_depth_counter/score) | [![Pub Likes](https://img.shields.io/pub/likes/widget_tree_depth_counter)](https://pub.dev/packages/widget_tree_depth_counter/score) |  |  |
| [![](https://img.shields.io/static/v1?label=flutter&message=flutter_scroll_shadow&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/flutter_scroll_shadow) | [![Pub Package](https://img.shields.io/pub/v/flutter_scroll_shadow.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_scroll_shadow) | [![Pub Points](https://img.shields.io/pub/points/flutter_scroll_shadow)](https://pub.dev/packages/flutter_scroll_shadow/score) | [![Pub Likes](https://img.shields.io/pub/likes/flutter_scroll_shadow)](https://pub.dev/packages/flutter_scroll_shadow/score) |  |  |
| [![](https://img.shields.io/static/v1?label=flutter&message=flutter_bargraph&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/flutter_bargraph) | [![Pub Package](https://img.shields.io/pub/v/flutter_bargraph.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_bargraph) | [![Pub Points](https://img.shields.io/pub/points/flutter_bargraph)](https://pub.dev/packages/flutter_bargraph/score) | [![Pub Likes](https://img.shields.io/pub/likes/flutter_bargraph)](https://pub.dev/packages/flutter_bargraph/score) |  |  |


### Dart

| Package | Verison | Score | Likes | Test | Coverage |
|--|--|--|--|--|--|
| [![](https://img.shields.io/static/v1?label=dart&message=cowsay&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/cowsay) | [![Pub Package](https://img.shields.io/pub/v/cowsay.svg?style=flat-square)](https://pub.dartlang.org/packages/cowsay) | [![Pub Points](https://img.shields.io/pub/points/cowsay)](https://pub.dev/packages/cowsay/score) | [![Pub Likes](https://img.shields.io/pub/likes/cowsay)](https://pub.dev/packages/cowsay/score) | [![Test CI](https://github.com/rickypid/cowsay/actions/workflows/test.yml/badge.svg)](https://github.com/rickypid/cowsay/actions/workflows/test.yml) | [![codecov](https://codecov.io/gh/rickypid/cowsay/branch/master/graph/badge.svg?token=Z65KEB9SAX)](https://codecov.io/gh/rickypid/cowsay) |
| [![](https://img.shields.io/static/v1?label=dart&message=telegram_link&color=red??style=for-the-badge&logo=GitHub)](https://github.com/rickypid/telegram_link) | [![Pub Package](https://img.shields.io/pub/v/telegram_link.svg?style=flat-square)](https://pub.dartlang.org/packages/telegram_link) | [![Pub Points](https://img.shields.io/pub/points/telegram_link)](https://pub.dev/packages/telegram_link/score) | [![Pub Likes](https://img.shields.io/pub/likes/telegram_link)](https://pub.dev/packages/telegram_link/score) | [![Test CI](https://github.com/rickypid/telegram_link/actions/workflows/test.yml/badge.svg)](https://github.com/rickypid/telegram_link/actions/workflows/test.yml) | [![codecov](https://codecov.io/gh/rickypid/telegram_link/branch/main/graph/badge.svg?token=Z65KEB9SAX)](https://codecov.io/gh/rickypid/telegram_link) |