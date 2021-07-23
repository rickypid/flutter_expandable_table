#### flutter_expandable_table
# Expandable Table

[![Pub Package](https://img.shields.io/pub/v/flutter_expandable_table.svg?style=flat-square)](https://pub.dartlang.org/packages/flutter_expandable_table) [![Package Issue](https://img.shields.io/github/issues/rickypid/flutter_expandable_table)](https://github.com/rickypid/flutter_expandable_table/issues)
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

&nbsp;

