// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'my_app_test.dart';

void main() {
  const widget = MyApp();
  group('Simple table', () {
    testWidgets('First header table', (tester) async {
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

      expect(find.text('_Row 0'), findsOneWidget);
      expect(find.text('_Cell 0:0'), findsOneWidget);
      expect(find.text('_Row 18'), findsNothing);
      expect(find.text('_Cell 18:0'), findsNothing);
      await tester.dragFrom(
          tester.getCenter(find.text('_Row 12')), const Offset(0, -500));
      await tester.pump();
      expect(find.text('_Row 18'), findsOneWidget);
      expect(find.text('_Cell 18:0'), findsOneWidget);
      expect(find.text('_Row 0'), findsNothing);
      expect(find.text('_Cell 0:0'), findsNothing);
    });
  });
}
