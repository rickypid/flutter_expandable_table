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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ExpandableTable _buildSimpleTable() {
    const int columnsCount = 20;
    const int rowsCount = 20;
    //Creation header
    List<ExpandableTableHeader> header = List.generate(
      columnsCount - 1,
      (index) => ExpandableTableHeader(
        width: index % 2 == 0 ? 200 : 150,
        cell: ExpandableTableCell(
          child: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: Center(
              child: Text(
                'Column $index',
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
    //Creation rows
    List<ExpandableTableRow> rows = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        height: rowIndex % 2 == 0 ? 50 : 70,
        firstCell: ExpandableTableCell(
          child: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: Center(
              child: Text(
                'Row $rowIndex',
                style: textStyle,
              ),
            ),
          ),
        ),
        cells: List<ExpandableTableCell>.generate(
          columnsCount - 1,
          (columnIndex) => ExpandableTableCell(
            child: Container(
              color: primaryColor,
              margin: const EdgeInsets.all(1),
              child: Center(
                child: Text(
                  'Cell $rowIndex:$columnIndex',
                  style: textStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return ExpandableTable(
      firstHeaderCell: ExpandableTableCell(
        child: Container(
          color: primaryColor,
          margin: const EdgeInsets.all(1),
          child: const Center(
            child: Text(
              'Simple\nTable',
              style: textStyle,
            ),
          ),
        ),
      ),
      header: header,
      scrollShadowColor: accentColor,
      rows: rows,
    );
  }

  ExpandableTable _buildExpandableTable() {
    const int columnsCount = 20;
    const int subColumnsCount = 5;
    const int rowsCount = 6;

    //Creation header
    List<ExpandableTableHeader> subHeader = List.generate(
      subColumnsCount,
      (index) => ExpandableTableHeader(
        cell: ExpandableTableCell(
          child: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: Center(
              child: Text(
                'Sub Column $index',
                style: textStyleSubItems,
              ),
            ),
          ),
        ),
      ),
    );

    //Creation header
    List<ExpandableTableHeader> header = List.generate(
      columnsCount,
      (index) => ExpandableTableHeader(
          cell: ExpandableTableCell(
            child: Container(
              color: primaryColor,
              margin: const EdgeInsets.all(1),
              child: Center(
                child: Text(
                  'Column $index',
                  style: textStyle,
                ),
              ),
            ),
          ),
          children: index == 6 ? subHeader : null),
    );

    //Creation sub rows
    List<ExpandableTableRow> subTows1 = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        height: 30,
        firstCell: ExpandableTableCell(
          child: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Sub Sub Row $rowIndex',
                style: textStyleSubItems,
              ),
            ),
          ),
        ),
        cells: List<ExpandableTableCell>.generate(
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
        ),
      ),
    );
    List<ExpandableTableRow> subRows = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        height: 30,
        firstCell: ExpandableTableCell(
          child: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Sub Row $rowIndex',
                style: textStyleSubItems,
              ),
            ),
          ),
        ),
        children: rowIndex == 0 ? subTows1 : null,
        cells: List<ExpandableTableCell>.generate(
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
        ),
      ),
    );
    //Creation rows
    List<ExpandableTableRow> rows = List.generate(
      rowsCount,
      (rowIndex) => ExpandableTableRow(
        height: 30,
        firstCell: ExpandableTableCell(
          child: Container(
            color: primaryColor,
            margin: const EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Row $rowIndex',
                style: textStyleSubItems,
              ),
            ),
          ),
        ),
        children: rowIndex == 0 ? subRows : null,
        cells: List<ExpandableTableCell>.generate(
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
        ),
      ),
    );

    return ExpandableTable(
      rows: rows,
      header: header,
      scrollShadowColor: accentColor,
      firstHeaderCell: ExpandableTableCell(
        child: Container(
          color: primaryColor,
          margin: const EdgeInsets.all(1),
          child: const Center(
            child: Text(
              'Expandable\nTable',
              style: textStyleSubItems,
            ),
          ),
        ),
      ),
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