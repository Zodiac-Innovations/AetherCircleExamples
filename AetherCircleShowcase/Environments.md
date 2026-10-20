# Showcase environments

The Home menu splits the demos into two collapsible sections. Changing sections
keeps the current environment; only an environment button changes it.

| Section | Kinds |
|---|---|
| Environment A | Passthrough, solid colors, material patterns, Floor + Sky, Cyber Floors, Rooms, photographic sky with ground |
| Environment B | Bundled/registered/internet 360 photos, 360 video, panoramas, Apple spatial photo, Yosemite galleries |

Environment A includes two `skyFloor` examples:

- **Grass + Day Sky:** Leafy Grass ground beneath Kloofendal's partly cloudy sky.
- **Sand + Sunset:** Sand 03 ground beneath Qwantani's sunset sky.

Both provide world-fixed ground at y=0, with textures repeating once per meter
and a 2048-meter floor. The sky has no translation parallax and wraps once around
the user, without turning with the head. Walk across the ground and look freely
in any direction. This differs from a 360 photo globe, whose photographed ground
remains part of the user-centered image.

```swift
world.environmentEngine.mode = .skyFloor(
    skyFile: "environment-day-sky.jpg",
    floor: .texture(baseColorTexture: "environment-grass-floor.jpg", roughness: 0.95)
)
```

All four new images are bundled and CC0. See
[Environment photo and video credits](Shared/Files/Environment-Photo-Credits.md)
for creators, source links, and preparation details.

Home automation identifiers remain stable: `showcase.environment` opens
Environment A, while `showcase.environment-b` opens Environment B. Existing
per-demo `showcase.environment.*` identifiers remain unchanged. Both pages retain
Home/navigation and the arrangement's minimize/restore controls.
