import 'package:flutter_expandable_table/src/class/header_core.dart';

class ExpandableTableHeader extends ExpandableTableHeaderCore {
  @override
  bool get isExpanded => super.isExpanded && parent?.isExpanded == true;
  final List<ExpandableTableHeader>? children;

  @override
  bool get visible => !isExpanded || !hideWhenExpanded;
  ExpandableTableHeader({
    required super.cell,
    this.children,
    super.hideWhenExpanded = true,
    super.width,
    super.isExpanded = false,
  }) {
    if (children != null) {
      for (var child in children!) {
        child.parent = this;
      }
    }
  }

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
    int count = isExpanded && hideWhenExpanded ? 0 : 1;
    if (children != null) {
      for (var e in children!) {
        count += e.visibleColumnsCount;
      }
    }
    return count;
  }
}