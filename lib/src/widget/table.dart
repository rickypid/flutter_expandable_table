import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/src/class/cell.dart';
import 'package:flutter_expandable_table/src/class/header.dart';
import 'package:flutter_expandable_table/src/class/row.dart';
import 'package:flutter_expandable_table/src/class/table.dart';
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
    required this.headers,
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
        widget.headers.map((e) => e.columnsCount).fold(0, (a, b) => a + b);
    for (int i = 0; i < widget.rows.length; i++) {
      if (widget.rows[i].cellsCount != totalColumns) {
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
      builder: (context, child) => const _Table(),
    );
  }
}

class _Table extends StatefulWidget {
  const _Table({
    Key? key,
  }) : super(key: key);

  @override
  __TableState createState() => __TableState();
}

class __TableState extends State<_Table> {
  late LinkedScrollControllerGroup _verticalLinkedControllers;
  late ScrollController _headController;
  late ScrollController _bodyController;
  late LinkedScrollControllerGroup _horizontalLinkedControllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _verticalLinkedControllers = LinkedScrollControllerGroup();
    _headController = _verticalLinkedControllers.addAndGet();
    _bodyController = _verticalLinkedControllers.addAndGet();
    _horizontalLinkedControllers = LinkedScrollControllerGroup();
    _firstColumnController = _horizontalLinkedControllers.addAndGet();
    _restColumnsController = _horizontalLinkedControllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  List<Widget> _buildHeaderCells(ExpandableTableData data) {
    return data.allHeaders
        .map(
          (e) => ExpandableTableCellWidget(
            height: data.headerHeight,
            width: e.width ?? data.defaultsColumnWidth,
            header: e,
            headerParent: e.parent,
            onTap: () {
              e.toggleExpand();
              debugPrint(
                  'OnTap header, childrenExpanded: ${e.childrenExpanded}');
            },
            builder: e.cell.build,
          ),
        )
        .toList();
  }

  Widget _buildRowCells(ExpandableTableData data, ExpandableTableRow row) {
    return Row(
      children: row.cells
          .map(
            (cell) => ExpandableTableCellWidget(
              header: data.allHeaders[row.cells.indexOf(cell)],
              row: row,
              height: row.height ?? data.defaultsRowHeight,
              width: data.allHeaders[row.cells.indexOf(cell)].width ??
                  data.defaultsColumnWidth,
              headerParent: data.allHeaders[row.cells.indexOf(cell)].parent,
              rowParent: row.parent,
              builder: cell.build,
            ),
          )
          .toList(),
    );
  }

  Widget _buildBody(ExpandableTableData data) {
    return Row(
      children: [
        SizedBox(
          width: data.firstColumnWidth,
          child: ScrollShadow(
            size: data.scrollShadowSize,
            color: data.scrollShadowColor,
            curve: data.scrollShadowCurve,
            duration: data.scrollShadowDuration,
            controller: _firstColumnController,
            child: Builder(
              builder: (context) {
                Widget child = ListView(
                  controller: _firstColumnController,
                  physics: const ClampingScrollPhysics(),
                  children: data.allRows
                      .map(
                        (e) => ChangeNotifierProvider<ExpandableTableRow>.value(
                          value: e,
                          builder: (context, child) =>
                              ExpandableTableCellWidget(
                            row: context.watch<ExpandableTableRow>(),
                            height:
                                context.watch<ExpandableTableRow>().height ??
                                    data.defaultsRowHeight,
                            width: data.firstColumnWidth,
                            rowParent:
                                context.watch<ExpandableTableRow>().parent,
                            builder: context
                                .watch<ExpandableTableRow>()
                                .firstCell
                                .build,
                            onTap: () {
                              e.toggleExpand();
                              debugPrint(
                                  'OnTap row, childrenExpanded: ${e.childrenExpanded}');
                            },
                          ),
                        ),
                      )
                      .toList(),
                );
                return data.visibleScrollbar
                    ? Scrollbar(
                        thumbVisibility: true,
                        controller: _firstColumnController,
                        child: child,
                      )
                    : child;
              },
            ),
          ),
        ),
        Expanded(
          child: ScrollShadow(
            size: data.scrollShadowSize,
            scrollDirection: Axis.horizontal,
            color: data.scrollShadowColor,
            curve: data.scrollShadowCurve,
            duration: data.scrollShadowDuration,
            controller: _bodyController,
            child: SingleChildScrollView(
              controller: _bodyController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: AnimatedContainer(
                width: data.visibleHeadersWidth,
                duration: data.duration,
                curve: data.curve,
                child: ScrollShadow(
                  size: data.scrollShadowSize,
                  color: data.scrollShadowColor,
                  curve: data.scrollShadowCurve,
                  duration: data.scrollShadowDuration,
                  controller: _restColumnsController,
                  child: Builder(
                    builder: (context) {
                      Widget child = ListView(
                        controller: _restColumnsController,
                        physics: const ClampingScrollPhysics(),
                        children: data.allRows
                            .map(
                              (e) => _buildRowCells(data, e),
                            )
                            .toList(),
                      );
                      return data.visibleScrollbar
                          ? ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context)
                                  .copyWith(scrollbars: false),
                              child: child,
                            )
                          : child;
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ExpandableTableData data = context.watch<ExpandableTableData>();

    return Column(
      children: [
        SizedBox(
          height: data.headerHeight,
          child: Row(
            children: [
              ExpandableTableCellWidget(
                height: data.headerHeight,
                width: data.firstColumnWidth,
                builder: data.firstHeaderCell.build,
              ),
              Expanded(
                child: ScrollShadow(
                  size: data.scrollShadowSize,
                  scrollDirection: Axis.horizontal,
                  color: data.scrollShadowColor,
                  curve: data.scrollShadowCurve,
                  duration: data.scrollShadowDuration,
                  controller: _headController,
                  child: Builder(
                    builder: (context) {
                      Widget child = ListView(
                        controller: _headController,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: _buildHeaderCells(data),
                      );
                      return data.visibleScrollbar
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
          child: _buildBody(data),
        ),
      ],
    );
  }
}
