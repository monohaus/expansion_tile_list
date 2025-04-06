import 'dart:developer' as developer;
import 'dart:math';

import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

/// A simple example of how to use the ExpansionTileList widget.
class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Expansion Tile List',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          expansionTileTheme: ExpansionTileThemeData(
            iconColor: Colors.black,
            textColor: Colors.black,
            // iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.blueGrey.shade300,
            collapsedIconColor: Colors.white,
            collapsedTextColor: Colors.white,
            // collapsedIconTheme: IconThemeData(color: Colors.black),
            collapsedBackgroundColor: Colors.blueGrey,
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Expansion Tile List Examples'),
          ),
          body: SafeArea(child: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return Column(children: [
              _buildPage(context),
            ]);
          })),
        ));
  }

  Widget _buildPage(BuildContext context) {
    return Expanded(
        child: PageView(
      children: <Widget>[
        Examples.buildBasicUsage(),
        Examples.buildCustomExpansionCallback(),
        Examples.buildCustomExpansionTile(),
      ]
          .map((child) => SingleChildScrollView(child: child))
          .toList(growable: false),
    ));
  }
}

class Examples {
  static Widget buildBasicUsage() {
    return ExpansionTileList(
      itemGapSize: 8.0,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 1.0,
          color: Colors.red,
        );
      },
      children: <ExpansionTile>[
        ..._buildChildren('basic'),
      ],
    );
  }

// With onExpansionChanged Callback
  static Widget buildCustomExpansionCallback() {
    return ExpansionTileList(
      itemGapSize: 8.0,
      children: <ExpansionTile>[
        ..._buildChildren('onExpansionChanged'),
      ],
      onExpansionChanged: (index, isExpanded) {
        developer.log('Tile $index isExpanded: $isExpanded');
      },
    );
  }

// With custom expansion tile using builder
  static Widget buildCustomExpansionTile() {
    return ExpansionTileList(
      itemGapSize: 8.0,
      children: <ExpansionTile>[
        ..._buildChildren('builder'),
      ],
      itemBuilder: (BuildContext context, int index, Widget? child) {
        return Column(
          children: <Widget>[
            child!,
            Text('Custom Divider $index',
                style: const TextStyle(color: Colors.red)),
            const Divider(
              height: 1.0,
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

// With custom separator
  static Widget buildWithCustomSeparator() {
    return ExpansionTileList(
      itemGapSize: 8.0,
      children: <ExpansionTile>[
        ..._buildChildren('separator'),
      ],
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 1.0,
          color: Colors.red,
        );
      },
    );
  }

  // With trailing icon
  static Widget buildWithTrailingIcon() {
    return ExpansionTileList(
      itemGapSize: 8.0,
      trailing: const Icon(Icons.add),
      children: <ExpansionTile>[
        ..._buildChildren('trailingIcon'),
      ],
    );
  }

  // With  trailing animation disabled
  static Widget buildWithTrailingAnimationDisabled() {
    return ExpansionTileList(
      itemGapSize: 8.0,
      trailing: const Icon(Icons.add),
      enableTrailingAnimation: false,
      children: <ExpansionTile>[
        ..._buildChildren('trailingAnimation'),
      ],
    );
  }
}

class ReorderableExamples {
  // With leading drag handle for reorderable ExpansionTileList
  static Widget buildWithLeadingDragHandle() {
    return ExpansionTileList.reorderable(
      dragHandlePlacement: DragHandlePlacement.leading,
      children: <ExpansionTile>[
        ..._buildChildren('LeadingDragHandle'),
      ],
    );
  }

  // With custom drag handle for reorderable ExpansionTileList
  static Widget buildWithCustomDragHandle() {
    return ExpansionTileList.reorderable(
      dragHandlePlacement: DragHandlePlacement.leading,
      dragHandleBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.blue,
          child: const Icon(Icons.drag_handle, color: Colors.white),
        );
      },
      children: <ExpansionTile>[
        ..._buildChildren('CustomDragHandle'),
      ],
    );
  }

  // With drag handle alignment  for reorderable ExpansionTileList
  static Widget buildWithDragHandleAlignment() {
    return ExpansionTileList.reorderable(
      dragHandlePlacement: DragHandlePlacement.leading,
      dragHandleAlignment: DragHandleAlignment.centerRight,
      children: <ExpansionTile>[
        ..._buildChildren('DragHandleAlignment'),
      ],
    );
  }

  // With proxy decorator
  static Widget buildWithProxyDecorator() {
    final controller = ExpansionTileListController();
    return ExpansionTileList.reorderable(
      controller: controller,
      proxyDecorator: (child, index, animation) {
        return Material(
          elevation: 6.0,
          child: child,
        );
      },
      children: <ExpansionTile>[
        ..._buildChildren('ProxyDecorator'),
      ],
    );
  }

  // With use delayed drag
  static Widget buildWithUseDelayedDrag() {
    final controller = ExpansionTileListController();
    return ExpansionTileList.reorderable(
      controller: controller,
      useDelayedDrag: true,
      children: <ExpansionTile>[
        ..._buildChildren('UseDelayedDrag'),
      ],
    );
  }
}

// Helper method to generate a list of ExpansionTiles
List<ExpansionTile> _buildChildren([String name = '']) {
  return List.generate(
      4,
      (index) => ExpansionTile(
            title: Text('Tile $index  $name'),
            children: <Widget>[
              ...List.generate(
                  6, (i) => Text('This is tile $index of $i $name')),
            ],
          ));
}

class AdvancedCustomDragHandleExample extends StatefulWidget {
  const AdvancedCustomDragHandleExample({super.key});

  @override
  State<StatefulWidget> createState() =>
      _AdvancedCustomDragHandleExampleState();
}

class _AdvancedCustomDragHandleExampleState
    extends State<AdvancedCustomDragHandleExample> {
  final controller = ExpansionTileListController();
  final ValueNotifier<(int, int)> _reorderNotifier =
      ValueNotifier((-1, -1)); // remember to dispose the ValueNotifier
  @override
  void didUpdateWidget(AdvancedCustomDragHandleExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    _reorderNotifier.value = (-1, -1);
  }

  @override
  void dispose() {
    _reorderNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTileList.reorderable(
      enableDefaultDragHandles: false,
      controller: controller,
      dragHandlePlacement: DragHandlePlacement.leading,
      dragHandleAlignment: DragHandleAlignment.centerRight,
      dragHandleBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.blue,
          child: const Icon(Icons.drag_handle, color: Colors.white),
        );
      },
      onReorder: (oldIndex, newIndex) {
        _reorderNotifier.value = (
          oldIndex,
          newIndex
        ); // notify the custom drag handle of the reorder
      },
      children: <ExpansionTile>[
        ...List.generate(10, (index) {
          return ExpansionTile(
            leading: _buildCustomDragHandle(index),
            title: Text('Tile $index'),
            children: <Widget>[Text('Child $index')],
          );
        }),
      ],
    );
  }

  Widget _buildCustomDragHandle(int itemIndex) {
    Widget dragHandle(int index) {
      return ReorderableDragStartListener(
        key: PageStorageKey(index),
        index: index,
        child: const Icon(Icons.drag_handle),
      );
    }

    Widget? currentDragHandle;
    return ValueListenableBuilder<(int, int)>(
      valueListenable: _reorderNotifier,
      child: currentDragHandle,
      builder: (context, (int, int) value, child) {
        var minIndex = min(value.$1, value.$2);
        var maxIndex = max(value.$1, value.$2);
        var index = controller.currentPosition(itemIndex);
        if (minIndex < 0 || (index >= minIndex && index <= maxIndex)) {
          //only update when reorder index is within the range of oldIndex and newIndex or is -1
          currentDragHandle =
              (index == itemIndex ? child : null) ?? dragHandle(index);
        }
        return currentDragHandle ?? dragHandle(index);
      },
    );
  }
}
