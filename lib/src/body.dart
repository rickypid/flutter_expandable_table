import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'cell.dart';
import 'row.dart';
import 'data.dart';

class ExpandableTableBody extends StatefulWidget {
  final ScrollController scrollController;
  final List<ExpandableTableRow> rows;
  final bool visibleScrollbar;

  ExpandableTableBody({
    required this.scrollController,
    required this.rows,
    required this.visibleScrollbar,
  });

  @override
  _ExpandableTableBodyState createState() => _ExpandableTableBodyState();
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

  List<Widget> _buildFirstColumn(BuildContext context, ExpandableTableRow row,
      ExpandableTableRow? rowParent) {
    List<Widget> firstColumn = [];
    if (row.children is List<Widget> &&
        !(row.children is List<ExpandableTableRow>)) {
      firstColumn.add(
        ExpandableTableCell(
          child: row.firstCell,
          height: row.height,
          width: ExpandableTableData.of(context).firstColumnWidth,
          verticalExpanded: rowParent != null ? rowParent.isExpanded : true,
          onTap: () {
            setState(() {
              if (rowParent != null)
                rowParent.isExpanded = !rowParent.isExpanded;
            });
          },
        ),
      );
    } else {
      firstColumn.add(
        ExpandableTableCell(
          child: row.firstCell,
          height: row.height,
          width: ExpandableTableData.of(context).firstColumnWidth,
          verticalExpanded: rowParent == null || rowParent.isExpanded,
          onTap: () {
            setState(() {
              row.isExpanded = !row.isExpanded;
            });
          },
        ),
      );
      List<ExpandableTableRow> rows = row.children as List<ExpandableTableRow>;
      for (ExpandableTableRow subRow in rows) {
        firstColumn = [
          ...firstColumn,
          ..._buildFirstColumn(context, subRow, row)
        ];
      }
    }
    return firstColumn;
  }

  List<Widget> _buildBodyColumns(BuildContext context, ExpandableTableRow row,
      ExpandableTableRow? rowParent) {
    List<Widget> bodyColumns = [];
    if (row.children is List<Widget> &&
        !(row.children is List<ExpandableTableRow>)) {
      List<Widget> cells = row.children as List<Widget>;
      int x = 0;
      List<Widget> cellsRow = [];
      for (Widget cell in cells) {
        cellsRow.add(ExpandableTableCell(
          child: cell,
          height: row.height,
          width: ExpandableTableData.of(context).cellWidth,
          horizontalExpanded:
              ExpandableTableData.of(context).visibleColumn[x] == true,
          verticalExpanded: rowParent != null ? rowParent.isExpanded : true,
        ));
        x++;
      }
      bodyColumns.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: cellsRow,
        ),
      );
    } else {
      List<ExpandableTableRow> rows = row.children as List<ExpandableTableRow>;
      bodyColumns.add(
        Row(children: [
          Expanded(
            child: ExpandableTableCell(
                verticalExpanded: rowParent == null || rowParent.isExpanded,
                height: row.height,
                width: ExpandableTableData.of(context).cellWidth,
                child: row.legend),
          )
        ]),
      );
      for (ExpandableTableRow subRow in rows) {
        bodyColumns = [
          ...bodyColumns,
          ..._buildBodyColumns(context, subRow, row)
        ];
      }
    }
    return bodyColumns;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> firstColumn = [];
    List<Widget> bodyColumns = [];
    for (var row in widget.rows) {
      firstColumn = [...firstColumn, ..._buildFirstColumn(context, row, null)];
      bodyColumns = [...bodyColumns, ..._buildBodyColumns(context, row, null)];
    }
    return Row(
      children: [
        SizedBox(
          width: ExpandableTableData.of(context).firstColumnWidth,
          child: ScrollShadow(
            size: 10,
            color: ExpandableTableData.of(context).scrollShadowColor,
            curve: ExpandableTableData.of(context).scrollShadowCurve,
            duration: ExpandableTableData.of(context).scrollShadowDuration,
            controller: _firstColumnController,
            child: Builder(
              builder: (context) {
                Widget child = ListView(
                  controller: _firstColumnController,
                  physics: ClampingScrollPhysics(),
                  children: firstColumn,
                );
                return ExpandableTableData.of(context).visibleScrollbar
                    ? Scrollbar(
                        child: child,
                        thumbVisibility: true,
                        controller: _firstColumnController,
                      )
                    : child;
              },
            ),
          ),
        ),
        Expanded(
          child: ScrollShadow(
            size: 10,
            scrollDirection: Axis.horizontal,
            color: ExpandableTableData.of(context).scrollShadowColor,
            curve: ExpandableTableData.of(context).scrollShadowCurve,
            duration: ExpandableTableData.of(context).scrollShadowDuration,
            controller: widget.scrollController,
            child: SingleChildScrollView(
              controller: widget.scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: AnimatedContainer(
                width: ExpandableTableData.of(context).visibleColumnsCount *
                    ExpandableTableData.of(context).cellWidth,
                //constraints: BoxConstraints(maxWidth: AppCycleProgrammingTableSharedData.of(context).visibleColumnsCount * AppCycleProgrammingTableSharedData.of(context).cellWidth ),
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                child: ScrollShadow(
                  size: 10,
                  color: ExpandableTableData.of(context).scrollShadowColor,
                  curve: ExpandableTableData.of(context).scrollShadowCurve,
                  duration:
                      ExpandableTableData.of(context).scrollShadowDuration,
                  controller: _restColumnsController,
                  child: Builder(
                    builder: (context) {
                      Widget child = ListView(
                        controller: _restColumnsController,
                        physics: const ClampingScrollPhysics(),
                        children: bodyColumns,
                      );
                      return ExpandableTableData.of(context).visibleScrollbar
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