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
    Key? key,
  }) : super(key: key);

  @override
  InternalTableState createState() => InternalTableState();
}

/// [InternalTable] state.
class InternalTableState extends State<InternalTable> {
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
    _restColumnsController = _horizontalLinkedControllers.addAndGet();
    _firstColumnController = _horizontalLinkedControllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
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
          child: ScrollShadow(
            size: data.scrollShadowSize,
            color: data.scrollShadowColor,
            fadeInCurve: data.scrollShadowFadeInCurve,
            fadeOutCurve: data.scrollShadowFadeOutCurve,
            duration: data.scrollShadowDuration,
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
            color: data.scrollShadowColor,
            fadeInCurve: data.scrollShadowFadeInCurve,
            fadeOutCurve: data.scrollShadowFadeOutCurve,
            duration: data.scrollShadowDuration,
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
                  fadeInCurve: data.scrollShadowFadeInCurve,
                  fadeOutCurve: data.scrollShadowFadeOutCurve,
                  duration: data.scrollShadowDuration,
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
    ExpandableTableController data = context.watch<ExpandableTableController>();
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
                  color: data.scrollShadowColor,
                  fadeInCurve: data.scrollShadowFadeInCurve,
                  fadeOutCurve: data.scrollShadowFadeOutCurve,
                  duration: data.scrollShadowDuration,
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
