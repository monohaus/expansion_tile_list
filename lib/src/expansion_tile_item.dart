import 'dart:developer' as dev;
import 'dart:math';

import 'package:expansion_tile_list/src/expansion_tile_extension.dart';
import 'package:flutter/material.dart';

import 'expansion_tile_animation.dart';

/// This typedef represents a function that takes a [BuildContext] and a generic value of type [T], and returns a [Widget].
typedef ExpansionTileItemAnimation = ValueExpansionTileAnimation;

/// [ExpansionTileItem] is a custom [ExpansionTile] widget that allows you to animate the trailing widget of the tile.
/// The widget provides an [trailingAnimation] property that allows you to animate the trailing widget of the tile.
/// The [trailingAnimation] property is an [ExpansionTileAnimation] object that defines the animation behaviour and builder for the trailing widget.
/// The [enableTrailingAnimation] property is a boolean value that determines whether the trailing widget should be animated.
/// If [enableTrailingAnimation] is true, the trailing widget is animated using the [trailingAnimation] property.
/// If [enableTrailingAnimation] is false, the trailing widget is not animated.
class ExpansionTileItem extends ExpansionTile {
  /// Creates an [ExpansionTileItem] widget.
  const ExpansionTileItem({
    super.key,
    required super.title,
    super.subtitle,
    super.children = const <Widget>[],
    super.leading,
    super.trailing,
    super.initiallyExpanded = false,
    super.onExpansionChanged,
    super.backgroundColor,
    super.collapsedBackgroundColor,
    super.textColor,
    super.collapsedTextColor,
    super.iconColor,
    super.collapsedIconColor,
    super.tilePadding,
    super.childrenPadding,
    super.expandedCrossAxisAlignment = CrossAxisAlignment.center,
    super.expandedAlignment = Alignment.center,
    super.maintainState = false,
    super.shape,
    super.collapsedShape,
    super.clipBehavior,
    super.controlAffinity,
    super.controller,
    super.dense,
    super.visualDensity,
    //super.minTileHeight,
    super.enableFeedback,
    super.enabled,
    super.expansionAnimationStyle,
    //
    this.trailingAnimation,
    this.enableTrailingAnimation = true,
  });

  /// Creates an [ExpansionTileItem] from an [ExpansionTile] widget.
  /// The [ExpansionTileItem.from] constructor allows you to create an [ExpansionTileItem] widget from an existing [ExpansionTile] widget.
  /// The constructor takes an [ExpansionTile] widget as an argument and creates an [ExpansionTileItem] widget with the same properties.
  /// The [ExpansionTileItem.from] constructor is useful when you want to convert an existing [ExpansionTile] widget to an [ExpansionTileItem] widget.
  ExpansionTileItem.from(
    ExpansionTile expansionTile, {
    Key? key,
    Widget? title,
    Widget? subtitle,
    List<Widget>? children,
    Widget? leading,
    Widget? trailing,
    bool? initiallyExpanded,
    ValueChanged<bool>? onExpansionChanged,
    Color? backgroundColor,
    Color? collapsedBackgroundColor,
    Color? textColor,
    Color? collapsedTextColor,
    Color? iconColor,
    Color? collapsedIconColor,
    EdgeInsetsGeometry? tilePadding,
    EdgeInsetsGeometry? childrenPadding,
    CrossAxisAlignment? expandedCrossAxisAlignment,
    Alignment? expandedAlignment,
    bool? maintainState,
    ShapeBorder? shape,
    ShapeBorder? collapsedShape,
    Clip? clipBehavior,
    ListTileControlAffinity? controlAffinity,
    ExpansionTileController? controller,
    bool? dense,
    VisualDensity? visualDensity,
    double? minTileHeight,
    bool? enableFeedback,
    bool? enabled,
    AnimationStyle? expansionAnimationStyle,
    ExpansionTileItemAnimation? trailingAnimation,
    bool? enableTrailingAnimation,
  }) : this(
          key: key ?? expansionTile.key,
          title: title ?? expansionTile.title,
          subtitle: subtitle ?? expansionTile.subtitle,
          leading: leading ?? expansionTile.leading,
          trailing: trailing ?? expansionTile.trailing,
          initiallyExpanded:
              initiallyExpanded ?? expansionTile.initiallyExpanded,
          onExpansionChanged:
              onExpansionChanged ?? expansionTile.onExpansionChanged,
          backgroundColor: backgroundColor ?? expansionTile.backgroundColor,
          collapsedBackgroundColor: collapsedBackgroundColor ??
              expansionTile.collapsedBackgroundColor,
          textColor: textColor ?? expansionTile.textColor,
          collapsedTextColor:
              collapsedTextColor ?? expansionTile.collapsedTextColor,
          iconColor: iconColor ?? expansionTile.iconColor,
          collapsedIconColor:
              collapsedIconColor ?? expansionTile.collapsedIconColor,
          tilePadding: tilePadding ?? expansionTile.tilePadding,
          childrenPadding: childrenPadding ?? expansionTile.childrenPadding,
          expandedCrossAxisAlignment: expandedCrossAxisAlignment ??
              expansionTile.expandedCrossAxisAlignment,
          expandedAlignment:
              expandedAlignment ?? expansionTile.expandedAlignment,
          maintainState: maintainState ?? expansionTile.maintainState,
          shape: shape ?? expansionTile.shape,
          collapsedShape: collapsedShape ?? expansionTile.collapsedShape,
          clipBehavior: clipBehavior ?? expansionTile.clipBehavior,
          controlAffinity: controlAffinity ?? expansionTile.controlAffinity,
          controller: controller ?? expansionTile.controller,
          dense: dense ?? expansionTile.dense,
          visualDensity: visualDensity ?? expansionTile.visualDensity,
          // minTileHeight: minTileHeight ?? expansionTile.minTileHeight,
          enableFeedback: enableFeedback ?? expansionTile.enableFeedback,
          enabled: enabled ?? expansionTile.enabled,
          expansionAnimationStyle:
              expansionAnimationStyle ?? expansionTile.expansionAnimationStyle,
          trailingAnimation: trailingAnimation ??
              (expansionTile is ExpansionTileItem
                  ? expansionTile.trailingAnimation
                  : null),
          enableTrailingAnimation: enableTrailingAnimation ??
              (expansionTile is ExpansionTileItem
                  ? expansionTile.enableTrailingAnimation
                  : null),
          children: children ?? expansionTile.children,
        );

  /// The animation for the trailing widget of the tile.
  final ExpansionTileItemAnimation? trailingAnimation;

  /// A boolean value that determines whether the trailing widget should be animated.
  final bool? enableTrailingAnimation;

  /// Creates the mutable state for this widget at a given location in the tree.
  @override
  State<ExpansionTileItem> createState() => _ExpansionTileItemState();

  /// Creates a copy of this [ExpansionTileItem] but with the given fields replaced with the new values.
  /// The [copyWith] method allows you to create a copy of the [ExpansionTileItem] widget with the given fields replaced with the new values.
  /// If the fields are null, the copy will use the original values.
  /// The method takes the following arguments:
  /// - [key] - An optional key for the widget.
  /// - [title] - The title of the tile.
  /// - [subtitle] - The subtitle of the tile.
  /// - [children] - The children of the tile.
  /// - [leading] - The leading widget of the tile.
  /// - [trailing] - The trailing widget of the tile.
  /// - [initiallyExpanded] - A boolean value that determines whether the tile is initially expanded.
  /// - [onExpansionChanged] - A callback that is called when the tile is expanded or collapsed.
  /// - [backgroundColor] - The background color of the tile.
  /// - [collapsedBackgroundColor] - The background color of the tile when collapsed.
  /// - [textColor] - The text color of the tile.
  /// - [collapsedTextColor] - The text color of the tile when collapsed.
  /// - [iconColor] - The icon color of the tile.
  /// - [collapsedIconColor] - The icon color of the tile when collapsed.
  /// - [tilePadding] - The padding of the tile.
  /// - [childrenPadding] - The padding of the children.
  /// - [expandedCrossAxisAlignment] - The cross axis alignment of the tile when expanded.
  /// - [expandedAlignment] - The alignment of the tile when expanded.
  /// - [maintainState] - A boolean value that determines whether the state of the tile is maintained when it is collapsed.
  /// - [shape] - The shape of the tile.
  /// - [collapsedShape] - The shape of the tile when collapsed.
  /// - [clipBehavior] - The clipping behavior of the tile.
  /// - [controlAffinity] - The control affinity of the tile.
  /// - [controller] - The controller of the tile.
  /// - [dense] - A boolean value that determines whether the tile is dense.
  /// - [visualDensity] - The visual density of the tile.
  /// - [enableFeedback] - A boolean value that determines whether the tile provides feedback.
  /// - [enabled] - A boolean value that determines whether the tile is enabled.
  /// - [expansionAnimationStyle] - The animation style of the tile.
  /// - [trailingAnimation] - The animation for the trailing widget of the tile.
  ExpansionTileItem copyWith({
    Key? key,
    Widget? title,
    Widget? subtitle,
    List<Widget>? children,
    Widget? leading,
    Widget? trailing,
    bool? initiallyExpanded,
    ValueChanged<bool>? onExpansionChanged,
    Color? backgroundColor,
    Color? collapsedBackgroundColor,
    Color? textColor,
    Color? collapsedTextColor,
    Color? iconColor,
    Color? collapsedIconColor,
    EdgeInsetsGeometry? tilePadding,
    EdgeInsetsGeometry? childrenPadding,
    CrossAxisAlignment? expandedCrossAxisAlignment,
    Alignment? expandedAlignment,
    bool? maintainState,
    ShapeBorder? shape,
    ShapeBorder? collapsedShape,
    Clip? clipBehavior,
    ListTileControlAffinity? controlAffinity,
    ExpansionTileController? controller,
    bool? dense,
    VisualDensity? visualDensity,
    bool? enableFeedback,
    bool? enabled,
    AnimationStyle? expansionAnimationStyle,
    ExpansionTileItemAnimation? trailingAnimation,
    bool? enableTrailingAnimation,
  }) {
    return ExpansionTileItem(
      key: key ?? this.key,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
      onExpansionChanged: onExpansionChanged ?? this.onExpansionChanged,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      collapsedBackgroundColor:
          collapsedBackgroundColor ?? this.collapsedBackgroundColor,
      textColor: textColor ?? this.textColor,
      collapsedTextColor: collapsedTextColor ?? this.collapsedTextColor,
      iconColor: iconColor ?? this.iconColor,
      collapsedIconColor: collapsedIconColor ?? this.collapsedIconColor,
      tilePadding: tilePadding ?? this.tilePadding,
      childrenPadding: childrenPadding ?? this.childrenPadding,
      expandedCrossAxisAlignment:
          expandedCrossAxisAlignment ?? this.expandedCrossAxisAlignment,
      expandedAlignment: expandedAlignment ?? this.expandedAlignment,
      maintainState: maintainState ?? this.maintainState,
      shape: shape ?? this.shape,
      collapsedShape: collapsedShape ?? this.collapsedShape,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      controlAffinity: controlAffinity ?? this.controlAffinity,
      controller: controller ?? this.controller,
      dense: dense ?? this.dense,
      visualDensity: visualDensity ?? this.visualDensity,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      enabled: enabled ?? this.enabled,
      expansionAnimationStyle:
          expansionAnimationStyle ?? this.expansionAnimationStyle,
      trailingAnimation: trailingAnimation ?? this.trailingAnimation,
      enableTrailingAnimation:
          enableTrailingAnimation ?? this.enableTrailingAnimation,
      children: children ?? this.children,
    );
  }
}

/// The state class for the [ExpansionTileItem] widget.
class _ExpansionTileItemState extends State<ExpansionTileItem>
    with SingleTickerProviderStateMixin {
  /*static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);*/
  static final Tween<double> _halfTween = Tween<double>(begin: 0.0, end: pi);

  late AnimationController _animationController;
  late Animation<double> _trailingAnimation;
  late ExpansionTileController _controller;
  late bool _isEnabled;
  late bool _isExpanded;
  late Key? _key;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.enabled;
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
        duration: widget.expansionAnimationStyle?.duration ?? Durations.short4,
        reverseDuration: widget.expansionAnimationStyle?.reverseDuration ??
            widget.expansionAnimationStyle?.duration ??
            Durations.short4,
        value: widget.initiallyExpanded ? _halfTween.end : _halfTween.begin,
        vsync: this);

    _updateTrailingAnimation();
    _updateExpansionTileItemController(true);
    _updateKey();
  }

  @override
  void didUpdateWidget(covariant ExpansionTileItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled) {
      _isEnabled = widget.enabled;
    }
    if (oldWidget.expansionAnimationStyle != widget.expansionAnimationStyle) {
      _updateAnimationStyle(ExpansionTileTheme.of(context));
    }
    if (oldWidget.trailingAnimation != widget.trailingAnimation) {
      _updateTrailingAnimation();
    }
    if (widget.controller != oldWidget.controller) {
      _updateExpansionTileItemController();
      _updateKey();
    } else if (widget.key != oldWidget.key) {
      _updateKey();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (widget.controller is ExpansionTileItemController &&
        (widget.controller as ExpansionTileItemController)._state == this) {
      (widget.controller as ExpansionTileItemController)._state = null;
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget as ExpansionTile).copyWith(
      key: _key,
      enabled: _isEnabled,
      controller: _controller,
      //initiallyExpanded: _isExpanded,
      trailing: widget.enableTrailingAnimation == true
          ? _buildTrailingAnimation(context)
          : widget.trailing,
      onExpansionChanged: (isExpanded) {
        _isExpanded = isExpanded;
        _updateExpansionChange(isExpanded);
        if (widget.onExpansionChanged != null) {
          widget.onExpansionChanged!(isExpanded);
        }
      },
    );
  }

  void _setState([VoidCallback? fn]) {
    super.setState(fn ?? () {});
  }

  void _updateKey() {
    _key = PageStorageKey(
        widget.key != null ? [widget.key, _controller] : _controller);
  }

  void _updateTrailingAnimation() {
    var curve = widget.trailingAnimation?.curve ?? Curves.easeIn;
    var animatable = (widget.trailingAnimation?.animate ?? _halfTween)
        .chain(CurveTween(curve: curve));
    var isTween = animatable is Tween<double>;
    if (isTween) {
      _animationController.value =
          (_isExpanded ? animatable.end : animatable.begin) ??
              _animationController.value;
    }
    _trailingAnimation = _animationController.drive(animatable);
    if (!isTween) {
      _updateExpansionChange(_isExpanded);
    }
  }

  void _updateExpansionTileItemController([bool init = false]) {
    if (widget.controller is ExpansionTileItemController) {
      if (init) {
        if ((widget.controller as ExpansionTileItemController)._state != null) {
          //("ExpansionTile controller already in use or this is an indicator that you should use a Global Key to manage widget state update rather than recreation");
        }
      }
      _controller = (widget.controller as ExpansionTileItemController
                .._state = this)
              .delegate ??
          ExpansionTileController();
    } else {
      _controller = widget.controller ?? ExpansionTileController();
    }
  }

  /// Updates the expansion state of the tile at the given [index].
  ///
  /// This method is called when the expansion state of a tile changes.
  /// If the tile is not expanded ([isExpanded] is false), this method returns early.
  /// If the [ExpansionTileList] is set to single expansion mode, it collapses all other tiles.
  ///
  /// [isExpanded] is the new expansion state of the tile.
  void _updateExpansionChange(bool isExpanded, {double? from}) {
    if (widget.enableTrailingAnimation == true) {
      isExpanded
          ? _animationController.forward(from: from)
          : _animationController.reverse(from: from);
    }
  }

  /// Updates the animation controller of the tile.
  /// This method updates the animation controller of the tile based on the theme.
  void _updateAnimationStyle(ExpansionTileThemeData theme) {
    if (widget.enableTrailingAnimation != true) {
      return;
    }
    _animationController.duration = widget.expansionAnimationStyle?.duration ??
        theme.expansionAnimationStyle?.duration ??
        _animationController.duration ??
        Durations.short4;
    //_updateExpansionChange(widget.initiallyExpanded);
    /* var tween = widget.trailingAnimation is Tween
        ? widget.trailingAnimation as Tween<double>
        : _halfTween;
    var value = (*/ /*_controller.isExpanded || */ /* widget.initiallyExpanded)
        ? tween.end
        : tween.begin;*/

    /* if (value != null && _animationController.value != value) {
      _animationController.value = value;
    }*/
  }

  /// Builds the trailing animation for the tile.
  /// This method builds the trailing animation for the tile based on the animation value.
  /// If the [trailingAnimation] property is not set, it returns the trailing widget.
  /// If the [trailingAnimation] property is set, it applies the animation to the trailing widget.
  /// The animation is applied using the [AnimatedBuilder] widget.
  /// The [AnimatedBuilder] widget listens to the animation and rebuilds the widget when the animation value changes.
  /// The [AnimatedBuilder] widget takes a [builder] function that builds the widget based on the animation value.
  /// The [builder] function takes a [BuildContext], a child widget, and the animation value, and returns a [Widget].
  /// The [builder] function is called every time the animation value changes.
  /// The [builder] function applies a rotation transformation to the child widget based on the animation value.
  Widget _buildTrailingAnimation(BuildContext context) {
    return AnimatedBuilder(
      animation: _trailingAnimation,
      builder: (context, child) {
        var value = _trailingAnimation.value;
        return widget.trailingAnimation?.builder?.call(context, value, child) ??
            Transform.rotate(
              angle: value,
              child: child,
            );
      },
      child: widget.trailing,
    );
  }
}

/// [ExpansionTileItemController] is a custom [ExpansionTileController] that allows you to control the expansion state of an [ExpansionTileItem] widget.
/// The [ExpansionTileItemController] class extends the [ExpansionTileController] class and provides additional methods to control the expansion state of an [ExpansionTileItem] widget.
/// The [ExpansionTileItemController] class provides methods to expand, collapse, toggle, refresh, disable, and enable the expansion state of an [ExpansionTileItem] widget.
class ExpansionTileItemController extends ExpansionTileController {
  /// Creates an [ExpansionTileItemController] instance.
  ExpansionTileItemController([this.delegate]);

  _ExpansionTileItemState? _state;

  /// The delegate controller of the [ExpansionTileItemController].
  final ExpansionTileController? delegate;

  ExpansionTileController? get _this => delegate ?? _state?._controller;

  /// A boolean value that determines whether the [ExpansionTileItem] widget is mounted.
  bool get mounted => _state != null && _state!.mounted;

  /// Expands the [ExpansionTileItem] widget.
  /// This method expands the [ExpansionTileItem] widget if it is not already expanded.
  /// @return true if the widget is expanded, false otherwise.
  /// @see [safeDebugMode] to suppress assertions when in [kDebugMode].
  @override
  bool get isExpanded {
    return _validate() && (_this?.isExpanded ?? super.isExpanded);
  }

  /// Collapses the [ExpansionTileItem] widget.
  /// This method collapses the [ExpansionTileItem] widget if it is not already collapsed.
  void toggle() {
    if (!_validate()) {
      return;
    }
    var controller = _this;
    if (controller != null) {
      controller.isExpanded ? controller.collapse() : controller.expand();
    } else {
      super.isExpanded ? super.collapse() : super.expand();
    }
  }

  /// Expands the [ExpansionTileItem] widget.
  /// This method expands the [ExpansionTileItem] widget if it is not already expanded.
  @override
  void expand() {
    if (!_validate()) {
      return;
    }
    _this != null ? _this!.expand() : super.expand();
  }

  /// Collapses the [ExpansionTileItem] widget.
  /// This method collapses the [ExpansionTileItem] widget if it is not already collapsed.
  @override
  void collapse() {
    if (!_validate()) {
      return;
    }
    _this != null ? _this!.collapse() : super.collapse();
  }

  /// Rebuild the [ExpansionTileItem] widget.
  /// This method rebuilds the [ExpansionTileItem] widget by calling the setState method.
  /// The [fn] parameter is an optional callback function that is called after the widget is rebuilt.
  void _refresh([VoidCallback? fn]) {
    if (!_validate()) {
      return;
    }
    _state?._setState(fn);
  }

  /// Disables the [ExpansionTileItem] widget.
  /// This method disables the [ExpansionTileItem] widget by setting the [isEnabled] property to false.
  /// The [fn] parameter is an optional callback function that is called after the widget is disabled.
  void disable([VoidCallback? fn]) {
    if (!_validate()) {
      return;
    }
    if (_state!._isEnabled) {
      _refresh(() {
        _state?._isEnabled = false;
        fn?.call();
      });
    }
  }

  /// Enables the [ExpansionTileItem] widget.
  /// This method enables the [ExpansionTileItem] widget by setting the [isEnabled] property to true.
  /// The [fn] parameter is an optional callback function that is called after the widget is enabled.
  void enable([VoidCallback? fn]) {
    if (!_validate()) {
      return;
    }
    if (!_state!._isEnabled) {
      _refresh(() {
        _state?._isEnabled = true;
        fn?.call();
      });
    }
  }

  /// A boolean value that determines whether the [ExpansionTileItem] widget is enabled.
  /// If the [isEnabled] property is true, the [ExpansionTileItem] widget is enabled.
  /// @return true if the widget is enabled, false otherwise.
  bool get isEnabled {
    return _validate() && _state!._isEnabled;
  }

  bool _validate() {
    assert(_state != null,
        "ExpansionTileItemController is not attached to any ExpansionTileItem widget");

    if (_state == null) {
      dev.log(
          "Controller is not attached to any ExpansionTileItem widget. (Possibly disposed or not yet initialized)",
          name: "ExpansionTileItemController");
      return false;
    }
    return true;
  }
}
