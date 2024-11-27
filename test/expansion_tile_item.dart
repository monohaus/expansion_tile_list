import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  basicWidgetTests();

  trailingAnimationTests();

  edgeCaseTests();
}

void basicWidgetTests() {
  testWidgets('ExpansionTileItem displays title and expands',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ExpansionTileItem(
          title: Text('Test Title'),
          children: [Text('Expanded Content')],
        ),
      ),
    ));

    // Verify the title is displayed
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Expanded Content'), findsNothing);

    // Tap the ExpansionTile to expand it
    await tester.tap(find.text('Test Title'));
    await tester.pumpAndSettle();

    // Verify the expanded content is displayed
    expect(find.text('Expanded Content'), findsOneWidget);
  });

  // ExpansionTileItem.from creates an ExpansionTileItem from an ExpansionTile
  testWidgets(
      'ExpansionTileItem.from creates an ExpansionTileItem from an ExpansionTile',
      (WidgetTester tester) async {
    // Create an ExpansionTile
    ExpansionTile originalTile = const ExpansionTile(
      title: Text('Original'),
      children: [Text('Expanded Content')],
    );

    // Create an ExpansionTileItem from the ExpansionTile
    ExpansionTileItem copiedTile = ExpansionTileItem.from(originalTile);

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: copiedTile,
      ),
    ));

    // Verify the title is displayed
    expect(find.text('Original'), findsOneWidget);
    expect(find.text('Expanded Content'), findsNothing);

    // Tap the ExpansionTile to expand it
    await tester.tap(find.text('Original'));
    await tester.pumpAndSettle();

    // Verify the expanded content is displayed
    expect(find.text('Expanded Content'), findsOneWidget);
  });
}

void trailingAnimationTests() {
  testWidgets('ExpansionTileItem displays trailing animation',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ExpansionTileItem(
          title: Text('Test Title'),
          enableTrailingAnimation: true,
          trailing: Icon(CupertinoIcons.chevron_up),
          children: [Text('Expanded Content')],
        ),
      ),
    ));

    // Verify the title is displayed
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Expanded Content'), findsNothing);

    // Tap the ExpansionTile to expand it
    await tester.tap(find.text('Test Title'));
    await tester.pumpAndSettle();

    // Verify the expanded content is displayed
    expect(find.text('Expanded Content'), findsOneWidget);
  });

  testWidgets(
      'ExpansionTileItem displays trailing animation with custom animation and test the animation scale',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ExpansionTileItem(
          title: const Text('Test Title'),
          enableTrailingAnimation: true,
          trailing: const Icon(Icons.arrow_back_ios),
          trailingAnimation: ExpansionTileAnimation(
            animate: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            duration: const Duration(milliseconds: 500),
          ),
          children: const [Text('Expanded Content')],
        ),
      ),
    ));

    // Verify the title is displayed
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Expanded Content'), findsNothing);

    // Wait for a frame to ensure the initial scale value is captured correctly
    await tester.pump();
    /*// Find the icon
  final initialIconFinder = find.byIcon(Icons.arrow_back_ios);
  // Verify the icon is present
  expect(initialIconFinder, findsOneWidget);*/
    // Get the initial scale value
    final initialTransform =
        tester.widget<Transform>(find.byType(Transform).first);
    final initialScale = initialTransform.transform.storage[0];

    //expect((initialTransform.child as Icon).icon, Icons.arrow_back_ios);
    expect(initialScale, 0.0);

    // Tap the ExpansionTile to expand it
    await tester.tap(find.text('Test Title'));
    await tester.pumpAndSettle();

    // Verify the expanded content is displayed
    expect(find.text('Expanded Content'), findsOneWidget);

    // Get the current scale value
    final currentTransform =
        tester.widget<Transform>(find.byType(Transform).first);
    final currentScale = currentTransform.transform.storage[0];
    //expect((initialTransform.child as Icon).icon, Icons.arrow_back_ios);
    // Verify the custom animation scales the child widget to 1.0
    expect(currentScale, 1.0);

    // Verify the scale has changed from the initial value
    expect(currentScale, isNot(equals(initialScale)));
  });
}

void edgeCaseTests() {
  testWidgets(
      'ExpansionTileItem displays title and expands with empty children',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ExpansionTileItem(
          title: Text('Test Title'),
          children: [],
        ),
      ),
    ));

    // Verify the title is displayed
    expect(find.text('Test Title'), findsOneWidget);

    // Tap the ExpansionTile to expand it
    await tester.tap(find.text('Test Title'));
    await tester.pumpAndSettle();
  });
}
