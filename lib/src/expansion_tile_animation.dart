import 'package:flutter/material.dart';

/// This typedef represents a function that takes a [BuildContext] and a generic value of type [T], and returns a [Widget].
typedef ValueExpansionTileAnimation
    = ExpansionTileAnimation<double, ValueWidgetBuilder<double>>;

/// This typedef represents a function that takes a [BuildContext], an index, a generic value of type [T], and an optional child widget.
typedef IndexedValueExpansionTileAnimation
    = ExpansionTileAnimation<double, IndexedValueWidgetBuilder<double>>;

/// This typedef represents a function that takes a [BuildContext], an index, a generic value of type [T], and an optional child widget.
/// It returns a [Widget]. This function can be used to build widgets based on the index and value in a list or collection.
typedef IndexedValueWidgetBuilder<T> = Widget Function(
    BuildContext context, int index, T value, Widget? child);

/// This class represents an animation for an [ExpansionTile] widget.
/// It contains an [Animatable] object that represents the animation, a [Duration] object that represents the duration of the animation,
/// a [Curve] object that represents the curve of the animation, and a [BuilderFxn] function that builds the widget based on the animation value.
/// The [BuilderFxn] function takes a [BuildContext], a generic value of type [T], and an optional child widget, and returns a [Widget].
/// This class is used to animate the trailing widget of an [ExpansionTile] widget.
/// The [ExpansionTileAnimation] class is used to animate the trailing widget of an [ExpansionTile] widget.
@immutable
class ExpansionTileAnimation<T, BuilderFxn> {
  /// The animatable object to play the animation sequence.
  final Animatable<T> animate;

  /// The duration of the animation.
  final Duration? duration;

  /// The curve of the animation.
  final Curve? curve;

  /// The function that builds the widget based on the animation value.
  final BuilderFxn? builder;

  /// Creates an [ExpansionTileAnimation] object.
  /// The [animate] parameter is required and represents the animation.
  /// The [duration] parameter is optional and represents the duration of the animation.
  /// The [curve] parameter is optional and represents the curve of the animation.
  /// The [builder] parameter is required and represents the function that builds the widget based on the animation value.
  /// The [builder] function takes a [BuildContext], a generic value of type [T], and an optional child widget, and returns a [Widget].
  const ExpansionTileAnimation({
    required this.animate,
    this.duration,
    this.curve,
    required this.builder,
  });

  /// Creates an [ExpansionTileAnimation] object with a generic value of type [double].
  static ValueExpansionTileAnimation value(
      {required Animatable<double> animate,
      Duration? duration,
      Curve? curve,
      required ValueWidgetBuilder<double> builder}) {
    return ValueExpansionTileAnimation(
      animate: animate,
      duration: duration,
      curve: curve,
      builder: builder,
    );
  }

  /// Creates an [ExpansionTileAnimation] object with a generic value of type [double] for indexed range.
  static IndexedValueExpansionTileAnimation indexed(
      {required Animatable<double> animate,
      Duration? duration,
      Curve? curve,
      required IndexedValueWidgetBuilder<double> builder}) {
    return IndexedValueExpansionTileAnimation(
      animate: animate,
      duration: duration,
      curve: curve,
      builder: builder,
    );
  }
}
