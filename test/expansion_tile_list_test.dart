import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ExpansionTileList can be created and responds to tap events',
      (WidgetTester tester) async {
    int callbackCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            children: const [
              ExpansionTile(
                title: Text('Tile 1'),
                children: [Text('Child 1')],
              ),
              ExpansionTile(
                title: Text('Tile 2'),
                children: [Text('Child 2')],
              ),
            ],
            onExpansionChanged: (index, isExpanded) {
              callbackCount += 1;
            },
          ),
        ),
      ),
    );

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Tap on the first tile to expand it.
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify the first tile is expanded.
    expect(find.text('Child 1'), findsOneWidget);

    // Verify the callback is called once.
    expect(callbackCount, 1);

    // Tap on the first tile again to collapse it.
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify the first tile is collapsed.
    expect(find.text('Child 1'), findsNothing);

    // Verify the callback is called twice.
    expect(callbackCount, 2);
  });

  testWidgets(
      'ExpansionTileListController can toggle, expand and collapse tiles',
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            controller: controller,
            children: List<ExpansionTile>.generate(
                3,
                (int index) => ExpansionTile(
                      title: Text('Item $index'),
                      children: [Text('Item $index body')],
                    )),
          ),
        ),
      ),
    );

    // Initially, all tiles are collapsed.
    expect(find.text('Item 0 body'), findsNothing);
    expect(find.text('Item 1 body'), findsNothing);
    expect(find.text('Item 2 body'), findsNothing);

    // Toggle the first tile.
    controller.toggle(0);
    await tester.pumpAndSettle();

    // Verify the first tile is expanded.
    expect(find.text('Item 0 body'), findsOneWidget);
    expect(find.text('Item 1 body'), findsNothing);
    expect(find.text('Item 2 body'), findsNothing);

    // Expand all tiles.
    controller.expandAll();
    await tester.pumpAndSettle();

    // Verify all tiles are expanded.
    expect(find.text('Item 0 body'), findsOneWidget);
    expect(find.text('Item 1 body'), findsOneWidget);
    expect(find.text('Item 2 body'), findsOneWidget);

    // Collapse all tiles.
    controller.collapseAll();
    await tester.pumpAndSettle();

    // Verify all tiles are collapsed.
    expect(find.text('Item 0 body'), findsNothing);
    expect(find.text('Item 1 body'), findsNothing);
    expect(find.text('Item 2 body'), findsNothing);
  });
}
