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
- Added a new Widget `ExpansionTileItem` to customize the tile appearance for better flexibility when compared to `ExpansionTile`
