import 'package:flutter/material.dart';
import 'package:flutter_expandable_table/src/class/cell.dart';

class ExpandableTableHeaderCore extends ChangeNotifier {
  late bool _isExpanded;

  bool get isExpanded => _isExpanded;

  bool get visible => !isExpanded || !hideWhenExpanded;
  ExpandableTableHeaderCore? parent;

  set isExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }

  final ExpandableTableCell cell;
  final double? width;
  final bool hideWhenExpanded;

  ExpandableTableHeaderCore({
    required this.cell,
    this.hideWhenExpanded = true,
    this.width,
    bool isExpanded = false,
  }) {
    _isExpanded = isExpanded;
  }
}