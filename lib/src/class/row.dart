import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class ExpandableTableRow extends ChangeNotifier {
  final List<ExpandableTableRow>? children;
  final ExpandableTableCell firstCell;
  final List<ExpandableTableCell>? cells;
  final Widget? legend;
  final double? height;
  final bool hideWhenExpanded;
  final bool disableDefaultOnTapExpansion;

  late bool _childrenExpanded;

  bool get childrenExpanded =>
      children?.isNotEmpty == true && _childrenExpanded;

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

  ExpandableTableRow? _parent;

  ExpandableTableRow? get parent => _parent;
  int? index;

  ExpandableTableRow({
    required this.firstCell,
    this.cells,
    this.legend,
    this.children,
    this.height,
    this.hideWhenExpanded = false,
    bool childrenExpanded = false,
    this.disableDefaultOnTapExpansion = false,
  }) : assert(cells != null || legend != null) {
    _childrenExpanded = childrenExpanded;
    if (children != null) {
      for (var i = 0; i < children!.length; i++) {
        children![i]._parent = this;
        children![i].addListener(_listener);
        children![i].index = i;
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

  int? get cellsCount => cells?.length;

  List<int> get address => (parent?.address ?? [])..add(index ?? 0);

  toggleExpand() => childrenExpanded = !childrenExpanded;
}
