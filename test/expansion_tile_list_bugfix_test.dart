import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  childrenUpdateTests();
  boundsCheckTests();
  controllerStateErrorTests();
}

void childrenUpdateTests() {
  group('Bug fix: children update detection (negated listEquals)', () {
    testWidgets(
        'didUpdateWidget correctly detects when children list changes',
        (WidgetTester tester) async {
      final controller = ExpansionTileListController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              controller: controller,
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

      expect(find.byType(ExpansionTile), findsNWidgets(2));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              controller: controller,
              children: const <ExpansionTile>[
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
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ExpansionTile), findsNWidgets(3));
      expect(find.text('Tile 3'), findsOneWidget);
    });

    testWidgets(
        'didUpdateWidget does not re-init when children list is identical',
        (WidgetTester tester) async {
      final controller = ExpansionTileListController();

      const tiles = <ExpansionTile>[
        ExpansionTile(
          title: Text('Tile 1'),
          children: <Widget>[Text('Child 1')],
        ),
        ExpansionTile(
          title: Text('Tile 2'),
          children: <Widget>[Text('Child 2')],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              controller: controller,
              children: tiles,
            ),
          ),
        ),
      );

      controller.expand(0);
      await tester.pumpAndSettle();
      expect(find.text('Child 1'), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              controller: controller,
              children: tiles,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Child 1'), findsOneWidget);
    });

    testWidgets(
        'reducing children count updates positions correctly',
        (WidgetTester tester) async {
      final controller = ExpansionTileListController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              controller: controller,
              children: const <ExpansionTile>[
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
        ),
      );

      expect(find.byType(ExpansionTile), findsNWidgets(3));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              controller: controller,
              children: const <ExpansionTile>[
                ExpansionTile(
                  title: Text('Tile 1'),
                  children: <Widget>[Text('Child 1')],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExpansionTile), findsNWidgets(1));
      expect(find.text('Tile 2'), findsNothing);
      expect(find.text('Tile 3'), findsNothing);
    });
  });
}

void boundsCheckTests() {
  group('Bug fix: bounds check guards prevent crashes', () {
    testWidgets(
        'empty children list does not crash with expansionMode atLeastOne',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              expansionMode: ExpansionMode.atLeastOne,
              children: <ExpansionTile>[],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExpansionTile), findsNothing);
    });

    testWidgets(
        'empty children list does not crash with expansionMode exactlyOne',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              expansionMode: ExpansionMode.exactlyOne,
              children: <ExpansionTile>[],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExpansionTile), findsNothing);
    });

    testWidgets(
        'initialExpandedIndexes out of range does not crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              initialExpandedIndexes: [5, 10],
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
      await tester.pumpAndSettle();

      expect(find.byType(ExpansionTile), findsNWidgets(2));
    });

    testWidgets(
        'switching from many children to empty does not crash',
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
      await tester.pumpAndSettle();

      expect(find.byType(ExpansionTile), findsNWidgets(2));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              expansionMode: ExpansionMode.exactlyOne,
              children: <ExpansionTile>[],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExpansionTile), findsNothing);
    });

    testWidgets(
        'onExpansionChanged with invalid index does not crash',
        (WidgetTester tester) async {
      int callbackCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              onExpansionChanged: (index, isExpanded) {
                callbackCount++;
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

      await tester.tap(find.text('Tile 1'));
      await tester.pumpAndSettle();

      expect(callbackCount, 1);
    });

    testWidgets(
        'expansion mode change from any to exactlyOne with expanded tiles does not crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              expansionMode: ExpansionMode.any,
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
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              expansionMode: ExpansionMode.exactlyOne,
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
                ExpansionTile(
                  title: Text('Tile 3'),
                  children: <Widget>[Text('Child 3')],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsNothing);
      expect(find.text('Child 3'), findsNothing);
    });
  });
}

void controllerStateErrorTests() {
  group('Bug fix: controller throws StateError for unmounted items', () {
    testWidgets(
        'controller throws when index is out of bounds',
        (WidgetTester tester) async {
      final controller = ExpansionTileListController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              controller: controller,
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

      expect(() => controller.expand(5), throwsA(anything));
      expect(() => controller.collapse(5), throwsA(anything));
      expect(() => controller.toggle(5), throwsA(anything));
      expect(() => controller.isExpanded(5), throwsA(anything));
    });

    testWidgets(
        'controller throws for negative index',
        (WidgetTester tester) async {
      final controller = ExpansionTileListController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              controller: controller,
              children: const <ExpansionTile>[
                ExpansionTile(
                  title: Text('Tile 1'),
                  children: <Widget>[Text('Child 1')],
                ),
              ],
            ),
          ),
        ),
      );

      expect(() => controller.expand(-1), throwsA(anything));
      expect(() => controller.collapse(-1), throwsA(anything));
      expect(() => controller.toggle(-1), throwsA(anything));
    });

    testWidgets(
        'controller isExpanded returns correct state',
        (WidgetTester tester) async {
      final controller = ExpansionTileListController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpansionTileList(
              controller: controller,
              initialExpandedIndexes: const [0],
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

      expect(controller.isExpanded(0), isTrue);
      expect(controller.isExpanded(1), isFalse);
    });
  });
}
