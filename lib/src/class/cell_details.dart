import 'package:flutter_expandable_table/flutter_expandable_table.dart';

class CellDetails {
  final ExpandableTableHeader? headerParent;
  final ExpandableTableRow? rowParent;
  final ExpandableTableHeader? header;
  final ExpandableTableRow? row;

  CellDetails({
    required this.headerParent,
    required this.rowParent,
    required this.header,
    required this.row,
  });
}
