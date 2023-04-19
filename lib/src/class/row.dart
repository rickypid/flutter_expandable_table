import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class ExpandableTableRow extends ChangeNotifier {
  final List<ExpandableTableRow>? children;
  final ExpandableTableCell firstCell;
  final List<ExpandableTableCell> cells;
  final double? height;
  final bool hideWhenExpanded;

  late bool _childrenExpanded;

  bool get childrenExpanded => _childrenExpanded;

  bool get visible =>
      (!childrenExpanded || !hideWhenExpanded) &&
      (parent == null || parent?.childrenExpanded == true);

  set childrenExpanded(bool value) {
    _childrenExpanded = value;
    if (children != null && !_childrenExpanded) {
      for (var child in children!) {
        child.childrenExpanded = false;
      }
    }
    notifyListeners();
  }

  toggleExpand() => childrenExpanded = !childrenExpanded;

  ExpandableTableRow? parent;

  ExpandableTableRow({
    required this.firstCell,
    required this.cells,
    this.children,
    this.height,
    this.hideWhenExpanded = false,
    bool childrenExpanded = false,
  }) {
    _childrenExpanded = childrenExpanded;
    if (children != null) {
      for (var child in children!) {
        child.parent = this;
      }
    }
  }

  int get rowsCount {
    int count = 1;
    if (children != null) {
      for (var e in children!) {
        count += e.visibleRowsCount;
      }
    }
    return count;
  }

  int get visibleRowsCount {
    int count = childrenExpanded && hideWhenExpanded ? 0 : 1;
    if (children != null) {
      for (var e in children!) {
        count += e.visibleRowsCount;
      }
    }
    return count;
  }

  int get cellsCount => cells.length;
}
