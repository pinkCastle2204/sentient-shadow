# Godot-ready tiles

These PNGs are cleaned versions of the supplied tilesheet:
- labels and outer presentation frame are cropped away
- the surrounding dark canvas is transparent
- original artwork scale is preserved

## Godot 4 recommended setup

1. Copy the PNGs into your Godot project's `assets/tiles/` folder.
2. Import them as normal PNG textures.
3. Create a `TileMapLayer` (Godot 4.3+) and create a new `TileSet`.
4. Add an **Atlas** TileSet source and select `terrain_tiles.png` first.
5. Use the atlas grid to define the individual pieces.
6. For this artwork, start with a **16x16 or 32x32** atlas grid and adjust the separation/region selection to the artwork. The source sheet contains both modular panels and larger decorative pieces, so do not force every object into one tile size.
7. Put furniture, terminals, specimen pods, and boss-room pieces in separate TileSet atlas sources.

### Important
The source artwork is not a strict uniformly-sized pixel tilemap. It contains modular wall/floor panels of different sizes. The cleaned sheets therefore preserve the original geometry rather than distorting/resizing it.

For actual level construction, use `terrain_tiles.png` as the main environment atlas and the other sheets as secondary/decorative atlases.
