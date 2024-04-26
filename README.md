# Expansion Tile List

This project is a Flutter package that provides an container to the `ExpansionTile` widget.

## Description

The `ExpansionTileList` serves as a container for `ExpansionTile` widgets. It provides an easy way to create a list of
items that can be expanded or collapsed to show or hide additional information.
<p style="text-align: center">
  <img src="https://github.com/monohaus/expansion_tile_list/blob/main/.assets/images/expansion_tile_list.gif?raw=true" width="300" title="expansion_tile_list">
</p>

## Features

- The `builder` property allows the customization of the creation of each tile in the `ExpansionTileList`.
- The `tileGapSize` property allows you to specify the size of the gap between each tile in the `ExpansionTileList`.
- Expand at most one Tile at a time.
- Extension of `ExpansionTile` class with a `copyWith` method.
- The `trailing` property allows you to specify the trailing widget for all tiles, can be overridden by`ExpansionTile`
  trailing property.
- The `trailingAnimation` property allows you to specify the animation for the trailing widget.

## Installation

To use this package, add `expansion_tile_list` as
a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

```yaml
dependencies:
  flutter:
    sdk: flutter
  expansion_tile_list: ^0.1.0
```

## Usage

Import the package:

```dart
import 'package:expansion_tile_list/expansion_tile_list.dart';
```

## Example

Here's a simple example of how to use the `ExpansionTileList`:

1. Basic usage: This example shows how to create a list of `ExpansionTile` widgets using the `ExpansionTileList` widget.

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

2. Using `trailing` and `trailingAnimation`: This example shows how to use the `trailing` and `trailingAnimation`
   properties to customize the trailing widget of the tiles.

```dart

var expansionTileList =
ExpansionTileList(
  trailing: Icon(Icons.arrow_drop_down),
  trailingAnimation: Tween<double>(begin: 0, end: 0.5),
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

3. Using `trailingAnimationBuilder`: This property allows you to specify a custom animation for the trailing widget of
   the tiles.

```dart

var expansionTileList =
ExpansionTileList(
  trailingAnimationBuilder: (context, index, value, child) {
    return Transform.rotate(
      angle: value * pi,
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

4. `ExpansionTileList.radio`: This widget allows you to expand at most one tile at a time. The `initialExpandedIndex`
   property allows you to specify the index of the tile that is initially expanded.

```dart

var expansionTileList =
ExpansionTileList.radio(
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
```

## Parameters

| Parameter                  | Description                                                                                                              | Default Value   |
|----------------------------|--------------------------------------------------------------------------------------------------------------------------|-----------------|
| `key`                      | The widget key.                                                                                                          | `null`          |
| `children`                 | The list of ExpansionTile widgets that are managed by this widget.                                                       | `required`      |
| `onExpansionChanged`       | Called whenever a tile is expanded or collapsed.                                                                         | `null`          |
| `tileGapSize`              | The size of the gap between the tiles in the list.                                                                       | `0.0`           |
| `builder`                  | A builder that can be used to customize the appearance of the tiles.                                                     | `null`          |
| `controller`               | A controller that can be used to programmatically control the expansion of the tiles.                                    | `null`          |
| `trailing`                 | The widget that is displayed at the end of each tile header. Can be overridden by `trailing` property of `ExpansionList` | `null`          |
| `trailingAnimation`        | The animation for the trailing widget of the tiles. No effect of `trailing` property of `ExpansionList` if specified     | `null`          |
| `trailingAnimationEnabled` | Whether the trailing animation is enabled. If true, the trailing widget of the tiles is animated.                        | `true`          |
| `trailingAnimationBuilder` | The builder for the trailing animation of the tiles. If null, the default animation is used.                             | `null`          |
| `initialExpandedIndexes`   | The indexes of the tiles that are initially expanded.                                                                    | `const <int>[]` |
| `initialExpandedIndex`     | The index of the tile that is initially expanded. If null, no tiles are initially expanded.                              | `null`          |

## Testing

This package includes thorough unit tests for the `ExpansionTileExtension`. To run the tests, use the following command:

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


## License

This project is licensed under the BSD-style license. See the [LICENSE](LICENSE) file for details.
