import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class ExpandableTableData extends ChangeNotifier {
  late double _headerHeight;

  double get headerHeight => _headerHeight;

  set headerHeight(double value) {
    _headerHeight = value;
    notifyListeners();
  }

  late double _firstColumnWidth;

  double get firstColumnWidth => _firstColumnWidth;

  set firstColumnWidth(double value) {
    _firstColumnWidth = value;
    notifyListeners();
  }

  late double _defaultsColumnWidth;

  double get defaultsColumnWidth => _defaultsColumnWidth;

  set defaultsColumnWidth(double value) {
    _defaultsColumnWidth = value;
    notifyListeners();
  }

  late double _defaultsRowHeight;

  double get defaultsRowHeight => _defaultsRowHeight;

  set defaultsRowHeight(double value) {
    _defaultsRowHeight = value;
    notifyListeners();
  }

  bool _visibleScrollbar = false;

  bool get visibleScrollbar => _visibleScrollbar;

  set visibleScrollbar(bool value) {
    _visibleScrollbar = value;
    notifyListeners();
  }

  final Duration duration;

  final Curve curve;
  final Duration scrollShadowDuration;

  final Curve scrollShadowCurve;

  final Color scrollShadowColor;
  final double scrollShadowSize;

  final List<ExpandableTableHeader> headers;
  final List<ExpandableTableRow> rows;

  ExpandableTableData({
    required this.headers,
    required this.rows,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastOutSlowIn,
    this.scrollShadowDuration = const Duration(milliseconds: 500),
    this.scrollShadowCurve = Curves.fastOutSlowIn,
    this.scrollShadowColor = Colors.transparent,
    this.scrollShadowSize = 10,
    double headerHeight = 188,
    double firstColumnWidth = 200,
    double defaultsColumnWidth = 120,
    double defaultsRowHeight = 50,
  }) {
    _headerHeight = headerHeight;
    _firstColumnWidth = firstColumnWidth;
    _defaultsColumnWidth = defaultsColumnWidth;
    _defaultsRowHeight = defaultsRowHeight;
  }

  List<ExpandableTableHeader> get allHeaders => _getAllHeaders(headers);

  List<ExpandableTableHeader> get visibleHeaders =>
      allHeaders.where((element) => element.visible).toList();

  double get visibleHeadersWidth => visibleHeaders
      .map<double>((e) => e.width ?? defaultsColumnWidth)
      .fold(0, (a, b) => a + b);

  List<ExpandableTableHeader> _getAllHeaders(
      List<ExpandableTableHeader> headers) {
    List<ExpandableTableHeader> cells = [];
    for (var header in headers) {
      cells.add(header);
      if (header.children != null) {
        cells.addAll(_getAllHeaders(header.children!));
      }
    }
    return cells;
  }

  List<ExpandableTableRow> get allRows => _getAllRows(rows);

  List<ExpandableTableRow> get visibleRows =>
      allRows.where((element) => element.visible).toList();

  double get visibleRowsHeight => visibleRows
      .map<double>((e) => e.height ?? defaultsRowHeight)
      .fold(0, (a, b) => a + b);

  List<ExpandableTableRow> _getAllRows(List<ExpandableTableRow> rows) {
    List<ExpandableTableRow> rowsTmp = [];
    for (var row in rows) {
      rowsTmp.add(row);
      if (row.children != null) {
        rowsTmp.addAll(_getAllRows(row.children!));
      }
    }
    return rowsTmp;
  }
}
