// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_expandable_table/flutter_expandable_table.dart';

ExpandableTableCell _cell(String text) =>
    ExpandableTableCell(child: Center(child: Text(text)));

/// 10 columns, the last one ("C 9") has 4 nested columns.
List<ExpandableTableHeader> _headers() => List.generate(
      10,
      (index) => ExpandableTableHeader(
        cell: _cell('C $index'),
        children: index == 9
            ? List.generate(
                4, (child) => ExpandableTableHeader(cell: _cell('C 9.$child')))
            : null,
      ),
    );

/// Rows with 14 cells; the first one ("R 0") has 3 nested rows.
List<ExpandableTableRow> _rows(int count) => List.generate(
      count,
      (row) => ExpandableTableRow(
        firstCell: _cell('R $row'),
        cells: List.generate(14, (column) => _cell('R$row C$column')),
        children: row == 0
            ? List.generate(
                3,
                (child) => ExpandableTableRow(
                  firstCell: _cell('R 0.$child'),
                  cells: List.generate(
                      14, (column) => _cell('R0.$child C$column')),
                ),
              )
            : null,
      ),
    );

Widget _app(Widget table) => MaterialApp(home: Scaffold(body: table));

ExpandableTable _table({int rows = 5}) => ExpandableTable(
      firstHeaderCell: _cell('Table'),
      headers: _headers(),
      rows: _rows(rows),
      firstColumnWidth: 100,
      defaultsColumnWidth: 100,
      headerHeight: 50,
    );

void main() {
  testWidgets('Header and body stay aligned after collapsing scrolled columns',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_app(_table()));

    await tester.dragFrom(const Offset(400, 300), const Offset(-2000, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('C 9'));
    await tester.pumpAndSettle();

    // Scroll to the far right, then collapse the nested columns.
    await tester.dragFrom(const Offset(400, 300), const Offset(-2000, 0));
    await tester.pumpAndSettle();
    expect(find.text('C 9.3').hitTestable(), findsOneWidget);
    await tester.tap(find.text('C 9'));
    await tester.pumpAndSettle();

    expect(find.text('C 9.3'), findsNothing);
    for (final column in [6, 7, 8, 9]) {
      expect(
        tester.getCenter(find.text('R1 C$column')).dx,
        tester.getCenter(find.text('C $column')).dx,
        reason: 'column $column misaligned',
      );
    }
  });

  testWidgets('Rows expand and collapsed rows leave the tree', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_app(_table()));
    expect(find.text('R 0.0'), findsNothing);

    await tester.tap(find.text('R 0'));
    await tester.pumpAndSettle();
    expect(find.text('R 0.2').hitTestable(), findsOneWidget);
    expect(find.text('R0.2 C0').hitTestable(), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('R0.2 C0')).dy,
      tester.getTopLeft(find.text('R 0.2')).dy,
    );

    await tester.tap(find.text('R 0'));
    // Still visible while animating out.
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('R 0.2'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('R 0.2'), findsNothing);
    expect(find.text('R0.2 C0'), findsNothing);
  });

  testWidgets('Only rows in the viewport are built with many rows',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_app(_table(rows: 10000)));
    expect(find.text('R 0'), findsOneWidget);
    expect(find.text('R 9999'), findsNothing);
    // Only the rows filling the viewport are built.
    expect(find.textContaining(RegExp(r'^R \d+$')).evaluate().length,
        lessThan(30));
  });

  testWidgets('Non expanded table with no rows or headers', (tester) async {
    await tester.pumpWidget(_app(Center(
      child: ExpandableTable(
        firstHeaderCell: _cell('Table'),
        headers: const [],
        rows: const [],
        expanded: false,
      ),
    )));
    expect(tester.takeException(), isNull);
    expect(find.text('Table'), findsOneWidget);
  });

  test('rowsCount counts nested rows regardless of expansion', () {
    final row = ExpandableTableRow(
      firstCell: _cell('R'),
      cells: const [],
      children: [
        ExpandableTableRow(
          firstCell: _cell('R.0'),
          cells: const [],
          hideWhenExpanded: true,
          childrenExpanded: true,
          children: [
            ExpandableTableRow(firstCell: _cell('R.0.0'), cells: const []),
          ],
        ),
      ],
    );
    expect(row.rowsCount, 3);
  });

  test('Controller flattened lists follow expansion changes', () {
    final controller = ExpandableTableController(
      firstHeaderCell: _cell('Table'),
      headers: _headers(),
      rows: _rows(2),
    );
    expect(controller.allRows.length, 5);
    expect(controller.visibleRows.length, 2);
    controller.rows.first.toggleExpand();
    expect(controller.visibleRows.length, 5);
    expect(controller.visibleHeaders.length, 10);
    controller.headers.last.toggleExpand();
    expect(controller.visibleHeaders.length, 14);
    controller.rows = _rows(1);
    expect(controller.allRows.length, 4);
    expect(controller.visibleRows.length, 1);
  });
}
