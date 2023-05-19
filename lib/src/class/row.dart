// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

/// [ExpandableTableRow] class.
/// This class defines a single table row.
class ExpandableTableRow extends ChangeNotifier {
  /// [firstCell] defines the contents of the first cell, this cell
  /// is the cell that remains fixed during horizontal scrolling..
  /// `required`
  final ExpandableTableCell firstCell;

  /// [cells] defines the cells in the row, excluding the first one on the left.
  /// The length of this list must be identical to the total headers, including nested ones.
  /// `optional, if it is not defined, the legend must be defined`
  final List<ExpandableTableCell>? cells;

  late List<ExpandableTableRow>? _children;

  /// [children] returns nested rows to this one.
  List<ExpandableTableRow>? get children => _children;

  /// [children] defines rows nested to this, populating
  /// this list will create an expandable row.
  set children(List<ExpandableTableRow>? value) {
    _removeChildrenListener();
    _children = value;
    _addChildrenListener();
    notifyListeners();
  }

  /// [legend] defines the object to insert in place of the cells of the row, used to
  /// create separation or display of totals for example.
  /// `optional, if it is not defined, the [cells] must be defined`
  final Widget? legend;

  /// [height] defines the height of the row, if not specified
  /// the default height defined in the table will be used.
  /// `optional`
  final double? height;

  /// [hideWhenExpanded] Defines whether this row should be
  /// hidden when nested rows are expanded. Attention, by setting
  /// this property to true it will be necessary to implement manual
  /// management of column expansion.
  /// `Default: false`
  final bool hideWhenExpanded;

  /// [disableDefaultOnTapExpansion] Defines whether to disable the
  /// standard expand interaction, setting to true will require
  /// manually implementing an expand logic.
  /// `Default: false`
  final bool disableDefaultOnTapExpansion;

  late bool _childrenExpanded;

  bool get childrenExpanded =>
      children?.isNotEmpty == true && _childrenExpanded;

  /// [childrenExpanded] allows you to expand or not the rows nested within this one.
  set childrenExpanded(bool value) {
    if (children != null) {
      _childrenExpanded = value;
      if (!_childrenExpanded) {
        for (var child in children!) {
          child.childrenExpanded = false;
        }
      }
      notifyListeners();
    }
  }

  ExpandableTableRow? _parent;

  /// [parent] if this row is nested within another,
  /// the instance of the parent row is returned
  ExpandableTableRow? get parent => _parent;
  int? index;

  /// [ExpandableTableRow] class constructor.
  /// This class defines a single table row.
  ExpandableTableRow({
    required this.firstCell,
    this.cells,
    this.legend,
    List<ExpandableTableRow>? children,
    this.height,
    this.hideWhenExpanded = false,
    bool childrenExpanded = false,
    this.disableDefaultOnTapExpansion = false,
  }) : assert((cells != null || legend != null) &&
            (cells == null || legend == null)) {
    _childrenExpanded = childrenExpanded;
    _children = children;
    _addChildrenListener();
  }

  void _addChildrenListener() {
    if (_children != null) {
      for (var i = 0; i < _children!.length; i++) {
        children![i]._parent = this;
        _children![i].addListener(_listener);
        _children![i].index = i;
      }
    }
  }

  void _removeChildrenListener() {
    if (_children != null) {
      for (var child in _children!) {
        child.removeListener(_listener);
      }
    }
  }

  @override
  void dispose() {
    _removeChildrenListener();
    super.dispose();
  }

  _listener() => notifyListeners();

  /// [rowsCount] returns the number of rows, this one and
  /// all those nested within it.
  int get rowsCount {
    int count = 1;
    if (children != null) {
      for (var e in children!) {
        count += e.visibleRowsCount;
      }
    }
    return count;
  }

  /// [visibleRowsCount] returns the number of rows currently visible,
  /// this one and all those nested within it.
  int get visibleRowsCount {
    int count = childrenExpanded && hideWhenExpanded ? 0 : 1;
    if (children != null) {
      for (var e in children!) {
        count += e.visibleRowsCount;
      }
    }
    return count;
  }

  /// [cellsCount] returns the number of cells in the row, excluding the first.
  int? get cellsCount => cells?.length;

  /// [visible] returns true if this row is currently visible.
  bool get visible =>
      (!childrenExpanded || !hideWhenExpanded) &&
      (parent == null || parent?.childrenExpanded == true);

  /// [address] returns a list of integers, each of which the position
  /// referred to the parent row, each nesting adds an element to the
  /// list, this element will be the address of the row with respect to the parent.
  List<int> get address => (parent?.address ?? [])..add(index ?? 0);

  /// [toggleExpand] this method allows you to reverse the
  /// expansion or not of the child rows.
  toggleExpand() => childrenExpanded = !childrenExpanded;
}
