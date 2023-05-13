// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_expandable_table/src/class/cell_details.dart';

/// [ExpandableTableCell] class.
/// This class defines a single table cell.
/// You can define a child Widget or pass a builder function to build
/// your widget in the cell. Using the builder it is possible to access
/// the details of the cell itself.
class ExpandableTableCell extends ChangeNotifier {
  /// [builder] By defining the builder function it is possible to return
  /// the Widget to be inserted inside the cell and access the details
  /// of the cell itself during the build..
  /// `optional`
  final CellBuilder? builder;

  /// [child] Widget to insert inside the cell
  /// `optional`
  final Widget? child;

  /// [ExpandableTableCell] class constructor.
  /// This class defines a single table cell.
  /// You can define a child Widget or pass a builder function to build
  /// your widget in the cell. Using the builder it is possible to access
  /// the details of the cell itself.
  ExpandableTableCell({
    this.builder,
    this.child,
  }) : assert((builder != null || child != null) &&
            (builder == null || child == null));

  /// [build] method for building the cell contents
  Widget build(BuildContext context, CellDetails details) =>
      child ?? builder!(context, details);
}

typedef CellBuilder = Widget Function(
    BuildContext context, CellDetails details);
