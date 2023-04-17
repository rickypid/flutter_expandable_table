import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/src/class/table.dart';
import 'package:provider/provider.dart';

class ExpandableTableCellWidget extends StatelessWidget {
  final Widget? child;
  final double height;
  final double width;
  final VoidCallback? onTap;
  final bool horizontalExpanded;
  final bool verticalExpanded;

  //final int rowIndex; //ToDo
  //final int columnIndex; //ToDo

  const ExpandableTableCellWidget({
    super.key,
    this.child,
    required this.height,
    required this.width,
    this.onTap,
    this.horizontalExpanded = true,
    this.verticalExpanded = true,
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
          width: horizontalExpanded == true ? width : 0,
          height: verticalExpanded == true ? height : 0,
          child: child),
    );
  }
}