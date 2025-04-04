# Expansion Tile List

> Leave a thumbs up 👍 if you like the package.

The `ExpansionTileList` serves as a container for the `ExpansionTile` widget, enabling the creation of a list of
`ExpansionTile` items. It offers additional features that allow you to customize the appearance of the tiles and control
their expansion programmatically.

[![pub package](https://img.shields.io/pub/v/expansion_tile_list)](https://pub.dev/packages/expansion_tile_list)
[![pub points](https://img.shields.io/pub/likes/expansion_tile_list)](https://pub.dev/packages/expansion_tile_list/score)
[![pub points](https://img.shields.io/pub/points/expansion_tile_list)](https://pub.dev/packages/expansion_tile_list/score)
[![popularity](https://img.shields.io/pub/dm/expansion_tile_list)](https://pub.dev/packages/expansion_tile_list/score)
[![Flutter Widget](https://img.shields.io/badge/Flutter-Widget-02569B?logo=flutter&logoColor=fff)](https://pub.dev/packages/expansion_tile_list)

[![Github](https://img.shields.io/badge/Github-ExpansionTileList-darkgreen)](https://github.com/monohaus/expansion_tile_list)
[![Github](https://img.shields.io/badge/Demo-ExpansionTileList-red)](https://monohaus.github.io/expansion_tile_list_demo/)
[![Test](https://github.com/monohaus/expansion_tile_list/actions/workflows/test.yml/badge.svg)](https://github.com/monohaus/expansion_tile_list/actions/workflows/test.yml)

## Description

The `expansion_tile_list` package offers a highly customizable list of `expansion_tile` items for Flutter applications.
It enables developers to create expandable tile lists with extensive options for appearance, animations, and control
over the expansion behaviour. The package includes features such as a global trailing widget, trailing animation, and
various expansion modes to accommodate different use cases.

<img src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_basic_usage.gif?raw=true" alt="Basic Usage"  title="Basic Usage"  width="250" style="max-width: 100%; height: auto;"/> <img  src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_trailing.gif?raw=true"  alt="Trailing"  title="Trailing"  width="250" style="max-width: 100%; height: auto;"/> <img  src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_controller.gif?raw=true"  alt="Controller"  title="Controller"  width="250" style="max-width: 100%; height: auto;"/> <img src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_expansion_mode.gif?raw=true"  alt="Expansion Mode"  title="Expansion Mode"  width="250" style="max-width: 100%; height: auto;"/> <img src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_reorderable.gif?raw=true" alt="Reorderable" title="Reorderable" width="250" style="max-width: 100%; height: auto;"/> <img src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_drag_handle.gif?raw=true"  alt="Drag handle"  title="Drag handle"  width="250" style="max-width: 100%; height: auto;"/>

## Features

- Compatible with `ExpansionTile` widgets.
- Includes additional features when using `ExpansionTileItem` widget instead of `ExpansionTile`
- Supports hot reload.🔥
- Accordion like expansion mode and many more.
- Customizable trailing widget and trailing animation.
- Customize the appearance of the tiles using itemBuilder, separatorBuilder and itemGapSize.
- Programmatically control the expansion of the tiles with `ExpansionTileListController`.
- Listen to the expansion changes of the tiles.
- Drag and reorder the items in the list.
- Checkout the [Demo](https://monohaus.github.io/expansion_tile_list_demo/) to explore the latest features and
  experience the features firsthand!

### `List Features`

All the features affects all the tiles in the `ExpansionTileList`.

- `itemGapSize` allows you to specify the size of the gap between each tile in the `ExpansionTileList`.
- `trailing` allows you to specify the trailing widget for all tiles, can be overridden by`ExpansionTile`
  trailing property.
- `trailingAnimation` allows you to specify a custom animation for the trailing widget.
- `enableTrailingAnimation` allows you to enable or disable the trailing animation.
- `itemBuilder` allows the customization of the creation and appearance of the tiles in the `ExpansionTileList`.
- `separatorBuilder` allows the customization of the creation and appearance of the separators between the tiles in the
  `ExpansionTileList`.
- `initialExpandedIndexes`  allows you to specify the indexes of the tiles that are initially expanded.
- `controller` allows you to programmatically control the expansion of the tiles.
- `onExpansionChanged`  allows you to listen to the expansion changes of the tiles.
- `ExpansionMode` allows you to specify the expansion mode for the
  `ExpansionTileList`.
    - `ExpansionMode.atMostOne` allows you to expand at most one tile at a time. (i.e. zero or one )
    - `ExpansionMode.atLeastOne` ensures that at least one tile is always expanded  (i.e. one or more )
    - `ExpansionMode.exactlyOne` allows you to expand exactly one tile at a time. (i.e. one )
    - `ExpansionMode.any` allows you to expand any number of tiles. (i.e. zero or more )
- `separatorAlignment` allows you to specify the alignment of the `separator` against the space `itemGapSize` between
  the tiles in the `ExpansionTileList`.
- ![new](https://img.shields.io/badge/new-brightgreen) `ExpansionTileList.reorderable` enable the list to be reorderable
  by dragging the items.

### `Item Features`

By default `ExpansionTileList` supports `ExpansionTile` widget as children to create tiles. But you can also use
`ExpansionTileItem` widget when more control is required. All the properties overrides the that of `ExpansionTileList`.

- `trailing`  allows you to specify the trailing widget for the tile.
- `trailingAnimation` allows you to specify a custom animation for the trailing widget.
- `enableTrailingAnimation` allows you to enable or disable the trailing animation.

## Installation

To use this package, add `expansion_tile_list` as
a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

```yaml
dependencies:
  flutter:
    sdk: flutter
  expansion_tile_list: ^2.0.0
```

## Usage

Import the package:

```dart
import 'package:expansion_tile_list/expansion_tile_list.dart';
```

## Example

Here are some simple examples of how to use the `ExpansionTileList`: check out
the [demo](https://monohaus.github.io/expansion_tile_list_demo/)

1. Basic usage: create a list of `ExpansionTile` widgets using the `ExpansionTileList` widget.

```dart
import 'package:flutter/material.dart';
import 'package:expansion_tile_list/expansion_tile_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ExpansionTileList(
          itemGapSize: 10.0,
          children: <Widget>[
            ExpansionTile(
              title: Text('Tile 1'),
              children: <Widget>[
                Text('Child 1'),
              ],
            ),
            ExpansionTile(
              title: Text('Tile 2'),
              children: <Widget>[
                Text('Child 2'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

2. Using `trailing` and `trailingAnimation`: use the `trailing` and `trailingAnimation` properties to customize the
   trailing widget of the tiles.

```dart

var expansionTileList =
ExpansionTileList(
  trailing: Icon(Icons.arrow_drop_down),
  trailingAnimation: ExpansionTileAnimation(
    tween: Tween<double>(begin: 0, end: 0.5),
    duration: Duration(milliseconds: 200),
    curve: Curves.easeInOut,
    builder: (context, index, value, child) {
      return Transform.rotate(
        angle: value * pi,
        child: child,
      );
    },
  ),
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
);
```

3. Using `separatorBuilder`: This property allows you to customize the appearance of the separators between the
   `ExpansionTile` items in the list.

> **_NOTE:_** The `separatorAlignment` can be used to specify the alignment of the separator against the space
`itemGapSize` between the tiles in the `ExpansionTileList`.

```dart

var expansionTileList =
ExpansionTileList(
  separatorAlignment: Alignment.topCenter, // defaults to Alignment.bottomCenter if not specified
  separatorBuilder: (context, index, value, child) {
    return Divider(
      color: Colors.blue,
      height: 2.0,
    );
  },
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
);

```

4. Using `itemBuilder`: This property allows you to customize the appearance of the items in the list.

```dart

var expansionTileList = ExpansionTileList(
  itemBuilder: (context, index, isExpanded, child) {
    return Container(
      color: isExpanded ? Colors.blue : Colors.white,
      child: child,
    );
  },
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
);
```

5. Using `controller`: This property allows you to programmatically control the expansion of the `ExpansionTile` items.

```dart

var controller = ExpansionTileListController();

var expansionTileList = ExpansionTileList(
  controller: controller,
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
);

_() {
  /// Expand the first tile
  controller.expand(0);

  /// Collapse the first  tile
  controller.collapse(0);

  /// Toggle the first 
  controller.toggle(0);

  /// Expand all 
  controller.expandAll();

  /// Collapse all tiles
  controller.collapseAll();
}
```

6. Using `onExpansionChanged`: This property allows you to listen to the expansion changes of the tiles.

```dart

var expansionTileList = ExpansionTileList(
  onExpansionChanged: (index, isExpanded) {
    print('Tile $index is ${isExpanded ? 'expanded' : 'collapsed'}');
  },
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
);
```

7. Using `ExpansionMode`: Use `ExpansionMode` property of the `ExpansionTileList` widget to control the expansion of the
   tiles. The `initialExpandedIndexes` property allows you to specify the indexes of the tiles that are initially
   expanded. `ExpansionMode` that enforces a single tile expansions at a time expects a single index in the array
   `initialExpandedIndexes` i.e. `ExpansionMode.atMostOne` and `ExpansionMode.exactlyOne`, if multiple indexes are
   specified then only the first index at 0 is considered. If the `initialExpandedIndexes` is not specified then the
   first tile is expanded by default.

```dart 
/// Use ExpansionMode property
/// length of `initialExpandedIndexes` for enforces at least one tile always expanded [`ExpansionMode.atLeastOne`, `ExpansionMode.exactlyOne`] should be 1 or 0.
var expansionTileList = ExpansionTileList(
  initialExpandedIndexes: [0, 1], // defaults to [] if not specified
  expansionMode: ExpansionMode.any, // defaults to ExpansionMode.any if not specified
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
);

// Use named constructor
var expansionTileList = ExpansionTileList(
  expansionMode: ExpansionMode.atMostOne,
  initialExpandedIndexes: [0], // defaults to [] if not specified
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
);

var expansionTileList = ExpansionTileList(
  expansionMode: ExpansionMode.atLeastOne,
  initialExpandedIndexes: [1],
  // defaults to [0] if not specified and cannot be resolved by first initialExpandedIndex of children
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
);

var expansionTileList = ExpansionTileList(
  expansionMode: ExpansionMode.exactlyOne,
  initialExpandedIndexes: [0], // defaults to [0] if not specified
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
);

```

8. Using `ExpansionTileItem`: Use the `ExpansionTileItem` widget to customize the trailing widget
   of the tiles.

```dart

var expansionTileList = ExpansionTileList(
  children: <ExpansionTile>[
    ExpansionTileItem(
      title: Text('Tile 1'),
      trailing: Icon(Icons.arrow_drop_down),
      children: <Widget>[Text('Child 1')],
    ),
    ExpansionTileItem(
      title: Text('Tile 2'),
      trailing: Icon(Icons.arrow_drop_down),
      children: <Widget>[Text('Child 2')],
    ),
  ],
);
```

9. Using `ExpansionTileItem` with `trailingAnimation`: Use the `ExpansionTileItem` widget with
   the `trailingAnimation` property to customize the trailing widget of the tiles.

```dart

var expansionTileList = ExpansionTileList(
  children: <ExpansionTile>[
    ExpansionTileItem(
      title: Text('Tile 1'),
      trailing: Icon(Icons.arrow_drop_down),
      trailingAnimation: Tween<double>(begin: 0, end: 0.5),
      children: <Widget>[Text('Child 1')],
    ),
    ExpansionTileItem(
      title: Text('Tile 2'),
      trailing: Icon(Icons.arrow_drop_down),
      trailingAnimation: Tween<double>(begin: 0, end: 0.5),
      children: <Widget>[Text('Child 2')],
    ),
  ],
);
```

10. Using `ExpansionTileItem` with `trailingAnimationBuilder`: Use the `ExpansionTileItem` widget
    with the `trailingAnimationBuilder` property to customize the trailing widget of the tiles.

```dart

var expansionTileList = ExpansionTileList(
  children: <ExpansionTile>[
    ExpansionTileItem(
      title: Text('Tile 1'),
      trailing: Icon(Icons.arrow_drop_down),
      trailingAnimationBuilder: (context, index, value, child) {
        return Transform.rotate(
          angle: value * pi,
          child: child,
        );
      },
      children: <Widget>[Text('Child 1')],
    ),
    ExpansionTileItem(
      title: Text('Tile 2'),
      trailing: Icon(Icons.arrow_drop_down),
      trailingAnimationBuilder: (context, index, value, child) {
        return Transform.rotate(
          angle: value * pi,
          child: child,
        );
      },
      children: <Widget>[Text('Child 2')],
    ),
  ],
);
```

11. Using `ExapnsionTileList.reorderable`: Use the `ExpansionTileList.reorderable` constructor to enable the list to be
    reorderable by dragging the items.

```dart

var expansionTileList = ExpansionTileList.reorderable(
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
);
```

12. Using `reorderable` with callbacks: Use the callbacks to listen to the reordering of the items
    in the list.

```dart
// Use the canReorder and onReorder callback
var expansionTileList = ExpansionTileList.reorderable(
  canReorder: (oldIndex, newIndex) { // allow reordering only if the new index is greater than the old index (drag down)
    return newIndex > oldIndex;
  },
  onReorder: (oldIndex, newIndex) {
    print('Reordered from $oldIndex to $newIndex');
  },
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
);

// Use the onReorderStart and onReorderEnd callback
var expansionTileList = ExpansionTileList.reorderable(
  onReorderStart: (index) { // called when the reordering starts at the index
    print('Reorder started at $index');
  },
  onReorderEnd: (index) { // called when the reordering ends at the index
    print('Reorder ended at $index');
  },
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
);
```

13. Using `proxyDecorator`: Use the `proxyDecorator` property to customize the appearance of the proxy item that is
    displayed while reordering the items in the list.

```dart

var expansionTileList = ExpansionTileList.reorderable(
  proxyDecorator: (Widget child, int index,
      Animation<double> animation) { // customize the appearance of the proxy item during reordering (dragging)
    return Material(
      elevation: 4.0,
      child: SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
    );
  },
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
);
```

14. Using `enableDefaultDragHandles` : Use the `enableDefaultDragHandles` property to enable the default drag handles
    for
    the
    reorderable list and `useDelayedDrag` for a long press to trigger reordering. The default drag handles makes the
    whole `ExpansionTile` item draggable. This can be set to false when a custom drag handle is required.

```dart

// Use default drag handles with delayed drag
var expansionTileList = ExpansionTileList.reorderable(
  enableDefaultDragHandles: true, // defaults to true if not specified
  useDelayedDrag: true, // enable delayed drag (long press) to start reordering
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
);
```

15. Using DragHandlePlacement: Use the `dragHandlePlacement` property to specify the placement of the drag handle for
    the
    reorderable list.

```dart

var expansionTileList = ExpansionTileList.reorderable(
  dragHandlePlacement: DragHandlePlacement.trailing, // defaults to DragHandlePlacement.none if not specified
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
);
```

16. Using dragHandleAlignment: Use the `dragHandleAlignment` property to specify the horizontal alignment of the drag handle relative to its placement for
    the reorderable list.

```dart
 var expansionTileList = ExpansionTileList.reorderable(
  dragHandleAlignment: HorizontalAlignment.centerRight, // defaults to HorizontalAlignment.centerLeft if not specified
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
);
```

17. Using dragHandleBuilder: Use the `dragHandleBuilder` property to customize the appearance of the drag handle for the
    reorderable list based on the DragHandlePlacement value. `NOTE`: DragHandlePlacement.none does not call the
    dragHandleBuilder. The dragHandleBuilder can be used as a custom drag handle when the enableDefaultDragHandles is
    set to false.

```dart

// decorate the drag handle based on DragHandlePlacement (child is the drag handle placement widget (leading , trailing or title))
// DragHandlePlacement.none does not call the dragHandleBuilder
var expansionTileList = ExpansionTileList.reorderable(
  dragHandlerPlacement: DragHandlePlacement.leading,
  // important for dragHandleBuilder to know the placement of the drag handle
  dragHandleBuilder: (context, index, child) { // customize the appearance of the drag handle
    return child == null ? const Icon(Icons.drag_handle) : Row(
      mainAxisSize: MainAxisSize.min, //give it a min size to avoid overflow
      children: <Widget>[
        const Icon(Icons.drag_handle),
        !child,
      ],
    );
  },
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
);

// use as a custom drag handle (only a specific widget is used as the handle)
// disable the default drag handles (enableDefaultDragHandles = false) and use either the ReorderableDragStartListener or ReorderableDelayedDragStartListener to create a custom drag handle for the reorderable list.
var expansionTileList = ExpansionTileList.reorderable(
  enableDefaultDragHandles: false,
  // disable the default drag handles
  dragHandlerPlacement: DragHandlePlacement.leading,
  // important for dragHandleBuilder to know the placement of the drag handle
  dragHandleBuilder: (context, index, child) { // customize the appearance of the drag handle
    final dragHandle = ReorderableDragStartListener(
      key: PageStorageKey(index),
      index: index,
      child: const Icon(Icons.drag_handle),
    );
    return child == null ? dragHandle : Row(
      mainAxisSize: MainAxisSize.min, //give it a min size to avoid overflow
      children: <Widget>[
        dragHandle,
        !child,
      ],
    );
  },
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
);

```

18. Using Custom Drag Handle: Disable the default drag handles and use either the `ReorderableDragStartListener` or
    `ReorderableDelayedDragStartListener` to create
    a custom drag handle for the reorderable list.
    1. create a custom drag handle (e.g Icon)
    2. set enableDefaultDragHandles to false
    3. create an ExpansionTileController to programmatically control the tiles and access the position of the tiles
    4. wrap the drag handle with ReorderableDragStartListener or ReorderableDelayedDragStartListener
    5. wrap the ReorderableDragStartListener or ReorderableDelayedDragStartListener with a ValueListenableBuilder to
       update the index property of the drag handle
    6. update the index property of the drag handle ReorderableDragStartListener or ReorderableDelayedDragStartListener
       to the current position of th ExpansionTile every time the list is reordered by using the onReorder callback.

> **_NOTE:_** `dragHandleBuilder` is a simpler way to create a custom drag handle for the reorderable list.

```dart

final ValueNotifier<(int, int)> _reorderNotifier = ValueNotifier((-1, -1)); // remember to dispose the ValueNotifier
final ExpansionTileListController _controller = ExpansionTileListController();

var expansionTileList = ExpansionTileList.reorderable(
  enableDefaultDragHandles: false, // defaults to true if not specified
  controller: _controller, // controller to programmatically control tiles and access the position of the tiles
  onReorder: (oldIndex, newIndex) {
    _reorderNotifier.value = (oldIndex, newIndex); // notify the custom drag handle of the reorder
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

Widget _buildCustomDragHandle(int itemIndex) {
  return ValueListenableBuilder<(int, int)>(
      valueListenable: _reorderNotifier,
      builder: (context, (int, int) value, child) {
        return ReorderableDragStartListener(
          key: PageStorageKey(itemIndex),
          index: _controller.currentPosition(itemIndex),
          child: const Icon(Icons.drag_handle),
        );
      });
}

// for large items in a list, to improve performance a custom drag handle can be created as below
// Note: _reorderNotifier should be reset to (-1, -1) in the didUpdateWidget lifecycle method when setState is called to rebuild the list.
@Override
void didUpdateWidget() {
  _reorderNotifier.value = (-1, -1);
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
      var index = _controller.currentPosition(itemIndex);
      if (minIndex < 0 || (index >= minIndex &&
          index <= maxIndex)) { //only update when reorder index is within the range of oldIndex and newIndex or is -1
        currentDragHandle =
            (index == itemIndex ? child : null) ?? dragHandle(index);
      }
      return currentDragHandle ?? dragHandle(index);
    },
  );
}

```

## How Drag Handle works

By default the whole widget is draggable for a reorderable expansion list.
To create use a widget as a drag handle, use `dragHandleBuilder` to customize the appearance of the drag handle and use
`dragHandlePlacement` and `dragHandleAlignment` to specify the placement and alignment of the drag handle respectively.
For a custom drag handle, disable the default drag handles by setting `enableDefaultDragHandles` to false.

- `enableDefaultDragHandles` is used to enable the default drag handles for the reorderable list. Only set false if you
  intend to build custom drag handles.
- `useDelayedDrag` is used to enable the delayed drag (long press) to start reordering.
- `dragHandlePlacement` is used to specify the placement of the drag handle. This works for both the default drag
  handles
  and the custom drag handles (i.e `enableDefaultDragHandles` is false).
- `dragHandleAlignment` is used to specify the alignment of the drag handle in relation to the space between the tiles.
- `dragHandleBuilder` is used only when `dragHandlePlacement` has a value other than `DragHandlePlacement.none` to
  customize the appearance of the drag handle based on the `DragHandlePlacement` widget.

## How initialExpandedIndexes with ExpansionMode works

- `ExpansionMode.atMostOne`
    - considers `initialExpandedIndexes` first valid index.
    - considers first `ExpansionTile` child widget with`initiallyExpanded` true.
    - collapses all tiles.
- `ExpansionMode.exactlyOne`
    - considers `initialExpandedIndexes` first valid index.
    - considers first `ExpansionTile` child widget with`initiallyExpanded` true.
    - considers first `ExpansionTile` child widget at index `0`.
- `ExpansionMode.atLeastOne`
    - considers `initialExpandedIndexes` all indexes if not empty.
    - considers all `ExpansionTile` children widget with`initiallyExpanded` true.
    - considers first `ExpansionTile` child widget at index `0`.
- `ExpansionMode.any`
    - considers `initialExpandedIndexes` all indexes if not empty.
    - considers all `ExpansionTile` children widget with`initiallyExpanded` true.
    - collapses all tiles.

## How itemGapSize and separatorBuilder layout works

- `itemGapSize` is the size of the gap between the tiles in the list.
- `separatorBuilder` is the builder which returns a separator widget rendered between the `ExpansionTile` items in the
  list.
- `separatorAlignment` is the alignment of the separator widget in relation to the space `itemGapSize` between items.

> **_NOTE:_** The `separatorAlignment` can be used to specify the alignment of the separator against the space

### Layout as follows:

```
Alignment.topLeft           Alignment.topCenter         Alignment.topRight

[ExpansionTile 1]           [ExpansionTile 1]           [ExpansionTile 1]  
[     Gap       ]           [     Gap       ]           [      Gap      ]  
[Divider]                       [Divider]                       [Divider]

[ExpansionTile 2]           [ExpansionTile 2]           [ExpansionTile 2]  
[     Gap       ]           [     Gap       ]           [      Gap      ]  
[Divider]                       [Divider]                       [Divider]

[ExpansionTile 3]           [ExpansionTile 3]           [ExpansionTile 3]  

```

```
Alignment.centerLeft        Alignment.center            Alignment.centerRight

[ExpansionTile 1]           [ExpansionTile 1]           [ExpansionTile 1]  
[     Gap/2     ]           [     Gap/2     ]           [     Gap/2     ]  
[Divider]                   [Divider]                   [Divider]  
[     Gap/2     ]           [     Gap/2     ]           [     Gap/2     ]  

[ExpansionTile 2]           [ExpansionTile 2]           [ExpansionTile 2]  
[     Gap/2     ]           [     Gap/2     ]           [     Gap/2     ]  
[Divider]                   [Divider]                   [Divider]  
[     Gap/2     ]           [     Gap/2     ]           [     Gap/2     ]  

[ExpansionTile 3]           [ExpansionTile 3]           [ExpansionTile 3]  

```

```
Alignment.bottomLeft        Alignment.bottomCenter      Alignment.bottonRight

[ExpansionTile 1]           [ExpansionTile 1]           [ExpansionTile 1]  
[Divider]                   [Divider]                   [Divider]  
[     Gap       ]           [     Gap       ]           [      Gap      ]

[ExpansionTile 2]           [ExpansionTile 2]           [ExpansionTile 2]  
[Divider]                   [Divider]                   [Divider]  
[     Gap       ]           [     Gap       ]           [      Gap      ]  

[ExpansionTile 3]           [ExpansionTile 3]           [ExpansionTile 3]  

```

## How ExpansionTileList current position and initial position works

- The `ExpansionTileList` item initial position is the index of the `ExpansionTile` in the children list of the
  ExpansionTileList on creation and before reordering.
- For a non-reorderable `ExpansionTileList`, an item current position will always be the same as the initial position.
- For a reorderable `ExpansionTileList`, the current position is the index of the ExpansionTile in the items of the
  ExpansionTileList after reordering.
- Before reordering, the current position is the same as the initial position.
- After reordering, the current position is updated to the new index of the ExpansionTile in the items of the
  ExpansionTileList.
- Both the initial position and current position are zero-based indexes.
- All ExpansionTileList callbacks and methods that require a position or index use the `current position`.

### Method : initialPosition

- Returns the initial position(index) of the tile at the given current position(index).
- The initial position is the original position of the tile in the list.
- For example, A tile at the initial index 0 will be assigned a position 0,
- if the tile is moved to the position 2, the initial position of the tile at the position 2 will still be 0.
- Therefore, initial position is the position of the tile in the list before any reordering and it remains the same
  after reordering.

```dart

var controller = ExpansionTileListController();

_() {
// before reordering
  controller.initialPosition(0); // returns 0
// after reordering
  controller.initialPosition(2); // returns 0
}
```

### Method : currentPosition

- Returns the current position(index) of the tile at the given initial position(index).
- The current position is the updated position of the tile in the list after reordering.
- For example, A tile at the initial index 0 will be assigned a position 0,
- if the tile is moved to the position 2, the current position of the tile at the position 0 will be 2.
- Therefore, current position is the position of the tile in the list after reordering.

```dart

var controller = ExpansionTileListController();

_() {
// before reordering
  controller.currentPosition(0); // returns 0
// after reordering
  controller.currentPosition(0); // returns 2
}
```

## List Properties

| Property                  | Description                                                                                                              | Default Value            |
|---------------------------|--------------------------------------------------------------------------------------------------------------------------|--------------------------|
| `key`                     | The widget key.                                                                                                          | `null`                   |
| `children`                | The list of ExpansionTile widgets that are managed by this widget.                                                       | `required`               |
| `onExpansionChanged`      | Called whenever a tile is expanded or collapsed.                                                                         | `null`                   |
| `itemGapSize`             | The size of the gap between the tiles in the list. (renamed to itemGapSize from next major release)                      | `0.0`                    |
| `separatorBuilder`        | The builder for the separator between the tiles in the list.                                                             | `null`                   |
| `itemBuilder`             | A builder that can be used to customize the appearance of the tiles. (renamed to itemBuilder from next major release)    | `null`                   |
| `controller`              | A controller that can be used to programmatically control the expansion of the tiles.                                    | `null`                   |
| `trailing`                | The widget that is displayed at the end of each tile header. Can be overridden by `trailing` property of `ExpansionTile` | `null`                   |
| `trailingAnimation`       | The animation for the trailing widget of the tiles. Can be overridden by `trailingAnimation` property of `ExpansionTile` | `null`                   |
| `enableTrailingAnimation` | Enable or disable the trailing animation.                                                                                | `true`                   |
| `initialExpandedIndexes`  | The indexes of the tiles that are initially expanded.                                                                    | `const <int>[]`          |
| `expansionMode`           | The expansion mode of the `ExpansionTileList`.                                                                           | `ExpansionMode.any`      |
| `separatorAlignment`      | The alignment of the separator widget in relation to the space `itemGapSize` between items                               | `Alignment.bottomCenter` |

## Scrollable Properties

| Property                  | Description                                                                                                      | Default Value                              |
|---------------------------|------------------------------------------------------------------------------------------------------------------|--------------------------------------------|
| `scrollDirection`         | The direction in which the list scrolls                                                                          | `Axis.vertical`                            |
| `reverse`                 | Whether the list scrolls in reverse                                                                              | `false`                                    |
| `scrollController`        | An object that can be used to control the position to which this scroll view is scrolled.                        | `null`                                     |
| `primary`                 | Whether this is the primary scroll view associated with the parent `PrimaryScrollController`.                    | `true`                                     |
| `physics`                 | How the scroll view should respond to user input.                                                                | `AlwaysScrollableScrollPhysics()`          |
| `shrinkWrap`              | Whether the extent of the scroll view in the scroll direction should be determined by the contents being viewed. | `false`                                    | | `EdgeInsets.zero`                          |
| `padding`                 | The amount of space by which to inset the list contents.                                                         | `EdgeInsets.zero`                          |
| `restorationId`           | An identifier that will be used to save the scroll position in the restoration data.                             | `null`                                     |
| `keyboardDismissBehavior` | How the scroll view should respond to keyboard events.                                                           | `ScrollViewKeyboardDismissBehavior.manual` |
| `dragStartBehavior`       | Determines the way that drag start behavior is handled.                                                          | `DragStartBehavior.start`                  |
| `clipBehavior`            | Determines how to clip the content of the scroll view.                                                           | `Clip.hardEdge`                            |

## Reorderable Properties

| Property                     | Description                                                                                                  | Default Value                    |
|------------------------------|--------------------------------------------------------------------------------------------------------------|----------------------------------|
| `reorderable`                | Readonly bool property indicating if the `ExpansionTileList` can be reordered                                | `false`                          |
| `canReorder`                 | A callback that returns whether the item at the given index can be reordered.                                | `null`                           |
| `onReorder`                  | A callback invoked when an item has been reordered.                                                          | `null`                           |
| `onReorderStart`             | A callback invoked when the user starts reordering an item                                                   | `null`                           |
| `onReorderEnd`               | A callback invoked when the user stops reordering an item                                                    | `null`                           |
| `proxyDecorator`             | A builder that can be used to customize the appearance of the proxy item that is displayed while reordering. | `null`                           |
| `enableDefaultDragHandles`   | A bool property indicating if the default drag handles should be used for the reorderable list.              | `true`                           |
| `useDelayedDrag`             | A bool property indicating if delayed (long press) drag start should trigger item reordering.                | `false`                          |
| `dragHandlePlacement`        | The placement of the drag handle in the ExpansionTile.                                                       | `DragHandlePlacement.none`       |
| `dragHandleAlignment`        | The alignment of the drag handle in the ExpansionTile.                                                       | `HorizontalAlignment.centerLeft` |
| `dragHandleBuilder`          | A builder that can be used to customize the appearance of the drag handle for the reorderable list.          | `null`                           |
| `anchor`                     | Determines the relative position of the zero scroll offset within the viewport. (values: 0.0 to 1.0)         | `0.0`                            |
| `autoScrollerVelocityScalar` | Enables you to adjust the speed of the auto-scroll behavior during drag-and-drop operations                  | `50`                             |

## Item Properties

| Property                  | Description                                                                                              | Default Value |
|---------------------------|----------------------------------------------------------------------------------------------------------|---------------|
| `controller`              | Programmatically control the expansion using `ExpansionTileController` or `ExpansionTileItemController`. | `null`        |
| `trailing`                | The widget that is displayed at the end of each tile header.                                             | `null`        |
| `trailingAnimation`       | The animation for the trailing widget of the tiles.                                                      | `null`        |
| `enableTrailingAnimation` | Enable or disable the trailing animation.                                                                | `true`        |

## Testing

All testcase are available for the package.

- expansion_tile_list_test.dart
- expansion_tile_item_test.dart
- expansion_tile_extension_test.dart
  To run the tests, use the following command:

```bash
flutter test
```

## Troubleshooting

1. If you encounter any issues while using the package, please check
   the [GitHub issues](https://github.com/monohaus/expansion_tile_list/issues) page to see if the issue has already been
   reported.
2. If you are unable to find a solution, please create a new issue with a detailed description of the problem, including
   the steps to reproduce it.
3. If you have any questions or need help with the package, please feel free to reach out to the package maintainer.
4. If you would like to contribute to the package, please refer to the [Contributing](#contributing) section for more
   information.
5. If you have any feedback or suggestions for the package, please share them with the package maintainer.

## Known Issues & Fixes

- State Management issues with ExpansionTile children:
  Set [maintainState](https://api.flutter.dev/flutter/material/ExpansionTile/maintainState.html) to `true` for the
  `ExpansionTile` children to maintain the state of the children when the parent `ExpansionTileList` is rebuilt.
- Expansion state issues: The expansion state of the `ExpansionTile`  may not be maintained when the parent of
  `ExpansionTileList` is rebuilt due to the change of the widget tree. To maintain the expansion state, use a GlobalKey
  on the `ExpansionTile`.
- ExpansionTileList `itemBuilder` issues: If the `itemBuilder` modifies the widget tree during a rebuild, it may disrupt
  the maintenance of the expansion state of the `ExpansionTile`. To address this, use a `GlobalKey` on the
  `ExpansionTile`.
- ExpansionTileController `controller` issues:  The `controller` property may not function as expected when the
  `ExpansionTile` modifies the widget tree during a rebuild. To resolve this, use a `GlobalKey` or delegate
  the management of the controller to `ExpansionTileList` by using `ExpansionTileItemController` type as a controller.

```text
  Failed assertion: line 607 pos 12: 'widget.controller?._state == null': is not true.
 ```

- ExpansionTileController `controller` methods may throw an assertion error when the widget is not yet mounted or
  initialized, mostly due to item not visible in scroll viewport. To resolve this, always check for init state
  `controller.isInitialized` before calling the controller methods.

- Using a ListView or ScrollView within the ExpansionTile children may cause layout issues. To resolve this, use a
  `Column` or `Container` with a fixed height as parent to the `ListView` and use a `PageStorageKey(index)` on the
  `ListView`.

```text
The following _TypeError was thrown building ListView(scrollDirection: vertical, dependencies: [MediaQuery]): type 'bool' is not a subtype of type 'double?' in type cast
```

These issues are due to the `ExpansionTile` widget limitations and not the package. We have ensured that the package
works as expected with the Flutter framework and made sure to take a safe decision to mitigate these issues.
This means no issues should be encountered when using the package as intended.

## Contributing

Contributions are welcome! If you find a bug or want a feature, please fill an issue. If you want to contribute code,
please submit a pull request.
We welcome contributions from everyone. Before you start:

1. Fork the repository to your own GitHub account.
2. Clone the project to your machine.
3. Create a branch locally with a descriptive name.
4. Commit changes to the branch.
5. Push changes to your fork.
6. Create a new pull request in GitHub and link the issue you are fixing.

## Visitors

![Visitor Count](https://profile-counter.glitch.me/expansion_tile_list/count.svg)

## License

This project is licensed under the BSD-style license. See
the [![License](https://img.shields.io/badge/License-BSD%203--Clause-blue)](LICENSE)
file for details.

#

[![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/seun.ogunjimi)