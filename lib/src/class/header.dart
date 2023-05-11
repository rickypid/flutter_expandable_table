import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class ExpandableTableHeader extends ChangeNotifier {
  final List<ExpandableTableHeader>? children;
  late bool _childrenExpanded;

  bool get childrenExpanded =>
      children?.isNotEmpty == true && _childrenExpanded;

  set childrenExpanded(bool value) {
    _childrenExpanded = value;
    if (children != null && !_childrenExpanded) {
      for (var child in children!) {
        child.childrenExpanded = false;
      }
    }
    notifyListeners();
  }

  ExpandableTableHeader? parent;
  final ExpandableTableCell cell;
  final double? width;
  final bool hideWhenExpanded;

  ExpandableTableHeader({
    required this.cell,
    this.children,
    this.hideWhenExpanded = false,
    this.width,
    bool childrenExpanded = false,
  }) {
    _childrenExpanded = childrenExpanded;
    if (children != null) {
      for (var child in children!) {
        child.parent = this;
        child.addListener(_listener);
      }
    }
  }

  @override
  void dispose() {
    for (var child in children!) {
      child.removeListener(_listener);
    }
    super.dispose();
  }

  _listener() => notifyListeners();

  int get columnsCount {
    int count = 1;
    if (children != null) {
      for (var e in children!) {
        count += e.columnsCount;
      }
    }
    return count;
  }

  int get visibleColumnsCount {
    int count = childrenExpanded && hideWhenExpanded ? 0 : 1;
    if (children != null) {
      for (var e in children!) {
        count += e.visibleColumnsCount;
      }
    }
    return count;
  }

  bool get visible =>
      (!childrenExpanded || !hideWhenExpanded) &&
      (parent == null || parent?.childrenExpanded == true);

  toggleExpand() => childrenExpanded = !childrenExpanded;
}