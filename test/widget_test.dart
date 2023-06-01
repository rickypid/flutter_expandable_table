// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'my_app_test.dart';

void main() {
  const widget = MyApp();
  group('Simple table', () {
    testWidgets('First header table cell', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('Simple\nTable'), findsOneWidget);
    });
    testWidgets('Visible columns and rows limits', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Column 0').hitTestable(), findsOneWidget);
      expect(find.text('_Column 3').hitTestable(), findsOneWidget);
      expect(find.text('_Column 4').hitTestable(), findsNothing);
      expect(find.text('_Row 0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 12').hitTestable(), findsOneWidget);
      expect(find.text('_Row 13').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:3').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:4').hitTestable(), findsNothing);
      expect(find.text('_Cell 12:0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 12:3').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 12:4').hitTestable(), findsNothing);
    });
    testWidgets('First column vertical scroll', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Row 0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 18').hitTestable(), findsNothing);
      expect(find.text('_Cell 18:0').hitTestable(), findsNothing);
      await tester.dragFrom(
          tester.getCenter(find.text('_Row 12')), const Offset(0, -500));
      await tester.pump();
      expect(find.text('_Row 18').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 18:0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 0').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsNothing);
    });
    testWidgets('Header horizontal scroll', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Column 0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Column 7').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:7').hitTestable(), findsNothing);
      await tester.dragFrom(
          tester.getCenter(find.text('_Column 3')), const Offset(-730, 0));
      await tester.pump();
      expect(find.text('_Column 0').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsNothing);
      expect(find.text('_Column 7').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:7').hitTestable(), findsOneWidget);
    });
    testWidgets('Body vertical scroll', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Row 0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 18').hitTestable(), findsNothing);
      expect(find.text('_Cell 18:0').hitTestable(), findsNothing);
      await tester.dragFrom(
          tester.getCenter(find.text('_Cell 12:0')), const Offset(0, -500));
      await tester.pump();
      expect(find.text('_Row 18').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 18:0').hitTestable(), findsOneWidget);
      expect(find.text('_Row 0').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsNothing);
    });
    testWidgets('Body horizontal scroll', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('_Column 0').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('_Column 7').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:7').hitTestable(), findsNothing);
      await tester.dragFrom(
          tester.getCenter(find.text('_Cell 0:3')), const Offset(-730, 0));
      await tester.pump();
      expect(find.text('_Column 0').hitTestable(), findsNothing);
      expect(find.text('_Cell 0:0').hitTestable(), findsNothing);
      expect(find.text('_Column 7').hitTestable(), findsOneWidget);
      expect(find.text('_Cell 0:7').hitTestable(), findsOneWidget);
    });
  });
  group('Expandable table', () {
    testWidgets('First header table cell', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('Expandable\nTable'), findsOneWidget);
    });
    testWidgets('Visible columns and rows limits', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('&Column 0').hitTestable(), findsOneWidget);
      expect(find.text('&Column 3').hitTestable(), findsOneWidget);
      expect(find.text('&Column 4').hitTestable(), findsNothing);
      expect(find.text('&Row 0').hitTestable(), findsOneWidget);
      expect(find.text('&Row 5').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 0:0').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 0:5').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 0:6').hitTestable(), findsNothing);
      expect(find.text('&Cell 5:0').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 5:5').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 5:6').hitTestable(), findsNothing);
    }); /*
    testWidgets('Rows expansion', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1920, 1080));
      await tester.pumpWidget(widget);
      expect(find.text('&Row 2').hitTestable(), findsOneWidget);
      expect(find.text('&Sub &Row 0').hitTestable(), findsNothing);
      expect(find.text('&Cell 0:0').hitTestable(), findsOneWidget);
      await tester.tap(find.text('&Row 2'));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('&Row 2').hitTestable(), findsOneWidget);
      expect(find.text('&Cell 0:0').hitTestable(), findsNWidgets(2));
      expect(find.textContaining('&Sub &Row 0').hitTestable(), findsOneWidget);
    });*/
  });
}
