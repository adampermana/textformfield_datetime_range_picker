import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:textformfield_datetime_range_picker/src/datetime_range.dart';
import 'package:textformfield_datetime_range_picker/textformfield_datetime_range_picker.dart';

void main() {
  group('TextFormFieldDateTimeRangePicker', () {
    testWidgets('renders correctly in fullDateTime mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.fullDateTime,
              onChanged: (DateTimeRange range) {},
            ),
          ),
        ),
      );

      expect(find.text('Start Date'), findsOneWidget);
      expect(find.text('End Date'), findsOneWidget);
      expect(find.text('Starting Hour'), findsOneWidget);
      expect(find.text('End Hour'), findsOneWidget);
    });

    testWidgets('renders correctly in timeOnly mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.timeOnly,
              onChanged: (DateTimeRange range) {},
            ),
          ),
        ),
      );

      expect(find.text('Start Time'), findsOneWidget);
      expect(find.text('End Time'), findsOneWidget);
      expect(find.text('Start Date'), findsNothing);
      expect(find.text('End Date'), findsNothing);
    });

    testWidgets('renders correctly in dateOnly mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.dateOnly,
              onChanged: (DateTimeRange range) {},
            ),
          ),
        ),
      );

      expect(find.text('Start Date'), findsOneWidget);
      expect(find.text('End Date'), findsOneWidget);
      expect(find.text('Starting Hour'), findsNothing);
      expect(find.text('End Hour'), findsNothing);
    });

    testWidgets('calls onChanged when date is selected',
        (WidgetTester tester) async {
      DateTimeRange? selectedRange;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormFieldDateTimeRangePicker(
              selectedOption: DateTimeOption.fullDateTime,
              onChanged: (DateTimeRange range) {
                selectedRange = range;
              },
            ),
          ),
        ),
      );

      // Tap the start date field
      await tester.tap(find.byType(DateTimeFields).first);
      await tester.pumpAndSettle();

      // Select a date from the date picker
      await tester.tap(find.text('15'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(selectedRange, isNotNull);
    });
  });
}
