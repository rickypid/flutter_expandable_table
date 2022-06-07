import 'package:flutter/cupertino.dart';

class _ExpandableTableDataInherited extends InheritedWidget {
  final ExpandableTableDataState data;

  _ExpandableTableDataInherited({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(_ExpandableTableDataInherited old) => true;
}

class ExpandableTableData extends StatefulWidget {
  final Widget child;
  final double cellWidth;
  final double cellHeight;
  final double headerHeight;
  final double firstColumnWidth;
  final Duration duration;
  final Curve curve;
  final Duration scrollShadowDuration;
  final Curve scrollShadowCurve;
  final Color scrollShadowColor;
  final bool visibleScrollbar;

  ExpandableTableData({
    required this.child,
    required this.cellWidth,
    required this.cellHeight,
    required this.headerHeight,
    required this.firstColumnWidth,
    required this.duration,
    required this.curve,
    required this.scrollShadowDuration,
    required this.scrollShadowCurve,
    required this.scrollShadowColor,
    required this.visibleScrollbar,
  });

  static ExpandableTableDataState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<
            _ExpandableTableDataInherited>())!
        .data;
  }

  @override
  ExpandableTableDataState createState() => new ExpandableTableDataState();
}

class ExpandableTableDataState extends State<ExpandableTableData> {
  Duration get duration => widget.duration;

  Curve get curve => widget.curve;

  Duration get scrollShadowDuration => widget.scrollShadowDuration;

  Curve get scrollShadowCurve => widget.scrollShadowCurve;

  Color get scrollShadowColor => widget.scrollShadowColor;

  bool get visibleScrollbar => widget.visibleScrollbar;

  double get cellWidth => widget.cellWidth;

  double get cellHeight => widget.cellHeight;

  double get headerHeight => widget.headerHeight;

  double get firstColumnWidth => widget.firstColumnWidth;

  int get columnsCount => visibleColumn.length;

  int get visibleColumnsCount =>
      visibleColumn.where((element) => element == true).length;
  List<bool> visibleColumn = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new _ExpandableTableDataInherited(
      data: this,
      child: widget.child,
    );
  }
}
