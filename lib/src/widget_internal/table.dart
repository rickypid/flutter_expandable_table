// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_expandable_table/src/widget_internal/animated_extents.dart';
import 'package:flutter_expandable_table/src/widget_internal/cell.dart';

/// [InternalTable] it is the widget that builds the table.
class InternalTable extends StatefulWidget {
  /// [InternalTable] constructor.
  const InternalTable({
    super.key,
  });

  @override
  InternalTableState createState() => InternalTableState();
}

/// [InternalTable] state.
class InternalTableState extends State<InternalTable>
    with TickerProviderStateMixin {
  // Header and body share a single horizontal scrollable, so they cannot get
  // out of sync when the content width changes (e.g. collapsing columns while
  // scrolled to the end).
  late ScrollController _horizontalController;
  late LinkedScrollControllerGroup _verticalLinkedControllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;
  late AnimatedExtents<ExpandableTableHeader> _columnExtents;
  late AnimatedExtents<ExpandableTableRow> _rowExtents;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalLinkedControllers = LinkedScrollControllerGroup();
    _firstColumnController = _verticalLinkedControllers.addAndGet();
    _restColumnsController = _verticalLinkedControllers.addAndGet();
    _columnExtents = AnimatedExtents<ExpandableTableHeader>(
      controller: AnimationController(vsync: this)
        ..addStatusListener(_handleExtentsStatus),
      curve: Curves.linear,
    );
    _rowExtents = AnimatedExtents<ExpandableTableRow>(
      controller: AnimationController(vsync: this)
        ..addStatusListener(_handleExtentsStatus),
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _restColumnsController.dispose();
    _firstColumnController.dispose();
    _columnExtents.controller.dispose();
    _rowExtents.controller.dispose();
    super.dispose();
  }

  // Once a transition ends, fully collapsed rows/columns are dropped from the
  // layout. A completion fired synchronously from build (nothing to animate)
  // needs no rebuild, since build reads the settled extents right after.
  void _handleExtentsStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed &&
        mounted &&
        SchedulerBinding.instance.schedulerPhase !=
            SchedulerPhase.persistentCallbacks) {
      setState(() {});
    }
  }

  void _syncExtents(ExpandableTableController data) {
    _columnExtents
      ..curve = data.curve
      ..update(
        {
          for (final header in data.allHeaders)
            header:
                header.visible ? header.width ?? data.defaultsColumnWidth : 0,
        },
        duration: data.duration,
      );
    _rowExtents
      ..curve = data.curve
      ..update(
        {
          for (final row in data.allRows)
            row: row.visible ? row.height ?? data.defaultsRowHeight : 0,
        },
        duration: data.duration,
      );
  }

  // Lays [child] out at the full row [height] and clips it to the animated one.
  Widget _animatedRow({
    required ExpandableTableRow row,
    required double height,
    required Widget child,
  }) =>
      AnimatedBuilder(
        key: ObjectKey(row),
        animation: _rowExtents.controller,
        builder: (context, child) {
          final double extent = _rowExtents.of(row);
          return SizedBox(
            height: extent,
            child: ClipRect(
              clipBehavior: extent < height ? Clip.hardEdge : Clip.none,
              child: OverflowBox(
                alignment: Alignment.topCenter,
                minHeight: height,
                maxHeight: height,
                child: child,
              ),
            ),
          );
        },
        child: child,
      );

  // Lays each cell out at its full column width and clips it to the animated
  // one. Only the cheap wrappers are rebuilt on every animation frame, the
  // cells themselves are built once.
  Widget _animatedCells({
    required ExpandableTableController data,
    required List<int> columns,
    required List<Widget> cells,
    required double height,
  }) {
    final List<ExpandableTableHeader> headers = data.allHeaders;
    return AnimatedBuilder(
      animation: _columnExtents.controller,
      builder: (context, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < columns.length; i++)
            Builder(
              key: ObjectKey(headers[columns[i]]),
              builder: (context) {
                final ExpandableTableHeader header = headers[columns[i]];
                final double width = header.width ?? data.defaultsColumnWidth;
                final double extent = _columnExtents.of(header);
                return SizedBox(
                  width: extent,
                  height: height,
                  child: ClipRect(
                    clipBehavior: extent < width ? Clip.hardEdge : Clip.none,
                    child: OverflowBox(
                      alignment: AlignmentDirectional.centerStart,
                      minWidth: width,
                      maxWidth: width,
                      child: cells[i],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderCells(ExpandableTableController data, List<int> columns) {
    final List<ExpandableTableHeader> headers = data.allHeaders;
    return _animatedCells(
      data: data,
      columns: columns,
      height: data.headerHeight,
      cells: [
        for (final int index in columns)
          ExpandableTableCellWidget(
            height: data.headerHeight,
            width: headers[index].width ?? data.defaultsColumnWidth,
            header: headers[index],
            onTap: () {
              if (!headers[index].disableDefaultOnTapExpansion) {
                headers[index].toggleExpand();
              }
            },
            builder: headers[index].cell.build,
          ),
      ],
    );
  }

  Widget _buildRowCells(
    ExpandableTableController data,
    ExpandableTableRow row,
    double height,
    List<int> columns,
  ) {
    if (row.cells == null) {
      return ExpandableTableCellWidget(
        height: height,
        width: double.infinity,
        row: row,
        builder: (context, details) => row.legend!,
      );
    }
    final List<ExpandableTableHeader> headers = data.allHeaders;
    return _animatedCells(
      data: data,
      columns: columns,
      height: height,
      cells: [
        for (final int index in columns)
          ExpandableTableCellWidget(
            header: headers[index],
            row: row,
            height: height,
            width: headers[index].width ?? data.defaultsColumnWidth,
            builder: row.cells![index].build,
          ),
      ],
    );
  }

  ScrollShadow _scrollShadow(ExpandableTableController data, Widget child) =>
      ScrollShadow(
        size: data.scrollShadowSize,
        color: data.scrollShadowColor,
        fadeInCurve: data.scrollShadowFadeInCurve,
        fadeOutCurve: data.scrollShadowFadeOutCurve,
        duration: data.scrollShadowDuration,
        child: child,
      );

  Widget _buildFirstColumn(
    BuildContext context,
    ExpandableTableController data,
    List<ExpandableTableRow> rows,
    Map<ExpandableTableRow, int> rowIndexes,
  ) {
    final Widget child = ListView.builder(
      controller: _firstColumnController,
      physics: const ClampingScrollPhysics(),
      itemCount: rows.length,
      // Keeps each row bound to its own element when rows are inserted or
      // removed above it by an expansion.
      findChildIndexCallback: (key) =>
          key is ObjectKey ? rowIndexes[key.value] : null,
      itemBuilder: (context, index) {
        final ExpandableTableRow row = rows[index];
        final double height = row.height ?? data.defaultsRowHeight;
        return _animatedRow(
          row: row,
          height: height,
          child: ChangeNotifierProvider<ExpandableTableRow>.value(
            value: row,
            child: ExpandableTableCellWidget(
              row: row,
              height: height,
              width: data.firstColumnWidth,
              builder: row.firstCell.build,
              onTap: () {
                if (!row.disableDefaultOnTapExpansion) {
                  row.toggleExpand();
                }
              },
            ),
          ),
        );
      },
    );
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: _scrollShadow(
        data,
        data.visibleScrollbar
            ? Scrollbar(
                controller: _firstColumnController,
                thumbVisibility: data.thumbVisibilityScrollbar,
                trackVisibility: data.trackVisibilityScrollbar,
                scrollbarOrientation: ScrollbarOrientation.left,
                child: child,
              )
            : child,
      ),
    );
  }

  Widget _buildColumns(
    BuildContext context,
    ExpandableTableController data,
    List<int> columns,
    List<ExpandableTableRow> rows,
    Map<ExpandableTableRow, int> rowIndexes,
  ) {
    final List<ExpandableTableHeader> headers = data.allHeaders;
    final Widget body = _scrollShadow(
      data,
      ListView.builder(
        controller: _restColumnsController,
        physics: const ClampingScrollPhysics(),
        itemCount: rows.length,
        findChildIndexCallback: (key) =>
            key is ObjectKey ? rowIndexes[key.value] : null,
        itemBuilder: (context, index) {
          final ExpandableTableRow row = rows[index];
          final double height = row.height ?? data.defaultsRowHeight;
          return _animatedRow(
            row: row,
            height: height,
            child: _buildRowCells(data, row, height, columns),
          );
        },
      ),
    );
    final Widget child = SingleChildScrollView(
      controller: _horizontalController,
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      child: AnimatedBuilder(
        animation: _columnExtents.controller,
        builder: (context, child) => SizedBox(
          width: columns.fold<double>(
              0, (sum, index) => sum + _columnExtents.of(headers[index])),
          child: child,
        ),
        child: Column(
          children: [
            SizedBox(
              height: data.headerHeight,
              child: _buildHeaderCells(data, columns),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: _scrollShadow(
        data,
        data.visibleScrollbar
            ? Scrollbar(
                controller: _horizontalController,
                thumbVisibility: data.thumbVisibilityScrollbar,
                trackVisibility: data.trackVisibilityScrollbar,
                child: child,
              )
            : child,
      ),
    );
  }

  double _computeTableWidth({required ExpandableTableController data}) =>
      data.firstColumnWidth +
      data.headers.fold<double>(
          0,
          (sum, e) =>
              sum +
              (e.width ?? data.defaultsColumnWidth) +
              _computeChildrenWidth(
                  expandableTableHeader: e,
                  defaultsColumnWidth: data.defaultsColumnWidth));

  double _computeTableHeight({required ExpandableTableController data}) =>
      data.headerHeight +
      data.rows.fold<double>(
          0,
          (sum, e) =>
              sum +
              (e.height ?? data.defaultsRowHeight) +
              _computeChildrenHeight(
                  expandableTableRow: e,
                  defaultsRowHeight: data.defaultsRowHeight));

  double _computeChildrenHeight({
    required ExpandableTableRow expandableTableRow,
    required double defaultsRowHeight,
  }) =>
      expandableTableRow.childrenExpanded
          ? expandableTableRow.children!.fold<double>(
              0,
              (sum, e) =>
                  sum +
                  (e.height ?? defaultsRowHeight) +
                  _computeChildrenHeight(
                      expandableTableRow: e,
                      defaultsRowHeight: defaultsRowHeight))
          : 0;

  double _computeChildrenWidth({
    required ExpandableTableHeader expandableTableHeader,
    required double defaultsColumnWidth,
  }) =>
      expandableTableHeader.childrenExpanded
          ? expandableTableHeader.children!.fold<double>(
              0,
              (sum, e) =>
                  sum +
                  (e.width ?? defaultsColumnWidth) +
                  _computeChildrenWidth(
                      expandableTableHeader: e,
                      defaultsColumnWidth: defaultsColumnWidth))
          : 0;

  @override
  Widget build(BuildContext context) {
    final ExpandableTableController data =
        context.watch<ExpandableTableController>();
    _syncExtents(data);
    final List<ExpandableTableHeader> headers = data.allHeaders;
    // Only rows/columns that take up space (or are animating out) are laid
    // out: collapsed ones would otherwise be zero-sized items that the lazy
    // list has to build all at once.
    final List<int> columns = [
      for (int i = 0; i < headers.length; i++)
        if (_columnExtents.isDisplayed(headers[i])) i,
    ];
    final List<ExpandableTableRow> rows =
        data.allRows.where(_rowExtents.isDisplayed).toList(growable: false);
    final Map<ExpandableTableRow, int> rowIndexes =
        Map<ExpandableTableRow, int>.identity();
    for (int i = 0; i < rows.length; i++) {
      rowIndexes[rows[i]] = i;
    }
    return SizedBox(
      width: data.expanded ? null : _computeTableWidth(data: data),
      height: data.expanded ? null : _computeTableHeight(data: data),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: data.firstColumnWidth,
            child: Column(
              children: [
                ExpandableTableCellWidget(
                  height: data.headerHeight,
                  width: data.firstColumnWidth,
                  builder: data.firstHeaderCell.build,
                ),
                Expanded(
                  child: _buildFirstColumn(context, data, rows, rowIndexes),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildColumns(context, data, columns, rows, rowIndexes),
          ),
        ],
      ),
    );
  }
}
