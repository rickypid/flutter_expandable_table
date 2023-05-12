import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/src/class/cell.dart';
import 'package:flutter_expandable_table/src/class/header.dart';
import 'package:flutter_expandable_table/src/class/row.dart';
import 'package:flutter_expandable_table/src/class_internal/table.dart';
import 'package:flutter_expandable_table/src/widget_internal/table.dart';
import 'package:provider/provider.dart';

/// [ExpandableTable] class.
class ExpandableTable extends StatefulWidget {
  /// [firstHeaderCell] ToDo ???.
  /// `optional`
  final ExpandableTableCell firstHeaderCell;

  /// [headerHeight] ToDo ???.
  /// `optional`
  final double headerHeight;

  /// [defaultsColumnWidth] ToDo ???.
  /// `optional`
  final double defaultsColumnWidth;

  /// [defaultsRowHeight] ToDo ???.
  /// `optional`
  final double defaultsRowHeight;

  /// [headers] Contain a table header widget.
  /// `required`
  final List<ExpandableTableHeader> headers;

  /// [rows] Contain a table body rows widget.
  /// `required`
  final List<ExpandableTableRow> rows;

  /// [firstColumnWidth] determines first Column width size.
  ///
  /// Default: [200]
  final double firstColumnWidth;

  /// [duration] determines duration rendered animation of Rows/Columns expansion.
  ///
  /// Default: [500ms]
  final Duration duration;

  /// [curve] determines rendered curve animation of Rows/Columns expansion.
  ///
  /// Default: [Curves.fastOutSlowIn]
  final Curve curve;

  /// [scrollShadowDuration] determines duration rendered animation of shadows.
  ///
  /// Default: [500ms]
  final Duration scrollShadowDuration;

  /// [scrollShadowCurve] determines rendered curve animation of shadows.
  ///
  /// Default: [Curves.fastOutSlowIn]
  final Curve scrollShadowCurve;

  /// [scrollShadowColor] determines rendered color of shadows.
  ///
  /// Default: [Colors.transparent]
  final Color scrollShadowColor;

  /// [scrollShadowSize] ToDo ???.
  ///
  /// Default: [10]
  final double scrollShadowSize;

  /// [visibleScrollbar] determines visibility of scrollbar.
  ///
  /// Default: [false]
  final bool visibleScrollbar;

  /// [ExpandableTable] constructor.
  /// Required:
  ///   - rows
  ///   - header
  const ExpandableTable({
    Key? key,
    required this.firstHeaderCell,
    required this.headers,
    required this.rows,
    this.firstColumnWidth = 200,
    this.headerHeight = 188,
    this.defaultsColumnWidth = 120,
    this.defaultsRowHeight = 50,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastOutSlowIn,
    this.scrollShadowDuration = const Duration(milliseconds: 500),
    this.scrollShadowCurve = Curves.fastOutSlowIn,
    this.scrollShadowColor = Colors.transparent,
    this.scrollShadowSize = 10,
    this.visibleScrollbar = false,
  }) : super(key: key);

  @override
  State<ExpandableTable> createState() => _ExpandableTableState();
}

class _ExpandableTableState extends State<ExpandableTable> {
  @override
  void initState() {
    int totalColumns =
        widget.headers.map((e) => e.columnsCount).fold(0, (a, b) => a + b);
    for (int i = 0; i < widget.rows.length; i++) {
      if (widget.rows[i].cellsCount != null &&
          widget.rows[i].cellsCount != totalColumns) {
        throw FormatException(
            "Row $i cells count ${widget.rows[i].cellsCount} <> $totalColumns header cell count.");
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExpandableTableData>(
      create: (context) => ExpandableTableData(
        firstHeaderCell: widget.firstHeaderCell,
        headers: widget.headers,
        rows: widget.rows,
        duration: widget.duration,
        curve: widget.curve,
        scrollShadowDuration: widget.scrollShadowDuration,
        scrollShadowCurve: widget.scrollShadowCurve,
        scrollShadowColor: widget.scrollShadowColor,
        scrollShadowSize: widget.scrollShadowSize,
        firstColumnWidth: widget.firstColumnWidth,
        defaultsColumnWidth: widget.defaultsColumnWidth,
        defaultsRowHeight: widget.defaultsRowHeight,
        headerHeight: widget.headerHeight,
      ),
      builder: (context, child) => const InternalTable(),
    );
  }
}
