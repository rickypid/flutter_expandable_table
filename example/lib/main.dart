import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

const Color primaryColor = Color(0xFF1e2f36); //corner
const Color accentColor = Color(0xFF0d2026); //background
const TextStyle textStyle = TextStyle(color: Colors.white);
const TextStyle textStyleSubItems = TextStyle(color: Colors.grey);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExpandableTable Example',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const MyHomePage(),
      scrollBehavior: AppCustomScrollBehavior(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ExpandableTableCell _buildCell(String content) {
    return ExpandableTableCell(
      child: Container(
        color: primaryColor,
        margin: const EdgeInsets.all(1),
        child: Center(
          child: Text(
            content,
            style: textStyle,
          ),
        ),
      ),
    );
  }

  ExpandableTable _buildSimpleTable() {
    const int columnsCount = 20;
    const int rowsCount = 20;
    //Creation header
    List<ExpandableTableHeader> header = List.generate(
      columnsCount - 1,
      (index) => ExpandableTableHeader(
        width: index % 2 == 0 ? 200 : 150,
        cell: _buildCell('Column $index'),
      ),
    );
    //Creation rows
    List<ExpandableTableRow> rows = List.generate(
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
      headers: header,
      scrollShadowColor: accentColor,
      rows: rows,
    );
  }

  ExpandableTable _buildExpandableTable() {
    const int columnsCount = 20;
    const int subColumnsCount = 2;
    const int rowsCount = 6;

    //Creation header
    List<ExpandableTableHeader> subHeader = List.generate(
      subColumnsCount,
      (index) => ExpandableTableHeader(
        cell: _buildCell('Sub Column $index'),
      ),
    );

    //Creation header
    List<ExpandableTableHeader> header = List.generate(
      columnsCount,
      (index) => ExpandableTableHeader(
          cell: _buildCell('Column $index'),
          children: index == 19 ? subHeader : null),
    );

    //Creation sub rows
    List<ExpandableTableRow> subTows1 = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        firstCell: _buildCell('Sub Sub Row $rowIndex'),
        cells: List<ExpandableTableCell>.generate(
          columnsCount + subColumnsCount,
          (columnIndex) => _buildCell('Cell $rowIndex:$columnIndex'),
        ),
      ),
    );
    List<ExpandableTableRow> subRows = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        firstCell: ExpandableTableCell(
          builder: (context, details) => Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 500),
                    turns: details.row?.childrenExpanded == true ? 0.25 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Sub Row $rowIndex',
                    style: textStyleSubItems,
                  ),
                ],
              ),
            ),
          ),
        ),
        children: rowIndex == 3 ? subTows1 : null,
        cells: List<ExpandableTableCell>.generate(
          columnsCount + subColumnsCount,
          (columnIndex) => _buildCell('Cell $rowIndex:$columnIndex'),
        ),
      ),
    );
    //Creation rows
    List<ExpandableTableRow> rows = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        firstCell: ExpandableTableCell(
          child: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Center(
                child: Text(
                  'Row $rowIndex',
                  style: textStyle,
                ),
              ),
            ),
          ),
        ),
        children: rowIndex == 4 ? subRows : null,
        cells: rowIndex != 3
            ? List<ExpandableTableCell>.generate(
                columnsCount + subColumnsCount,
                (columnIndex) => ExpandableTableCell(
                  child: Container(
                    color: primaryColor,
                    margin: const EdgeInsets.all(1),
                    child: Center(
                      child: Text(
                        'Cell $rowIndex:$columnIndex',
                        style: textStyleSubItems,
                      ),
                    ),
                  ),
                ),
              )
            : null,
        legend: rowIndex == 3
            ? Container(
                color: primaryColor,
                margin: const EdgeInsets.all(1),
                child: const Align(
                  alignment: FractionalOffset.centerLeft,
                  child: Text(
                    'Row legend',
                    style: textStyle,
                  ),
                ),
              )
            : null,
      ),
    );

    return ExpandableTable(
      firstHeaderCell: _buildCell('Expandable\nTable'),
      rows: rows,
      headers: header,
      defaultsRowHeight: 60,
      scrollShadowColor: accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            '   Simple Table                    |                    Expandable Table'),
        centerTitle: true,
      ),
      body: Container(
        color: accentColor,
        child: Row(
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
}

class AppCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
