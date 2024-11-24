
### `List Features`

All the features affects all the tiles in the `ExpansionTileList`.

- `tileGapSize` allows you to specify the size of the gap between each tile in the `ExpansionTileList`.
- `trailing` allows you to specify the trailing widget for all tiles, can be overridden by`ExpansionTile`
  trailing property.
- `trailingAnimation` allows you to specify a custom animation for the trailing widget.
- `enableTrailingAnimation` allows you to enable or disable the trailing animation.
- `tileBuilder` allows the customization of the creation and appearance of the tiles in the `ExpansionTileList`.
- `separatorBuilder` allows the customization of the creation and appearance of the separators between the tiles in the
  `ExpansionTileList`.
- `initialExpandedIndexes`  allows you to specify the indexes of the tiles that are initially expanded.
- `controller` allows you to programmatically control the expansion of the tiles.
- `onExpansionChanged`  allows you to listen to the expansion changes of the tiles.
- ![new](https://img.shields.io/badge/new-brightgreen) `ExpansionMode` allows you to specify the expansion mode of the `ExpansionTileList`. This feature can be used only
  with named constructor.
    - `ExpansionMode.atMostOne` allows you to expand at most one tile at a time. (i.e zero or one )
    - `ExpansionMode.atLeastOne` ensures that at least one tile is always expanded  (i.e one or more )
    - `ExpansionMode.exactlyOne` allows you to expand exactly one tile at a time. (i.e one )
    - `ExpansionMode.any` allows you to expand any number of tiles. (i.e zero or more )

### `Item Features`

By default `ExpansionTileList` supports `ExpansionTile` widget as children to create tiles. But you can also use
`ExpansionTileItem` widget when more control is required. All the properties overrides the that of `ExpansionTileList`.

- `trailing`  allows you to specify the trailing widget for the tile.
- `trailingAnimation` allows you to specify a custom animation for the trailing widget.
- `enableTrailingAnimation` allows you to enable or disable the trailing animation.
