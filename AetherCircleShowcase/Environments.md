# Showcase environments

The Home menu splits the demos into two collapsible sections. Changing sections
keeps the current environment; only an environment button changes it.

| Section | Kinds |
|---|---|
| Environment A | Passthrough, solid colors, material patterns, Floor + Sky, Cyber Floors, rectangular/cylinder/dome rooms, photographic sky with ground, stars, snow, rain, fireflies |
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

## Particle fields

Four procedural presets share one configurable environment:

```swift
.particleField(.stars())
.particleField(.snow())
.particleField(.rain())
.particleField(.fireflies())
```

The matching shorthand values are `.particleStar`, `.particleSnow`,
`.particleRain`, and `.particleFireFlies`.

```swift
var snowfall = AetherParticleField.snow(count: 350)
snowfall.speed = 0.8
snowfall.drift = 0.4
snowfall.volume = .init(x: 30, y: 12, z: 30)
snowfall.material = .color(.white)
let environment = AetherEnvironmentMode.particleField(snowfall)
```

Settings include style, particle count (0–2000), size, volume, material,
direction, speed, drift, rotation speed, opacity, twinkle, background, optional
floor, placement, and deterministic seed. Spatial settings use meters and
motion uses seconds. Renderers normalize edited or decoded settings before use.
Materials are unlit and use their base color and optional base-color texture;
roughness and metallic do not affect particles.

Stars form a distant sphere that follows viewer translation without turning
with the head. Snow, rain and fireflies use world-fixed volumes: you can walk
among them. Particles recycle at distant volume boundaries and the optional
ground extends beyond a normal tracked play area. Snow uses six-arm flakes,
rain uses falling streaks, and fireflies drift and pulse. Particles have no
collisions or interaction targets. Changing environments clears the field.
Quest batches particles into at most fifteen opacity groups per eye.

All four examples appear in Showcase **Environment A**. Their geometry and
motion are generated in code; they require no downloaded images or credits.
After updating the development framework and Showcase, regenerate an existing
Quest project with `aethercircle quest create -d` to pick up the new native
bridge and rendering support.

## Circular rooms

```swift
.cylinderRoom(diameter: 7000, height: 3200,
              floor: .named("wood"), walls: .named("stone"), ceiling: .color(.white))
.domeRoom(diameter: 8000, height: 4000,
          floor: .named("marble"), dome: .color(.blue))
```

Both environments are world-fixed, with the circular floor centered at X/Z=0
and Y=0. Dimensions are millimeters. The cylinder has independent floor, wall,
and ceiling materials. The dome has a floor and a continuous half-ellipsoid
roof; setting height to half the diameter gives a hemisphere. You can move
inside either room using tracked movement. These visual surfaces do not impose
physical collision boundaries; stay within your headset's tracked play area.

Curved walls have smooth inward normals. Floor and ceiling are circular discs;
textures repeat approximately once per meter, with the wrap seam at negative Z.
`AetherCurvedRoom` exposes shared meshes and normalized dimensions for renderers.
Dimensions are bounded to 100–1,000,000 mm; nonfinite values use 6000 mm diameter
or 3000 mm height. There are no external assets required by either environment.

Showcase Environment A includes **Cylinder Room**, **Dome Room**, and the four
particle examples **Stars**, **Snow**, **Rain**, and **Fireflies**. The home menu
uses four items per column, forming two columns with Quit below the menu.
