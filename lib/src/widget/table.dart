/// [ExpandableTable] class
library flutter_expandable_table;

import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/src/class/cell.dart';
import 'package:flutter_expandable_table/src/class/header.dart';
import 'package:flutter_expandable_table/src/class/row.dart';
import 'package:flutter_expandable_table/src/class/table.dart';
import 'package:flutter_expandable_table/src/widget/body.dart';
import 'package:flutter_expandable_table/src/widget/cell.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
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

  /// [header] Contain a table header widget.
  /// `required`
  final List<ExpandableTableHeader> header;

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
    required this.header,
    required this.rows,
    this.firstColumnWidth = 200,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastOutSlowIn,
    this.scrollShadowDuration = const Duration(milliseconds: 500),
    this.scrollShadowCurve = Curves.fastOutSlowIn,
    this.scrollShadowColor = Colors.transparent,
    this.scrollShadowSize = 10,
    this.visibleScrollbar = false,
    required this.firstHeaderCell,
    this.headerHeight = 188,
    this.defaultsColumnWidth = 120,
    this.defaultsRowHeight = 50,
  }) : super(key: key);

  @override
  State<ExpandableTable> createState() => _ExpandableTableState();
}

class _ExpandableTableState extends State<ExpandableTable> {
  @override
  void initState() {
    int totalColumns =
        widget.header.map((e) => e.columnsCount).fold(0, (a, b) => a + b);
    for (int i = 0; i < widget.rows.length; i++) {
      if (widget.rows[i].cellsCount != totalColumns) {
        throw FormatException("Row $i cells count ${widget.rows[i].cellsCount} <> $totalColumns header cell count.");
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExpandableTableData>(
      create: (context) => ExpandableTableData(
        headers: widget.header,
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
      builder: (context, child) => _Table(
        header: widget.header,
        rows: widget.rows,
        firstHeaderCell: widget.firstHeaderCell,
      ),
    );
  }
}

class _Table extends StatefulWidget {
  final List<ExpandableTableHeader> header;
  final List<ExpandableTableRow> rows;
  final ExpandableTableCell firstHeaderCell;

  const _Table({
    Key? key,
    required this.header,
    required this.rows,
    required this.firstHeaderCell,
  }) : super(key: key);

  @override
  __TableState createState() => __TableState();
}

class __TableState extends State<_Table> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _headController;
  late ScrollController _bodyController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  List<Widget> _buildHeaderCells(BuildContext context) {
    ExpandableTableData tableData = context.watch<ExpandableTableData>();
    return tableData.allHeaders
        .map(
          (e) => ExpandableTableCellWidget(
            height: tableData.headerHeight,
            width: e.width ?? tableData.defaultsColumnWidth,
            horizontalExpanded: e.visible,

            onTap: () {
              e.isExpanded = !e.isExpanded;
            },
            child: e.cell.child ?? e.cell.builder!(context),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.watch<ExpandableTableData>().headerHeight,
          child: Row(
            children: [
              ExpandableTableCellWidget(
                height: context.watch<ExpandableTableData>().headerHeight,
                width: context.watch<ExpandableTableData>().firstColumnWidth,
                child: widget.firstHeaderCell.child ??
                    widget.firstHeaderCell.builder!(context),
              ),
              Expanded(
                child: ScrollShadow(
                  size: context.watch<ExpandableTableData>().scrollShadowSize,
                  scrollDirection: Axis.horizontal,
                  color: context.watch<ExpandableTableData>().scrollShadowColor,
                  curve: context.watch<ExpandableTableData>().scrollShadowCurve,
                  duration:
                      context.watch<ExpandableTableData>().scrollShadowDuration,
                  controller: _headController,
                  child: Builder(
                    builder: (context) {
                      Widget child = ListView(
                        controller: _headController,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: _buildHeaderCells(context),
                      );
                      return context
                              .watch<ExpandableTableData>()
                              .visibleScrollbar
                          ? Scrollbar(
                              thumbVisibility: true,
                              controller: _headController,
                              child: child,
                            )
                          : child;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ExpandableTableBody(
            scrollController: _bodyController,
            rows: widget.rows,
          ),
        ),
      ],
    );
  }
}