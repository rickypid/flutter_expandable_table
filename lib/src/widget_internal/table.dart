import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_expandable_table/src/class_internal/table.dart';
import 'package:flutter_expandable_table/src/widget_internal/cell.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';

class InternalTable extends StatefulWidget {
  const InternalTable({
    Key? key,
  }) : super(key: key);

  @override
  InternalTableState createState() => InternalTableState();
}

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
              if (!e.disableDefaultOnTapExpansion) {
                e.toggleExpand();
              }
            },
            builder: e.cell.build,
          ),
        )
        .toList();
  }

  Widget _buildRowCells(ExpandableTableData data, ExpandableTableRow row) {
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
                headerParent: data.allHeaders[row.cells!.indexOf(cell)].parent,
                rowParent: row.parent,
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
        rowParent: row.parent,
        builder: (context, details) => row.legend!,
      );
    }
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
