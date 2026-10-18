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
