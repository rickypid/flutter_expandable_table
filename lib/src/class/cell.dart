import 'package:flutter/material.dart';

class ExpandableTableCell extends ChangeNotifier {
  final Widget Function(BuildContext context)? builder;
  final Widget? child;

  ExpandableTableCell({
    this.builder,
    this.child,
  }) : assert((builder != null || child != null) &&
            (builder == null || child == null));
}