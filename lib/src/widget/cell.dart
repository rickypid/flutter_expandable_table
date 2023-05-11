import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';
import 'package:flutter_expandable_table/src/class/cell_details.dart';
import 'package:flutter_expandable_table/src/class/table.dart';
import 'package:provider/provider.dart';

class ExpandableTableCellWidget extends StatelessWidget {
  final Function(BuildContext context, CellDetails details) builder;
  final double height;
  final double width;
  final VoidCallback? onTap;
  final ExpandableTableHeader? headerParent;
  final ExpandableTableRow? rowParent;
  final ExpandableTableHeader? header;
  final ExpandableTableRow? row;

  //final int rowIndex; //ToDo
  //final int columnIndex; //ToDo

  const ExpandableTableCellWidget({
    super.key,
    required this.builder,
    required this.height,
    required this.width,
    this.onTap,
    this.headerParent,
    this.rowParent,
     this.header,
     this.row,

    //required this.rowIndex,
    //required this.columnIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: context.watch<ExpandableTableData>().duration,
        curve: context.watch<ExpandableTableData>().curve,
        width: header?.visible == false ? 0 : width,
        height: rowParent?.childrenExpanded == false ? 0 : height,
        child: builder(
          context,
          CellDetails(
            rowChildrenExpanded: row?.childrenExpanded == true,
            columnChildrenExpanded: header?.childrenExpanded == true,
            headerParent: headerParent,
            rowParent: rowParent,
            header: header,
            row: row,
          ),
        ),
      ),
    );
  }
}