import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

const Color _primaryColor = Color(0xFF1e2f36); //corner
const Color _accentColor = Color(0xFF0d2026); //background
const TextStyle _textStyle = TextStyle(color: Colors.white);
// const TextStyle _textStyleSubItems = TextStyle(color: Colors.grey);

void main() => runApp(const _MyApp());

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'ExpandableTable Example',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const _MyHomePage(),
      scrollBehavior: _AppCustomScrollBehavior(),
    );
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage();

  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _DefaultCellCard extends StatelessWidget {
  final Widget child;

  const _DefaultCellCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
      color: _primaryColor,
      margin: const EdgeInsets.all(1),
      child: child,
    );
}

class _MyHomePageState extends State<_MyHomePage> {
  ExpandableTableCell _buildCell(String content, {CellBuilder? builder}) => ExpandableTableCell(
      child: builder != null
          ? null
          : _DefaultCellCard(
              child: Center(
                child: Text(
                  content,
                  style: _textStyle,
                ),
              ),
            ),
      builder: builder,
    );

  ExpandableTableCell _buildFirstRowCell() => ExpandableTableCell(
      builder: (context, details) => _DefaultCellCard(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              SizedBox(
                width: 24 * details.row!.address.length.toDouble(),
                child: details.row?.children != null
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedRotation(
                          duration: const Duration(milliseconds: 500),
                          turns:
                              details.row?.childrenExpanded == true ? 0.25 : 0,
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
              Text(
                '${details.row!.address.length > 1 ? details.row!.address.skip(1).map((e) => 'Sub ').join() : ''}Row ${details.row!.address.last}',
                style: _textStyle,
              ),
            ],
          ),
        ),
      ),
    );

  ExpandableTable _buildSimpleTable() {
    const int columnsCount = 20;
    const int rowsCount = 20;
    //Creation header
    final List<ExpandableTableHeader> headers = List.generate(
      columnsCount - 1,
      (index) => ExpandableTableHeader(
        width: index % 2 == 0 ? 200 : 150,
        cell: _buildCell('Column $index'),
      ),
    );
    //Creation rows
    final List<ExpandableTableRow> rows = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        height: rowIndex % 2 == 0 ? 50 : 70,
        firstCell: _buildCell('Row $rowIndex'),
        cells: List<ExpandableTableCell>.generate(
          columnsCount - 1,
          (columnIndex) => _buildCell('Cell $rowIndex:$columnIndex'),
        ),
      ),
    );

    return ExpandableTable(
      firstHeaderCell: _buildCell('Simple\nTable'),
      headers: headers,
      scrollShadowColor: _accentColor,
      rows: rows,
      visibleScrollbar: true,
      trackVisibilityScrollbar: true,
      thumbVisibilityScrollbar: true,
    );
  }

  static const int columnsCount = 20;
  static const int subColumnsCount = 2;
  static const int rowsCount = 6;
  static const int subRowsCount = 3;
  static const int totalColumns = columnsCount + subColumnsCount;

  List<ExpandableTableRow> _generateRows(int quantity, {int depth = 0}) {
    final bool generateLegendRow = (depth == 0 || depth == 2);
    return List.generate(
      quantity,
      (rowIndex) => ExpandableTableRow(
        firstCell: _buildFirstRowCell(),
        children: ((rowIndex == 3 || rowIndex == 2) && depth < 3)
            ? _generateRows(subRowsCount, depth: depth + 1)
            : null,
        cells: !(generateLegendRow && (rowIndex == 3 || rowIndex == 2))
            ? List<ExpandableTableCell>.generate(
                totalColumns,
                (columnIndex) => _buildCell('Cell $rowIndex:$columnIndex'),
              )
            : null,
        legend: generateLegendRow && (rowIndex == 3 || rowIndex == 2)
            ? const _DefaultCellCard(
                child: Align(
                  alignment: FractionalOffset.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 24.0),
                    child: Text(
                      'This is row legend',
                      style: _textStyle,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  ExpandableTable _buildExpandableTable() {
    //Creation header
    final List<ExpandableTableHeader> subHeader = List.generate(
      subColumnsCount,
      (index) => ExpandableTableHeader(
        cell: _buildCell('Sub Column $index'),
      ),
    );

    //Creation header
    final List<ExpandableTableHeader> headers = List.generate(
      columnsCount,
      (index) => ExpandableTableHeader(
          cell: _buildCell(
              '${index == 1 ? 'Expandable\nColumn' : 'Column'} $index'),
          children: index == 1 ? subHeader : null),
    );

    return ExpandableTable(
      firstHeaderCell: _buildCell('Expandable\nTable'),
      rows: _generateRows(rowsCount),
      headers: headers,
      defaultsRowHeight: 60,
      defaultsColumnWidth: 150,
      firstColumnWidth: 250,
      scrollShadowColor: _accentColor,
      visibleScrollbar: true,
      expanded: false,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text(
            '   Simple Table                    |                    Expandable Table'),
        centerTitle: true,
      ),
      body: Container(
        color: _accentColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildSimpleTable(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildExpandableTable(),
              ),
            ),
          ],
        ),
      ),
    );
}

class _AppCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
