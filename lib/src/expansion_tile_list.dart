import 'dart:math';

import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/material.dart';

import 'expansion_tile_extension.dart';

/// Signature for the listener callback that's called when an [ExpansionTile] is
/// expanded or collapsed.
///
/// The position of the panel within an [ExpansionTileList] is given by
/// [index]. The [isExpanded] parameter is true if the tile was expanded, and
/// [isExpanded]. The [isExpanded] parameter is true if the tile was expanded, and false if it was collapsed.
typedef ExpansionTileCallback = void Function(int index, bool isExpanded);

/// This typedef represents a function that takes a [BuildContext], an index, a generic value of type [T], and an optional child widget.
/// It returns a [Widget]. This function can be used to build widgets based on the index and value in a list or collection.
typedef IndexedValueWidgetBuilder<T> = Widget Function(
    BuildContext context, int index, T value, Widget? child);

/// Enum representing the expansion behavior of the [ExpansionTileList].
///
/// - [atLeastOne]: At least one tile in the list should be expanded.
/// - [atMostOne]: At most one tile in the list can be expanded.
/// - [exactlyOne]: Exactly one tile in the list should be expanded.
/// - [any]: Any number of tiles in the list can be expanded
enum ExpansionType {
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
  bool get isMultipleExpansion =>
      this == ExpansionType.any || this == ExpansionType.atLeastOne;

  /// Returns true if the expansion type allows only a single tile to be expanded.
  bool get isSingleExpansion =>
      this == ExpansionType.atMostOne || this == ExpansionType.exactlyOne;
}

/// A widget that manages a list of [ExpansionTile]s.
///
/// The [ExpansionTileList] takes a list of [ExpansionTile]s and an [ExpansionType]
/// to manage the expansion behavior of the list. It also accepts optional parameters
/// for initially expanded indexes, a callback for expansion changes, a gap size between tiles,
/// a custom builder for the tile, and a controller for the list.
///
/// The [ExpansionType] determines how many tiles can be expanded at once. It can be set to
/// allow multiple tiles to be expanded at the same time, or restrict it to a single tile.
///
/// The [initialExpandedIndexes] or [initialExpandedIndex] can be used to specify which tiles
/// are expanded when the list is first created.
///
/// The [onExpansionChanged] callback is called whenever a tile is expanded or collapsed.
///
/// The [tileGapSize] can be used to specify a gap between the tiles in the list.
///
/// The [builder] can be used to customize the appearance of the tiles.
///
/// The [controller] can be used to programmatically control the expansion of the tiles.

class ExpansionTileList extends StatefulWidget {
  const ExpansionTileList._({
    super.key,
    this.trailing,
    this.trailingAnimation,
    this.trailingAnimationEnabled = true,
    this.trailingAnimationBuilder,
    this.controller,
    this.builder,
    required this.children,
    required this.expansionType,
    this.onExpansionChanged,
    List<int> initialExpandedIndexes = const <int>[],
    int? initialExpandedIndex,
    this.tileGapSize = 0.0,
  })  : assert(tileGapSize >= 0.0,
            'Error: Please set the tileGapSize of ExpansionTileList must be >= 0'),
        assert(
            (expansionType == ExpansionType.any ||
                    expansionType == ExpansionType.atLeastOne) ||
                (expansionType == ExpansionType.atMostOne &&
                    initialExpandedIndexes.length <= 1) ||
                (expansionType == ExpansionType.exactlyOne &&
                    (initialExpandedIndexes.length <= 1 ||
                        initialExpandedIndex != null)),
            'Error: Please set the initialExpandedIndexes for the provided ExpansionType.atMostOne or ExpansionType.exactlyOn must be <= 1 or use initialExpandedIndex instead'),
        _initialExpandedIndexes = initialExpandedIndexes,
        _initialExpandedIndex = initialExpandedIndex;

  /// Creates a list of [ExpansionTile]s that can have any number of tiles expanded at once.
  const ExpansionTileList({
    Key? key,
    Widget? trailing,
    Animatable<double>? trailingAnimation,
    bool trailingAnimationEnabled = true,
    IndexedValueWidgetBuilder<double>? trailingAnimationBuilder,
    required List<ExpansionTile> children,
    List<int> initialExpandedIndexes = const <int>[],
    ExpansionTileCallback? onExpansionChanged,
    double tileGapSize = 0.0,
    ValueWidgetBuilder<int>? builder,
    ExpansionTileListController? controller,
  }) : this._(
          key: key,
          trailing: trailing,
          trailingAnimation: trailingAnimation,
          trailingAnimationEnabled: trailingAnimationEnabled,
          trailingAnimationBuilder: trailingAnimationBuilder,
          children: children,
          expansionType: ExpansionType.any,
          initialExpandedIndexes: initialExpandedIndexes,
          onExpansionChanged: onExpansionChanged,
          tileGapSize: tileGapSize,
          builder: builder,
          controller: controller,
        );

  /// Creates a list of [ExpansionTile]s that can have at least one tile expanded at all times.
  const ExpansionTileList.radio({
    Key? key,
    Widget? trailing,
    Animatable<double>? trailingAnimation,
    bool trailingAnimationEnabled = true,
    IndexedValueWidgetBuilder<double>? trailingAnimationBuilder,
    required List<ExpansionTile> children,
    int? initialExpandedIndex,
    ExpansionTileCallback? onExpansionChanged,
    double tileGapSize = 0.0,
    ValueWidgetBuilder<int>? builder,
    ExpansionTileListController? controller,
  }) : this._(
          key: key,
          trailing: trailing,
          trailingAnimation: trailingAnimation,
          trailingAnimationEnabled: trailingAnimationEnabled,
          trailingAnimationBuilder: trailingAnimationBuilder,
          children: children,
          expansionType: ExpansionType.atMostOne,
          initialExpandedIndex: initialExpandedIndex,
          onExpansionChanged: onExpansionChanged,
          tileGapSize: tileGapSize,
          builder: builder,
          controller: controller,
        );

  /// The list of [ExpansionTile]s that are managed by this widget.
  final List<ExpansionTile> children;

  /// The type of expansion: at most one, exactly one, or any number of tiles can be expanded at a time.
  final ExpansionType expansionType;

  /// Called whenever a tile is expanded or collapsed.
  final ExpansionTileCallback? onExpansionChanged;

  /// The size of the gap between the tiles in the list.
  final double tileGapSize;

  /// A builder that can be used to customize the appearance of the tiles.
  final ValueWidgetBuilder<int>? builder;

  /// A controller that can be used to programmatically control the expansion of the tiles.
  final ExpansionTileListController? controller;

  /// The widget that is displayed at the end of each tile header.
  final Widget? trailing;

  /// The animation for the trailing widget of the tiles.
  final Animatable<double>? trailingAnimation;

  /// Whether the trailing animation is enabled.
  /// If true, the trailing widget of the tiles is animated.
  final bool trailingAnimationEnabled;

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
  final IndexedValueWidgetBuilder<double>? trailingAnimationBuilder;

  /// The indexes of the tiles that are initially expanded. If empty, no tiles are initially expanded.
  /// For multiple: [ExpansionType.any] , [ExpansionType.atLeastOne].
  final List<int> _initialExpandedIndexes;

  /// The index of the tile that is initially expanded. If null, no tiles are initially expanded.
  /// For single: [ExpansionType.exactlyOne] , [ExpansionType.atMostOne].
  final int? _initialExpandedIndex;

  /// Returns the indexes of the tiles that are initially expanded.
  /// The behavior depends on the expansion type:
  /// - For multiple expansion types ([ExpansionType.any] or [ExpansionType.atLeastOne]),
  ///   it returns the list of initial expanded indexes if it's not empty,
  ///   otherwise it returns the list containing the initial expanded index if it's not null.
  /// - For single expansion types ([ExpansionType.exactlyOne] or [ExpansionType.atMostOne]),
  ///   it returns the list containing the first index from the initial expanded indexes if it's not empty,
  ///   otherwise it returns the list containing the initial expanded index if it's not null.
  List<int> get initialExpandedIndexes => expansionType.isMultipleExpansion
      ? (_initialExpandedIndexes.isNotEmpty
          ? _initialExpandedIndexes
          : (_initialExpandedIndex != null ? [_initialExpandedIndex!] : []))
      : (_initialExpandedIndex == null
          ? (_initialExpandedIndexes.isNotEmpty
              ? [_initialExpandedIndexes[0]]
              : [])
          : [_initialExpandedIndex!]);

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// This method is called immediately after the widget is inserted in the tree
  /// and must return a separate [State] object for each instance of this widget.
  /// In this case, it returns an instance of [_ExpansionTileListState].
  @override
  State<ExpansionTileList> createState() => _ExpansionTileListState();
}

/// [_ExpansionTileListState] is the [State] object for the [ExpansionTileList] widget.
///
/// This class manages the stateful properties for the [ExpansionTileList] widget.
/// It maintains the state of the expansion tiles in the list, such as which tiles are expanded.
///
/// This class is private to the library as it starts with an underscore.
class _ExpansionTileListState extends State<ExpansionTileList>
    with TickerProviderStateMixin<ExpansionTileList> {
  late final ExpansionTileListController _listController;
  late final List<ExpansionTile> _children;

  /// The animation controllers for the trailing widgets of the tiles.
  late final Map<int, AnimationController> _animationControllers;
  late final Map<int, Animation<double>> _trailingAnimations;
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Tween<double> _halfTween = Tween<double>(begin: 0.0, end: pi);

  AnimationController _animationControllerAt(int index, [double? value]) {
    return _animationControllers.putIfAbsent(index, () {
      return AnimationController(
          value: value,
          vsync: this,
          duration: widget.children[index].expansionAnimationStyle?.duration ??
              Durations.short4);
    });
  }

  Animation<double> _trailingAnimationAt(int index, [double? value]) {
    return _trailingAnimations.putIfAbsent(
        index,
        () => _animationControllerAt(index, value)
            .drive(widget.trailingAnimation ?? _halfTween.chain(_easeInTween)));
  }

  @override
  void initState() {
    super.initState();
    _children = [];
    assert(widget.controller?._state == null);
    _listController = widget.controller ?? ExpansionTileListController();
    _listController._state = this;
    //
    _animationControllers = <int, AnimationController>{};
    _trailingAnimations = <int, Animation<double>>{};
    _updateChildren();
  }

  @override
  void didUpdateWidget(ExpansionTileList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trailing != widget.trailing ||
        oldWidget.trailingAnimationEnabled != widget.trailingAnimationEnabled ||
        oldWidget.trailingAnimation != widget.trailingAnimation ||
        oldWidget.trailingAnimationBuilder != widget.trailingAnimationBuilder) {
      _disposeAnimationControllers();
    }
    _updateChildren(oldWidget.children);
    _updateAnimationDuration(Theme.of(context).expansionTileTheme);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  /// Disposes the resources used by this state object.
  ///
  /// This method is called when this state object will never build again.
  /// After calling this method, the state object is considered unmounted.
  @override
  void dispose() {
    _children.clear();
    _listController._state = null;
    _disposeAnimationControllers();
    super.dispose();
  }

  void _disposeAnimationControllers() {
    _animationControllers.forEach((_, controller) => controller.dispose());
    _animationControllers.clear();
    _trailingAnimations.clear();
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in
  /// a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [..._buildChildren()],
    );
  }

  /// Builds the children of the [ExpansionTileList].
  ///
  /// This method is responsible for generating the list of widgets that represent
  /// the children of the [ExpansionTileList].
  List<Widget> _buildChildren() {
    return List.generate(widget.children.length, (int index) {
      return Column(
        children: <Widget>[
          widget.builder?.call(context, index, _children[index]) ??
              _children[index],
          if (index < widget.children.length - 1 && widget.tileGapSize > 0.0)
            SizedBox(height: widget.tileGapSize),
        ],
      );
    });
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
    var controller =
        widget.children[index].controller ?? ExpansionTileController();
    var oldController =
        _children.length > index ? _children[index].controller : null;
    var initiallyExpanded = oldController?.isExpanded ??
        (widget.children[index].initiallyExpanded ||
            widget.initialExpandedIndexes.contains(index));
    Widget trailingAnimationBuilder() {
      var trailingAnimation = _trailingAnimationAt(
          index, initiallyExpanded ? _halfTween.end : _halfTween.begin);
      return AnimatedBuilder(
        animation: trailingAnimation,
        builder: (context, child) {
          return (widget.trailingAnimationBuilder ?? _defaultAnimationBuilder)
              .call(context, index, trailingAnimation.value, child);
        },
        child: widget.trailing,
      );
    }

    return widget.children[index].copyWith(
        key: ObjectKey(controller),
        controller: controller,
        initiallyExpanded: initiallyExpanded,
        onExpansionChanged: (isExpanded) {
          _updateExpansionChange(index, isExpanded);
          widget.children[index].onExpansionChanged?.call(isExpanded);
          widget.onExpansionChanged?.call(index, isExpanded);
        },
        trailing: widget.children[index].trailing ??
            (widget.trailing != null && widget.trailingAnimationEnabled
                ? trailingAnimationBuilder()
                : widget.trailing ?? widget.children[index].trailing));
  }

  /// This is a helper method that creates a rotation animation for a widget.
  ///
  /// The method takes a [BuildContext], an index, a value representing the rotation angle, and a child widget.
  /// It applies a rotation transformation to the child widget based on the provided value.
  /// The rotation angle is calculated as the product of the value and pi, which results in a rotation in radians.
  ///
  /// [context] is the build context in which this widget is being constructed.
  /// [index] is the index of the child in the list of children.
  /// [value] is the value used to calculate the rotation angle.
  /// [child] is the widget to which the rotation transformation is applied.
  ///
  /// Returns a [Transform] widget that applies a rotation transformation to the child widget.
  Widget _defaultAnimationBuilder(
      BuildContext context, int index, double value, Widget? child) {
    return Transform.rotate(
      angle: value,
      child: child,
    );
  }

  /// Updates the expansion tiles (children) of the [ExpansionTileList].
  ///
  /// Update the expansion tiles by comparing the old and new children.
  /// If the children are the same, the old expansion tiles are reused.
  /// If the children are different, the expansion tiles are updated.
  void _updateChildren([List<ExpansionTile>? oldChildren]) {
    var tiles = List.generate(
        widget.children.length,
        (index) => (oldChildren != null &&
                oldChildren.length > index &&
                oldChildren[index] == widget.children[index])
            ? _children[index]
            : _buildChild(index));
    _children.clear();
    _children.addAll(tiles);
  }

  void _updateAnimationDuration(ExpansionTileThemeData expansionTileTheme) {
    _animationControllers.forEach((index, controller) {
      controller.duration =
          widget.children[index].expansionAnimationStyle?.duration ??
              expansionTileTheme.expansionAnimationStyle?.duration ??
              controller.duration ??
              Durations.short4;
    });
  }

  /// Updates the expansion state of the tile at the given [index].
  ///
  /// This method is called when the expansion state of a tile changes.
  /// If the tile is not expanded ([isExpanded] is false), this method returns early.
  /// If the [ExpansionTileList] is set to single expansion mode, it collapses all other tiles.
  ///
  /// [index] is the index of the tile in the list.
  /// [isExpanded] is the new expansion state of the tile.
  void _updateExpansionChange(int index, bool isExpanded) {
    if (_animationControllers.length > index) {
      isExpanded
          ? _animationControllers[index]?.forward()
          : _animationControllers[index]?.reverse();
    }

    if (!isExpanded) {
      return;
    }
    //_isExpanding = true;
    if (widget.expansionType.isSingleExpansion) {
      Future.microtask(() {
        for (int i = 0; i < _children.length; i++) {
          if (i != index && _children[i].enabled) {
            _children[i].controller?.collapse();
          }
        }
        // _isExpanding = false;
      });
    }
  }

  /// Toggles the expansion state of all tiles in the list.
  ///
  /// If [expand] is true, all tiles are expanded.
  /// If [expand] is false, all tiles are collapsed.
  /// If [expand] is null, the expansion state of all tiles is reversed.
  void _toggleAll([bool? expand]) {
    for (int i = 0; i < _children.length; i++) {
      if (expand != null) {
        if (expand) {
          _children[i].controller?.expand();
        } else {
          _children[i].controller?.collapse();
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
        _children.length > index ? _children[index].controller : null;
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
    return _state!._children.length > index &&
        (_state!._children[index].controller?.isExpanded ?? false);
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
