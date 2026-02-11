import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/ui/screens/ride_pref/widgets/bla_button.dart';

void main() {
  testWidgets('BlaButton renders primary with text and icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlaButton(
          type: BlaButtonType.primary,
          text: 'Request to book',
          icon: Icons.event_available,
          onPressed: () {},
        ),
      ),
    );
    expect(find.text('Request to book'), findsOneWidget);
    expect(find.byIcon(Icons.event_available), findsOneWidget);
  });

  testWidgets('BlaButton renders secondary with text and icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlaButton(
          type: BlaButtonType.secondary,
          text: 'Contact Volodia',
          icon: Icons.chat_bubble_outline,
          onPressed: () {},
        ),
      ),
    );
    expect(find.text('Contact Volodia'), findsOneWidget);
    expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
  });
}