/// [ExpandableTable] class
library flutter_expandable_table;

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

  List<Widget> _buildHeaderCells(BuildContext context) {
    ExpandableTableData tableData = context.watch<ExpandableTableData>();
    return tableData.allHeaders
        .map(
          (e) => ExpandableTableCellWidget(
            height: tableData.headerHeight,
            width: e.width ?? tableData.defaultsColumnWidth,
            horizontalExpanded: e.visible,
            onTap: () {
              setState(() {
                //ToDO rimuove setState
                e.toggleExpand();
                debugPrint(
                    'OnTap header, childrenExpanded: ${e.childrenExpanded}');
              });
            },
            builder: (context, details) =>
                e.cell.child ?? e.cell.builder!(context, details),
          ),
        )
        .toList();
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: context.watch<ExpandableTableData>().firstColumnWidth,
          child: ScrollShadow(
            size: context.watch<ExpandableTableData>().scrollShadowSize,
            color: context.watch<ExpandableTableData>().scrollShadowColor,
            curve: context.watch<ExpandableTableData>().scrollShadowCurve,
            duration: context.watch<ExpandableTableData>().scrollShadowDuration,
            controller: _firstColumnController,
            child: Builder(
              builder: (context) {
                Widget child = ListView(
                  controller: _firstColumnController,
                  physics: const ClampingScrollPhysics(),
                  children: context
                      .watch<ExpandableTableData>()
                      .allRows
                      .map(
                        (e) => ExpandableTableCellWidget(
                          verticalExpanded: e.visible,
                          height: e.height ??
                              context
                                  .watch<ExpandableTableData>()
                                  .defaultsRowHeight,
                          width: context
                              .watch<ExpandableTableData>()
                              .firstColumnWidth,
                          builder: (context, details) =>
                              e.firstCell.child ??
                              e.firstCell.builder!(context, details),
                          onTap: () {
                            setState(() {
                              //ToDO rimuove setState
                              e.toggleExpand();
                              debugPrint(
                                  'OnTap row, childrenExpanded: ${e.childrenExpanded}');
                            });
                          },
                        ),
                      )
                      .toList(),
                );
                return context.watch<ExpandableTableData>().visibleScrollbar
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
            size: context.watch<ExpandableTableData>().scrollShadowSize,
            scrollDirection: Axis.horizontal,
            color: context.watch<ExpandableTableData>().scrollShadowColor,
            curve: context.watch<ExpandableTableData>().scrollShadowCurve,
            duration: context.watch<ExpandableTableData>().scrollShadowDuration,
            controller: _bodyController,
            child: SingleChildScrollView(
              controller: _bodyController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: AnimatedContainer(
                width: context.watch<ExpandableTableData>().visibleHeadersWidth,
                duration: context.watch<ExpandableTableData>().duration,
                curve: context.watch<ExpandableTableData>().curve,
                child: ScrollShadow(
                  size: context.watch<ExpandableTableData>().scrollShadowSize,
                  color: context.watch<ExpandableTableData>().scrollShadowColor,
                  curve: context.watch<ExpandableTableData>().scrollShadowCurve,
                  duration:
                      context.watch<ExpandableTableData>().scrollShadowDuration,
                  controller: _restColumnsController,
                  child: Builder(
                    builder: (context) {
                      Widget child = ListView(
                        controller: _restColumnsController,
                        physics: const ClampingScrollPhysics(),
                        children: context
                            .watch<ExpandableTableData>()
                            .allRows
                            .map(
                              (e) => Row(
                                children: e.cells
                                    .map(
                                      (cell) => ExpandableTableCellWidget(
                                        horizontalExpanded: context
                                            .watch<ExpandableTableData>()
                                            .allHeaders[e.cells.indexOf(cell)]
                                            .visible,
                                        verticalExpanded: e.visible,
                                        height: e.height ??
                                            context
                                                .watch<ExpandableTableData>()
                                                .defaultsRowHeight,
                                        width: context
                                                .watch<ExpandableTableData>()
                                                .allHeaders[
                                                    e.cells.indexOf(cell)]
                                                .width ??
                                            context
                                                .watch<ExpandableTableData>()
                                                .defaultsColumnWidth,
                                        builder: (context, details) =>
                                            cell.child ??
                                            cell.builder!(context, details),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                            .toList(),
                      );
                      return context
                              .watch<ExpandableTableData>()
                              .visibleScrollbar
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
    return Column(
      children: [
        SizedBox(
          height: context.watch<ExpandableTableData>().headerHeight,
          child: Row(
            children: [
              ExpandableTableCellWidget(
                height: context.watch<ExpandableTableData>().headerHeight,
                width: context.watch<ExpandableTableData>().firstColumnWidth,
                builder: (context, details) =>
                    widget.firstHeaderCell.child ??
                    widget.firstHeaderCell.builder!(context, details),
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
          child: _buildBody(context),
        ),
      ],
    );
  }
}
