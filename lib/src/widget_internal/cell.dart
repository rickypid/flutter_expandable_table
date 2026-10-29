// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

/// [ExpandableTableCellWidget] it is the widget that builds the table cell.
/// The cell is always laid out at its full size: expand/collapse animations
/// are applied by the table, which clips the cell to the animated extent.
class ExpandableTableCellWidget extends StatelessWidget {
  /// [builder] method for building cell content.
  final Function(BuildContext context, CellDetails details) builder;

  /// [height] cell height.
  final double height;

  /// [width] cell width.
  final double width;

  /// [onTap] tap event.
  final VoidCallback? onTap;

  /// [header] header of the table this cell belongs to.
  final ExpandableTableHeader? header;

  /// [row] row of the table this cell belongs to.
  final ExpandableTableRow? row;

  /// [ExpandableTableCellWidget] widget constructor.
  const ExpandableTableCellWidget({
    super.key,
    required this.builder,
    required this.height,
    required this.width,
    this.onTap,
    this.header,
    this.row,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: builder(
            context,
            CellDetails(
              headerParent: header?.parent,
              rowParent: row?.parent,
              header: header,
              row: row,
            ),
          ),
        ),
      );
}
