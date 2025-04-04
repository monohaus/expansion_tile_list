## 0.0.1

- Expansion Tile List release

## 0.1.0

- Added `trailing` property which cascades to all the tiles
- Added `trailingAnimation` property which is a `Animatable<double>`
- Added `trailingAnimationBuilder` property to customize the trailing widget animation
- Added `trailingAnimationEnabled` property which enabled/disabled trailing animation is true by default

## 0.1.1

- Bug fix for initialExpandedIndex/initialExpandedIndexes `trailingAnimation` not working
- Added a better description for the package

## 1.0.0

- Renamed `trailingAnimationEnabled` to `enableTrailingAnimation`
- Renamed `builder` to `tileBuilder`
- Removed `ExpansionTileList.radio` in favor of `ExpansionMode.single` property
- Removed `trailingAnimationBuilder` property in favor of `trailingAnimation` property
- Allow `trailingAnimation` supports any `Animatable` type and not just `Tween<double>`.
- Added `separatorBuilder` property to customize the separator between the tiles
- Added `ExpansionMode` property to specify the expansion mode of the `ExpansionTileList`
- Added `ExpansionMode.single` named constructor to expand only one tile at a time.
- Added `ExpansionMode.multiple` named constructor to expand multiple tiles at a time.
- Added a new Widget `ExpansionTileItem` to customize the tile appearance for better flexibility when compared to
  `ExpansionTile`

## 1.0.1

- Documentation update
- Tested on minimum SDK version and updated the same in the pubspec.yaml
- Renamed typedef `IndexedExpansionTileAnimation` to `IndexedValueExpansionTileAnimation`

## 1.0.2

- Documentation update
- Fix dart format issues

## 1.1.0

- Deprecated `ExpansionTileList.single` in favor of `ExpansionMode.atMostOne` and `ExpansionMode.exactlyOne` property in
  `ExpansionTileList`.
- Deprecated `ExpansionTileList.multiple` in favor of `ExpansionMode.atLeastOne` and `Expansion.any` property in
  `ExpansionTileList`.
- New `ExpansionTileList.separator` constructor to customize the separator between the tiles using `separatorBuilder`
  property.
- Support for `scrollable` in `ExpansionTileList` to fix
  bottom [overflow issue](https://github.com/monohaus/expansion_tile_list/issues/1#issue-2896691899).
- Added multiple scrollable properties to `ExpansionTileList` to customize the scroll behavior.
- Support for `padding` in `ExpansionTileList` to add padding to the list.

## 2.0.0-rc.1

- Breaking changes
- Bug fix: ExpansionTileItemController methods are called when widget is not yet mounted/initialized when not in scroll
  viewport.
- `ExpansionMode.atLeastOne` and `ExpansionMode.exactlyOne` no longer disables the `ExpansionTile` to enforce the
  `ExpansionMode` behavior.
- Removed all the deprecated constructors and properties.
- Removed `ExpansionTileList.single`, `ExpansionTileList.multiple` and `ExpansionTileList.separator` named constructors.
- Removed `scrollable` property in favor a default support of scrolling in ExpansionTileList.
- Removed `itemExtent`, `itemExtendBuilder` and `prototypeItem` properties.
- Renamed `tileBuilder` to `itemBuilder`.
- Renamed `tileGapSize` to `itemGapSize`.
- Add separator customization using `separatorBuilder` property for reorderable list.
- Added a new `ExpansionTileList.reorderable` constructor to support item reordering functionality.
- Support for customizable drag handle in reorderable list using `dragHandleBuilder`, `dragHandlePlacement` and
  `dragHandleAlignment` properties.
- Support for callback functions in reorderable list when reordering.