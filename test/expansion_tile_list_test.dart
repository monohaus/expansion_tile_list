import 'dart:math';

import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  basicWidgetTests();

  trailingAnimationTests();

  edgeCaseTests();
}

void basicWidgetTests() {
  testWidgets('ExpansionTileList is created with correct number of tiles',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            children: <ExpansionTile>[
              ExpansionTile(
                title: Text('Tile 1'),
                children: <Widget>[Text('Child 1')],
              ),
              ExpansionTile(
                title: Text('Tile 2'),
                children: <Widget>[Text('Child 2')],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(ExpansionTile), findsNWidgets(2));
  });

  testWidgets(
      'ExpansionTileList can be created and responds to tap events (onExpansionChanged is called)',
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

  testWidgets(
      'ExpansionTileList initialExpandedIndex and initialExpandedIndexes properties work correctly',
      (WidgetTester tester) async {
    // Define the test widget
    const testWidget = MaterialApp(
      home: Scaffold(
        body: ExpansionTileList(
          // initialExpandedIndex: 0,
          initialExpandedIndexes: [0, 1],
          children: <ExpansionTile>[
            ExpansionTile(
              title: Text('Tile 1'),
              children: <Widget>[Text('Child 1')],
            ),
            ExpansionTile(
              title: Text('Tile 2'),
              children: <Widget>[Text('Child 2')],
            ),
            ExpansionTile(
              title: Text('Tile 3'),
              children: <Widget>[Text('Child 3')],
            ),
          ],
        ),
      ),
    );

    // Build the test widget
    await tester.pumpWidget(testWidget);

    // Verify that the child widgets of the first and second tiles are visible initially
    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Child 2'), findsOneWidget);

    // Verify that the child widget of the third tile is not visible initially
    expect(find.text('Child 3'), findsNothing);

    // Tap on the first tile to collapse it
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify that the child widget of the first tile is not visible after collapse
    expect(find.text('Child 1'), findsNothing);

    // Tap on the second tile to collapse it
    await tester.tap(find.text('Tile 2'));
    await tester.pumpAndSettle();

    // Verify that the child widget of the second tile is not visible after collapse
    expect(find.text('Child 2'), findsNothing);
  });
}

void trailingAnimationTests() {
  testWidgets('Trailing animation is triggered when ExpansionTile is expanded',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            trailing: Icon(Icons.arrow_drop_down),
            children: <ExpansionTile>[
              ExpansionTile(
                title: Text('Tile 1'),
                children: <Widget>[Text('Child 1')],
              ),
            ],
          ),
        ),
      ),
    );

    final trailingIcon = find.byIcon(Icons.arrow_drop_down);
    final Transform rotateTransform = tester.firstWidget(
        find.ancestor(of: trailingIcon, matching: find.byType(Transform)));

    // Verify the initial rotation angle is 0.
    expect(_getTransformRotation(rotateTransform), 0);

    await tester.tap(trailingIcon);
    await tester.pumpAndSettle();

    final Transform rotateTransformTapped = tester.firstWidget(
        find.ancestor(of: trailingIcon, matching: find.byType(Transform)));
    // Verify the rotation angle is pi after expansion.
    expect(_getTransformRotation(rotateTransformTapped), pi);
  });

  testWidgets('Trailing animation is reversed when ExpansionTile is collapsed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            trailing: Icon(Icons.arrow_drop_down),
            children: <ExpansionTile>[
              ExpansionTile(
                title: Text('Tile 1'),
                children: <Widget>[Text('Child 1')],
              ),
            ],
          ),
        ),
      ),
    );

    final trailingIcon = find.byIcon(Icons.arrow_drop_down);
    await tester.tap(trailingIcon);
    await tester.pumpAndSettle();

    final Transform rotateTransform = tester.firstWidget(
        find.ancestor(of: trailingIcon, matching: find.byType(Transform)));

    // Verify the rotation angle is pi after expansion.
    expect(_getTransformRotation(rotateTransform), pi);

    await tester.tap(trailingIcon);
    await tester.pumpAndSettle();

    final Transform rotateTransformTapped = tester.firstWidget(
        find.ancestor(of: trailingIcon, matching: find.byType(Transform)));
    // Verify the rotation angle is 0 after collapse.
    expect(_getTransformRotation(rotateTransformTapped), 0);
  });

  testWidgets(
      'Trailing animation is not triggered when trailingAnimationEnabled is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            trailing: Icon(Icons.arrow_drop_down),
            trailingAnimationEnabled: false,
            children: <ExpansionTile>[
              ExpansionTile(
                title: Text('Tile 1'),
                children: <Widget>[Text('Child 1')],
              ),
            ],
          ),
        ),
      ),
    );

    final trailingIcon = find.byIcon(Icons.arrow_drop_down);

    final rotateTransformFinder =
        find.ancestor(of: trailingIcon, matching: find.byType(Transform));

    // Verify the transform widget is not found.
    expect(rotateTransformFinder, findsNothing);

    await tester.tap(trailingIcon);
    await tester.pumpAndSettle();

    final rotateTransformTappedFinder =
        find.ancestor(of: trailingIcon, matching: find.byType(Transform));
    // Verify the transform widget is still not found after expansion..
    expect(rotateTransformTappedFinder, findsNothing);
  });

  testWidgets(
      'ExpansionTileList initialExpandedIndex, initialExpandedIndexes and trailing animation work correctly',
      (WidgetTester tester) async {
    // Define the test widget
    const testWidget = MaterialApp(
      home: Scaffold(
        body: ExpansionTileList(
          //initialExpandedIndex: 0,
          initialExpandedIndexes: [0, 1],
          trailing: Icon(Icons.arrow_drop_down),
          children: <ExpansionTile>[
            ExpansionTile(
              title: Text('Tile 1'),
              children: <Widget>[Text('Child 1')],
            ),
            ExpansionTile(
              title: Text('Tile 2'),
              children: <Widget>[Text('Child 2')],
            ),
            ExpansionTile(
              title: Text('Tile 3'),
              children: <Widget>[Text('Child 3')],
            ),
          ],
        ),
      ),
    );

    // Build the test widget
    await tester.pumpWidget(testWidget);

    // Verify that the child widgets of the first and second tiles are visible initially
    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Child 2'), findsOneWidget);

    // Verify that the child widget of the third tile is not visible initially
    expect(find.text('Child 3'), findsNothing);

    final expansionTile = find.byType(ExpansionTile);
    final tile1 =
        find.ancestor(of: find.text('Tile 1'), matching: expansionTile);
    final tile2 =
        find.ancestor(of: find.text('Tile 2'), matching: expansionTile);
    final tile3 =
        find.ancestor(of: find.text('Tile 3'), matching: expansionTile);
    // Verify the initial rotation angle of the trailing icon is 0
    var tileInitialData = [
      (tile: tile1, angle: pi),
      (tile: tile2, angle: pi),
      (tile: tile3, angle: 0),
    ];
    for (var i in tileInitialData) {
      final Transform rotateTransform = tester.firstWidget(
          find.descendant(of: i.tile, matching: find.byType(Transform)));
      expect(_getTransformRotation(rotateTransform), i.angle);
    }

    for (final (i, item) in tileInitialData.indexed) {
      // Tap on the first tile to collapse it or expand it
      await tester.tap(find.text('Tile ${i + 1}'));
      await tester.pumpAndSettle();

      // Verify that the child widget  tile is not visible after collapse or visible after expand
      expect(find.text('Child ${i + 1}'),
          item.angle > 0 ? findsNothing : findsOneWidget);

      // Verify the rotation angle of the trailing icon is pi after collapse or 0 after expand
      final Transform rotateTransformTapped = tester.firstWidget(
          find.descendant(of: item.tile, matching: find.byType(Transform)));
      expect(_getTransformRotation(rotateTransformTapped),
          item.angle > 0 ? 0 : pi);
    }
  });
}

double _getTransformRotation(Transform transform) {
  final float64List = transform.transform.storage;
  return atan2(float64List[1], float64List[0]);
}

void edgeCaseTests() {
  testWidgets('ExpansionTileList handles being empty',
      (WidgetTester tester) async {
    // Build an empty ExpansionTileList
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            children: [],
          ),
        ),
      ),
    );

    // Verify that no ExpansionTiles are found
    expect(find.byType(ExpansionTile), findsNothing);
  });

  testWidgets('ExpansionTileListController handles invalid indices gracefully',
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

    // Try to toggle, expand, and collapse an invalid index.
    controller.toggle(5);
    controller.expand(5);
    controller.collapse(5);
    await tester.pumpAndSettle();

    // Verify all tiles are still collapsed.
    expect(find.text('Item 0 body'), findsNothing);
    expect(find.text('Item 1 body'), findsNothing);
    expect(find.text('Item 2 body'), findsNothing);
  });
}
