import 'package:flutter/material.dart';

import 'data.dart';

class ExpandableTableCell extends StatelessWidget {
  final Widget? child;
  final double height;
  final double width;
  final VoidCallback? onTap;
  final bool horizontalExpanded;
  final bool verticalExpanded;

  ExpandableTableCell(
      {this.child,
      required this.height,
      required this.width,
      this.onTap,
      this.horizontalExpanded = true,
      this.verticalExpanded = true});

  @override
  Widget build(BuildContext context) {
    final ExpandableTableDataState tableSharedData =
        ExpandableTableData.of(context);
    return GestureDetector(
      onTap: this.onTap,
      child: AnimatedContainer(
          duration: tableSharedData.duration,
          curve: tableSharedData.curve,
          width: horizontalExpanded == true ? width : 0,
          height: verticalExpanded == true ? height : 0,
          child: child),
    );
  }
}
