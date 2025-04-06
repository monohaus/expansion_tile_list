import 'dart:developer' as dev;
import 'dart:math';
import 'dart:ui';

import 'package:expansion_tile_list/expansion_tile_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Signature for the listener callback that's called when an [ExpansionTile] is
/// expanded or collapsed.
///
/// The position of the panel within an [ExpansionTileList] is given by
/// [index]. The [isExpanded] parameter is true if the tile was expanded, and
/// [isExpanded]. The [isExpanded] parameter is true if the tile was expanded, and false if it was collapsed.
typedef ExpansionTileCallback = void Function(int index, bool isExpanded);

/// Signature for the listener callback that's called when an [ExpansionTileList] is animated.
typedef ExpansionTileListAnimation = IndexedValueExpansionTileAnimation;

/// callback checks if the item can be reordered.
/// The [oldIndex] parameter is the index of the item before it was reordered.
/// The [newIndex] parameter is the index of the item after it was reordered.
typedef CanReorderCallback = bool Function(int oldIndex, int newIndex);

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

  /// Returns the [ExpansionMode] enum value from the given name.
  /// Throws an [ArgumentError] if the name is not found.
  static ExpansionMode fromName(String name) {
    return ExpansionMode.values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('No such ExpansionMode: $name'),
    );
  }

  /// Returns the [ExpansionMode] enum value from the given index.
  /// Throws an [ArgumentError] if the index is not found.
  static ExpansionMode fromIndex(int index) {
    return ExpansionMode.values.firstWhere(
      (e) => e.index == index,
      orElse: () => throw ArgumentError('No such ExpansionMode: $index'),
    );
  }
}

/// Enum representing the placement of the drag handle in the [ExpansionTile].
/// The drag handle is used to reorder the tiles in the [ExpansionTileList].
/// The drag handle can be displayed at the beginning (leading widget) or end (trailing widget) or center (title widget) of the tile header.
/// If the leading or trailing widget is null, a default drag handle widget (Icons.drag_handle) is displayed.
enum DragHandlePlacement {
  /// Indicates that no placement for the drag handle, defaults to the entire [ExpansionTile].
  none,

  /// Indicates that the drag handle is displayed at the center (title widget) of the tile header.
  title,

  /// Indicates that the drag handle is displayed at the beginning (leading widget) of the tile header.
  /// If the leading widget is null, a default drag handle widget (Icons.drag_handle) is displayed.
  leading,

  /// Indicates that the drag handle is displayed at the end of the tile header.
  /// If the trailing widget is null, a default drag handle widget (Icons.drag_handle) is displayed.
  trailing;

  /// Returns the [DragHandlePlacement] enum value from the given name.
  static DragHandlePlacement fromName(String name) {
    return DragHandlePlacement.values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('No such placement: $name'),
    );
  }

  /// Returns the [DragHandlePlacement] enum value from the given index.
  static DragHandlePlacement fromIndex(int index) {
    return DragHandlePlacement.values.firstWhere(
      (e) => e.index == index,
      orElse: () => throw ArgumentError('No such placement: $index'),
    );
  }
}

/// Enum representing the drag handle alignment of a widget.
enum DragHandleAlignment {
  /// Aligns to the center left of a widget with an horizontal layout.
  centerLeft(Alignment.centerLeft),

  /// Aligns to the center right of a widget with an horizontal layout.
  centerRight(Alignment.centerRight),

  /// Aligns to the top left of a widget with an horizontal layout.
  topLeft(Alignment.topLeft),

  /// Aligns to the top right of a widget with an horizontal layout.
  topRight(Alignment.topRight),

  /// Aligns to the bottom left of a widget with an horizontal layout.
  bottomLeft(Alignment.bottomLeft),

  /// Aligns to the bottom right of a widget with an horizontal layout.
  bottomRight(Alignment.bottomRight),

  /// Aligns to the center of a widget with an horizontal layout.
  center(Alignment.center);

  /// The alignment value of the enum.
  final Alignment alignment;

  const DragHandleAlignment(this.alignment);

  /// Returns true if this is a left alignment.
  bool get isLeft =>
      this == DragHandleAlignment.centerLeft ||
      this == DragHandleAlignment.topLeft ||
      this == DragHandleAlignment.bottomLeft;

  /// Returns true if this is a right alignment.
  bool get isRight =>
      this == DragHandleAlignment.centerRight ||
      this == DragHandleAlignment.topRight ||
      this == DragHandleAlignment.bottomRight;

  /// Returns the [DragHandleAlignment] enum value from the given name.
  /// Throws an [ArgumentError] if the name is not found.
  static DragHandleAlignment fromName(String name) {
    return DragHandleAlignment.values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('No such DragHandleAlignment: $name'),
    );
  }

  /// Returns the [DragHandleAlignment] enum value from the given index.
  /// Throws an [ArgumentError] if the index is not found.
  static DragHandleAlignment fromIndex(int index) {
    return DragHandleAlignment.values.firstWhere(
      (e) => e.index == index,
      orElse: () => throw ArgumentError('No such DragHandleAlignment: $index'),
    );
  }
}

abstract class _AssertMessage {
  static const String itemGapSize =
      'Error: itemGapSize property value must be greater than or equal to zero [itemGapSize >= 0]';
}

///The [ExpansionTileList] widget can be used to create a list of [ExpansionTile]s that can have any number of tiles expanded at once.
/// The tiles can be expanded or collapsed by tapping on them.
/// The expansion behavior of the tiles can be customized using the [expansionMode] property.
/// The [expansionMode] property can be set to [ExpansionMode.atLeastOne], [ExpansionMode.atMostOne],
/// [ExpansionMode.exactlyOne], or [ExpansionMode.any].
/// The [expansionMode] property determines how many tiles can be expanded at once.
/// The [initialExpandedIndexes] property can be used to specify the indexes of the tiles that are initially expanded.
/// The [onExpansionChanged] callback is called whenever a tile is expanded or collapsed.
/// The [itemGapSize] property can be used to set the size of the gap between the tiles in the list.
/// The [itemBuilder] property can be used to customize the appearance of the tiles.
/// The [controller] property can be used to programmatically control the expansion of the tiles.
/// The [trailing] property can be used to set the widget that is displayed at the end of each tile header.
/// The [trailingAnimation] property can be used to customize the animation for the trailing widget of the tiles.
/// The [enableTrailingAnimation] property can be used to enable or disable the trailing animation.
/// The [separatorBuilder] property can be used to customize the appearance of the separator between the tiles.
/// The [separatorAlignment] property can be used to set the alignment of the separator widget relative to the itemGap.
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
    this.itemGapSize = 0.0,
    this.trailing,
    this.trailingAnimation,
    this.enableTrailingAnimation = true,
    this.itemBuilder,
    this.separatorBuilder,
    this.separatorAlignment = Alignment.bottomCenter,
    // ScrollView Specific Properties
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  })  : assert(itemGapSize >= 0.0, _AssertMessage.itemGapSize),
        reorderable = false,
        canReorder = null,
        onReorder = null,
        onReorderStart = null,
        onReorderEnd = null,
        proxyDecorator = null,
        enableDefaultDragHandles = false,
        useDelayedDrag = false,
        dragHandlePlacement = DragHandlePlacement.none,
        dragHandleAlignment = DragHandleAlignment.centerLeft,
        dragHandleBuilder = null,
        anchor = 0.0,
        autoScrollerVelocityScalar = null;

  /// Creates a list of [ExpansionTile]s that can be reordered by dragging and dropping.
  /// The expansion behavior uses [expansionMode] property as [ExpansionMode.any] by default.
  /// Multiple Expansion Mode: [ExpansionMode.any] , [ExpansionMode.atLeastOne] will use the [initialExpandedIndexes] if it's not empty.
  /// [ExpansionMode.atLeastOne] will default to the first expandable tile child index at zero if [initialExpandedIndexes] is empty.
  /// The [onReorder] callback is called when the user finishes reordering the list.
  /// The [onReorderStart] callback is called when the user starts reordering an item.
  /// The [onReorderEnd] callback is called when the user stops reordering an item.
  /// The [proxyDecorator] property can be used to customize the appearance of the proxy item that is displayed while reordering.
  /// The [buildDefaultDragHandles] property can be used to build default drag handles for the reorderable items.
  /// The [header] property can be used to set the widget that is displayed at the beginning of the list.
  /// The [footer] property can be used to set the widget that is displayed at the end of the list.
  /// The [anchor] property can be used to set the anchor value for the auto scroller.
  /// The [autoScrollerVelocityScalar] property can be used to set the scalar value for the auto scroller velocity.
  const ExpansionTileList.reorderable({
    super.key,
    required this.children,
    this.controller,
    this.expansionMode = ExpansionMode.any,
    this.initialExpandedIndexes = const <int>[],
    this.onExpansionChanged,
    this.itemGapSize = 0.0,
    this.trailing,
    this.trailingAnimation,
    this.enableTrailingAnimation = true,
    this.itemBuilder,
    this.separatorBuilder,
    this.separatorAlignment = Alignment.bottomCenter,
    // ScrollView Specific Properties
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.scrollController,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    // OrderableListView Specific Properties
    this.canReorder,
    this.onReorder,
    this.onReorderStart,
    this.onReorderEnd,
    this.proxyDecorator,
    this.enableDefaultDragHandles = true,
    this.useDelayedDrag = false,
    this.dragHandlePlacement = DragHandlePlacement.none,
    this.dragHandleAlignment = DragHandleAlignment.centerLeft,
    this.dragHandleBuilder,
    this.anchor = 0.0,
    this.autoScrollerVelocityScalar,
  })  : assert(itemGapSize >= 0.0, _AssertMessage.itemGapSize),
        /* assert(
            dragHandleBuilder == null ||
                dragHandlePlacement != DragHandlePlacement.none,
            'Error: dragHandleBuilder property requires a valid dragHandlePlacement value'),*/
        reorderable = true;

  // ScrollView Specific Properties
  /// The direction in which the list scrolls.
  final Axis scrollDirection;

  /// Whether the list scrolls in the reading direction.
  final bool reverse;

  /// An object that can be used to control the position to which this scroll view is scrolled.
  final ScrollController? scrollController;

  /// Whether this is the primary scroll view associated with the parent [PrimaryScrollController].
  final bool? primary;

  /// How the scroll view should respond to user input.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view in the scrollDirection should be determined by the contents being viewed.
  final bool shrinkWrap;

  /// The amount of space by which to inset the children.
  final EdgeInsets? padding;

  /// The amount of space by which to extend the scrollable area in the main axis.
  final double? cacheExtent;

  /// How the scroll view should behave during a drag.
  final DragStartBehavior dragStartBehavior;

  /// The behavior to use when a keyboard is displayed.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// A string that identifies the semantic scroll scope of this scroll view.
  final String? restorationId;

  /// How to clip the scroll view's contents.
  final Clip clipBehavior;

  // ReorderableListView
  /// If true, the list of tiles can be reordered by dragging and dropping.
  final bool reorderable;

  /// A callback that determines whether an item can be reordered.
  /// If the callback returns true, the item can be reordered; otherwise, it cannot.
  final CanReorderCallback? canReorder;

  /// Called when the user finishes reordering the list.
  final ReorderCallback? onReorder;

  /// Called when the user starts reordering an item.
  final void Function(int index)? onReorderStart;

  /// Called when the user stops reordering an item.
  final void Function(int index)? onReorderEnd;

  /// A builder that can be used to customize the appearance of the proxy item that is displayed while reordering.
  final ReorderItemProxyDecorator? proxyDecorator;

  /// Whether to build default drag handles for the reorderable items.
  final bool enableDefaultDragHandles;

  /// Whether to use delayed drag start after a long press event.
  final bool useDelayedDrag;

  /// The placement of the drag handle.
  final DragHandlePlacement dragHandlePlacement;

  /// The alignment of the drag handle.
  final DragHandleAlignment dragHandleAlignment;

  /// A builder that can be used to customize the appearance of the drag handle.
  final NullableIndexedWidgetBuilder? dragHandleBuilder;

  /// The anchor value for the auto scroller.
  /// Determines the relative position of the zero scroll offset within the viewport
  /// 0.0: Aligns the zero scroll offset to the top of the viewport.
  /// 1.0: Aligns the zero scroll offset to the bottom of the viewport.
  /// 0.5: Centers the zero scroll offset in the middle of the viewport.
  final double anchor;

  /// The scalar value for the auto scroller velocity.
  /// Enables you to adjust the speed of the auto-scroll behavior during drag-and-drop operations.
  /// By modifying this value, you can control how fast the list scrolls when the dragged item approaches the top or bottom of the list.
  final double? autoScrollerVelocityScalar;

  // ExpansionTileList Specific Properties
  /// The list of [ExpansionTile]s that are managed by this widget.
  final List<ExpansionTile> children;

  /// The type of expansion: at most one, exactly one, or any number of tiles can be expanded at a time.
  final ExpansionMode expansionMode;

  /// Called whenever a tile is expanded or collapsed.
  final ExpansionTileCallback? onExpansionChanged;

  /// The size of the gap between the tiles in the list.
  final double itemGapSize;

  /// A builder that can be used to customize the appearance of the tiles.
  final ValueWidgetBuilder<int>? itemBuilder;

  /// A builder that can be used to customize the appearance of the separator between the tiles.
  final NullableIndexedWidgetBuilder? separatorBuilder;

  /// The alignment of the separator widget relative to the itemGap.
  final Alignment separatorAlignment;

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
  /// The custom builder can be used to create animations that depend on the index and value of the tiles.
  final ExpansionTileListAnimation? trailingAnimation;

  /// The indexes of the tiles that are initially expanded.
  /// The behavior depends on the expansion type:
  /// For multiple values: [ExpansionMode.any] , [ExpansionMode.atLeastOne].
  /// For single values: [ExpansionMode.exactlyOne] , [ExpansionMode.atMostOne].
  final List<int> initialExpandedIndexes;

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// This method is called immediately after the widget is inserted in the tree
  /// and must return a separate [State] object for each instance of this widget.
  /// In this case, it returns an instance of [_ExpansionTileListState].
  @override
  State<ExpansionTileList> createState() =>
      _ExpansionTileListState<ExpansionTileList>();

  /// Creates a copy of this [ExpansionTileList] but with the given fields replaced with the new values.
  /// If the original [ExpansionTileList] has a [key], the newly created [ExpansionTileList] will also have the same key.
  ExpansionTileList copyWith({
    Key? key,
    List<ExpansionTile>? children,
    ExpansionMode? expansionMode,
    List<int>? initialExpandedIndexes,
    ExpansionTileCallback? onExpansionChanged,
    double? itemGapSize,
    Widget? trailing,
    ExpansionTileListAnimation? trailingAnimation,
    bool? enableTrailingAnimation,
    ValueWidgetBuilder<int>? itemBuilder,
    NullableIndexedWidgetBuilder? separatorBuilder,
    Alignment? separatorAlignment,
    ExpansionTileListController? controller,
    // ScrollView Specific Properties
    Axis? scrollDirection,
    bool? reverse,
    ScrollController? scrollController,
    bool? primary,
    ScrollPhysics? physics,
    bool? shrinkWrap,
    EdgeInsets? padding,
    double? cacheExtent,
    DragStartBehavior? dragStartBehavior,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
    String? restorationId,
    Clip? clipBehavior,
    // OrderableListView Specific Properties
    CanReorderCallback? canReorder,
    ReorderCallback? onReorder,
    void Function(int index)? onReorderStart,
    void Function(int index)? onReorderEnd,
    ReorderItemProxyDecorator? proxyDecorator,
    bool? enableDefaultDragHandles,
    DragHandlePlacement? dragHandlePlacement,
    DragHandleAlignment? dragHandleAlignment,
    NullableIndexedWidgetBuilder? dragHandleBuilder,
    bool? useDelayedDrag,
    double? anchor,
    double? autoScrollerVelocityScalar,
  }) {
    if (reorderable) {
      return ExpansionTileList.reorderable(
        key: key ?? this.key,
        expansionMode: expansionMode ?? this.expansionMode,
        initialExpandedIndexes:
            initialExpandedIndexes ?? this.initialExpandedIndexes,
        onExpansionChanged: onExpansionChanged ?? this.onExpansionChanged,
        itemGapSize: itemGapSize ?? this.itemGapSize,
        trailing: trailing ?? this.trailing,
        trailingAnimation: trailingAnimation ?? this.trailingAnimation,
        enableTrailingAnimation:
            enableTrailingAnimation ?? this.enableTrailingAnimation,
        itemBuilder: itemBuilder ?? this.itemBuilder,
        separatorBuilder: separatorBuilder ?? this.separatorBuilder,
        separatorAlignment: separatorAlignment ?? this.separatorAlignment,
        controller: controller ?? this.controller,
        // ScrollView Specific Properties
        scrollDirection: scrollDirection ?? this.scrollDirection,
        reverse: reverse ?? this.reverse,
        scrollController: scrollController ?? this.scrollController,
        primary: primary ?? this.primary,
        physics: physics ?? this.physics,
        shrinkWrap: shrinkWrap ?? this.shrinkWrap,
        padding: padding ?? this.padding,
        cacheExtent: cacheExtent ?? this.cacheExtent,
        dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
        keyboardDismissBehavior:
            keyboardDismissBehavior ?? this.keyboardDismissBehavior,
        restorationId: restorationId ?? this.restorationId,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        // OrderableListView Specific Properties
        canReorder: canReorder ?? this.canReorder,
        onReorder: onReorder ?? this.onReorder,
        onReorderStart: onReorderStart ?? this.onReorderStart,
        onReorderEnd: onReorderEnd ?? this.onReorderEnd,
        proxyDecorator: proxyDecorator ?? this.proxyDecorator,
        enableDefaultDragHandles:
            enableDefaultDragHandles ?? this.enableDefaultDragHandles,
        useDelayedDrag: useDelayedDrag ?? this.useDelayedDrag,
        dragHandlePlacement: dragHandlePlacement ?? this.dragHandlePlacement,
        dragHandleAlignment: dragHandleAlignment ?? this.dragHandleAlignment,
        dragHandleBuilder: dragHandleBuilder ?? this.dragHandleBuilder,
        anchor: anchor ?? this.anchor,
        autoScrollerVelocityScalar:
            autoScrollerVelocityScalar ?? this.autoScrollerVelocityScalar,
        //
        children: children ?? this.children,
      );
    }
    return ExpansionTileList(
      key: key ?? this.key,
      expansionMode: expansionMode ?? this.expansionMode,
      initialExpandedIndexes:
          initialExpandedIndexes ?? this.initialExpandedIndexes,
      onExpansionChanged: onExpansionChanged ?? this.onExpansionChanged,
      itemGapSize: itemGapSize ?? this.itemGapSize,
      trailing: trailing ?? this.trailing,
      trailingAnimation: trailingAnimation ?? this.trailingAnimation,
      enableTrailingAnimation:
          enableTrailingAnimation ?? this.enableTrailingAnimation,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      separatorBuilder: separatorBuilder ?? this.separatorBuilder,
      separatorAlignment: separatorAlignment ?? this.separatorAlignment,
      controller: controller ?? this.controller,
      // ScrollView Specific Properties
      scrollDirection: scrollDirection ?? this.scrollDirection,
      reverse: reverse ?? this.reverse,
      scrollController: scrollController ?? this.scrollController,
      primary: primary ?? this.primary,
      physics: physics ?? this.physics,
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
      padding: padding ?? this.padding,
      cacheExtent: cacheExtent ?? this.cacheExtent,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      keyboardDismissBehavior:
          keyboardDismissBehavior ?? this.keyboardDismissBehavior,
      restorationId: restorationId ?? this.restorationId,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      //
      children: children ?? this.children,
    );
  }
}

// [_ExpansionTileListState] is the [State] object for the [ExpansionTileList] widget.
///
/// This class manages the stateful properties for the [ExpansionTileList] widget.
/// It maintains the state of the expansion tiles in the list, such as which tiles are expanded.
///
/// This class is private to the library as it starts with an underscore.
class _ExpansionTileListState<T extends ExpansionTileList> extends State<T> {
  late ExpansionTileListController _listController;
  final List<ExpansionTileItemController> _itemControllers = [];
  final Set<int> _initialExpandedIndexes = {};
  final List<int> _positions = [];
  late final int id;

  @override
  void initState() {
    super.initState();
    id = Random(widget.children.length).nextInt(1000000000);
    _initPositions();
    _updateListController();
    _updateExpandedIndexes();
    _updateTileControllers();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateListController(oldWidget.controller);
    }
    if (widget.children != oldWidget.children ||
        listEquals(widget.children, oldWidget.children)) {
      _initPositions(oldWidget.children);
      _updateTileControllers(oldWidget.children);
    }
    if (widget.expansionMode != oldWidget.expansionMode ||
        !listEquals(
            widget.initialExpandedIndexes, oldWidget.initialExpandedIndexes) ||
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

  void _initPositions([List<Widget>? oldChildren]) {
    if (oldChildren != null &&
        oldChildren.length == widget.children.length &&
        _positions.length == widget.children.length) {
      return;
    }
    _positions
      ..clear()
      ..addAll(List.generate(widget.children.length, (index) => index));
  }

  void _updateListController([ExpansionTileListController? oldController]) {
    oldController?._state = null;
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
    if (widget.reorderable) {
      return _buildReorderableList(context);
    } else {
      return _buildList(context);
    }
  }

  Widget _buildList(BuildContext context) {
    if (widget.separatorBuilder != null || widget.itemGapSize > 0.0) {
      return ListView.separated(
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return _buildChild(context, index,
              key: PageStorageKey(".item.$id.$index"),
              renderSeparatorGap: false);
        },
        separatorBuilder: (context, index) {
          return _buildSeparatorGap(context, index);
        },
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        controller: widget.scrollController,
        primary: widget.primary,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        padding: widget.padding,
        cacheExtent: widget.cacheExtent,
        dragStartBehavior: widget.dragStartBehavior,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        restorationId: widget.restorationId,
        clipBehavior: widget.clipBehavior,
      );
    }
    return ListView.builder(
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return _buildChild(context, index,
            key: PageStorageKey(".item.$id.$index"));
      },
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.scrollController,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      cacheExtent: widget.cacheExtent,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
    );
  }

  Widget _buildReorderableList(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return (widget.enableDefaultDragHandles &&
                widget.dragHandlePlacement == DragHandlePlacement.none)
            ? _buildDefaultDragHandle(
                context, index, _buildChild(context, index))
            : _buildChild(context, index,
                key: PageStorageKey(".item.$id.$index"));
      },
      onReorder: (int oldIndex, int newIndex) {
        if (widget.canReorder?.call(oldIndex, newIndex) ?? true) {
          setState(() {
            var orderIndex = _positions.removeAt(oldIndex);
            _positions.insert(
                oldIndex < newIndex ? newIndex - 1 : newIndex, orderIndex);
            widget.onReorder?.call(oldIndex, newIndex);
          });
        }
      },
      proxyDecorator:
          (widget.itemGapSize > 0.0 || widget.separatorBuilder != null)
              ? (child, index, animation) {
                  child = _findProxyItem(child) ?? child;
                  return (widget.proxyDecorator ?? _proxyDecorator)
                      .call(child, index, animation);
                }
              : widget.proxyDecorator,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      scrollController: widget.scrollController,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      cacheExtent: widget.cacheExtent,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
      //
      buildDefaultDragHandles: false,
      onReorderStart: widget.onReorderStart,
      onReorderEnd: widget.onReorderEnd,
      anchor: widget.anchor,
      autoScrollerVelocityScalar: widget.autoScrollerVelocityScalar,
    );
  }

  Widget _buildChild(BuildContext context, int index,
      {Key? key, bool renderSeparatorGap = true}) {
    return Column(
      key: key,
      children: <Widget>[
        widget.itemBuilder?.call(
                context, index, _buildExpansionTileItem(context, index)) ??
            _buildExpansionTileItem(context, index),
        if (renderSeparatorGap &&
            index < widget.children.length - 1 &&
            (widget.itemGapSize > 0.0 || widget.separatorBuilder != null))
          _buildSeparatorGap(context, index),
      ],
    );
  }

  Widget _buildSeparatorGap(BuildContext context, int index) {
    if (widget.separatorBuilder == null) {
      return widget.itemGapSize > 0.0
          ? SizedBox(height: widget.itemGapSize)
          : const SizedBox();
    }
    var padding = EdgeInsets.zero;
    if (widget.itemGapSize > 0.0) {
      padding = widget.separatorAlignment.y < 0.0
          ? EdgeInsets.only(top: widget.itemGapSize)
          : (widget.separatorAlignment.y > 0.0
              ? EdgeInsets.only(bottom: widget.itemGapSize)
              : EdgeInsets.symmetric(vertical: widget.itemGapSize));
    }
    return Container(
      alignment: widget.separatorAlignment,
      padding: padding,
      child: widget.separatorBuilder?.call(context, index),
    );
  }

  Widget? _buildDragHandle(BuildContext context, int index, Widget? child) {
    var dragHandle = widget.dragHandleBuilder?.call(context, index);

    if (dragHandle != null) {
      dragHandle = Container(
        alignment: widget.dragHandleAlignment.alignment,
        child: widget.enableDefaultDragHandles
            ? _buildDefaultDragHandle(context, index, dragHandle)
            : dragHandle,
      );
      return child != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: widget.dragHandleAlignment.isLeft
                  ? [dragHandle, child]
                  : [child, dragHandle],
            )
          : dragHandle;
    }
    return (widget.enableDefaultDragHandles && child != null)
        ? _buildDefaultDragHandle(context, index, child)
        : child;
  }

  Widget _buildDefaultDragHandle(
      BuildContext context, int index, Widget child) {
    return widget.useDelayedDrag
        ? ReorderableDelayedDragStartListener(
            key: ValueKey(".delayed_drag_handle.$id.$index"),
            index: index,
            child: child,
          )
        : ReorderableDragStartListener(
            key: ValueKey(".drag_handle.$id.$index"),
            index: index,
            child: child,
          );
  }

  /// Builds an [ExpansionTileItem] for a given index in the list of children.
  ///
  /// This method creates an [ExpansionTileItem] using the child at the given index. It assigns a controller to the tile,
  /// sets its initial expanded state, and assigns a callback for when the tile's expansion state changes.
  ///
  /// The method also assigns a trailing widget to the tile. If the trailing animation is enabled, an [AnimatedBuilder]
  /// is used to create the trailing widget with an animation. If the trailing animation is not enabled, the trailing
  /// widget from the child at the given index is used.
  ///
  /// [index] is the index of the child in the list of children.
  ///
  ExpansionTileItem _buildExpansionTileItem(BuildContext context, int index) {
    final i = _positions[index];
    final expansionTile = widget.children[i];
    final expansionTileItem =
        expansionTile is ExpansionTileItem ? expansionTile : null;
    return ExpansionTileItem.from(
      expansionTile,
      controller: _itemControllers[i],
      initiallyExpanded: _initialExpandedIndexes.contains(i),
      onExpansionChanged: (isExpanded) =>
          _onExpansionChanged(index, isExpanded),
      title: widget.dragHandlePlacement == DragHandlePlacement.title
          ? _buildDragHandle(context, index, expansionTile.title)
          : null,
      leading: widget.dragHandlePlacement == DragHandlePlacement.leading
          ? _buildDragHandle(context, index,
              expansionTile.leading ?? const Icon(Icons.drag_handle))
          : null,
      trailing: widget.dragHandlePlacement == DragHandlePlacement.trailing
          ? _buildDragHandle(
              context,
              index,
              expansionTile.trailing ??
                  widget.trailing ??
                  const Icon(Icons.drag_handle))
          : expansionTile.trailing ?? widget.trailing,
      enableTrailingAnimation: expansionTileItem?.enableTrailingAnimation ??
          widget.enableTrailingAnimation,
      trailingAnimation: expansionTileItem?.trailingAnimation ??
          (widget.trailingAnimation != null
              ? _createExpansionTileItemAnimation(
                  widget.trailingAnimation!, index)
              : null),
    );
  }

  ExpansionTileItemAnimation _createExpansionTileItemAnimation(
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

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget? _findProxyItem(Widget? widget) {
    if (widget is SingleChildRenderObjectWidget) {
      return _findProxyItem(widget.child);
    }
    if (widget is KeyedSubtree) {
      return _findProxyItem(widget.child);
    }
    if (widget is ReorderableDragStartListener) {
      return _findProxyItem(widget.child);
    }
    if (widget is MultiChildRenderObjectWidget) {
      for (var c in widget.children) {
        var w = _findProxyItem(c);
        if (w != null) {
          return c;
        }
      }
    }
    if (widget is ExpansionTileItem) {
      return widget;
    }
    return null;
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
    var i = _positions[index];
    Future.microtask(() {
      return _updateExpansionMode(index, isExpanded);
    }).then(
      (mode) {
        if (mode != -1) {
          widget.children[i].onExpansionChanged?.call(isExpanded);
          widget.onExpansionChanged?.call(index, isExpanded);
        }
      },
    );
  }

  /// Updates the indexes of the tiles that are initially expanded.
  /// This method is called at [initState] and when the [initialExpandedIndexes] or [expansionMode] properties changes.
  /// It updates the list of indexes that are initially expanded based on the new property value.
  /// The combination of the [initialExpandedIndexes] and [initiallyExpanded] properties of tiles determines the initial expansion state of the tiles.
  /// If the combination is empty, no tiles are initially expanded for [ExpansionMode.atMostOne] and [ExpansionMode.any].
  /// If the combination is empty, the first tile is initially expanded for [ExpansionMode.exactlyOne] and [ExpansionMode.atLeastOne].
  void _updateExpandedIndexes() {
    var initialExpandedIndexes = {
      ...{...widget.initialExpandedIndexes}
          .where((index) => index >= 0 && index < widget.children.length),
      ...widget.children.indexed
          .where((value) => value.$2.initiallyExpanded)
          .map((value) => value.$1)
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
    final expandedIndexes = _itemControllers.indexed
        .where((value) => value.$2.mounted && value.$2.isExpanded)
        .map((value) => value.$1);
    if (expandedIndexes.isEmpty) {
      var index = _initialExpandedIndexes.isNotEmpty
          ? _initialExpandedIndexes.first
          : 0;
      _updateExpansionMode(index, true);
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
  /// @param index The index of the tile in the list.
  /// @param isExpanded The new expansion state of the tile.
  /// @return The index of the tile that was expanded or collapsed else -1 if the expansion mode rejects the expanded state.
  int _updateExpansionMode(int index, bool isExpanded) {
    index = _positions[index];

    switch (widget.expansionMode) {
      case ExpansionMode.atLeastOne:
        final hasExpansion = _itemControllers
            .any((controller) => controller.mounted && controller.isExpanded);
        if (!hasExpansion && !isExpanded) {
          _itemControllers[index].expand();
          index = -1;
        }
        break;
      case ExpansionMode.atMostOne:
        if (isExpanded) {
          for (int i = 0; i < _itemControllers.length; i++) {
            if (i != index && _itemControllers[i].mounted) {
              _itemControllers[i].collapse();
            }
          }
        }
        break;
      case ExpansionMode.exactlyOne:
        if (isExpanded) {
          _itemControllers.indexed
              .where((v) => v.$1 != index && v.$2.mounted)
              .forEach((v) {
            _itemControllers[v.$1].collapse();
          });
        } else {
          final hasExpansion = _itemControllers
              .any((controller) => controller.mounted && controller.isExpanded);
          if (!hasExpansion) {
            _itemControllers[index].expand();
            index = -1;
          }
        }
        break;
      case ExpansionMode.any:
        break;
    }
    return index;
  }

  /// Toggles the expansion state of all tiles in the list.
  ///
  /// If [expand] is true, all tiles are expanded.
  /// If [expand] is false, all tiles are collapsed.
  /// If [expand] is null, the expansion state of all tiles is reversed.
  void _toggleAll([bool? expand]) {
    final exp = expand ?? false;
    final len = _positions.length;
    for (int i = exp ? 0 : len - 1; exp ? i < len : i >= 0; exp ? i++ : i--) {
      final x = _positions[i];
      if (_itemControllers[x].mounted) {
        expand ?? !_itemControllers[x].isExpanded
            ? _itemControllers[x].expand()
            : _itemControllers[x].collapse();
      } else {
        dev.log("Warning: The controller is not mounted for index $i",
            name: "ExpansionTileList", level: 900);
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
    final controller = widget.children.length > index
        ? _itemControllers[_positions[index]]
        : null;
    if (controller != null && controller.mounted) {
      controller.isExpanded ? controller.collapse() : controller.expand();
    } else {
      dev.log(
          "Warning: The controller is not mounted or not found for index $index",
          name: "ExpansionTileList",
          level: 900);
    }
  }

  bool _isExpanded(index) {
    final controller = widget.children.length > index
        ? _itemControllers[_positions[index]]
        : null;
    if (controller != null && controller.mounted) {
      return controller.isExpanded;
    } else {
      dev.log(
          "Warning: The controller is not mounted or not found for index $index",
          name: "ExpansionTileList",
          level: 900);
      return false;
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

  /// A boolean value that determines whether the [ExpansionTileList] widget is mounted.
  bool get mounted => _state != null && _state!.mounted;

  /// Checks if the tile at the given index is expanded.
  ///
  /// This method returns `true` if the tile at the specified index is expanded, and `false` otherwise.
  /// It throws an assertion error if the controller is not ready
  ///
  /// [index] is the index of the tile in the `ExpansionTileList`.
  /// @return `true` if the tile is expanded, `false` otherwise.
  bool isExpanded(int index) {
    return _validate(index) && _state!._isExpanded(index);
  }

  /// Expands the tile at the given index.
  ///
  /// Returns `true` if the tile is expanded, `false` otherwise.
  /// Throws an assertion error if the controller is not ready.
  ///
  /// [index] is the index of the tile in the `ExpansionTileList`.
  void expand(int index) {
    if (!_validate(index)) {
      return;
    }
    if (!_state!._isExpanded(index)) {
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
    if (!_validate(index)) {
      return;
    }
    if (_state!._isExpanded(index)) {
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
    if (!_validate(index)) {
      return;
    }
    _state!._toggle(index);
  }

  /// Expands all the tiles in the `ExpansionTileList`.
  /// If the tiles are already expanded, this method has no effect.

  void expandAll() {
    if (!_validate()) {
      return;
    }
    _state!._toggleAll(true);
  }

  /// Collapses all the tiles in the `ExpansionTileList`.
  ///
  /// If the tiles are already collapsed, this method has no effect.
  void collapseAll() {
    if (!_validate()) {
      return;
    }
    _state!._toggleAll(false);
  }

  /// Returns the indexes of the tiles position in the list.
  /// Throws an assertion error if the controller is not ready.
  /// If reorderable is false, the indexes will be the same as the positions.
  /// If reorderable is true, the indexes will be the order of the tiles in the list.
  /// else the indexes will be the the same as the children in the list.
  /// @return A list of indexes of the tiles in the list.
  List<int> positions() {
    return _validate() ? [..._state!._positions] : [];
  }

  /// Returns the initial position(index) of the tile at the given current position(index).
  /// The initial position is the original position of the tile in the list.
  /// For example, A tile at the initial index 0 will be assigned a position 0,
  /// if the tile is moved to the position 2, the initial position of the tile at the position 2 will still be 0.
  /// Therefore, initial position is the position of the tile in the list before any reordering.
  /// This method is useful when you want to access the initial position of the tile
  /// @param currentPosition The current index of the tile in the list.
  /// @return The initial index of the tile in the list or -1 if the current position is out of bounds.
  int initialPosition(int currentPosition) {
    return _validate(currentPosition)
        ? _state!._positions[currentPosition]
        : -1;
  }

  /// Returns the current position(index) of the tile at the given initial position(index).
  /// The current position is the current position of the tile in the list.
  /// For example, A tile at the initial index 0 will be assigned a position 0,
  /// if the tile is moved to the position 2, the current position of the tile at the initial index 0 will be 2.
  /// Therefore, current position is the position of the tile in the list after reordering.
  /// This method is useful when you want to access the current position of the tile
  /// @param initialPosition The initial index of the tile in the list.
  /// @return The current index of the tile in the list or -1 if the initial position is out of bounds.
  int currentPosition(int initialPosition) {
    return _validate(initialPosition)
        ? _state!._positions.indexOf(initialPosition)
        : -1;
  }

  bool _validate([int? index, bool safeMode = false]) {
    assert(_state != null,
        "ExpansionTileListController is not attached to any ExpansionTileList widget");
    assert(
        index == null || (index >= 0 && index < _state!.widget.children.length),
        "ExpansionTileListController index out of bounds");

    if (_state == null) {
      dev.log(
          "Controller is not attached to any ExpansionTileList widget. (Possibly disposed or not yet initialized)",
          name: "ExpansionTileListController");
      return false;
    }
    if (index != null) {
      if (index < 0 || index >= _state!.widget.children.length) {
        dev.log("Index [$index] out of bounds",
            name: "ExpansionTileListController");
        if (!safeMode) {
          throw RangeError.range(
              index,
              0,
              _state!.widget.children.length - 1,
              "ExpansionTileListController"
              "Index [$index] out of bounds");
        }
        return false;
      }
      if (!_state!._itemControllers[_state!._positions[index]].mounted) {
        dev.log("ItemController is not mounted",
            name: "ExpansionTileListController");
        if (!safeMode) {
          StateError(
            "ItemController is not mounted, possibly because the widget has been disposed or not yet initialized",
          );
        }
        return false;
      }
    }
    return true;
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
