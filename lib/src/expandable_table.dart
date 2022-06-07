/// [ExpandableTable] class
library flutter_expandable_table;

import 'package:flutter/material.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'body.dart';
import 'cell.dart';
import 'header.dart';
import 'row.dart';
import 'data.dart';

/// [ExpandableTable] class.
class ExpandableTable extends StatefulWidget {
  /// [header] Contain a table header widget.
  /// `required`
  final ExpandableTableHeader header;

  /// [rows] Contain a table body rows widget.
  /// `required`
  final List<ExpandableTableRow> rows;

  /// [cellWidth] determines default cell width size, this is overwritable with cell property.
  ///
  /// Default: [120]
  final double cellWidth;

  /// [cellHeight] determines default cell height size, this is overwritable with row property.
  ///
  /// Default: [50]
  final double cellHeight;

  /// [headerHeight] determines Header Row height size.
  ///
  /// Default: [188]
  final double headerHeight;

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

  /// [visibleScrollbar] determines visibility of scrollbar.
  ///
  /// Default: [false]
  final bool visibleScrollbar;

  /// [ExpandableTable] constructor.
  /// Required:
  ///   - rows
  ///   - header
  ExpandableTable({
    Key? key,
    required this.header,
    required this.rows,
    this.cellWidth = 120,
    this.cellHeight = 50,
    this.headerHeight = 188,
    this.firstColumnWidth = 200,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.fastOutSlowIn,
    this.scrollShadowDuration = const Duration(milliseconds: 500),
    this.scrollShadowCurve = Curves.fastOutSlowIn,
    this.scrollShadowColor = Colors.transparent,
    this.visibleScrollbar = false,
  }) : super(key: key);

  @override
  _ExpandableTableState createState() => _ExpandableTableState();
}

class _ExpandableTableState extends State<ExpandableTable> {
  @override
  Widget build(BuildContext context) {
    return ExpandableTableData(
      cellWidth: widget.cellWidth,
      cellHeight: widget.cellHeight,
      headerHeight: widget.headerHeight,
      firstColumnWidth: widget.firstColumnWidth,
      curve: widget.curve,
      duration: widget.duration,
      scrollShadowColor: widget.scrollShadowColor,
      scrollShadowCurve: widget.scrollShadowCurve,
      scrollShadowDuration: widget.scrollShadowDuration,
      visibleScrollbar: widget.visibleScrollbar,
      child: _Table(
        rows: widget.rows,
        header: widget.header,
      ),
    );
  }
}

class _Table extends StatefulWidget {
  final ExpandableTableHeader header;
  final List<ExpandableTableRow> rows;

  const _Table({Key? key, required this.header, required this.rows})
      : super(key: key);

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

  List<Widget> _buildHeaderCells(BuildContext context,
      ExpandableTableHeader header, ExpandableTableHeader? headerParent) {
    if (headerParent == null)
      ExpandableTableData.of(context).visibleColumn = [];
    List<Widget> headerCells = [];
    for (var child in header.children) {
      if (child is Widget && !(child is ExpandableTableHeader)) {
        headerCells.add(
          ExpandableTableCell(
            child: child,
            height: ExpandableTableData.of(context).headerHeight,
            width: ExpandableTableData.of(context).cellWidth,
            horizontalExpanded: headerParent != null ? header.isExpanded : true,
            onTap: () {
              if (headerParent != null) {
                setState(() {
                  header.isExpanded = !header.isExpanded;
                });
              }
            },
          ),
        );
        ExpandableTableData.of(context)
            .visibleColumn
            .add(header.isExpanded || headerParent == null);
      } else {
        ExpandableTableHeader thisChild = child as ExpandableTableHeader;
        if (headerParent != null && header.isExpanded != true)
          thisChild.isExpanded = false;
        headerCells.add(
          ExpandableTableCell(
            child: thisChild.firstCell,
            height: ExpandableTableData.of(context).headerHeight,
            width: ExpandableTableData.of(context).cellWidth,
            horizontalExpanded: thisChild.hideWhenExpanded != true ||
                thisChild.isExpanded != true,
            onTap: () {
              setState(() {
                thisChild.isExpanded = !thisChild.isExpanded;
              });
            },
          ),
        );
        ExpandableTableData.of(context).visibleColumn.add(
            thisChild.hideWhenExpanded != true || thisChild.isExpanded != true);
        List<Widget> subCells = _buildHeaderCells(context, thisChild, header);
        headerCells = [...headerCells, ...subCells];
      }
    }
    return headerCells;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: ExpandableTableData.of(context).headerHeight,
            child: Row(
              children: [
                ExpandableTableCell(
                  child: widget.header.firstCell,
                  height: ExpandableTableData.of(context).headerHeight,
                  width: ExpandableTableData.of(context).firstColumnWidth,
                ),
                Expanded(
                  child: ScrollShadow(
                    size: 10,
                    scrollDirection: Axis.horizontal,
                    color: ExpandableTableData.of(context).scrollShadowColor,
                    curve: ExpandableTableData.of(context).scrollShadowCurve,
                    duration:
                        ExpandableTableData.of(context).scrollShadowDuration,
                    controller: _headController,
                    child: Builder(
                      builder: (context) {
                        Widget child = ListView(
                          controller: _headController,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children:
                              _buildHeaderCells(context, widget.header, null),
                        );
                        return ExpandableTableData.of(context).visibleScrollbar
                            ? Scrollbar(
                                child: child,
                                thumbVisibility: true,
                                controller: _headController,
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
              visibleScrollbar:
                  ExpandableTableData.of(context).visibleScrollbar,
            ),
          ),
        ],
      ),
    );
  }
}