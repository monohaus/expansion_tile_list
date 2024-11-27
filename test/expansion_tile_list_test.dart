import 'dart:math';

import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  basicWidgetTests();

  trailingAnimationTests();

  edgeCaseTests();

  expansionModeTests();

  expansionModeUsingNamedConstructorTests();

  copyWithTests();
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
      'ExpansionTileList tileGapSize property sets the gap size between tiles',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            tileGapSize: 10,
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

  /// 'ExpansionTileList tileBuilder property customizes the ExpansionTile widget',
  testWidgets(
      'ExpansionTileList tileBuilder property customizes the ExpansionTile widget',
      (WidgetTester tester) async {
   var colors = [Colors.blue, Colors.green];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ExpansionTileList(
            tileBuilder: (context, index, child) {
              return Container(
                key: ValueKey(index),
                color: colors[index % 2],
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
      find.ancestor(of: find.text('Tile 1'), matching: find.byKey(const ValueKey(0))),
    );
    expect(firstTileContainer.color, Colors.blue);

    // Verify the second tile has a green background.
    final secondTileContainer = tester.widget<Container>(
      find.ancestor(of: find.text('Tile 2'), matching: find.byKey(const ValueKey(1))),
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

    // Get the initial rotation value
    final initialTransform =
        tester.widget<Transform>(find.byType(Transform).first);
    final initialRotation = _getTransformRotation(initialTransform);
    expect(initialRotation, 0.0);

    // Tap the ExpansionTile to expand it
    await tester.tap(find.text('Tile 1'));
    await tester.pumpAndSettle();

    // Verify the expanded content is displayed
    expect(find.text('Child 1'), findsOneWidget);

    // Get the current rotation value
    final currentTransform =
        tester.widget<Transform>(find.byType(Transform).first);
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
    controller.toggle(5);
    controller.expand(5);
    controller.collapse(5);
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

void expansionModeUsingNamedConstructorTests() {
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
}

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
