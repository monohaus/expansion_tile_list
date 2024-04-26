import 'dart:math';
import 'dart:typed_data';

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
}

double _getTransformRotation(Transform transform) {
  final Float64List val = transform.transform.storage;
  return atan2(val[1], val[0]);
}

void edgeCaseTests(){
  testWidgets('ExpansionTileList handles being empty', (WidgetTester tester) async {
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

  testWidgets('ExpansionTileListController handles invalid indices gracefully', (WidgetTester tester) async {
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
