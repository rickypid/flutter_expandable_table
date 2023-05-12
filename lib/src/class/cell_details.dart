import 'package:flutter_expandable_table/flutter_expandable_table.dart';

/// [CellDetails] class.
/// This class contains the details of a cell, such as the
/// instance of the row and column it belongs to, furthermore
/// if the cell is inside a nested row or column it is possible
/// to access the instance of the parent row or column
class CellDetails {
  /// [header] is the instance of the column it belongs to.
  final ExpandableTableHeader? header;

  /// [row] is the instance of the row it belongs to.
  final ExpandableTableRow? row;

  /// [headerParent] is the instance of the parent column it
  /// belongs to (Only if it is inside a nested column).
  final ExpandableTableHeader? headerParent;

  /// [rowParent] is the instance of the parent row it
  /// belongs to (Only if it is inside a nested row).
  final ExpandableTableRow? rowParent;

  /// [CellDetails] class constructor.
  /// This class contains the details of a cell, such as the
  /// instance of the row and column it belongs to, furthermore
  /// if the cell is inside a nested row or column it is possible
  /// to access the instance of the parent row or column
  CellDetails({
    required this.headerParent,
    required this.rowParent,
    required this.header,
    required this.row,
  });
}
