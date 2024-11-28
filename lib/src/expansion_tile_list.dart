import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Signature for the listener callback that's called when an [ExpansionTile] is
/// expanded or collapsed.
///
/// The position of the panel within an [ExpansionTileList] is given by
/// [index]. The [isExpanded] parameter is true if the tile was expanded, and
/// [isExpanded]. The [isExpanded] parameter is true if the tile was expanded, and false if it was collapsed.
typedef ExpansionTileCallback = void Function(int index, bool isExpanded);

/// Signature for the listener callback that's called when an [ExpansionTileList] is
typedef ExpansionTileListAnimation = IndexedValueExpansionTileAnimation;

/// Enum representing the expansion behavior of the [ExpansionTileList].
///
/// - [atLeastOne]: At least one tile in the list should be expanded (one or many).
/// - [atMostOne]: At most one tile in the list can be expanded (i.e zero or one ).
/// - [exactlyOne]: Exactly one tile in the list should be expanded. (i.e one)
/// - [any]: Any number of tiles in the list can be expanded. (i.e zero, one, or many).
enum ExpansionMode {
  /// Indicates that at least one tile in the list should be expanded.
  /// If all tiles are collapsed, one will automatically be expanded.
  atLeastOne,

  /// Indicates that at most one tile in the list can be expanded at a time.
  /// If a tile is expanded while another tile is already expanded, the first tile will be collapsed.
  atMostOne,

  /// Indicates that exactly one tile in the list should be expanded at any time.
  /// If a tile is expanded while another tile is already expanded, the first tile will be collapsed.
  /// If the expanded tile is collapsed, another tile will automatically be expanded.
  exactlyOne,

  /// Indicates that any number of tiles in the list can be expanded at the same time.
  any;

  /// Returns true if the expansion type allows multiple tiles to be expanded.
  bool get isMultiple =>
      this == ExpansionMode.any || this == ExpansionMode.atLeastOne;

  /// Returns true if the expansion type allows only a single tile to be expanded.
  bool get isSingle =>
      this == ExpansionMode.atMostOne || this == ExpansionMode.exactlyOne;
}

abstract class _AssertMessage {
  static const String tileGapSize =
      'Error: tileGapSize property value must be greater than or equal to zero [tileGapSize >= 0]';
  static const String initialExpandedIndex =
      'Error: initialExpandedIndex must be greater than or equal to zero [initialExpandedIndex >= 0]';
}

///The [ExpansionTileList] widget can be used to create a list of [ExpansionTile]s that can have any number of tiles expanded at once.
/// The tiles can be expanded or collapsed by tapping on them.
/// The expansion behavior of the tiles can be customized using the [expansionMode] property.
/// The [expansionMode] property can be set to [ExpansionMode.atLeastOne], [ExpansionMode.atMostOne],
/// [ExpansionMode.exactlyOne], or [ExpansionMode.any].
/// The [expansionMode] property determines how many tiles can be expanded at once.
/// The [initialExpandedIndexes] property can be used to specify the indexes of the tiles that are initially expanded.
/// The [onExpansionChanged] callback is called whenever a tile is expanded or collapsed.
/// The [tileGapSize] property can be used to set the size of the gap between the tiles in the list.
/// The [tileBuilder] property can be used to customize the appearance of the tiles.
/// The [controller] property can be used to programmatically control the expansion of the tiles.
/// The [trailing] property can be used to set the widget that is displayed at the end of each tile header.
/// The [trailingAnimation] property can be used to customize the animation for the trailing widget of the tiles.
/// The [enableTrailingAnimation] property can be used to enable or disable the trailing animation.
/// The default animation rotates the trailing widget by 180 degrees and can be customized by providing a custom builder.
/// The custom builder can be used to create more complex animations.
class ExpansionTileList extends StatefulWidget {
  /// Creates a list of [ExpansionTile]s that can have any number of tiles to expand and collapse.
  /// The expansion behavior uses [expansionMode] property as [ExpansionMode.any] by default.
  /// Multiple Expansion Modes i.e. [ExpansionMode.any] and [ExpansionMode.atLeastOne]  will use the [initialExpandedIndexes] if it's not empty.
  /// [ExpansionMode.atLeastOne] will default to the first expandable tile child at index`0` if [initialExpandedIndexes] is empty.
  /// Single Expansion Mode i.e. [ExpansionMode.exactlyOne] and [ExpansionMode.atMostOne] will use the [initialExpandedIndexes] if it's not empty,
  /// it requires only one index, it will use the first valid index if there are multiple indexes.
  /// [ExpansionMode.exactlyOne] will default to the first expandable tile child index at zero if [initialExpandedIndexes] is empty.
  const ExpansionTileList({
    super.key,
    required this.children,
    this.expansionMode = ExpansionMode.any,
    this.controller,
    this.initialExpandedIndexes = const <int>[],
    this.onExpansionChanged,
    this.tileGapSize = 0.0,
    this.trailing,
    this.trailingAnimation,
    this.enableTrailingAnimation = true,
    this.tileBuilder,
    this.separatorBuilder,
  })  : assert(tileGapSize >= 0.0, _AssertMessage.tileGapSize),
        initialExpandedIndex = null,
        alwaysOneExpanded = expansionMode == ExpansionMode.exactlyOne ||
            expansionMode == ExpansionMode.atLeastOne;

  /// Creates a list of [ExpansionTile]s that can have only one tile to expand and collapse at a time.
  /// The expansion behavior uses [expansionMode] property as [ExpansionMode.atMostOne] by default.
  /// Single Expansion Mode: [ExpansionMode.exactlyOne] , [ExpansionMode.atMostOne] will use the [initialExpandedIndex] if it's not null.
  /// [ExpansionMode.exactlyOne] will default to the first expandable tile child index at zero if [initialExpandedIndex] is null.
  const ExpansionTileList.single({
    super.key,
    required this.children,
    this.controller,
    this.initialExpandedIndex,
    this.alwaysOneExpanded = false,
    this.onExpansionChanged,
    this.tileGapSize = 0.0,
    this.trailing,
    this.trailingAnimation,
    this.enableTrailingAnimation = true,
    this.tileBuilder,
    this.separatorBuilder,
  })  : assert(tileGapSize >= 0.0, _AssertMessage.tileGapSize),
        assert((initialExpandedIndex ?? 0) >= 0,
            _AssertMessage.initialExpandedIndex),
        initialExpandedIndexes = const <int>[],
        expansionMode = alwaysOneExpanded
            ? ExpansionMode.exactlyOne
            : ExpansionMode.atMostOne;

  /// Creates a list of [ExpansionTile]s that can have any number of tiles to expand and collapse.
  /// The expansion behavior uses [expansionMode] property as [ExpansionMode.any] by default.
  /// Multiple Expansion Mode: [ExpansionMode.any] , [ExpansionMode.atLeastOne] will use the [initialExpandedIndexes] if it's not empty.
  /// [ExpansionMode.atLeastOne] will default to the first expandable tile child index at zero if [initialExpandedIndexes] is empty.
  const ExpansionTileList.multiple({
    super.key,
    required this.children,
    this.controller,
    this.initialExpandedIndexes = const <int>[],
    this.alwaysOneExpanded = false,
    this.onExpansionChanged,
    this.tileGapSize = 0.0,
    this.trailing,
    this.trailingAnimation,
    this.enableTrailingAnimation = true,
    this.tileBuilder,
    this.separatorBuilder,
  })  : assert(tileGapSize >= 0.0, _AssertMessage.tileGapSize),
        initialExpandedIndex = null,
        expansionMode =
            alwaysOneExpanded ? ExpansionMode.atLeastOne : ExpansionMode.any;

  /// The list of [ExpansionTile]s that are managed by this widget.
  final List<ExpansionTile> children;

  /// The type of expansion: at most one, exactly one, or any number of tiles can be expanded at a time.
  final ExpansionMode expansionMode;

  /// Called whenever a tile is expanded or collapsed.
  final ExpansionTileCallback? onExpansionChanged;

  /// The size of the gap between the tiles in the list.
  final double tileGapSize;

  /// A builder that can be used to customize the appearance of the tiles.
  final ValueWidgetBuilder<int>? tileBuilder;

  /// A builder that can be used to customize the appearance of the separator between the tiles.
  final NullableIndexedWidgetBuilder? separatorBuilder;

  /// A controller that can be used to programmatically control the expansion of the tiles.
  final ExpansionTileListController? controller;

  /// The widget that is displayed at the end of each tile header.
  final Widget? trailing;

  /// Whether the trailing animation is enabled.
  /// If true, the trailing widget of the tiles is animated.
  final bool enableTrailingAnimation;

  /// The builder for the trailing animation of the tiles.
  /// If null, the default animation is used.
  /// The default animation rotates the trailing widget by 180 degrees.
  /// The default animation can be customized by providing a custom builder.
  /// The custom builder can be used to create more complex animations.
  /// The custom builder takes an [IndexedValueWidgetBuilder] as a parameter.
  /// The [IndexedValueWidgetBuilder] takes a [BuildContext], an index, a value, and a child widget.
  /// It returns a [Widget].
  /// The [IndexedValueWidgetBuilder] can be used to build widgets based on the index and value in a list or collection.
  /// The custom builder can be used to create animations that depend on the index and value of the tiles.
  //final IndexedValueWidgetBuilder<double>? trailingAnimationBuilder;

  final ExpansionTileListAnimation? trailingAnimation;

  /// The indexes of the tiles that are initially expanded.
  /// The behavior depends on the expansion type:
  /// For multiple values: [ExpansionMode.any] , [ExpansionMode.atLeastOne].
  /// For single values: [ExpansionMode.exactlyOne] , [ExpansionMode.atMostOne].
  final List<int> initialExpandedIndexes;

  /// The index of the tile that is initially expanded.
  /// Mostly used for single expansion types.
  /// For single: [ExpansionMode.exactlyOne] , [ExpansionMode.atMostOne].
  final int? initialExpandedIndex;

  /// If true, only one tile will be expanded at a time.
  final bool alwaysOneExpanded;

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// This method is called immediately after the widget is inserted in the tree
  /// and must return a separate [State] object for each instance of this widget.
  /// In this case, it returns an instance of [_ExpansionTileListState].
  @override
  State<ExpansionTileList> createState() => _ExpansionTileListState();

  /// Creates a copy of this [ExpansionTileList] but with the given fields replaced with the new values.
  /// If the original [ExpansionTileList] has a [key], the newly created [ExpansionTileList] will also have the same key.
  ExpansionTileList copyWith({
    Key? key,
    List<ExpansionTile> children = const <ExpansionTile>[],
    ExpansionMode expansionMode = ExpansionMode.any,
    List<int> initialExpandedIndexes = const <int>[],
    ExpansionTileCallback? onExpansionChanged,
    double tileGapSize = 0.0,
    Widget? trailing,
    ExpansionTileListAnimation? trailingAnimation,
    bool enableTrailingAnimation = true,
    ValueWidgetBuilder<int>? tileBuilder,
    NullableIndexedWidgetBuilder? separatorBuilder,
    ExpansionTileListController? controller,
  }) {
    return ExpansionTileList(
      key: key ?? this.key,
      expansionMode: expansionMode,
      initialExpandedIndexes: initialExpandedIndexes,
      onExpansionChanged: onExpansionChanged ?? this.onExpansionChanged,
      tileGapSize: tileGapSize,
      trailing: trailing ?? this.trailing,
      trailingAnimation: trailingAnimation ?? this.trailingAnimation,
      enableTrailingAnimation: enableTrailingAnimation,
      tileBuilder: tileBuilder ?? this.tileBuilder,
      separatorBuilder: separatorBuilder ?? this.separatorBuilder,
      controller: controller ?? this.controller,
      children: children,
    );
  }
}

// [_ExpansionTileListState] is the [State] object for the [ExpansionTileList] widget.
///
/// This class manages the stateful properties for the [ExpansionTileList] widget.
/// It maintains the state of the expansion tiles in the list, such as which tiles are expanded.
///
/// This class is private to the library as it starts with an underscore.
class _ExpansionTileListState extends State<ExpansionTileList> {
  late ExpansionTileListController _listController;
  final List<ExpansionTileItemController> _itemControllers = [];
  final List<int> _initialExpandedIndexes = [];

  @override
  void initState() {
    super.initState();
    _updateListController(true);
    _updateExpandedIndexes();
    _updateTileControllers();
  }

  @override
  void didUpdateWidget(ExpansionTileList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateListController();
    }
    if (widget.children != oldWidget.children ||
        listEquals(widget.children, oldWidget.children)) {
      _updateTileControllers(oldWidget.children);
    }
    if (widget.expansionMode != oldWidget.expansionMode ||
        !listEquals(
            widget.initialExpandedIndexes, oldWidget.initialExpandedIndexes) ||
        widget.initialExpandedIndex != oldWidget.initialExpandedIndex ||
        !listEquals(widget.children, oldWidget.children)) {
      _updateExpandedIndexes();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initExpansionMode();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _updateListController([bool init = false]) {
    if (init && widget.controller != null) {
      if (widget.controller?._state != null) {
        //("ExpansionTileList controller already in use or this is an indicator that you should use a Global Key to manage widget state update rather than recreation");
      }
    }
    _listController = (widget.controller ?? ExpansionTileListController())
      .._state = this;
  }

  /// Updates the expansion tile controllers of the [ExpansionTileList] children.
  ///
  /// Update the expansion tiles by comparing the old and new children.
  /// If the children are the same, the old expansion tile controllers are reused.
  /// If the children are different, the expansion tile controllers are updated or recreated.
  void _updateTileControllers([List<Widget> oldChildren = const []]) {
    var controllers = List.generate(widget.children.length, (index) {
      var canWidgetUpdate = (oldChildren.length > index
          ? Widget.canUpdate(widget.children[index], oldChildren[index])
          : false);
      var isControllerEqual = _itemControllers.length > index &&
          (_itemControllers[index] == widget.children[index].controller ||
              _itemControllers[index].delegate ==
                  widget.children[index].controller);

      if (canWidgetUpdate && isControllerEqual) {
        return _itemControllers[index];
      } else {
        return widget.children[index].controller is ExpansionTileItemController
            ? (widget.children[index].controller as ExpansionTileItemController)
            : ExpansionTileItemController(widget.children[index].controller);
      }
    });
    _itemControllers
      ..clear()
      ..addAll(controllers);
  }

  /// Disposes the resources used by this state object.
  ///
  /// This method is called when this state object will never build again.
  /// After calling this method, the state object is considered unmounted.
  @override
  void dispose() {
    if (_listController._state == this) {
      _listController._state = null;
    }
    _itemControllers.clear();
    super.dispose();
  }

  /// Builds the [ExpansionTileList] widget.
  /// This method is responsible for creating the list of [ExpansionTile]s.
  /// It uses the [builder] property to customize the appearance of the tiles.
  /// If the [builder] property is null, the default appearance of the tiles is used.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (int index) {
        return Column(
          children: <Widget>[
            widget.tileBuilder?.call(context, index, _buildChild(index)) ??
                _buildChild(index),
            if (index < widget.children.length - 1 && widget.tileGapSize > 0.0)
              SizedBox(height: widget.tileGapSize),
            if (widget.separatorBuilder != null &&
                index < widget.children.length - 1)
              widget.separatorBuilder!(context, index) ?? const SizedBox(),
          ],
        );
      }),
    );
  }

  /// Builds an [ExpansionTile] for a given index in the list of children.
  ///
  /// This method creates an [ExpansionTile] using the child at the given index. It assigns a controller to the tile,
  /// sets its initial expanded state, and assigns a callback for when the tile's expansion state changes.
  ///
  /// The method also assigns a trailing widget to the tile. If the trailing animation is enabled, an [AnimatedBuilder]
  /// is used to create the trailing widget with an animation. If the trailing animation is not enabled, the trailing
  /// widget from the child at the given index is used.
  ///
  /// [index] is the index of the child in the list of children.
  ///
  ExpansionTile _buildChild(int index) {
    var controller = _itemControllers[index];
    var enrichedExpansionTile = widget.children[index].copyWith(
        controller: controller,
        initiallyExpanded: _initialExpandedIndexes.contains(index),
        onExpansionChanged: (isExpanded) =>
            _onExpansionChanged(index, isExpanded),
        trailing: widget.children[index].trailing ?? widget.trailing);

    var expansionTileItem = widget.children[index] is ExpansionTileItem
        ? (widget.children[index] as ExpansionTileItem)
        : null;

    return ExpansionTileItem.from(
      enrichedExpansionTile,
      enableTrailingAnimation: expansionTileItem?.enableTrailingAnimation ??
          widget.enableTrailingAnimation,
      trailingAnimation: expansionTileItem?.trailingAnimation ??
          (widget.trailingAnimation != null
              ? _createExpansionTileItemAnimation(
                  widget.trailingAnimation!, index)
              : null),
    );
  }

  _createExpansionTileItemAnimation(
      ExpansionTileListAnimation animation, int index) {
    return ExpansionTileItemAnimation(
      animate: animation.animate,
      duration: animation.duration,
      curve: animation.curve,
      builder: animation.builder != null
          ? (context, value, child) {
              return animation.builder!(context, index, value, child);
            }
          : null,
    );
  }

  /// Updates the expansion state of the tile at the given [index].
  ///
  /// This method is called when the expansion state of a tile changes.
  /// If the tile is not expanded ([isExpanded] is false), this method returns early.
  /// If the [ExpansionTileList] is set to single expansion mode, it collapses all other tiles.
  ///
  /// [index] is the index of the tile in the list.
  /// [isExpanded] is the new expansion state of the tile.
  void _onExpansionChanged(int index, bool isExpanded) {
    Future.microtask(() {
      _updateExpansionMode(index, isExpanded);
    });
    widget.children[index].onExpansionChanged?.call(isExpanded);
    widget.onExpansionChanged?.call(index, isExpanded);
  }

  /// Updates the indexes of the tiles that are initially expanded.
  /// This method is called at [initState] and when the [initialExpandedIndexes] or [expansionMode] properties changes.
  /// It updates the list of indexes that are initially expanded based on the new property value.
  /// The combination of the [initialExpandedIndexes] and [initiallyExpanded] properties of tiles determines the initial expansion state of the tiles.
  /// If the combination is empty, no tiles are initially expanded for [ExpansionMode.atMostOne] and [ExpansionMode.any].
  /// If the combination is empty, the first tile is initially expanded for [ExpansionMode.exactlyOne] and [ExpansionMode.atLeastOne].
  void _updateExpandedIndexes() {
    var initialExpandedIndexes = {
      ...{...widget.initialExpandedIndexes, widget.initialExpandedIndex ?? -1}
          .where((index) => index >= 0 && index < widget.children.length),
      ..._whereIndexOf(widget.children, (idx, child) => child.initiallyExpanded)
    }.toList();

    switch (widget.expansionMode) {
      case ExpansionMode.atLeastOne:
        initialExpandedIndexes =
            initialExpandedIndexes.isNotEmpty ? initialExpandedIndexes : [0];
        break;
      case ExpansionMode.exactlyOne:
        initialExpandedIndexes = [initialExpandedIndexes.firstOrNull ?? 0];
        break;
      case ExpansionMode.atMostOne:
        initialExpandedIndexes = initialExpandedIndexes.isNotEmpty
            ? [initialExpandedIndexes.first]
            : [];
        break;
      case ExpansionMode.any:
        break;
    }
    _initialExpandedIndexes
      ..clear()
      ..addAll(initialExpandedIndexes);
  }

  void _initExpansionMode() {
    var expandedIndexes = _whereIndexOf(
        _itemControllers, (idx, controller) => controller.isExpanded);
    if (expandedIndexes.isEmpty) {
      _updateExpansionMode(_initialExpandedIndexes.firstOrNull ?? 0, true);
      return;
    }

    //Note: ensure that the expansion mode is respected
    //expandedIndexes will update once for single expansion mode [since the iterator updates its values on each iteration]
    for (var index in expandedIndexes) {
      _updateExpansionMode(index, true);
    }
  }

  /// Updates the expansion mode of the [ExpansionTileList].
  /// This method is called when the expansion state of a tile changes.
  /// It updates the expansion mode based on the current state of the tiles.
  /// If the expansion mode is set to [ExpansionMode.atLeastOne], it ensures that at least one tile is expanded.
  /// If the expansion mode is set to [ExpansionMode.atMostOne], it ensures that at most one tile is expanded.
  /// If the expansion mode is set to [ExpansionMode.exactlyOne], it ensures that exactly one tile is expanded.
  /// If the expansion mode is set to [ExpansionMode.any], it allows any number of tiles to be expanded.
  /// [index] is the index of the tile in the list.
  /// [isExpanded] is the new expansion state of the tile.
  void _updateExpansionMode(int index, bool isExpanded) {
    switch (widget.expansionMode) {
      case ExpansionMode.atLeastOne:
        var expandedIndexes = _whereIndexOf(
            _itemControllers, (idx, controller) => controller.isExpanded);
        if (expandedIndexes.length == 1) {
          // probably the a collapse event so we change the index to the active one
          index = expandedIndexes.first;
          _itemControllers[expandedIndexes.first].disable();
        } else if (expandedIndexes.isEmpty) {
          isExpanded
              ? _itemControllers[index].disable()
              : _itemControllers[index].expand();
        }
        break;
      case ExpansionMode.atMostOne:
        for (int i = 0; i < _itemControllers.length; i++) {
          if (i != index && isExpanded) {
            _itemControllers[i].collapse();
          }
        }
        index = -1;
        break;
      case ExpansionMode.exactlyOne:
        var expandedIndexes = _whereIndexOf(
            _itemControllers, (idx, controller) => controller.isExpanded);
        if (expandedIndexes.length == 1) {
          index = expandedIndexes.first;
          _itemControllers[expandedIndexes.first].disable();
        } else {
          for (var idx in expandedIndexes) {
            if (index != idx && isExpanded) {
              _itemControllers[idx].collapse();
            }
          }
          isExpanded
              ? _itemControllers[index].disable()
              : _itemControllers[index].expand();
        }
        break;
      case ExpansionMode.any:
        index = -1;
        break;
    }

    for (int i = 0; i < _itemControllers.length; i++) {
      if (i != index && widget.children[i].enabled) {
        _itemControllers[i].enable();
      }
    }
  }

  Iterable<int> _whereIndexOf<E>(
      Iterable<E> iterable, bool Function(int, E) test) {
    return iterable.indexed
        .where((indexedValue) => test(indexedValue.$1, indexedValue.$2))
        .map((indexedValue) => indexedValue.$1);
  }

  /// Toggles the expansion state of all tiles in the list.
  ///
  /// If [expand] is true, all tiles are expanded.
  /// If [expand] is false, all tiles are collapsed.
  /// If [expand] is null, the expansion state of all tiles is reversed.
  void _toggleAll([bool? expand]) {
    for (int i = 0; i < widget.children.length; i++) {
      if (expand != null) {
        if (expand) {
          _itemControllers[i].expand();
        } else {
          _itemControllers[i].collapse();
        }
      } else {
        _toggle(i);
      }
    }
  }

  /// Toggles the expansion state of the tile at the given [index].
  ///
  /// If the tile is expanded, it is collapsed.
  /// If the tile is collapsed, it is expanded.
  ///
  /// [index] is the index of the tile in the list.
  void _toggle(int index) {
    var controller =
        widget.children.length > index ? _itemControllers[index] : null;
    if (controller != null) {
      if (controller.isExpanded) {
        controller.collapse();
      } else {
        controller.expand();
      }
    }
  }
}

/// `ExpansionTileListController` is a controller class that provides methods
/// to programmatically control the state of tiles in an `ExpansionTileList`.
///
/// It provides methods to expand, collapse, and toggle the state of individual tiles
/// as well as all tiles in the list.
///
/// The `toggle(int index)` method is used to toggle the state of the tile at the given index.
///
/// The `expandAll()` method is used to expand all the tiles in the list.
///
/// The `collapseAll()` method is used to collapse all the tiles in the list.
///
/// The `maybeOf(BuildContext context)` method is used to find the `ExpansionTileListController`
/// for the closest `ExpansionTileList` instance that encloses the given context.
///
/// Note: Before using these methods, make sure that the `ExpansionTileListController` is ready.
/// If the controller is not ready, an assertion error will be thrown.
class ExpansionTileListController {
  /// Creates a new instance of the `ExpansionTileListController`.
  ExpansionTileListController();

  _ExpansionTileListState? _state;

  /// Checks if the tile at the given index is expanded.
  ///
  /// This method returns `true` if the tile at the specified index is expanded, and `false` otherwise.
  /// It throws an assertion error if the controller is not ready.
  ///
  /// [index] is the index of the tile in the `ExpansionTileList`.
  bool isExpanded(int index) {
    assert(_state != null, 'Error: ExpansionTileListController is not ready');
    return _state!.widget.children.length > index &&
        (_state!._itemControllers[index].isExpanded);
  }

  /// Checks if the tile at the given index is expanded.
  ///
  /// Returns `true` if the tile is expanded, `false` otherwise.
  /// Throws an assertion error if the controller is not ready.
  ///
  /// [index] is the index of the tile in the `ExpansionTileList`.
  void expand(int index) {
    assert(_state != null, 'Error: ExpansionTileListController is not ready');
    if (!isExpanded(index)) {
      _state!._toggle(index);
    }
  }

  /// Collapses the tile at the given index.
  ///
  /// This method programmatically collapses the tile at the specified index in the `ExpansionTileList`.
  /// If the tile is already collapsed, this method has no effect.
  ///
  /// [index] is the index of the tile in the `ExpansionTileList`.
  void collapse(int index) {
    assert(_state != null, 'Error: ExpansionTileListController is not ready');
    if (isExpanded(index)) {
      _state!._toggle(index);
    }
  }

  /// Toggles the expanded state of the tile at the given index.
  ///
  /// This method programmatically toggles the expanded state of the tile at the specified index in the `ExpansionTileList`.
  /// If the tile is expanded, it will be collapsed; if it is collapsed, it will be expanded.
  ///
  /// [index] is the index of the tile in the `ExpansionTileList`.
  void toggle(int index) {
    assert(_state != null, 'Error: ExpansionTileListController is not ready');
    _state!._toggle(index);
  }

  /// Expands all the tiles in the `ExpansionTileList`.
  ///
  /// If the tiles are already expanded, this method has no effect.
  void expandAll() {
    assert(_state != null, 'Error: ExpansionTileListController is not ready');
    _state!._toggleAll(true);
  }

  /// Collapses all the tiles in the `ExpansionTileList`.
  ///
  /// If the tiles are already collapsed, this method has no effect.
  void collapseAll() {
    assert(_state != null, 'Error: ExpansionTileListController is not ready');
    _state!._toggleAll(false);
  }

  /// Finds the [ExpansionTileController] for the closest [ExpansionTile] instance
  /// that encloses the given context and returns it.
  ///
  /// If no [ExpansionTile] encloses the given context then return null.
  ///
  /// This method is useful when you want to access the [ExpansionTileController]
  /// but also want to avoid exceptions when no [ExpansionTile] is present in the
  /// current context. In such cases, this method will simply return null.
  ///
  /// See also:
  ///
  ///  * [of], a similar function to this one that throws if no [ExpansionTile]
  ///    encloses the given context.
  static ExpansionTileListController? maybeOf(BuildContext context) {
    return context
        .findAncestorStateOfType<_ExpansionTileListState>()
        ?._listController;
  }

  /// Finds the [ExpansionTileListController] for the closest [ExpansionTile] instance
  /// that encloses the given context and returns it.
  ///
  /// If no [ExpansionTile] encloses the given context, calling this
  /// method will cause an assert in debug mode, and throw an
  /// exception in release mode.
  ///
  /// This method is useful when you need to access the [ExpansionTileListController]
  /// and you are certain that the context is enclosed by an [ExpansionTile].
  /// If there's a chance that the context is not enclosed by an [ExpansionTile],
  /// consider using [maybeOf] method instead which returns null in such cases.
  ///
  /// See also:
  ///
  ///  * [maybeOf], a similar function to this one that returns null if no [ExpansionTile]
  ///    encloses the given context.
  static ExpansionTileListController of(BuildContext context) {
    final _ExpansionTileListState? result =
        context.findAncestorStateOfType<_ExpansionTileListState>();
    if (result != null) {
      return result._listController;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'ExpansionTileListController.of() called with a context that does not contain a ExpansionTileList.',
      ),
      ErrorDescription(
        'No ExpansionTileList ancestor could be found starting from the context that was passed to ExpansionTileListController.of(). '
        'This usually happens when the context provided is from the same StatefulWidget as that '
        'whose build function actually creates the ExpansionTileList widget being sought.',
      ),
      ErrorHint(
        'There are several ways to avoid this problem. The simplest is to use a Builder to get a '
        'context that is "under" the ExpansionTileList. For an example of this, please see the '
        'documentation for ExpansionTileListController.of():\n'
        '  https://api.flutter.dev/flutter/material/ExpansionTile/of.html',
      ),
      ErrorHint(
        'A more efficient solution is to split your build function into several widgets. This '
        'introduces a new context from which you can obtain the ExpansionTileList. In this solution, '
        'you would have an outer widget that creates the ExpansionTileList populated by instances of '
        'your new inner widgets, and then in these inner widgets you would use ExpansionTileListController.of().\n'
        'An other solution is assign a GlobalKey to the ExpansionListTile, '
        'then use the key.currentState property to obtain the ExpansionTileList rather than '
        'using the ExpansionTileListController.of() function.',
      ),
      context.describeElement('The context used was'),
    ]);
  }
}
