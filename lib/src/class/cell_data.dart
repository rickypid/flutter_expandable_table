import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class ExpandableTableCellData {
  final ExpandableTableCell cell;
  final double height;
  final double width;
  final bool visible;

  ExpandableTableCellData({
    required this.cell,
    required this.height,
    required this.width,
    required this.visible,
  });
}