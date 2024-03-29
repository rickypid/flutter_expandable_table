// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
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
class InternalTableState extends State<InternalTable> {
  late LinkedScrollControllerGroup _horizontalLinkedControllers;
  late ScrollController _headController;
  late ScrollController _horizontalBodyController;
  late LinkedScrollControllerGroup _verticalLinkedControllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _horizontalLinkedControllers = LinkedScrollControllerGroup();
    _headController = _horizontalLinkedControllers.addAndGet();
    _horizontalBodyController = _horizontalLinkedControllers.addAndGet();
    _verticalLinkedControllers = LinkedScrollControllerGroup();
    _firstColumnController = _verticalLinkedControllers.addAndGet();
    _restColumnsController = _verticalLinkedControllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _horizontalBodyController.dispose();
    _restColumnsController.dispose();
    _firstColumnController.dispose();
    super.dispose();
  }

  List<Widget> _buildHeaderCells(ExpandableTableController data) {
    return data.allHeaders
        .map(
          (e) => ExpandableTableCellWidget(
            height: data.headerHeight,
            width: e.width ?? data.defaultsColumnWidth,
            header: e,
            onTap: () {
              if (!e.disableDefaultOnTapExpansion) {
                e.toggleExpand();
              }
            },
            builder: e.cell.build,
          ),
        )
        .toList();
  }

  Widget _buildRowCells(
      ExpandableTableController data, ExpandableTableRow row) {
    if (row.cells != null) {
      return Row(
        children: row.cells!
            .map(
              (cell) => ExpandableTableCellWidget(
                header: data.allHeaders[row.cells!.indexOf(cell)],
                row: row,
                height: row.height ?? data.defaultsRowHeight,
                width: data.allHeaders[row.cells!.indexOf(cell)].width ??
                    data.defaultsColumnWidth,
                builder: cell.build,
              ),
            )
            .toList(),
      );
    } else {
      return ExpandableTableCellWidget(
        height: row.height ?? data.defaultsRowHeight,
        width: double.infinity,
        row: row,
        builder: (context, details) => row.legend!,
      );
    }
  }

  Widget _buildBody(ExpandableTableController data) {
    return Row(
      children: [
        SizedBox(
          width: data.firstColumnWidth,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ScrollShadow(
              size: data.scrollShadowSize,
              color: data.scrollShadowColor,
              fadeInCurve: data.scrollShadowFadeInCurve,
              fadeOutCurve: data.scrollShadowFadeOutCurve,
              duration: data.scrollShadowDuration,
              child: ListView(
                controller: _firstColumnController,
                physics: const ClampingScrollPhysics(),
                children: data.allRows
                    .map(
                      (e) => ChangeNotifierProvider<ExpandableTableRow>.value(
                        value: e,
                        builder: (context, child) => ExpandableTableCellWidget(
                          row: context.watch<ExpandableTableRow>(),
                          height: context.watch<ExpandableTableRow>().height ??
                              data.defaultsRowHeight,
                          width: data.firstColumnWidth,
                          builder: context
                              .watch<ExpandableTableRow>()
                              .firstCell
                              .build,
                          onTap: () {
                            if (!e.disableDefaultOnTapExpansion) {
                              e.toggleExpand();
                            }
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        Builder(
          builder: (context) {
            Widget child = ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ScrollShadow(
                size: data.scrollShadowSize,
                color: data.scrollShadowColor,
                fadeInCurve: data.scrollShadowFadeInCurve,
                fadeOutCurve: data.scrollShadowFadeOutCurve,
                duration: data.scrollShadowDuration,
                child: SingleChildScrollView(
                  controller: _horizontalBodyController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: AnimatedContainer(
                    width: data.visibleHeadersWidth,
                    duration: data.duration,
                    curve: data.curve,
                    child: ScrollShadow(
                      size: data.scrollShadowSize,
                      color: data.scrollShadowColor,
                      fadeInCurve: data.scrollShadowFadeInCurve,
                      fadeOutCurve: data.scrollShadowFadeOutCurve,
                      duration: data.scrollShadowDuration,
                      child: ListView(
                        controller: _restColumnsController,
                        physics: const ClampingScrollPhysics(),
                        children: data.allRows
                            .map(
                              (e) => _buildRowCells(data, e),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            );
            return Expanded(
              child: data.visibleScrollbar
                  ? Scrollbar(
                      controller: _horizontalBodyController,
                      thumbVisibility: true,
                      trackVisibility: true,
                      child: Scrollbar(
                        controller: _restColumnsController,
                        thumbVisibility: true,
                        trackVisibility: true,
                        notificationPredicate: (notification) =>
                            notification.depth >= 0,
                        child: child,
                      ),
                    )
                  : child,
            );
          },
        ),
      ],
    );
  }

  double _computeTableWidth({required ExpandableTableController data}) {
    return data.firstColumnWidth +
        (data.headers
            .map((e) =>
                (e.width ?? data.defaultsColumnWidth) +
                _computeChildrenWidth(
                    expandableTableHeader: e,
                    defaultsColumnWidth: data.defaultsColumnWidth))
            .reduce((value, element) => value + element));
  }

  double _computeTableHeight({required ExpandableTableController data}) {
    return data.headerHeight +
        (data.rows
            .map((e) =>
                (e.height ?? data.defaultsRowHeight) +
                _computeChildrenHeight(
                    expandableTableRow: e,
                    defaultsRowHeight: data.defaultsRowHeight))
            .reduce((value, element) => value + element));
  }

  double _computeChildrenHeight({
    required ExpandableTableRow expandableTableRow,
    required double defaultsRowHeight,
  }) {
    return expandableTableRow.childrenExpanded
        ? expandableTableRow.children!
            .map((e) =>
                (e.height ?? defaultsRowHeight) +
                _computeChildrenHeight(
                    expandableTableRow: e,
                    defaultsRowHeight: defaultsRowHeight))
            .reduce((value, element) => value + element)
        : 0;
  }

  double _computeChildrenWidth({
    required ExpandableTableHeader expandableTableHeader,
    required double defaultsColumnWidth,
  }) {
    return expandableTableHeader.childrenExpanded
        ? expandableTableHeader.children!
            .map((e) =>
                (e.width ?? defaultsColumnWidth) +
                _computeChildrenWidth(
                    expandableTableHeader: e,
                    defaultsColumnWidth: defaultsColumnWidth))
            .reduce((value, element) => value + element)
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    ExpandableTableController data = context.watch<ExpandableTableController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: _computeTableWidth(data: data) < constraints.maxWidth
              ? _computeTableWidth(data: data)
              : null,
          height: _computeTableHeight(data: data) < constraints.maxHeight
              ? _computeTableHeight(data: data)
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                        color: data.scrollShadowColor,
                        fadeInCurve: data.scrollShadowFadeInCurve,
                        fadeOutCurve: data.scrollShadowFadeOutCurve,
                        duration: data.scrollShadowDuration,
                        child: ListView(
                          controller: _headController,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: _buildHeaderCells(data),
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
          ),
        );
      },
    );
  }
}
