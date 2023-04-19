import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/src/class/cell_details.dart';

class ExpandableTableCell extends ChangeNotifier {
  final Widget Function(BuildContext context, CellDetails details)? builder;
  final Widget? child;

  ExpandableTableCell({
    this.builder,
    this.child,
  }) : assert((builder != null || child != null) &&
            (builder == null || child == null));
}
