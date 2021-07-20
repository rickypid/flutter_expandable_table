import 'package:flutter/material.dart';

class ExpandableTableHeader<T> {
  final List<T> children;
  final Widget firstCell;
  final Widget? legend;
  final bool hideWhenExpanded;
  bool isExpanded = false;

  ExpandableTableHeader({
    required this.children,
    required this.firstCell,
    this.legend,
    this.hideWhenExpanded = true,
  });
}
