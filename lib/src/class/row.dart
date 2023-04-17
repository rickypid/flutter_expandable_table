import 'package:flutter_expandable_table/src/class/row_core.dart';

class ExpandableTableRow extends ExpandableTableRowCore {
  final List<ExpandableTableRow>? children;


  @override
  bool get isExpanded => super.isExpanded && parent?.isExpanded == true;
  @override
  bool get visible => !isExpanded || !hideWhenExpanded;
  ExpandableTableRow({
    required super.firstCell,
    required super.cells,
    this.children,
    super.height,
    super.hideWhenExpanded = false,
    super.isExpanded = false,
  }) : super() {
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
    int count = isExpanded && hideWhenExpanded ? 0 : 1;
    if (children != null) {
      for (var e in children!) {
        count += e.visibleRowsCount;
      }
    }
    return count;
  }
}