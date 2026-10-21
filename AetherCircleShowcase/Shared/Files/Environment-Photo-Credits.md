# Environment photo and video credits

## Offline media policy

All Showcase images and movies are bundled in Shared/Files. The app does not
download media or convert video at startup. Each photo/media button uses a
different scene or photograph set; changing stereo packing is not a new scene.

## Side-by-side video — environment-stereo-sbs.mp4

- Apple's Rendering stereoscopic video with RealityKit sample:
  https://developer.apple.com/documentation/realitykit/rendering-stereoscopic-video-with-realitykit
- Archive: https://docs-assets.developer.apple.com/published/4bf2d74e8473/RenderingStereoscopicVideoWithRealityKit.zip
- Original: RealityKit-Playback-AVSampleBufferVideoRenderer/Resources/sample.mov.
- Genuine stereo hummingbird footage; resized to 1920 × 540 and transcoded to silent H.264.
- Permission notice retained in APPLE-STEREO-VIDEO-LICENSE.txt.
- The top/bottom button now uses the distinct dragon animation below, not this footage.

## Top/bottom video — environment-dragons-tb.mp4

- Source: A Perceptual Model for Disparity, SIGGRAPH 2011, Piotr Didyk,
  Tobias Ritschel, Elmar Eisemann, Karol Myszkowski and Hans-Peter Seidel.
- Publisher: Max-Planck-Institut Informatik.
- Source page: https://perception.mpi-inf.mpg.de/DisparityModel/backward-compatible.html
- Download: https://perception.mpi-inf.mpg.de/DisparityModel/backward-compatible/dragons/standard.avi
- This is the publisher's standard-stereo dragon animation, not the
  backward-compatible/disparity-altered comparison.
- Source packs the right eye first. Export swaps to left-above-right:
  ffmpeg -ss 8 -t 8 -i standard.avi -vf "stereo3d=sbsr:abl,scale=768:1536"
  -an -c:v libx264 -crf 23 -pix_fmt yuv420p -movflags +faststart environment-dragons-tb.mp4
- Eight seconds; 768 × 1536; silent H.264. Credit retained here.
- The source page does not specify a Creative Commons license; no CC or
  Apache license is asserted for this third-party media.

## Native MV-HEVC sample — environment-spatial-test.mov

- Creator/publisher: Mike Swanson.
- Source: https://blog.mikeswanson.com/spatial/
- Archive: https://www.mikeswanson.com/spatial/releases/spatial_0.6.2.zip
- Original: spatial_0.6.2/spatial_test.mov, bundled unchanged (82,344 bytes).
- The author provides this sample for experimentation. No separate
  Creative Commons or Apache license is asserted for the sample.
- Two-second native MV-HEVC stereo test card, 1920 × 1080 per eye,
  with distinct LEFT and RIGHT views. This is a format test, not scenic footage.
- Verified HEVC layers 0 and 1 and hvcC/lhvC/vexu/eyes/hfov metadata.
- Played directly through spatialVideoFile; no runtime encoding or cache registration.

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

To add your own camera images, export stitched equirectangular JPEG or PNG files. Native camera projects, unstitched dual-fisheye images, VR180, and video are not supported by the image360 cases. Native spatial HEIC uses the dedicated spatial-photo cases on supported platforms.

## environment-hahneberg-panorama.jpg

- Title: Blick vom Hahneberg Berlin Spandau
- Creator: Lordnikon
- Source: https://commons.wikimedia.org/wiki/File:Blick_vom_hahneberg_berlin_spandau.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/d/d0/Blick_vom_hahneberg_berlin_spandau.jpg
- License: released into the public domain by the creator (PD-self); see the source page's Licensing section.
- Changes: resized from 15775 x 1997 to 4096 x 519 and recompressed for Showcase.
- The source describes an approximately 270-degree stitched camera panorama. It is not a full-sphere 360 image and is not claimed to have been captured with a phone.
- Showcase button: `Panorama Auto`. The image is rendered once on a cylindrical arc, with its original aspect ratio preserved and dark surroundings outside the captured view.

Metadata demo update: Showcase adds GPano XMP crop-width/full-width values of 4096 / 5461 (approximately 270 degrees) to encode the source's approximately 270-degree coverage. These are demonstration metadata added by this project, not original camera metadata. `Panorama Auto` reads that angle. `Panorama Override` now uses a different campus photograph with an explicit 180-degree angle; the two buttons no longer share a photograph.

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

Only `Yosemite Files` uses the two photographs above. `Yosemite Images` and `Gallery 8` have separate CC0 photograph sets listed below. No photograph is shared between gallery buttons.

## Button-to-image mapping

Each photo environment button uses a separate photograph or photograph set. Repacking one photograph does not count as a new photograph.

| Button | Photograph(s) | Loading |
|---|---|---|
| File 360 Mono | Venice Sunset | Bundled file |
| File Stereo TB | SphericalStereo 01 | Bundled stereo top/bottom file |
| Image 360 Spruit Sunrise | Spruit Sunrise | Bundled JPEG registered at startup |
| Image 360 Kiara | Kiara 1 Dawn | Bundled data registered at startup; mono |
| Panorama Auto | Hahneberg | Bundled panorama with demonstration GPano metadata |
| Panorama Override | TUT campus | Bundled cylindrical panorama, explicit 180 degrees |
| Apple Spatial Photo | Apple's hummingbird stereo pair | Encoded and registered at startup |
| Yosemite Files | Half Dome; El Capitan | Two bundled files |
| Yosemite Images | Yosemite 01–02 below | Two different images registered at startup |
| Gallery 8 | Yosemite 03–10 below | Eight distinct bundled files |

The previous side-by-side packing of SphericalStereo 01 is no longer bundled or used: the registered-image button now demonstrates a different mono panorama. Both stereo layouts remain supported by AetherCircle. Existing Apple and DerMische samples retain their original licenses; all newly added photos are CC0.

Material buttons select three distinct texture images. Floor + Sky selects its floor texture from the remaining patterns, so it cannot repeat one of those three backdrop patterns in the same Environment page.

## environment-kiara-360.jpg

- Title: Kiara 1 Dawn
- Creator: Greg Zaal / Poly Haven
- Source: https://polyhaven.com/a/kiara_1_dawn
- Original: https://dl.polyhaven.org/file/ph-assets/HDRIs/extra/Tonemapped%20JPG/kiara_1_dawn.jpg
- License: CC0 1.0, https://creativecommons.org/publicdomain/zero/1.0/
- Changes: proportionally resized the 8192 × 4096 tonemapped JPEG to 2048 × 1024; recompressed as RGB JPEG without cropping.
- Format: mono 360 × 180-degree equirectangular; registered at startup for Image 360 Kiara.

## environment-spruit-sunrise-360.jpg — Image 360 Spruit Sunrise

- Title: Spruit Sunrise
- Creator: Greg Zaal / Poly Haven
- Source: https://polyhaven.com/a/spruit_sunrise
- Download: https://dl.polyhaven.org/file/ph-assets/HDRIs/extra/Tonemapped%20JPG/spruit_sunrise.jpg
- License: CC0 1.0, https://creativecommons.org/publicdomain/zero/1.0/
- Downloaded during development, resized from 8192 × 4096 to 2048 × 1024 and recompressed as RGB JPEG (quality 90). Bundled in Shared/Files and registered at startup. No app download or Venice fallback.

## environment-campus-panorama.jpg

- Title: TUTcampus_20230130_1630
- Creator: Bandai Namco Studios Inc.
- Source and CC0 statement: https://www.bandainamcostudios.com/projects/truehdri/library/tutcampus_20230130_1630
- Preview original: https://www.bandainamcostudios.com/upload/2024/11/TrueHDRI_TUTcampus_20230128_1630_L1000_Unclipped_sRGB.jpg
- License: CC0 1.0, https://creativecommons.org/publicdomain/zero/1.0/
- The source page and its preview URL use different date strings; the URL above is linked by that source page.
- Changes: reprojected the central 180 horizontal degrees of the equirectangular photograph into a 2048 × 512 cylindrical strip; vertical sampling uses latitude atan(height/radius). Converted/recompressed as RGB JPEG. No synthetic depth or scenery added.
- Panorama Override uses horizontalDegrees: 180 explicitly; this file contains no demonstration GPano angle metadata.

## Additional Yosemite photographs — CC0

All ten photographs below were taken by Wikimedia Commons contributor **Vulturesong** on 7 October 2022 and dedicated to the public domain under **CC0 1.0**: https://creativecommons.org/publicdomain/zero/1.0/. Each source file's image-license metadata was checked individually. Commons website text/metadata licensing is not being used as evidence of an image license.

The photos were downloaded at a reduced Wikimedia preview resolution and proportionally fitted within 1600 × 1600 pixels, then recompressed as RGB JPEG. No cropping, recoloring, or repeated photographs. Exact filenames and source links follow.

### environment-yosemite-01.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 001.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_001.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/5/54/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_001.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1280 × 960 pixels.
- Used only by: Yosemite Images (registered at startup).

### environment-yosemite-02.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 005.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_005.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/3/3d/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_005.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1280 × 960 pixels.
- Used only by: Yosemite Images (registered at startup).

### environment-yosemite-03.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 009.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_009.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/d/d7/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_009.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1280 × 960 pixels.
- Used only by: Gallery 8, slot 1.

### environment-yosemite-04.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 013.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_013.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/4/48/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_013.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1200 × 1600 pixels.
- Used only by: Gallery 8, slot 2.

### environment-yosemite-05.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 017.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_017.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/5/56/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_017.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1280 × 960 pixels.
- Used only by: Gallery 8, slot 3.

### environment-yosemite-06.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 021.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_021.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/c/cc/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_021.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1280 × 960 pixels.
- Used only by: Gallery 8, slot 4.

### environment-yosemite-07.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 069 - Upper Falls Trail.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_069_-_Upper_Falls_Trail.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/4/49/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_069_-_Upper_Falls_Trail.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1280 × 960 pixels.
- Used only by: Gallery 8, slot 5.

### environment-yosemite-08.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 103 - Upper Falls Trail.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_103_-_Upper_Falls_Trail.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/4/4f/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_103_-_Upper_Falls_Trail.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1280 × 960 pixels.
- Used only by: Gallery 8, slot 6.

### environment-yosemite-09.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 135 - Upper Falls Trail.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_135_-_Upper_Falls_Trail.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/4/4d/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_135_-_Upper_Falls_Trail.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1280 × 960 pixels.
- Used only by: Gallery 8, slot 7.

### environment-yosemite-10.jpg

- Title: Yosemite National Park - HCP - October 07, 2022 - 174.jpg
- Creator: Vulturesong
- Source and CC0 declaration: https://commons.wikimedia.org/wiki/File:Yosemite_National_Park_-_HCP_-_October_07,_2022_-_174.jpg
- Original image: https://upload.wikimedia.org/wikipedia/commons/c/c7/Yosemite_National_Park_-_HCP_-_October_07%2C_2022_-_174.jpg?utm_source=commons.wikimedia.org&utm_campaign=imageinfo&utm_content=original
- Packaged size: 1280 × 960 pixels.
- Used only by: Gallery 8, slot 8.

## environment-nasa-360.mp4 — Video 360 NASA

- Title: Experience NASA's Artemis II Moon Launch in 360°.
- Creator/credit: NASA. This demo is not endorsed by NASA.
- Original publisher: https://www.youtube.com/watch?v=9LFBFRH51Jo
- Source and public-domain declaration: https://commons.wikimedia.org/wiki/File:Experience_NASA%27s_Artemis_II_Moon_Launch_in_360%C2%B0_(20260402).webm
- License/status: public domain as a work of the United States federal government (NASA); the file page's PD-USGov-NASA declaration applies to the video, not merely Commons metadata.
- Changes: extracted seconds 10–26 of the source's 1080p VP9 derivative; proportionally resized from 1920 × 960 to 1280 × 640, converted to H.264 Main / YUV420P / 24 fps in an MP4 container, and removed audio. No cropping, reframing, artificial depth, or camera rotation added.
- Duration: 16 seconds. Format: mono equirectangular, complete 360 × 180-degree coverage (2:1).
- Bundled in Shared/Files; no internet connection or downloaded fallback needed. Plays on a user-centered globe and loops. The sample is intentionally silent. Other supported files may contain audio.
- NASA media guidelines: https://www.nasa.gov/nasa-brand-center/images-and-media/

## Sky Floor examples — four new CC0 images

Each Sky Floor button uses its own sky and ground image, separate from the other
photo and material demonstrations. Both skies retain their full 360 × 180-degree
coverage and wrap once; ground textures repeat once per meter. No images were
cropped, recolored, or generated. Only color/diffuse maps are included for these
two floor materials; relief and normal-map data are not bundled.

| Bundled file | Source title | Creator(s) | Preparation |
|---|---|---|---|
| environment-day-sky.jpg | Kloofendal 48d Partly Cloudy (Pure Sky) | Greg Zaal (original), Jarod Guest (sky edits) | Tonemapped 8192 × 4096 JPEG resized to 2048 × 1024 and recompressed |
| environment-sunset-sky.jpg | Qwantani Sunset (Pure Sky) | Greg Zaal (photography), Jarod Guest (processing) | Tonemapped 8192 × 4096 JPEG resized to 2048 × 1024 and recompressed |
| environment-grass-floor.jpg | Leafy Grass | Charlotte Baglioni | 1K diffuse map, 1024 × 1024, recompressed RGB JPEG |
| environment-sand-floor.jpg | Sand 03 | Charlotte Baglioni | 1K diffuse map, 1024 × 1024, recompressed RGB JPEG |

All four: **CC0 1.0 public-domain dedication**,
https://creativecommons.org/publicdomain/zero/1.0/.
Each source below states the CC0 license; Poly Haven's asset license is described
at https://polyhaven.com/license.

### Day sky
- Source: https://polyhaven.com/a/kloofendal_48d_partly_cloudy_puresky
- Original: https://dl.polyhaven.org/file/ph-assets/HDRIs/extra/Tonemapped%20JPG/kloofendal_48d_partly_cloudy_puresky.jpg
- Used only by Grass + Day Sky (Environment A).

### Sunset sky
- Source: https://polyhaven.com/a/qwantani_sunset_puresky
- Original: https://dl.polyhaven.org/file/ph-assets/HDRIs/extra/Tonemapped%20JPG/qwantani_sunset_puresky.jpg
- Used only by Sand + Sunset (Environment A).

### Grass ground
- Source: https://polyhaven.com/a/leafy_grass
- Download: https://dl.polyhaven.org/file/ph-assets/Textures/jpg/1k/leafy_grass/leafy_grass_diff_1k.jpg
- Used only by Grass + Day Sky (Environment A).

### Sand ground
- Source: https://polyhaven.com/a/sand_03
- Download: https://dl.polyhaven.org/file/ph-assets/Textures/jpg/1k/sand_03/sand_03_diff_1k.jpg
- Used only by Sand + Sunset (Environment A).

