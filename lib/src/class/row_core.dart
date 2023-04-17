import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/src/class/cell.dart';

class ExpandableTableRowCore extends ChangeNotifier {
  final ExpandableTableCell firstCell;
  final List<ExpandableTableCell> cells;
  final double? height;
  final bool hideWhenExpanded;

  late bool _isExpanded;

  bool get isExpanded => _isExpanded;


  set isExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }
  ExpandableTableRowCore? parent;
  bool get visible => !isExpanded || !hideWhenExpanded;

  ExpandableTableRowCore({
    required this.firstCell,
    required this.cells,
    this.height,
    this.hideWhenExpanded = false,
    bool isExpanded = false,
  }) {
    _isExpanded = isExpanded;
  }

  int get cellsCount => cells?.length ?? 0;
}