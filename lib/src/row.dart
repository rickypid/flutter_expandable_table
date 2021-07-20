import 'package:flutter/material.dart';

class ExpandableTableRow<T> {
  final double height;
  final Widget firstCell;
  List<T> children;
  final Widget? legend;
  bool isExpanded = false;

  ExpandableTableRow(
      {Key? key,
      required this.height,
      required this.firstCell,
      required this.children,
      this.legend})
      : assert(
            children is List<Widget> || children is List<ExpandableTableRow>);
}
