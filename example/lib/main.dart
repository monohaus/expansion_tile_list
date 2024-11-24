import 'dart:developer' as developer;

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
      tileGapSize: 8.0,
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
      tileGapSize: 8.0,
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
      tileGapSize: 8.0,
      children: <ExpansionTile>[
        ..._buildChildren('builder'),
      ],
      tileBuilder: (BuildContext context, int index, Widget? child) {
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
      tileGapSize: 8.0,
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
      tileGapSize: 8.0,
      trailing: const Icon(Icons.add),
      children: <ExpansionTile>[
        ..._buildChildren('trailingIcon'),
      ],
    );
  }

  // With custom trailing animation disabled
  static Widget buildWithCustomTrailingAnimation() {
    return ExpansionTileList(
      tileGapSize: 8.0,
      trailing: const Icon(Icons.add),
      enableTrailingAnimation: false,
      children: <ExpansionTile>[
        ..._buildChildren('trailingAnimation'),
      ],
    );
  }

  // Helper method to generate a list of ExpansionTiles
  static List<ExpansionTile> _buildChildren([String name = '']) {
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
}
