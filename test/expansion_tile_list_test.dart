import 'dart:math';

import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  basicWidgetTests();

  trailingAnimationTests();

  edgeCaseTests();

  expansionModeTests();

  //expansionModeUsingNamedConstructorTests();

  copyWithTests();

  scrollableWidgetTests();

  reorderableWidgetTests();
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
      'ExpansionTileList itemGapSize property sets the gap size between tiles',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            itemGapSize: 10,
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

    // Verify the gap size between tiles is 10.
    final expansionTiles = tester.widgetList(find.byType(ExpansionTile));
    for (int i = 0; i < expansionTiles.length - 1; i++) {
      final firstTileBottom =
          tester.getBottomLeft(find.byWidget(expansionTiles.elementAt(i))).dy;
      final secondTileTop =
          tester.getTopLeft(find.byWidget(expansionTiles.elementAt(i + 1))).dy;
      // Verify the gap size between tiles is 10.
      expect(secondTileTop - firstTileBottom, 10);
    }
  });

  /// 'ExpansionTileList separatorBuilder property customizes the separator between tiles',
  testWidgets(
      'ExpansionTileList separatorBuilder property customizes the separator between tiles',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.red),
            children: const <ExpansionTile>[
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Verify the separator is a Divider with red color.
    final separators = find.byType(Divider);
    expect(separators, findsOneWidget);
    final Divider separator = tester.widget(separators);
    expect(separator.color, Colors.red);
  });

  /// 'ExpansionTileList itemBuilder property customizes the ExpansionTile widget',
  testWidgets(
      'ExpansionTileList itemBuilder property customizes the ExpansionTile widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            itemBuilder: (context, index, child) {
              return Container(
                key: ValueKey(index),
                color: (index % 2 == 0) ? Colors.blue : Colors.green,
                child: child,
              );
            },
            children: const <ExpansionTile>[
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Verify the first tile has a blue background.
    final firstTileContainer = tester.widget<Container>(
      find.ancestor(
          of: find.text('Tile 1'), matching: find.byKey(const ValueKey(0))),
    );
    expect(firstTileContainer.color, Colors.blue);

    // Verify the second tile has a green background.
    final secondTileContainer = tester.widget<Container>(
      find.ancestor(
          of: find.text('Tile 2'), matching: find.byKey(const ValueKey(1))),
    );
    expect(secondTileContainer.color, Colors.green);
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
    /*final expansionTile = find.byType(ExpansionTile);
    final rotateTransform = tester.firstWidget<Transform>(
        find.descendant(of: expansionTile, matching: find.byType(Transform)));*/

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
      'Trailing animation is not triggered when enableTrailingAnimation is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            trailing: Icon(Icons.arrow_drop_down),
            enableTrailingAnimation: false,
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

    // Find the Transform widget
    final rotateTransformFinder = find.descendant(
        of: find.byType(ExpansionTile), matching: find.byType(Transform));
    // Verify the transform widget is not found.
    expect(rotateTransformFinder, findsNothing);

    await tester.tap(trailingIcon);
    await tester.pumpAndSettle();

    final rotateTransformTappedFinder = find.descendant(
        of: find.byType(ExpansionTile), matching: find.byType(Transform));
    // Verify the transform widget is still not found after expansion..
    expect(rotateTransformTappedFinder, findsNothing);
  });

  testWidgets(
      'ExpansionTileList trailingAnimation property customizes the trailing animation of ExpansionTile widgets',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ExpansionTileList(
          trailing: const Icon(Icons.arrow_back_ios),
          trailingAnimation: ExpansionTileAnimation(
            animate: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, index, value, child) {
              return Transform.rotate(
                angle: value * pi,
                child: child,
              );
            },
            duration: const Duration(milliseconds: 500),
          ),
          children: const <ExpansionTile>[
            ExpansionTile(
              title: Text('Tile 1'),
              children: <Widget>[Text('Child 1')],
            ),
          ],
        ),
      ),
    ));

    // Verify the title is displayed
    expect(find.text('Tile 1'), findsOneWidget);
    expect(find.text('Child 1'), findsNothing);

    // Wait for a frame to ensure the initial rotation value is captured correctly
    await tester.pump();

    // Find the expansion tile
    final expansionTile = find.byType(ExpansionTile);

    // Get the initial rotation value

    final initialTransform = tester.firstWidget<Transform>(
        find.descendant(of: expansionTile, matching: find.byType(Transform)));

    final initialRotation = _getTransformRotation(initialTransform);
    expect(initialRotation, 0.0);

    // Tap the ExpansionTile to expand it
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify the expanded content is displayed
    expect(find.text('Child 1'), findsOneWidget);

    final currentTransform = tester.firstWidget<Transform>(
        find.descendant(of: expansionTile, matching: find.byType(Transform)));

    final currentRotation = _getTransformRotation(currentTransform);
    expect(currentRotation, pi);

    // Verify the rotation has changed from the initial value
    expect(currentRotation, isNot(equals(initialRotation)));
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
    await tester.pumpAndSettle();
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

  testWidgets(
      'ExpansionTileListController handles invalid indices gracefully when actions are called from the controller',
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
    // This should throw an assertion error.
    expect(
      () => controller.toggle(5),
      throwsA(isA<AssertionError>().having(
          (e) => e.message, 'message', contains('index out of bounds'))),
    );
    expect(
      () => controller.expand(5),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => controller.collapse(5),
      throwsA(isA<AssertionError>()),
    );
    await tester.pumpAndSettle();

    // Verify all tiles are still collapsed.
    expect(find.text('Item 0 body'), findsNothing);
    expect(find.text('Item 1 body'), findsNothing);
    expect(find.text('Item 2 body'), findsNothing);
  });

  /*// Find the widget
      final myWidgetFinder = find.byType(MyWidget);

      // Verify the widget's enable property is true
      final myWidget = tester.widget<MyWidget>(myWidgetFinder);
      expect(myWidget.enable, isTrue);*/
}

void expansionModeTests() {
  testWidgets(
      'ExpansionTileList with ExpansionMode.any expands and collapses tiles independently',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            expansionMode: ExpansionMode.any,
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Tap on the first tile to expand it.
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify the first tile is expanded.
    expect(find.text('Child 1'), findsOneWidget);

    // Tap on the second tile to expand it.
    await tester.tap(find.text('Tile 2'));
    await tester.pumpAndSettle();

    // Verify the second tile is expanded and the first tile is still expanded.
    expect(find.text('Child 2'), findsOneWidget);
    expect(find.text('Child 1'), findsOneWidget);
  });

  testWidgets(
      'ExpansionTileList with ExpansionMode.atLeastOne always has at least one tile expanded',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            expansionMode: ExpansionMode.atLeastOne,
            initialExpandedIndexes: [0],
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Verify that the first tile is expanded initially.
    expect(find.text('Child 1'), findsOneWidget);

    // Tap on the first tile to collapse it (but it should keep it expanded).
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify that the first tile is still expanded and second tile is still collapsed.
    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Child 2'), findsNothing);
    //
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).first).enabled,
        isTrue);
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).last).enabled,
        isTrue);

    // Tap on the first tile to expand it.
    await tester.tap(find.text('Tile 2'));
    await tester.pumpAndSettle();

    // Verify the second tile is expanded and the first tile remain expanded and enabled.
    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Child 2'), findsOneWidget);
    //
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).first).enabled,
        isTrue);
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).last).enabled,
        isTrue);
  });

  testWidgets(
      'ExpansionTileList with ExpansionMode.atMostOne only allows at most one tile to be expanded at a time',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            expansionMode: ExpansionMode.atMostOne,
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Tap on the first tile to expand it.
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify the first tile is expanded.
    expect(find.text('Child 1'), findsOneWidget);

    // Tap on the second tile to expand it.
    await tester.tap(find.text('Tile 2'));
    await tester.pumpAndSettle();

    // Verify the first tile is collapsed and the second tile is expanded.
    expect(find.text('Child 1'), findsNothing);
    expect(find.text('Child 2'), findsOneWidget);
  });

  testWidgets(
      'ExpansionTileList with ExpansionMode.exactlyOne allows exactly one tile to be always expanded at a time',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            expansionMode: ExpansionMode.exactlyOne,
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Tap on the first tile to expand it.
    /*await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();*/

    // Verify the first tile is expanded as the default initialExpandedIndex is 0.
    expect(find.text('Child 1'), findsOneWidget);

    // Tap on the second tile to expand it.
    await tester.tap(find.text('Tile 2'));
    await tester.pumpAndSettle();

    // Verify the first tile is collapsed and the second tile is expanded.
    expect(find.text('Child 1'), findsNothing);
    expect(find.text('Child 2'), findsOneWidget);
  });
}

/*void expansionModeUsingNamedConstructorTests() {
  testWidgets(
      'ExpansionTileList.multiple defaults to ExpansionMode.any expands and collapses tiles independently',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.multiple(
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Tap on the first tile to expand it.
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify the first tile is expanded.
    expect(find.text('Child 1'), findsOneWidget);

    // Tap on the second tile to expand it.
    await tester.tap(find.text('Tile 2'));
    await tester.pumpAndSettle();

    // Verify the second tile is expanded and the first tile is still expanded.
    expect(find.text('Child 2'), findsOneWidget);
    expect(find.text('Child 1'), findsOneWidget);
  });

  testWidgets(
      'ExpansionTileList.multiple constructor works correctly with ExpansionMode.atLeastOne property when alwaysExpanded is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.multiple(
            alwaysOneExpanded: true,
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Verify that the first tile is expanded initially.
    expect(find.text('Child 1'), findsOneWidget);

    // Tap on the first tile to collapse it (but it should keep it expanded).
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify that the first tile is still expanded and second tile is still collapsed.
    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Child 2'), findsNothing);
    //
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).first).enabled,
        isFalse);
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).last).enabled,
        isTrue);

    // Tap on the first tile to expand it.
    await tester.tap(find.text('Tile 2'));
    await tester.pumpAndSettle();

    // Verify the second tile is expanded and the first tile remain expanded and enabled.
    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Child 2'), findsOneWidget);
    //
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).first).enabled,
        isTrue);
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).last).enabled,
        isTrue);
  });

  testWidgets(
      'ExpansionTileList.single defaults to ExpansionMode.atMostOne always has at most one tile expanded',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.single(
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Tap on the first tile to expand it.
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify the first tile is expanded.
    expect(find.text('Child 1'), findsOneWidget);

    // Tap on the second tile to expand it.
    await tester.tap(find.text('Tile 2'));
    await tester.pumpAndSettle();

    // Verify the first tile is collapsed and the second tile is expanded.
    expect(find.text('Child 1'), findsNothing);
    expect(find.text('Child 2'), findsOneWidget);
  });

  testWidgets(
      'ExpansionTileList.single constructor works correctly with ExpansionMode.exactlyOne property when alwaysExpanded is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.single(
            alwaysOneExpanded: true,
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

    // Verify the ExpansionTileList is created with 2 tiles.
    expect(find.byType(ExpansionTile), findsNWidgets(2));

    // Verify that the first tile is expanded initially.
    expect(find.text('Child 1'), findsOneWidget);

    // Tap on the first tile to collapse it (but it should keep it expanded).
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify that the first tile is still expanded and second tile is still collapsed.
    expect(find.text('Child 1'), findsOneWidget);
    expect(find.text('Child 2'), findsNothing);
    //
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).first).enabled,
        isFalse);
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).last).enabled,
        isTrue);

    // Tap on the first tile to expand it.
    await tester.tap(find.text('Tile 2'));
    await tester.pumpAndSettle();

    // Verify the second tile is expanded and the first tile remain expanded and enabled.
    expect(find.text('Child 1'), findsNothing);
    expect(find.text('Child 2'), findsOneWidget);
    //
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).first).enabled,
        isTrue);
    expect(
        tester.widget<ExpansionTile>(find.byType(ExpansionTile).last).enabled,
        isFalse);
  });
}*/

void copyWithTests() {
  testWidgets('ExpansionTileList copyWith works correctly',
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    final expansionTileList = ExpansionTileList(
      controller: controller,
      expansionMode: ExpansionMode.any,
      enableTrailingAnimation: true,
      trailing: const Icon(Icons.arrow_drop_down),
      children: const <ExpansionTile>[
        ExpansionTile(
          title: Text('Tile 1'),
          children: <Widget>[Text('Child 1')],
        ),
        ExpansionTile(
          title: Text('Tile 2'),
          children: <Widget>[Text('Child 2')],
        ),
      ],
    );

    final modifiedExpansionTileList = expansionTileList.copyWith(
      controller: controller,
      expansionMode: ExpansionMode.atLeastOne,
      enableTrailingAnimation: false,
      trailing: const Icon(Icons.arrow_drop_up),
      children: const <ExpansionTile>[
        ExpansionTile(
          title: Text('Tile 3'),
          children: <Widget>[Text('Child 3')],
        ),
        ExpansionTile(
          title: Text('Tile 4'),
          children: <Widget>[Text('Child 4')],
        ),
      ],
    );

    // Verify the controller is set correctly.
    expect(modifiedExpansionTileList.controller, controller);

    // Verify the expansionMode is set correctly.
    expect(modifiedExpansionTileList.expansionMode, ExpansionMode.atLeastOne);

    // Verify the enableTrailingAnimation is set correctly.
    expect(modifiedExpansionTileList.enableTrailingAnimation, isFalse);

    // Verify the trailing widget is set correctly.
    expect(modifiedExpansionTileList.trailing, isA<Icon>());

    // Verify the children are set correctly.
    expect(modifiedExpansionTileList.children.length, 2);
  });
}

void scrollableWidgetTests() {
  testWidgets('ExpansionTileList can be scrolled', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            children: List<ExpansionTile>.generate(
                20,
                (int index) => ExpansionTile(
                      title: Text('Item $index'),
                      children: [Text('Item $index body')],
                    )),
          ),
        ),
      ),
    );

    // Verify the first tile is  visible
    expect(find.text('Item 0'), findsOneWidget);
    final expansionTileListFinder = find.byType(ExpansionTileList);
    final position = tester.getBottomLeft(expansionTileListFinder);
    // Scroll the ExpansionTileList
    await tester.fling(
        expansionTileListFinder, Offset(0, -(position.dy)), 1000);
    await tester.pumpAndSettle();

    // Verify the first tile is not visible
    expect(find.text('Item 0'), findsNothing);

    // Verify the last tile is visible
    expect(find.text('Item 19'), findsOneWidget);
  });
}

void reorderableWidgetTests() {
  testWidgets('ExpansionTileList can be reordered',
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
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

    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    // Find the second item and its position
    final item2Finder = find.text('Item 1');
    final item2Position = tester.getCenter(item2Finder);

    // Find the third item and its position
    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    ///Drag the first item to the position of the third item
    await tester.drag(item1Finder,
        Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pumpAndSettle();

    final item1PositionAfterDrag = tester.getCenter(item1Finder);
    // Verify that the order has changed
    expect(item1PositionAfterDrag, item2Position);
    // find all text values
    final textValues = find
        .byType(Text)
        .evaluate()
        .map((e) => e.widget as Text)
        .map((e) => e.data)
        .toList();
    expect(textValues, ['Item 1', 'Item 0', 'Item 2']);

    // Expand the first tile
    controller.expand(0);
    await tester.pumpAndSettle();

    // Verify the expanded tile is still in the first position
    expect(find.text('Item 0 body'), findsNothing);
    expect(find.text('Item 1 body'), findsOneWidget);
    expect(find.text('Item 2 body'), findsNothing);
  });

  testWidgets(
      "ExpansionTileList will not be draggable when enableDefaultDragHandle is false",
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            enableDefaultDragHandles: false,
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

    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    await tester.drag(item1Finder,
        Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pumpAndSettle();

    // Verify the first item at index 0  has not been dragged
    expect(controller.currentPosition(0), 0);
  });

  testWidgets('ExpansionTileList can be reordered with custom drag handle',
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    final reorderNotifier = ValueNotifier<(int, int)>((0, 0));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            enableDefaultDragHandles: false,
            //dragHandle: Icon(Icons.drag_handle),
            onReorder: (oldIndex, newIndex) {
              reorderNotifier.value = (oldIndex, newIndex);
            },
            children: List<ExpansionTile>.generate(
                3,
                (int index) => ExpansionTile(
                      title: Text('Item $index'),
                      leading: ValueListenableBuilder<(int, int)>(
                          valueListenable: reorderNotifier,
                          builder: (context, (int, int) value, child) {
                            return ReorderableDragStartListener(
                              key: PageStorageKey(index),
                              index: controller.currentPosition(index),
                              child: const Icon(Icons.drag_handle),
                            );
                          }),
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

    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    // Find the second item and its position
    final item2Finder = find.text('Item 1');
    final item2Position = tester.getCenter(item2Finder);

    // Find the third item and its position
    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    ///Drag the first item to the position of the third item (using the center drag position)
    await tester.drag(item1Finder,
        Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pumpAndSettle();

    final item1PositionAfterDrag = tester.getCenter(item1Finder);
    // Verify that the order has not changed
    //expect(item1PositionAfterDrag, item2Position);
    expect(item1PositionAfterDrag, isNot(equals(item2Position)));
    // find all text values (still the same)
    var textValues = find
        .byType(Text)
        .evaluate()
        .map((e) => e.widget as Text)
        .map((e) => e.data)
        .toList();
    expect(textValues, ['Item 0', 'Item 1', 'Item 2']);

    final dragHandleFinder = find.byIcon(Icons.drag_handle).first;
    final dragHandlePosition = tester.getCenter(dragHandleFinder);

    ///Drag the first item to the position of the third item (using the leading drag handle)
    await tester.drag(dragHandleFinder,
        Offset(dragHandlePosition.dx, item3Position.dy - item1Position.dy));
    await tester.pumpAndSettle();

    final item1PosAfterDrag = tester.getCenter(item1Finder);
    // Verify that the order has changed
    expect(item1PosAfterDrag, item2Position);

    // find all text values
    textValues = find
        .byType(Text)
        .evaluate()
        .map((e) => e.widget as Text)
        .map((e) => e.data)
        .toList();
    expect(textValues, ['Item 1', 'Item 0', 'Item 2']);

    // Expand the first tile
    controller.expand(0);
    await tester.pumpAndSettle();

    // Verify the expanded tile is still in the first position
    expect(find.text('Item 0 body'), findsNothing);
    expect(find.text('Item 1 body'), findsOneWidget);
    expect(find.text('Item 2 body'), findsNothing);
    reorderNotifier.dispose();
  });

  testWidgets(
      "ExpansionTileList onReorder callback is called when item is dragged",
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    var reorderValue = (-1, -1);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            onReorder: (oldIndex, newIndex) {
              reorderValue = (oldIndex, newIndex);
            },
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

    expect(reorderValue, (-1, -1));
    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    // Find the third item and its position
    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    // Drag the first item to the position of the third item
    await tester.drag(item1Finder,
        Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pumpAndSettle();

    // Verify the callback is called with the correct indices
    expect(reorderValue, (0, 2));
  });

  testWidgets(
      "ExpansionTileList canReorder callback allows only even indexed items to be dragged",
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            canReorder: (oldIndex, newIndex) {
              return oldIndex.isEven;
            },
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

    expect(controller.initialPosition(1), controller.currentPosition(1));
    expect(controller.currentPosition(1), 1);
    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    // Find the second item and its position
    final item2Finder = find.text('Item 1');
    final item2Position = tester.getCenter(item2Finder);

    // Find the third item and its position
    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    // Drag the second item at index 1 to the position of the third item
    var dy = item3Position.dy - item2Position.dy;
    await tester.drag(item2Finder, Offset(0, dy + (dy / 2)));
    await tester.pumpAndSettle();

    // Verify the initialPosition equals the currentPosition
    expect(controller.currentPosition(1), 1);
    expect(controller.initialPosition(1), 1);

    // Drag the first item at index 0 to the position of the third item
    dy = item3Position.dy - item1Position.dy;
    await tester.drag(item1Finder, Offset(0, dy + (dy / 2)));
    await tester.pumpAndSettle();
    // Verify the initialPosition is not equals the currentPosition
    expect(controller.currentPosition(0), 1);
    expect(controller.initialPosition(1), 0);
  });

  testWidgets(
      "ExpansionTileList useDelayedDrag to delay the drag start (long press) when dragging an item",
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            useDelayedDrag: true,
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

    expect(controller.currentPosition(0), 0);
    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    // Find the third item and its position
    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    // Drag the first item to the position of the third item
    await tester.drag(item1Finder,
        Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pumpAndSettle();

    // Verify the position has not changed
    expect(controller.currentPosition(0), 0);

    // LongPressDrag the first item to the position of the second item
    // Start a gesture at the starting position
    final TestGesture gesture = await tester.startGesture(item1Position);
    // Pump to simulate the long press duration
    await tester.pump(const Duration(seconds: 1));
    await gesture
        .moveBy(Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    // Verify the position has changed
    expect(controller.currentPosition(0), 1);
  });

  testWidgets(
      "ExpansionTileList drag handle placement works correctly with DragHandlePlacement.leading",
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            dragHandlePlacement: DragHandlePlacement.leading,
            children: List<ExpansionTile>.generate(
                3,
                (int index) => ExpansionTile(
                      title: Text('Item $index'),
                      leading: const Icon(Icons.drag_handle),
                      children: [Text('Item $index body')],
                    )),
          ),
        ),
      ),
    );

    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    await tester.drag(item1Finder,
        Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pumpAndSettle();

    // Verify the first item at index 0  has not been dragged
    expect(controller.currentPosition(0), 0);

    // Find the drag handle and its position
    final dragHandleFinder = find.byIcon(Icons.drag_handle).first;
    final dragHandlePosition = tester.getCenter(dragHandleFinder);

    // Drag the first item to the position of the third item
    await tester.drag(
        dragHandleFinder,
        Offset(
            dragHandlePosition.dx, item3Position.dy - dragHandlePosition.dy));
    await tester.pumpAndSettle();

    // Verify the first item has been dragged
    expect(controller.currentPosition(0), 1);
  });

  testWidgets(
      "ExpansionTileList drag handle placement works correctly with DragHandlePlacement.trailing",
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            dragHandlePlacement: DragHandlePlacement.trailing,
            children: List<ExpansionTile>.generate(
                3,
                (int index) => ExpansionTile(
                      title: Text('Item $index'),
                      trailing: const Icon(Icons.drag_handle),
                      children: [Text('Item $index body')],
                    )),
          ),
        ),
      ),
    );

    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    await tester.drag(item1Finder,
        Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pumpAndSettle();

    // Verify the first item at index 0  has not been dragged
    expect(controller.currentPosition(0), 0);

    // Find the drag handle and its position
    final dragHandleFinder = find.byIcon(Icons.drag_handle).first;
    final dragHandlePosition = tester.getCenter(dragHandleFinder);

    // Drag the first item to the position of the third item
    await tester.drag(
        dragHandleFinder,
        Offset(
            dragHandlePosition.dx, item3Position.dy - dragHandlePosition.dy));
    await tester.pumpAndSettle();

    // Verify the first item has been dragged
    expect(controller.currentPosition(0), 1);
  });

  testWidgets(
      "ExpansionTileList drag handle placement works correctly with DragHandlePlacement.title",
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            dragHandlePlacement: DragHandlePlacement.title,
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

    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    await tester.dragFrom(
        item1Position.translate(item1Position.dx + 1, item1Position.dy),
        Offset(0, item3Position.dy - item1Position.dy),
        touchSlopX: 0);
    await tester.pumpAndSettle();

    // Verify the first item at index 0  has not been dragged
    expect(controller.currentPosition(0), 0);

    // Find the drag handle and its position
    final dragHandleFinder = item1Finder;
    final dragHandlePosition = item1Position;

    // Drag the first item to the position of the third item
    await tester.drag(
        dragHandleFinder,
        Offset(
            dragHandlePosition.dx, item3Position.dy - dragHandlePosition.dy));
    await tester.pumpAndSettle();

    // Verify the first item has been dragged
    expect(controller.currentPosition(0), 1);
  });

  testWidgets(
      "ExpansionTileList proxyDecorator function controls the appearance of the dragged item",
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    final proxyDecoration = BoxDecoration(
      color: Colors.red,
      border: Border.all(color: Colors.black),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            proxyDecorator: (widget, index, animation) {
              return Container(
                key: ValueKey<String>("proxy_decorator_$index"),
                decoration: proxyDecoration,
                child: Text('Proxy Decorator $index'),
              );
            },
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

    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    const item1ProxyKey = ValueKey<String>("proxy_decorator_0");
    final item1Proxy = find.byKey(item1ProxyKey);
    expect(item1Proxy, findsNothing);

    final TestGesture gesture = await tester.startGesture(item1Position);
    // Pump to simulate the long press duration
    await tester.pump(const Duration(seconds: 3));

    await gesture
        .moveBy(Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pump();
    // Verify the appearance of the dragged item
    final item1ProxyDuringDrag = find.byKey(item1ProxyKey);
    expect(item1ProxyDuringDrag, findsOneWidget);
    //
    final draggedItemDecoration =
        tester.widget<Container>(item1ProxyDuringDrag).decoration;
    expect(draggedItemDecoration, proxyDecoration);

    await gesture.up();
    await tester.pumpAndSettle();

    final item1ProxyAfterDrag = find.byKey(item1ProxyKey);
    expect(item1ProxyAfterDrag, findsNothing);
  });

  testWidgets(
      "ExpansionTileList drag handle builder function callback customizes the appearance of the drag handle",
      (WidgetTester tester) async {
    final controller = ExpansionTileListController();
    final dragHandleDecoration = BoxDecoration(
      color: Colors.red,
      border: Border.all(color: Colors.black),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            controller: controller,
            dragHandlePlacement: DragHandlePlacement.leading,
            dragHandleBuilder: (context, index) {
              return Container(
                key: ValueKey<String>("drag_handle_$index"),
                decoration: dragHandleDecoration,
                child: const Icon(Icons.drag_handle),
              );
            },
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

    // Find the first item and its position
    final item1Finder = find.text('Item 0');
    final item1Position = tester.getCenter(item1Finder);

    final item3Finder = find.text('Item 2');
    final item3Position = tester.getCenter(item3Finder);

    const item1DragHandleKey = ValueKey<String>("drag_handle_0");
    final item1DragHandle = find.byKey(item1DragHandleKey);
    expect(item1DragHandle, findsOneWidget);

    final TestGesture gesture = await tester.startGesture(item1Position);
    // Pump to simulate the long press duration
    await tester.pump(const Duration(seconds: 3));

    await gesture
        .moveBy(Offset(item1Position.dx, item3Position.dy - item1Position.dy));
    await tester.pump();
    // Verify the appearance of the drag handle
    final item1DragHandleDuringDrag = find.byKey(item1DragHandleKey);
    expect(item1DragHandleDuringDrag, findsOneWidget);
    //
    final draggedItemDecoration =
        tester.widget<Container>(item1DragHandleDuringDrag).decoration;
    expect(draggedItemDecoration, dragHandleDecoration);

    await gesture.up();
    await tester.pumpAndSettle();

    final item1DragHandleAfterDrag = find.byKey(item1DragHandleKey);
    expect(item1DragHandleAfterDrag, findsOneWidget);
  });

  testWidgets(
      "ExpansionTileList DragHandleAlignment.centerRight controls the alignment of the drag handle to the right relative to the DragHandlePlacement",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            dragHandlePlacement: DragHandlePlacement.leading,
            dragHandleAlignment: DragHandleAlignment.centerRight,
            dragHandleBuilder: (context, index) {
              return Container(
                key: ValueKey<String>("drag_handle_$index"),
                child: const Icon(Icons.drag_handle),
              );
            },
            children: List<ExpansionTile>.generate(
                3,
                (int index) => ExpansionTile(
                      leading: Icon(Icons.add,
                          key: ValueKey<String>("leading_$index")),
                      title: Text('Item $index'),
                      children: [Text('Item $index body')],
                    )),
          ),
        ),
      ),
    );

    for (int i = 0; i < 3; i++) {
      // Find the leading item and its position
      final leadingFinder = find.byKey(ValueKey<String>("leading_$i"));
      final leadingPosition = tester.getCenter(leadingFinder);

      // Find the drag handle and its position
      final dragHandleFinder = find.byKey(ValueKey<String>("drag_handle_$i"));
      final dragHandlePosition = tester.getCenter(dragHandleFinder);

      // Verify the drag handle is aligned to the center right of the leading item
      expect(dragHandlePosition.dx, greaterThan(leadingPosition.dx));
      expect(dragHandlePosition.dy, equals(leadingPosition.dy));
    }
  });

  testWidgets(
      "ExpansionTileList DragHandleAlignment.centerLeft controls the alignment of the drag handle to the left relative to the DragHandlePlacement",
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList.reorderable(
            dragHandlePlacement: DragHandlePlacement.leading,
            dragHandleAlignment: DragHandleAlignment.centerLeft,
            dragHandleBuilder: (context, index) {
              return Container(
                key: ValueKey<String>("drag_handle_$index"),
                child: const Icon(Icons.drag_handle),
              );
            },
            children: List<ExpansionTile>.generate(
                3,
                (int index) => ExpansionTile(
                      leading: Icon(Icons.add,
                          key: ValueKey<String>("leading_$index")),
                      title: Text('Item $index'),
                      children: [Text('Item $index body')],
                    )),
          ),
        ),
      ),
    );

    for (int i = 0; i < 3; i++) {
      // Find the leading item and its position
      final leadingFinder = find.byKey(ValueKey<String>("leading_$i"));
      final leadingPosition = tester.getCenter(leadingFinder);

      // Find the drag handle and its position
      final dragHandleFinder = find.byKey(ValueKey<String>("drag_handle_$i"));
      final dragHandlePosition = tester.getCenter(dragHandleFinder);

      // Verify the drag handle is aligned to the center left of the leading item
      expect(leadingPosition.dx, greaterThan(dragHandlePosition.dx));
      expect(leadingPosition.dy, equals(dragHandlePosition.dy));
    }
  });
}
