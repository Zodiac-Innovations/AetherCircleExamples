# 360 environment photo credits

The bundled files ship with Showcase and work offline; the Internet 360 Mono button additionally downloads the original Venice image at startup. They are separate assets with the licenses below; the project source-code license does not replace their licenses.

## environment-venice-360.jpg

- Title: Venice Sunset
- Creator: Greg Zaal / Poly Haven
- Source: https://polyhaven.com/a/venice_sunset
- Download: https://dl.polyhaven.org/file/ph-assets/HDRIs/extra/Tonemapped%20JPG/venice_sunset.jpg
- License: CC0 1.0, https://creativecommons.org/publicdomain/zero/1.0/
- Changes: resized the tonemapped JPEG from 8192 x 4096 to 2048 x 1024 and recompressed for this demo.
- Format: monoscopic 360 x 180 degree equirectangular image (2:1).

## environment-stereo-360-tb.jpg

- Title: SphericalStereo 01
- Creator: DerMische
- Source: https://commons.wikimedia.org/wiki/File:SphericalStereo_01.jpg
- Download: https://upload.wikimedia.org/wikipedia/commons/8/8c/SphericalStereo_01.jpg
- License: Creative Commons Attribution-ShareAlike 4.0 International, https://creativecommons.org/licenses/by-sa/4.0/
- Changes: resized from 8192 x 8192 to 2048 x 2048 and recompressed for this demo. This adapted image remains CC BY-SA 4.0.
- Format: stereoscopic equirectangular top/bottom (left eye on top, right eye below). Each eye covers 360 x 180 degrees.
- This is a rendered Blender scene, selected to test binocular depth; it is not a camera photograph.

To add your own camera images, export stitched equirectangular JPEG or PNG files. Native camera projects, unstitched dual-fisheye images, VR180, spatial HEIC photos, and video are not supported by this still-image environment.

## environment-stereo-360-sbs.jpg

Derived from DerMische's SphericalStereo 01, credited above, under the same CC BY-SA 4.0 license: https://creativecommons.org/licenses/by-sa/4.0/.
The resized top/bottom image was split into its original left and right eye views, arranged side by side (4096 x 1024), and recompressed. No new depth was generated. This image is registered as encoded data at startup for the `Image Stereo SBS` button.

The `Internet 360 Mono` button downloads the original 8192 x 4096 Venice Sunset JPEG from the Poly Haven download URL above at startup and registers the returned data. It is disabled until that succeeds, with no embedded fallback. The same Greg Zaal / Poly Haven CC0 credit applies; this downloaded original is not resized by the app. The two `File` buttons and `Image Stereo SBS` remain offline examples.

## environment-hahneberg-panorama.jpg

- Title: Blick vom Hahneberg Berlin Spandau
- Creator: Lordnikon
- Source: https://commons.wikimedia.org/wiki/File:Blick_vom_hahneberg_berlin_spandau.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/d/d0/Blick_vom_hahneberg_berlin_spandau.jpg
- License: released into the public domain by the creator (PD-self); see the source page's Licensing section.
- Changes: resized from 15775 x 1997 to 4096 x 519 and recompressed for Showcase.
- The source describes an approximately 270-degree stitched camera panorama. It is not a full-sphere 360 image and is not claimed to have been captured with a phone.
- Showcase button: `Panorama 270`. The image is rendered once on a cylindrical arc, with its original aspect ratio preserved and dark surroundings outside the captured view.

Metadata demo update: Showcase adds GPano XMP crop-width/full-width values of 4096 / 5461 (approximately 270 degrees) to encode the source's approximately 270-degree coverage. These are demonstration metadata added by this project, not original camera metadata. `Panorama Auto` reads that angle; `Panorama Override` deliberately overrides it with 180 degrees for comparison.

## Apple spatial photo demo — environment-spatial-left.jpg / environment-spatial-right.jpg

- Source: Apple, Writing Spatial Photos sample, https://developer.apple.com/documentation/imageio/writing-spatial-photos
- Download: https://docs-assets.developer.apple.com/published/f576a7476465/WritingSpatialPhotos.zip
- Copyright © 2024 Apple Inc. Permission notice: APPLE-SPATIAL-SAMPLE-LICENSE.txt (included).
- Hummingbird_Left.png and Hummingbird_Right.png are rendered stereo images supplied by Apple, not iPhone camera photos.
- Changes: resized proportionally to at most 1280 pixels per dimension, converted to RGB JPEG, without cropping or swapping eyes.
- On visionOS 26+, Showcase encodes these into a native stereo HEIC at startup and registers it. Calibration follows Apple's sample: 64 mm baseline, 80-degree horizontal field of view, +2% disparity adjustment.
- `Apple Spatial Photo` is enabled after registration on supported AVP systems; disabled on Quest and earlier visionOS.

## Yosemite 2D gallery photographs

### environment-half-dome.jpg
- Title: Half-dome.jpg (Half Dome at Yosemite National Park).
- Photographer: Christoffer G. Thomsen (Cgtdk), 12 July 2009.
- Source: https://commons.wikimedia.org/wiki/File:Half-dome.jpg
- Original: https://upload.wikimedia.org/wikipedia/commons/e/e4/Half-dome.jpg
- Public domain dedication: CC0 1.0, https://creativecommons.org/publicdomain/zero/1.0/
- Changes: proportionally resized from 3456 × 2304 to 2048 × 1365 and recompressed as RGB JPEG. No cropping.

### environment-el-capitan.jpg
- Title: El Capitan, Yosemite NP.jpg.
- Photographer: Fenners, 1 July 2003.
- Source: https://commons.wikimedia.org/wiki/File:El_Capitan,_Yosemite_NP.jpg
- Original: https://upload.wikimedia.org/wikipedia/commons/6/64/El_Capitan%2C_Yosemite_NP.jpg
- Released into the public domain worldwide by the author; see source page's public-domain declaration.
- Changes: recompressed as RGB JPEG, retaining 1186 × 790 pixels. No cropping.

Showcase uses these two photographs for `Yosemite Files`, `Yosemite Images` (registered encoded data at startup), and `Gallery 8` (alternates the same two photos in all eight slots; no additional photographs implied).
