import 'package:flutter/material.dart';

/// An extension method for enhancing the functionality of [ExpansionTile].
///
/// This extension allows you to create a copy of an existing [ExpansionTile]
/// with specific modifications.
extension ExpansionTileExtension on ExpansionTile {
  /// Creates a new [ExpansionTile] by copying the properties from the original
  /// [ExpansionTile] and applying optional modifications.
  ///   If not provided, it uses the default style.
  ///
  /// Example usage:
  /// ```dart
  /// final modifiedTile = originalTile.copyWith(
  ///   title: Text('Custom Title'),
  ///   children: [Text('Custom Content')],
  /// );
  /// ```
  ExpansionTile copyWith({
    Key? key,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    ValueChanged<bool>? onExpansionChanged,
    List<Widget>? children,
    Widget? trailing,
    bool? initiallyExpanded,
    bool? maintainState,
    EdgeInsetsGeometry? tilePadding,
    Alignment? expandedAlignment,
    CrossAxisAlignment? expandedCrossAxisAlignment,
    EdgeInsetsGeometry? childrenPadding,
    Color? backgroundColor,
    Color? collapsedBackgroundColor,
    Color? textColor,
    Color? collapsedTextColor,
    Color? iconColor,
    Color? collapsedIconColor,
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
  }) {
    return ExpansionTile(
      key: key ?? this.key,
      leading: leading ?? this.leading,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      onExpansionChanged: onExpansionChanged ?? this.onExpansionChanged,
      trailing: trailing ?? this.trailing,
      initiallyExpanded: initiallyExpanded ?? this.initiallyExpanded,
      maintainState: maintainState ?? this.maintainState,
      tilePadding: tilePadding ?? this.tilePadding,
      expandedAlignment: expandedAlignment ?? this.expandedAlignment,
      expandedCrossAxisAlignment:
          expandedCrossAxisAlignment ?? this.expandedCrossAxisAlignment,
      childrenPadding: childrenPadding ?? this.childrenPadding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      collapsedBackgroundColor:
          collapsedBackgroundColor ?? this.collapsedBackgroundColor,
      textColor: textColor ?? this.textColor,
      collapsedTextColor: collapsedTextColor ?? this.collapsedTextColor,
      iconColor: iconColor ?? this.iconColor,
      collapsedIconColor: collapsedIconColor ?? this.collapsedIconColor,
      shape: shape ?? this.shape,
      collapsedShape: collapsedShape ?? this.collapsedShape,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      controlAffinity: controlAffinity ?? this.controlAffinity,
      controller: controller ?? this.controller,
      dense: dense ?? this.dense,
      visualDensity: visualDensity ?? this.visualDensity,
      minTileHeight: minTileHeight ?? this.minTileHeight,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      enabled: enabled ?? this.enabled,
      expansionAnimationStyle:
          expansionAnimationStyle ?? this.expansionAnimationStyle,
      children: children ?? this.children,
    );
  }
}
