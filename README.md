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

## Installation

To use this package, add `expansion_tile_list` as
a [dependency in your pubspec.yaml file](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

```yaml
dependencies:
  flutter:
    sdk: flutter
  expansion_tile_list: ^0.0.1
```

## Usage

Import the package:

```dart
import 'package:expansion_tile_list/expansion_tile_list.dart';
```

## Example

Here's a simple example of how to use the `ExpansionTileList`:

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
          title: Text('Expansion Tile'),
          children: <Widget>[
            ExpansionTile(
              title: Text('Header 1'),
              children: <Widget>[
                Text('Child 1'),
              ],
            ),
            ExpansionTile(
              title: Text('Header 2'),
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

In this example, we created a simple `ExpansionTileList` with two children.

## Testing

This package includes thorough unit tests for the `ExpansionTileExtension`. To run the tests, use the following command:

```bash
flutter test
```

## Contributing

Contributions are welcome! If you find a bug or want a feature, please fill an issue. If you want to contribute code,
please submit a pull request.

## License

This project is licensed under the BSD-style license. See the [LICENSE](LICENSE) file for details.

```