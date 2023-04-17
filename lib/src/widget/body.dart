import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/src/class/header.dart';
import 'package:flutter_expandable_table/src/class/row.dart';
import 'package:flutter_expandable_table/src/class/table.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';
import 'cell.dart';

class ExpandableTableBody extends StatefulWidget {
  final ScrollController scrollController;
  final List<ExpandableTableRow> rows;

  const ExpandableTableBody({
    super.key,
    required this.scrollController,
    required this.rows,
  });

  @override
  State<ExpandableTableBody> createState() => _ExpandableTableBodyState();
}

class _ExpandableTableBodyState extends State<ExpandableTableBody>
    with TickerProviderStateMixin {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      .rows
                      .map(
                        (e) => ChangeNotifierProvider<ExpandableTableRow>.value(
                          value: e,
                          builder: (context, child) =>
                              ExpandableTableCellWidget(
                            verticalExpanded:
                                context.watch<ExpandableTableRow>().visible,
                            height:
                                context.watch<ExpandableTableRow>().height ??
                                    context
                                        .watch<ExpandableTableData>()
                                        .defaultsRowHeight,
                            width: context
                                .watch<ExpandableTableData>()
                                .firstColumnWidth,
                            child: context
                                    .watch<ExpandableTableRow>()
                                    .firstCell
                                    .child ??
                                context
                                    .watch<ExpandableTableRow>()
                                    .firstCell
                                    .builder!(context),
                            onTap: () {
                              e.isExpanded = !e.isExpanded;
                            },
                          ),
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
            controller: widget.scrollController,
            child: SingleChildScrollView(
              controller: widget.scrollController,
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
                            .rows
                            .map(
                              (e) => Row(
                                children: e.cells
                                    .map(
                                      (cell) => ExpandableTableCellWidget(
                                        horizontalExpanded: context
                                            .watch<ExpandableTableData>()
                                            .allHeaders[e.cells.indexOf(cell)]
                                            .visible,
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
                                        child: cell.child ??
                                            cell.builder!(context),
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
}