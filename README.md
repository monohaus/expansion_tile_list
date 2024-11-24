# Expansion Tile List

The `ExpansionTileList` widget is a container for the `ExpansionTile` widget that allows you to create a list of tiles.
It provides additional features that empowers you to customize the appearance of the tiles and control their expansion
programmatically.

[![pub package](https://img.shields.io/pub/v/expansion_tile_list)](https://pub.dev/packages/expansion_tile_list)
[![pub points](https://img.shields.io/pub/likes/expansion_tile_list)](https://pub.dev/packages/expansion_tile_list/score)
[![pub points](https://img.shields.io/pub/points/expansion_tile_list)](https://pub.dev/packages/expansion_tile_list/score)
[![popularity](https://img.shields.io/pub/popularity/expansion_tile_list)](https://pub.dev/packages/expansion_tile_list/score)

[![Flutter Widgets](https://img.shields.io/badge/Flutter-Widgets-blue)](https://pub.dev/packages/expansion_tile_group)
[![Github](https://img.shields.io/badge/Github-ExpansionTileList-darkgreen)](https://github.com/monohaus/expansion_tile_list)

## Description

The `expansion_tile_list` package provides a highly customizable list of expansion tiles for Flutter applications. It
allows developers to create lists of expandable tiles with various customization options for appearance, animations, and
control over the expansion state. The package supports features like global trailing widget, trailing animation, and
different expansion modes to suit various use cases.


<img src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/expansion_tile_list.gif?raw=true" width="300" title="expansion_tile_list">

<img  src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_basic_usage.gif?raw=true"  alt="Basic Usage"  title="Basic Usage"  width="300"/><img  src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_trailing.gif?raw=true"  alt="Trailing"  title="Trailing"  width="300"/><img  src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_controller.gif?raw=true"  alt="Controller"  title="Controller"  width="300"/><img  src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/list_expansion_mode.gif?raw=true"  alt="Expansion Mode"  title="Expansion Mode"  width="300"/>

## Features

### `List Features`

All the features affects all the tiles in the `ExpansionTileList`.

- `tileGapSize` allows you to specify the size of the gap between each tile in the `ExpansionTileList`.
- `trailing` allows you to specify the trailing widget for all tiles, can be overridden by`ExpansionTile`
  trailing property.
- `trailingAnimation` allows you to specify a custom animation for the trailing widget.
- `enableTrailingAnimation` allows you to enable or disable the trailing animation.
- `tileBuilder` allows the customization of the creation and appearance of the tiles in the `ExpansionTileList`.
- `separatorBuilder` allows the customization of the creation and appearance of the separators between the tiles in the
  `ExpansionTileList`.
- `initialExpandedIndexes`  allows you to specify the indexes of the tiles that are initially expanded.
- `controller` allows you to programmatically control the expansion of the tiles.
- `onExpansionChanged`  allows you to listen to the expansion changes of the tiles.
- ![new](https://img.shields.io/badge/new-brightgreen) `ExpansionMode` allows you to specify the expansion mode of the
  `ExpansionTileList`. This feature can be used only
  with named constructor.
    - `ExpansionMode.atMostOne` allows you to expand at most one tile at a time. (i.e zero or one )
    - `ExpansionMode.atLeastOne` ensures that at least one tile is always expanded  (i.e one or more )
    - `ExpansionMode.exactlyOne` allows you to expand exactly one tile at a time. (i.e one )
    - `ExpansionMode.any` allows you to expand any number of tiles. (i.e zero or more )

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
  expansion_tile_list: ^0.1.1
```

## Usage

Import the package:

```dart
import 'package:expansion_tile_list/expansion_tile_list.dart';
```

## Example

Here's a simple example of how to use the `ExpansionTileList`:

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
          tileGapSize: 10.0,
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

3. Using `separtorBuilder`: This property allows you to customize the appearance of the separators between the tiles in
   the list.

```dart

var expansionTileList =
ExpansionTileList(
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

4. Using `tileBuilder`: This property allows you to customize the appearance of the tiles in the list.

```dart

var expansionTileList = ExpansionTileList(
  tileBuilder: (context, index, isExpanded, child) {
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

5. Using `controller`: This property allows you to programmatically control the expansion of the tiles.

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


/// Expand the first tile
controller.expand
(0);

/// Collapse the first tilecontroller.collapse(0);
/// Toggle the first tilecontroller.toggle(0);
/// Expand all tilescontroller.expandAll();

/// Collapse all tiles
controller.collapseAll();
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
   `initialExpandedIndexes` i.e [`ExpansionMode.atMostOne`, `ExpansionMode.exactlyOne`], if multiple indexes are
   specified then only the first index at 0 is considered. If the `initialExpandedIndexes` is not specified then the
   first tile is expanded by default.

> **_NOTE:_**  ExpansionMode that allows at lease one tile to be always expanded i.e [`ExpansionMode.atLeastOne`,
`ExpansionMode.exactlyOne`] disables the `ExpansionTile` widget to enforce this rule.

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

8. Using `ExpansionTileList.single` named constructor: Use the `ExpansionTileList.single` named constructor to create
   a list of tiles with either the `ExpansionMode.atMostOne` or `ExpansionMode.exactlyOne` expansion mode.

```dart

var expansionTileList = ExpansionTileList.single(
  initialExpandedIndex: 0,
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

// Use ExpansionMode.atMostOne  named constructor

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

## How initialExpandedIndexes with ExpansionMode works

- `ExpansionMode.atMostOne`
    - consider `initialExpandedIndexes` first valid index.
    - consider first `ExpansionTile` child widget with`initiallyExpanded` true.
    - collapse all tiles.
- `ExpansionMode.exactlyOne`
    - consider `initialExpandedIndexes` first valid index.
    - consider first `ExpansionTile` child widget with`initiallyExpanded` true.
    - consider first `ExpansionTile` child widget at index 0.
- `ExpansionMode.atLeastOne`
    - consider `initialExpandedIndexes` all indexes if not empty.
    - consider all `ExpansionTile` children widget with`initiallyExpanded` true.
    - consider first `ExpansionTile` child widget at index 0.
- `ExpansionMode.any`
    - consider `initialExpandedIndexes` all indexes if not empty.
    - consider all `ExpansionTile` children widget with`initiallyExpanded` true.
    - collapse all tiles.

## How tileGapSize and separatorBuilder layout works

- `tileGapSize` is the size of the gap between the tiles in the list.
- `separatorBuilder` is the builder for the separator between the tiles in the list.
  Note: `tileGapSize` is always rendered before the `separatorBuilder` if both are specified.
- Layout as follows:

```
[ExpansionTile 1]
[Gap]
[Divider]
[ExpansionTile 2]
[Gap]
[Divider]
[ExpansionTile 3]
```

## Properties

| Property                  | Description                                                                                                              | Default Value       |
|---------------------------|--------------------------------------------------------------------------------------------------------------------------|---------------------|
| `key`                     | The widget key.                                                                                                          | `null`              |
| `children`                | The list of ExpansionTile widgets that are managed by this widget.                                                       | `required`          |
| `onExpansionChanged`      | Called whenever a tile is expanded or collapsed.                                                                         | `null`              |
| `tileGapSize`             | The size of the gap between the tiles in the list.                                                                       | `0.0`               |
| `separatorBuilder`        | The builder for the separator between the tiles in the list.                                                             | `null`              |
| `tileBuilder`             | A builder that can be used to customize the appearance of the tiles.                                                     | `null`              |
| `controller`              | A controller that can be used to programmatically control the expansion of the tiles.                                    | `null`              |
| `trailing`                | The widget that is displayed at the end of each tile header. Can be overridden by `trailing` property of `ExpansionList` | `null`              |
| `trailingAnimation`       | The animation for the trailing widget of the tiles. No effect of `trailing` property of `ExpansionList` if specified     | `null`              |
| `enableTrailingAnimation` | Enable or disable the trailing animation.                                                                                | `true`              |
| `initialExpandedIndexes`  | The indexes of the tiles that are initially expanded.                                                                    | `const <int>[]`     |
| `expansionMode`           | The expansion mode of the `ExpansionTileList`.                                                                           | `ExpansionMode.any` |

## Testing

All testcase are available for the package.

- expansion_tile_extension_test.dart
- expansion_tile_list_test.dart
- expansion_tile_item_test.dart
  To run the tests, use the following command:

```bash
flutter test
```

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

This project is licensed under the BSD-style license. See the [LICENSE](LICENSE) file for details.

[list_basic_usage]: https://user-images.githubusercontent.com/15138747/208438575-8a9acded-1188-494e-9b01-9ac061c6d911.gif
