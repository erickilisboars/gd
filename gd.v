@[translated]
module gd

$if windows {
    #flag -l gd
    #include <gd.h>
} $else {
    $if $pkgconfig('gd') {
        #pkgconfig gd
        #include <gd.h>
    } $else {
        #flag -l gd
        #include <gd.h>
    }
}

//
//  Group: Types
//
//  typedef: gdIOCtx
//
//  gdIOCtx structures hold function pointers for doing image IO.
//
//  Most of the gd functions that read and write files, such as
//  <gdImagePng> also have variants that accept a <gdIOCtx> structure;
//  see <gdImagePngCtx> and <gdImageCreateFromJpegCtx>.
//
//  Those who wish to provide their own custom routines to read and
//  write images can populate a gdIOCtx structure with functions of
//  their own devising to to read and write data. For image reading, the
//  only mandatory functions are getC and getBuf, which must return the
//  number of characters actually read, or a negative value on error or
//  EOF. These functions must read the number of characters requested
//  unless at the end of the file.
//
//  For image writing, the only mandatory functions are putC and putBuf,
//  which return the number of characters written; these functions must
//  write the number of characters requested except in the event of an
//  error. The seek and tell functions are only required in conjunction
//  with the gd2 file format, which supports quick loading of partial
//  images. The gd_free function will not be invoked when calling the
//  standard Ctx functions; it is an implementation convenience when
//  adding new data types to gd. For examples, see gd_png.c, gd_gd2.c,
//  gd_jpeg.c, etc., all of which rely on gdIOCtx to implement the
//  standard image read and write functions.
//
//  > typedef struct gdIOCtx
//  > {
//  >   int (*etC)(gdIOCtxPtr);
//  >   int (*etBuf)(gdIOCtxPtr, void * int wanted);
//  >
//  >   void (*utC)(gdIOCtxPtr, int);
//  >   int (*utBuf)(gdIOCtxPtr, const void * int wanted);
//  >
//  >   // seek must return 1 on SUCCESS, 0 on FAILURE. Unlike fseek!
//  >   int (*eek)(gdIOCtxPtr, const int);
//  >   long (*ell)(gdIOCtxPtr);
//  >
//  >   void (*d_free)(gdIOCtxPtr);
//  > } gdIOCtx;
//
type GdIOCtxPtr = voidptr

struct GdIOCtx {
	getC   fn (GdIOCtxPtr) int
	getBuf fn (GdIOCtxPtr, voidptr, int) int
	putC   fn (GdIOCtxPtr, int)
	putBuf fn (GdIOCtxPtr, voidptr, int) int
	// seek must return 1 on SUCCESS, 0 on FAILURE. Unlike fseek!
	seek    fn (GdIOCtxPtr, int) int
	tell    fn (GdIOCtxPtr) int
	gd_free fn (GdIOCtxPtr)
	data    voidptr
}

// Version information.  This gets parsed by build scripts as well as
// *gcc so each #define line in this group must also be splittable on
// *whitespace, take the form GD_*VERSION and contain the magical
// *trailing comment.
// version605b5d1778
// version605b5d1778
// version605b5d1778
// version605b5d1778
// End parsable section.
// The version string.  This is constructed from the version number
// *parts above via macro abuse^Wtrickery.
// Two levels needed to expand args.
// Do the DLL dance: dllexport when building the DLL,
//   dllimport when importing from it, nothing when
//   not on Silly Silly Windows (tm Aardman Productions).
// 2.0.20: for headers
// 2.0.24: __stdcall also needed for Visual BASIC
//   and other languages. This breaks ABI compatibility
//   with previous DLL revs, but it's necessary.
// 2.0.29: WIN32 programmers can declare the NONDLL macro if they
//   wish to build gd as a static library or by directly including
//   the gd sources in a project.
// http://gcc.gnu.org/wiki/Visibility
// VS2012+ disable keyword macroizing unless _ALLOW_KEYWORD_MACROS is set
//   We define inline, and strcasecmp if they're missing
//
// gd.h: declarations file for the graphic-draw module.
// *Permission to use, copy, modify, and distribute this software and its
// *documentation for any purpose and without fee is hereby granted, provided
// *that the above copyright notice appear in all copies and that both that
// *copyright notice and this permission notice appear in supporting
// *documentation.  This software is provided "AS IS." Thomas Boutell and
// *Boutell.Com, Inc. disclaim all warranties, either express or implied,
// *including but not limited to implied warranties of merchantability and
// *fitness for a particular purpose, with respect to this code and accompanying
// *documentation.
// stdio is needed for file I/O.
// The maximum number of palette entries in palette-based images.
//   In the wonderful new world of gd 2.0, you can of course have
//   many more colors when using truecolor mode.
// Image type. See functions below; you will not need to change
//   the elements directly. Use the provided macros to
//   access sx, sy, the color table, and colorsTotal for
//   read-only purposes.
// If 'truecolor' is set true, the image is truecolor;
//   pixels are represented by integers, which
//   must be 32 bits wide or more.
//
//   True colors are repsented as follows:
//
//   ARGB
//
//   Where 'A' (alpha channel) occupies only the
//   LOWER 7 BITS of the MSB. This very small
//   loss of alpha channel resolution allows gd 2.x
//   to keep backwards compatibility by allowing
//   signed integers to be used to represent colors,
//   and negative numbers to represent special cases,
//   just as in gd 1.x.
//* *Group: Color Decomposition
//
//* *Macro: gdTrueColorGetAlpha
// * *Gets the alpha channel value
// * *Parameters:
// *  c - The color
// * *See also:
// *  - <gdTrueColorAlpha>
//
//* *Macro: gdTrueColorGetRed
// * *Gets the red channel value
// * *Parameters:
// *  c - The color
// * *See also:
// *  - <gdTrueColorAlpha>
//
//* *Macro: gdTrueColorGetGreen
// * *Gets the green channel value
// * *Parameters:
// *  c - The color
// * *See also:
// *  - <gdTrueColorAlpha>
//
//* *Macro: gdTrueColorGetBlue
// * *Gets the blue channel value
// * *Parameters:
// *  c - The color
// * *See also:
// *  - <gdTrueColorAlpha>
//
//* *Group: Effects
// * *The layering effect
// * *When pixels are drawn the new colors are "mixed" with the background
// *depending on the effect.
// * *Note that the effect does not apply to palette images, where pixels
// *are always replaced.
// * *Modes:
// *  gdEffectReplace    - replace pixels
// *  gdEffectAlphaBlend - blend pixels, see <gdAlphaBlend>
// *  gdEffectNormal     - default mode; same as gdEffectAlphaBlend
// *  gdEffectOverlay    - overlay pixels, see <gdLayerOverlay>
// *  gdEffectMultiply   - overlay pixels with multiply effect, see
// *                       <gdLayerMultiply>
// * *See also:
// *  - <gdImageAlphaBlending>
//
// This function accepts truecolor pixel values only. The
//   source color is composited with the destination color
//   based on the alpha channel value of the source color.
//   The resulting color is opaque.
fn C.gdAlphaBlend(dest int, src int) int

pub fn gd_alpha_blend(dest int, src int) int {
	return C.gdAlphaBlend(dest, src)
}

fn C.gdLayerOverlay(dest int, src int) int

pub fn gd_layer_overlay(dest int, src int) int {
	return C.gdLayerOverlay(dest, src)
}

fn C.gdLayerMultiply(dest int, src int) int

pub fn gd_layer_multiply(dest int, src int) int {
	return C.gdLayerMultiply(dest, src)
}

//* *Group: Color Quantization
// * *Enum: gdPaletteQuantizationMethod
// * *Constants:
// *  GD_QUANT_DEFAULT  - GD_QUANT_LIQ if libimagequant is available,
// *                      GD_QUANT_JQUANT otherwise.
// *  GD_QUANT_JQUANT   - libjpeg's old median cut. Fast, but only uses 16-bit
// *                      color.
// *  GD_QUANT_NEUQUANT - NeuQuant - approximation using Kohonen neural network.
// *  GD_QUANT_LIQ      - A combination of algorithms used in libimagequant
// *                      aiming for the highest quality at cost of speed.
// * *Note that GD_QUANT_JQUANT does not retain the alpha channel, and
// *GD_QUANT_NEUQUANT does not support dithering.
// * *See also:
// *  - <gdImageTrueColorToPaletteSetMethod>
//
enum GdPaletteQuantizationMethod {
	gd_quant_default  = 0
	gd_quant_jquant   = 1
	gd_quant_neuquant = 2
	gd_quant_liq      = 3
}

//* *Group: Transform
// * *Constants: gdInterpolationMethod
// * * GD_BELL				 - Bell
// * GD_BESSEL			 - Bessel
// * GD_BILINEAR_FIXED 	 - fixed point bilinear
// * GD_BICUBIC 			 - Bicubic
// * GD_BICUBIC_FIXED 	 - fixed point bicubic integer
// * GD_BLACKMAN			 - Blackman
// * GD_BOX				 - Box
// * GD_BSPLINE			 - BSpline
// * GD_CATMULLROM		 - Catmullrom
// * GD_GAUSSIAN			 - Gaussian
// * GD_GENERALIZED_CUBIC - Generalized cubic
// * GD_HERMITE			 - Hermite
// * GD_HAMMING			 - Hamming
// * GD_HANNING			 - Hannig
// * GD_MITCHELL			 - Mitchell
// * GD_NEAREST_NEIGHBOUR - Nearest neighbour interpolation
// * GD_POWER			 - Power
// * GD_QUADRATIC		 - Quadratic
// * GD_SINC				 - Sinc
// * GD_TRIANGLE       - Triangle
// * GD_WEIGHTED4		 - 4 pixels weighted bilinear interpolation
// * GD_LINEAR            - bilinear interpolation
// * *See also:
// * - <gdImageSetInterpolationMethod>
// * - <gdImageGetInterpolationMethod>
//
enum GdInterpolationMethod {
	gd_default      = 0
	gd_bell
	gd_bessel
	gd_bilinear_fixed
	gd_bicubic
	gd_bicubic_fixed
	gd_blackman
	gd_box
	gd_bspline
	gd_catmullrom
	gd_gaussian
	gd_generalized_cubic
	gd_hermite
	gd_hamming
	gd_hanning
	gd_mitchell
	gd_nearest_neighbour
	gd_power
	gd_quadratic
	gd_sinc
	gd_triangle
	gd_weighted_4
	gd_linear
	gd_lanczos_3
	gd_lanczos_8
	gd_blackman_bessel
	gd_blackman_sinc
	gd_quadratic_bspline
	gd_cubic_spline
	gd_cosine
	gd_welsh
	gd_method_count = 30
}

//* *Group: HEIF Coding Format
// * *Values that select the HEIF coding format.
// * *Constants: gdHeifCodec
// * * GD_HEIF_CODEC_UNKNOWN
// * GD_HEIF_CODEC_HEVC
// * GD_HEIF_CODEC_AV1
// * *See also:
// * - <gdImageHeif>
//
enum GdHeifCodec {
	gd_heif_codec_unknown = 0
	gd_heif_codec_hevc
	gd_heif_codec_av_1    = 4
}

//* *Group: HEIF Chroma Subsampling
// * *Values that select the HEIF chroma subsampling.
// * *Constants: gdHeifCompression
// * * GD_HEIF_CHROMA_420
// * GD_HEIF_CHROMA_422
// * GD_HEIF_CHROMA_444
// * *See also:
// * - <gdImageHeif>
//
type GdHeifChroma = &i8

// define struct with name and func ptr and add it to gdImageStruct gdInterpolationMethod interpolation;
// Interpolation function ptr
type Interpolation_method = fn (f64, f64) f64

//
//   Group: Types
//
//   typedef: gdImage
//
//   typedef: gdImagePtr
//
//   The data structure in which gd stores images. <gdImageCreate>,
//   <gdImageCreateTrueColor> and the various image file-loading functions
//   return a pointer to this type, and the other functions expect to
//   receive a pointer to this type as their first argument.
//
//   *dImagePtr*is a pointer to *dImage*
//
//   See also:
//     <Accessor Macros>
//
//   (Previous versions of this library encouraged directly manipulating
//   the contents ofthe struct but we are attempting to move away from
//   this practice so the fields are no longer documented here.  If you
//   need to poke at the internals of this struct, feel free to look at
//   *d.h*)
//
struct GdImage {
pub:
	// Palette-based image pixels
	pixels &&u8
	sx     int
	sy     int
	// These are valid in palette images only. See also
	//	   'alpha', which appears later in the structure to
	//	   preserve binary backwards compatibility
	colorsTotal int
	red         [256]int
	green       [256]int
	blue        [256]int
	open        [256]int
	// For backwards compatibility, this is set to the
	//	   first palette entry with 100% transparency,
	//	   and is also set and reset by the
	//	   gdImageColorTransparent function. Newer
	//	   applications can allocate palette entries
	//	   with any desired level of transparency; however,
	//	   bear in mind that many viewers, notably
	//	   many web browsers, fail to implement
	//	   full alpha channel for PNG and provide
	//	   support for full opacity or transparency only.
	transparent   int
	polyInts      &int
	polyAllocated int
	brush         &GdImage
	tile          &GdImage
	brushColorMap [256]int
	tileColorMap  [256]int
	styleLength   int
	stylePos      int
	style         &int
	interlace     int
	// New in 2.0: thickness of line. Initialized to 1.
	thick int
	// New in 2.0: alpha channel for palettes. Note that only
	//	   Macintosh Internet Explorer and (possibly) Netscape 6
	//	   really support multiple levels of transparency in
	//	   palettes, to my knowledge, as of 2/15/01. Most
	//	   common browsers will display 100% opaque and
	//	   100% transparent correctly, and do something
	//	   unpredictable and/or undesirable for levels
	//	   in between. TBB
	alpha [256]int
	// Truecolor flag and pixels. New 2.0 fields appear here at the
	//	   end to minimize breakage of existing object code.
	trueColor int
	tpixels   &&int
	// Should alpha channel be copied, or applied, each time a
	//	   pixel is drawn? This applies to truecolor images only.
	//	   No attempt is made to alpha-blend in palette images,
	//	   even if semitransparent palette entries exist.
	//	   To do that, build your image as a truecolor image,
	//	   then quantize down to 8 bits.
	alphaBlendingFlag int
	// Should the alpha channel of the image be saved? This affects
	//	   PNG at the moment; other future formats may also
	//	   have that capability. JPEG doesn't.
	saveAlphaFlag int
	// There should NEVER BE ACCESSOR MACROS FOR ITEMS BELOW HERE, so this
	//	   part of the structure can be safely changed in new releases.
	// 2.0.12: anti-aliased globals. 2.0.26: just a few vestiges after
	//	  switching to the fast, memory-cheap implementation from PHP-gd.
	aA            int
	aA_color      int
	aA_dont_blend int
	// 2.0.12: simple clipping rectangle. These values
	//	  must be checked for safety when set; please use
	//	  gdImageSetClip
	cx1 int
	cy1 int
	cx2 int
	cy2 int
	// 2.1.0: allows to specify resolution in dpi
	res_x u32
	res_y u32
	// Selects quantization method, see gdImageTrueColorToPaletteSetMethod() and gdPaletteQuantizationMethod enum.
	paletteQuantizationMethod int
	// speed/quality trade-off. 1 = best quality, 10 = best speed. 0 = method-specific default.
	//	   Applicable to GD_QUANT_LIQ and GD_QUANT_NEUQUANT.
	paletteQuantizationSpeed int
	// Image will remain true-color if conversion to palette cannot achieve given quality.
	//	   Value from 1 to 100, 1 = ugly, 100 = perfect. Applicable to GD_QUANT_LIQ.
	paletteQuantizationMinQuality int
	// Image will use minimum number of palette colors needed to achieve given quality. Must be higher than paletteQuantizationMinQuality
	//	   Value from 1 to 100, 1 = ugly, 100 = perfect. Applicable to GD_QUANT_LIQ.
	paletteQuantizationMaxQuality int
	interpolation_id              GdInterpolationMethod
	interpolation                 Interpolation_method
}

type GdImagePtr = &GdImage

// Point type for use in polygon drawing.
//* *Group: Types
// * *typedef: gdPointF
// * Defines a point in a 2D coordinate system using floating point
// * values.
// *x - Floating point position (increase from left to right)
// *y - Floating point Row position (increase from top to bottom)
// * *typedef: gdPointFPtr
// * Pointer to a <gdPointF>
// * *See also:
// * <gdImageCreate>, <gdImageCreateTrueColor>,
// */
// typedef struct
//{
//	double x, y;
//}
// gdPointF, *dPointFPtr;
//
//
///*  Group: Types
//
//  typedef: gdFont
//
//  typedef: gdFontPtr
//
//  A font structure, containing the bitmaps of all characters in a
//  font.  Used to declare the characteristics of a font. Text-output
//  functions expect these as their second argument, following the
//  <gdImagePtr> argument.  <gdFontGetSmall> and <gdFontGetLarge> both
//  return one.
//
//  You can provide your own font data by providing such a structure and
//  the associated pixel array. You can determine the width and height
//  of a single character in a font by examining the w and h members of
//  the structure. If you will not be creating your own fonts, you will
//  not need to concern yourself with the rest of the components of this
//  structure.
//
//  Please see the files gdfontl.c and gdfontl.h for an example of
//  the proper declaration of this structure.
//
//  > typedef struct {
//  >   // # of characters in font
//  >   int nchars;
//  >   // First character is numbered... (usually 32 = space)
//  >   int offset;
//  >   // Character width and height
//  >   int w;
//  >   int h;
//  >   // Font data; array of characters, one row after another.
//  >   // Easily included in code, also easily loaded from
//  >   // data files.
//  >   char *ata;
//  > } gdFont;
//
//  gdFontPtr is a pointer to gdFont.
//
//
struct GdPointF {
	x f64
	y f64
}

type GdPointFPtr = voidptr

struct GdFont {
	// # of characters in font
	nchars int
	// First character is numbered... (usually 32 = space)
	offset int
	// Character width and height
	w int
	h int
	// Font data; array of characters, one row after another.
	//	   Easily included in code, also easily loaded from
	//	   data files.
	data &i8
}

// Text functions take these.
type GdFontPtr = &GdFont
type GdErrorMethod = string

fn C.gdSetErrorMethod(arg0 GdErrorMethod)

pub fn gd_set_error_method(arg0 GdErrorMethod) {
	C.gdSetErrorMethod(arg0)
}

fn C.gdClearErrorMethod()

pub fn gd_clear_error_method() {
	C.gdClearErrorMethod()
}

// For backwards compatibility only. Use gdImageSetStyle()
//   for MUCH more flexible line drawing. Also see
//   gdImageSetBrush().
//* *Group: Colors
// * *Colors are always of type int which is supposed to be at least 32 bit large.
// * *Kinds of colors:
// *  true colors     - ARGB values where the alpha channel is stored as most
// *                    significant, and the blue channel as least significant
// *                    byte. Note that the alpha channel only uses the 7 least
// *                    significant bits.
// *                    Don't rely on the internal representation, though, and
// *                    use <gdTrueColorAlpha> to compose a truecolor value, and
// *                    <gdTrueColorGetAlpha>, <gdTrueColorGetRed>,
// *                    <gdTrueColorGetGreen> and <gdTrueColorGetBlue> to access
// *                    the respective channels.
// *  palette indexes - The index of a color palette entry (0-255).
// *  special colors  - As listed in the following section.
// * *Constants: Special Colors
// *  gdStyled        - use the current style, see <gdImageSetStyle>
// *  gdBrushed       - use the current brush, see <gdImageSetBrush>
// *  gdStyledBrushed - use the current style and brush
// *  gdTiled         - use the current tile, see <gdImageSetTile>
// *  gdTransparent   - indicate transparency, what is not the same as the
// *                    transparent color index; used for lines only
// *  gdAntiAliased   - draw anti aliased
//
// Functions to manipulate images.
// Creates a palette-based image (up to 256 colors).
fn C.gdImageCreate(sx int, sy int) GdImagePtr

pub fn gd_image_create(sx int, sy int) GdImagePtr {
	return C.gdImageCreate(sx, sy)
}

// An alternate name for the above (2.0).
// Creates a truecolor image (millions of colors).
fn C.gdImageCreateTrueColor(sx int, sy int) GdImagePtr

pub fn gd_image_create_truecolor(sx int, sy int) GdImagePtr {
	return C.gdImageCreateTrueColor(sx, sy)
}

// Creates an image from various file types. These functions
//   return a palette or truecolor image based on the
//   nature of the file being loaded. Truecolor PNG
//   stays truecolor; palette PNG stays palette-based;
//   JPEG is always truecolor.
fn C.gdImageCreateFromPng(fd &C.FILE) GdImagePtr

pub fn gd_image_create_from_png(fd &C.FILE) GdImagePtr {
	return C.gdImageCreateFromPng(fd)
}

fn C.gdImageCreateFromPngCtx(in_ GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_png_ctx(in_ GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromPngCtx(in_)
}

fn C.gdImageCreateFromPngPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_png_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromPngPtr(size, data)
}

// These read the first frame only
fn C.gdImageCreateFromGif(fd &C.FILE) GdImagePtr

pub fn gd_image_create_from_gif(fd &C.FILE) GdImagePtr {
	return C.gdImageCreateFromGif(fd)
}

fn C.gdImageCreateFromGifCtx(in_ GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_gif_ctx(in_ GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromGifCtx(in_)
}

fn C.gdImageCreateFromGifPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_gif_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromGifPtr(size, data)
}

fn C.gdImageCreateFromWBMP(in_file &C.FILE) GdImagePtr

pub fn gd_image_create_from_wbmp(in_file &C.FILE) GdImagePtr {
	return C.gdImageCreateFromWBMP(in_file)
}

fn C.gdImageCreateFromWBMPCtx(infile GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_wbmpc_tx(infile GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromWBMPCtx(infile)
}

fn C.gdImageCreateFromWBMPPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_wbmpp_tr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromWBMPPtr(size, data)
}

fn C.gdImageCreateFromJpeg(infile &C.FILE) GdImagePtr

pub fn gd_image_create_from_jpeg(infile &C.FILE) GdImagePtr {
	return C.gdImageCreateFromJpeg(infile)
}

fn C.gdImageCreateFromJpegEx(infile &C.FILE, ignore_warning int) GdImagePtr

pub fn gd_image_create_from_jpeg_ex(infile &C.FILE, ignore_warning int) GdImagePtr {
	return C.gdImageCreateFromJpegEx(infile, ignore_warning)
}

fn C.gdImageCreateFromJpegCtx(infile GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_jpeg_ctx(infile GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromJpegCtx(infile)
}

fn C.gdImageCreateFromJpegCtxEx(infile GdIOCtxPtr, ignore_warning int) GdImagePtr

pub fn gd_image_create_from_jpeg_ctx_ex(infile GdIOCtxPtr, ignore_warning int) GdImagePtr {
	return C.gdImageCreateFromJpegCtxEx(infile, ignore_warning)
}

fn C.gdImageCreateFromJpegPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_jpeg_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromJpegPtr(size, data)
}

fn C.gdImageCreateFromJpegPtrEx(size int, data voidptr, ignore_warning int) GdImagePtr

pub fn gd_image_create_from_jpeg_ptr_ex(size int, data voidptr, ignore_warning int) GdImagePtr {
	return C.gdImageCreateFromJpegPtrEx(size, data, ignore_warning)
}

fn C.gdImageCreateFromWebp(in_file &C.FILE) GdImagePtr

pub fn gd_image_create_from_webp(in_file &C.FILE) GdImagePtr {
	return C.gdImageCreateFromWebp(in_file)
}

fn C.gdImageCreateFromWebpPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_webp_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromWebpPtr(size, data)
}

fn C.gdImageCreateFromWebpCtx(infile GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_webp_ctx(infile GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromWebpCtx(infile)
}

fn C.gdImageCreateFromHeif(in_file &C.FILE) GdImagePtr

pub fn gd_image_create_from_heif(in_file &C.FILE) GdImagePtr {
	return C.gdImageCreateFromHeif(in_file)
}

fn C.gdImageCreateFromHeifPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_heif_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromHeifPtr(size, data)
}

fn C.gdImageCreateFromHeifCtx(infile GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_heif_ctx(infile GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromHeifCtx(infile)
}

fn C.gdImageCreateFromAvif(in_file &C.FILE) GdImagePtr

pub fn gd_image_create_from_avif(in_file &C.FILE) GdImagePtr {
	return C.gdImageCreateFromAvif(in_file)
}

fn C.gdImageCreateFromAvifPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_avif_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromAvifPtr(size, data)
}

fn C.gdImageCreateFromAvifCtx(infile GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_avif_ctx(infile GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromAvifCtx(infile)
}

fn C.gdImageCreateFromTiff(in_file &C.FILE) GdImagePtr

pub fn gd_image_create_from_tiff(in_file &C.FILE) GdImagePtr {
	return C.gdImageCreateFromTiff(in_file)
}

fn C.gdImageCreateFromTiffCtx(infile GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_tiff_ctx(infile GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromTiffCtx(infile)
}

fn C.gdImageCreateFromTiffPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_tiff_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromTiffPtr(size, data)
}

fn C.gdImageCreateFromTga(fp &C.FILE) GdImagePtr

pub fn gd_image_create_from_tga(fp &C.FILE) GdImagePtr {
	return C.gdImageCreateFromTga(fp)
}

fn C.gdImageCreateFromTgaCtx(ctx GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_tga_ctx(ctx GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromTgaCtx(ctx)
}

fn C.gdImageCreateFromTgaPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_tga_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromTgaPtr(size, data)
}

fn C.gdImageCreateFromBmp(in_file &C.FILE) GdImagePtr

pub fn gd_image_create_from_bmp(in_file &C.FILE) GdImagePtr {
	return C.gdImageCreateFromBmp(in_file)
}

fn C.gdImageCreateFromBmpPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_bmp_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromBmpPtr(size, data)
}

fn C.gdImageCreateFromBmpCtx(infile GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_bmp_ctx(infile GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromBmpCtx(infile)
}

fn C.gdImageCreateFromFile(filename &i8) GdImagePtr

pub fn gd_image_create_from_file(filename &i8) GdImagePtr {
	return C.gdImageCreateFromFile(filename)
}

//
//  Group: Types
//
//  typedef: gdSource
//
//  typedef: gdSourcePtr
//
//    *ote:*This interface is *bsolete*and kept only for
//    *ompatibility.  Use <gdIOCtx> instead.
//
//    Represents a source from which a PNG can be read. Programmers who
//    do not wish to read PNGs from a file can provide their own
//    alternate input mechanism, using the <gdImageCreateFromPngSource>
//    function. See the documentation of that function for an example of
//    the proper use of this type.
//
//    > typedef struct {
//    >         int (*ource) (void *ontext, char *uffer, int len);
//    >         void *ontext;
//    > } gdSource, *dSourcePtr;
//
//    The source function must return -1 on error, otherwise the number
//    of bytes fetched. 0 is EOF, not an error!
//
//   'context' will be passed to your source function.
//
//
struct GdSource {
	source  fn (voidptr, &i8, int) int
	context voidptr
}

type GdSourcePtr = voidptr

// Deprecated in favor of gdImageCreateFromPngCtx
fn C.gdImageCreateFromPngSource(in_ GdSourcePtr) GdImagePtr

pub fn gd_image_create_from_png_source(in_ GdSourcePtr) GdImagePtr {
	return C.gdImageCreateFromPngSource(in_)
}

fn C.gdImageCreateFromGd(in_ &C.FILE) GdImagePtr

pub fn gd_image_create_from_gd(in_ &C.FILE) GdImagePtr {
	return C.gdImageCreateFromGd(in_)
}

fn C.gdImageCreateFromGdCtx(in_ GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_gd_ctx(in_ GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromGdCtx(in_)
}

fn C.gdImageCreateFromGdPtr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_gd_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromGdPtr(size, data)
}

fn C.gdImageCreateFromGd2(in_ &C.FILE) GdImagePtr

pub fn gd_image_create_from_gd2(in_ &C.FILE) GdImagePtr {
	return C.gdImageCreateFromGd2(in_)
}

fn C.gdImageCreateFromGd2Ctx(in_ GdIOCtxPtr) GdImagePtr

pub fn gd_image_create_from_gd2_ctx(in_ GdIOCtxPtr) GdImagePtr {
	return C.gdImageCreateFromGd2Ctx(in_)
}

fn C.gdImageCreateFromGd2Ptr(size int, data voidptr) GdImagePtr

pub fn gd_image_create_from_gd2_ptr(size int, data voidptr) GdImagePtr {
	return C.gdImageCreateFromGd2Ptr(size, data)
}

fn C.gdImageCreateFromGd2Part(in_ &C.FILE, srcx int, srcy int, w int, h int) GdImagePtr

pub fn gd_image_create_from_gd2_part(in_ &C.FILE, srcx int, srcy int, w int, h int) GdImagePtr {
	return C.gdImageCreateFromGd2Part(in_, srcx, srcy, w, h)
}

fn C.gdImageCreateFromGd2PartCtx(in_ GdIOCtxPtr, srcx int, srcy int, w int, h int) GdImagePtr

pub fn gd_image_create_from_gd2_part_ctx(in_ GdIOCtxPtr, srcx int, srcy int, w int, h int) GdImagePtr {
	return C.gdImageCreateFromGd2PartCtx(in_, srcx, srcy, w, h)
}

fn C.gdImageCreateFromGd2PartPtr(size int, data voidptr, srcx int, srcy int, w int, h int) GdImagePtr

pub fn gd_image_create_from_gd2_part_ptr(size int, data voidptr, srcx int, srcy int, w int, h int) GdImagePtr {
	return C.gdImageCreateFromGd2PartPtr(size, data, srcx, srcy, w, h)
}

// 2.0.10: prototype was missing
fn C.gdImageCreateFromXbm(in_ &C.FILE) GdImagePtr

pub fn gd_image_create_from_xbm(in_ &C.FILE) GdImagePtr {
	return C.gdImageCreateFromXbm(in_)
}

fn C.gdImageXbmCtx(image GdImagePtr, file_name &i8, fg int, out GdIOCtxPtr)

pub fn gd_image_xbm_ctx(image GdImagePtr, file_name &i8, fg int, out GdIOCtxPtr) {
	C.gdImageXbmCtx(image, file_name, fg, out)
}

// NOTE: filename, not FILE
fn C.gdImageCreateFromXpm(filename &i8) GdImagePtr

pub fn gd_image_create_from_xpm(filename &i8) GdImagePtr {
	return C.gdImageCreateFromXpm(filename)
}

fn C.gdImageDestroy(im GdImagePtr)

pub fn gd_image_destroy(im GdImagePtr) {
	C.gdImageDestroy(im)
}

// Replaces or blends with the background depending on the
//   most recent call to gdImageAlphaBlending and the
//   alpha channel value of 'color'; default is to overwrite.
//   Tiling and line styling are also implemented
//   here. All other gd drawing functions pass through this call,
//   allowing for many useful effects.
//   Overlay and multiply effects are used when gdImageAlphaBlending
//   is passed gdEffectOverlay and gdEffectMultiply
fn C.gdImageSetPixel(im GdImagePtr, x int, y int, color int)

pub fn gd_image_set_pixel(im GdImagePtr, x int, y int, color int) {
	C.gdImageSetPixel(im, x, y, color)
}

// FreeType 2 text output with hook to extra flags
fn C.gdImageGetPixel(im GdImagePtr, x int, y int) int

pub fn gd_image_get_pixel(im GdImagePtr, x int, y int) int {
	return C.gdImageGetPixel(im, x, y)
}

fn C.gdImageGetTrueColorPixel(im GdImagePtr, x int, y int) int

pub fn gd_image_get_truecolor_pixel(im GdImagePtr, x int, y int) int {
	return C.gdImageGetTrueColorPixel(im, x, y)
}

fn C.gdImageAABlend(im GdImagePtr)

pub fn gd_image_aab_lend(im GdImagePtr) {
	C.gdImageAABlend(im)
}

fn C.gdImageLine(im GdImagePtr, x1 int, y1 int, x2 int, y2 int, color int)

pub fn gd_image_line(im GdImagePtr, x1 int, y1 int, x2 int, y2 int, color int) {
	C.gdImageLine(im, x1, y1, x2, y2, color)
}

// For backwards compatibility only. Use gdImageSetStyle()
//   for much more flexible line drawing.
fn C.gdImageDashedLine(im GdImagePtr, x1 int, y1 int, x2 int, y2 int, color int)

pub fn gd_image_dashed_line(im GdImagePtr, x1 int, y1 int, x2 int, y2 int, color int) {
	C.gdImageDashedLine(im, x1, y1, x2, y2, color)
}

// Corners specified (not width and height). Upper left first, lower right
//   second.
fn C.gdImageRectangle(im GdImagePtr, x1 int, y1 int, x2 int, y2 int, color int)

pub fn gd_image_rectangle(im GdImagePtr, x1 int, y1 int, x2 int, y2 int, color int) {
	C.gdImageRectangle(im, x1, y1, x2, y2, color)
}

// Solid bar. Upper left corner first, lower right corner second.
fn C.gdImageFilledRectangle(im GdImagePtr, x1 int, y1 int, x2 int, y2 int, color int)

pub fn gd_image_filled_rectangle(im GdImagePtr, x1 int, y1 int, x2 int, y2 int, color int) {
	C.gdImageFilledRectangle(im, x1, y1, x2, y2, color)
}

fn C.gdImageSetClip(im GdImagePtr, x1 int, y1 int, x2 int, y2 int)

pub fn gd_image_set_clip(im GdImagePtr, x1 int, y1 int, x2 int, y2 int) {
	C.gdImageSetClip(im, x1, y1, x2, y2)
}

fn C.gdImageGetClip(im GdImagePtr, x1_p &int, y1_p &int, x2_p &int, y2_p &int)

pub fn gd_image_get_clip(im GdImagePtr, x1_p &int, y1_p &int, x2_p &int, y2_p &int) {
	C.gdImageGetClip(im, x1_p, y1_p, x2_p, y2_p)
}

fn C.gdImageSetResolution(im GdImagePtr, res_x u32, res_y u32)

pub fn gd_image_set_resolution(im GdImagePtr, res_x u32, res_y u32) {
	C.gdImageSetResolution(im, res_x, res_y)
}

fn C.gdImageBoundsSafe(im GdImagePtr, x int, y int) int

pub fn gd_image_bounds_safe(im GdImagePtr, x int, y int) int {
	return C.gdImageBoundsSafe(im, x, y)
}

fn C.gdImageChar(im GdImagePtr, f GdFontPtr, x int, y int, c int, color int)

pub fn gd_image_char(im GdImagePtr, f GdFontPtr, x int, y int, c int, color int) {
	C.gdImageChar(im, f, x, y, c, color)
}

fn C.gdImageCharUp(im GdImagePtr, f GdFontPtr, x int, y int, c int, color int)

pub fn gd_image_char_up(im GdImagePtr, f GdFontPtr, x int, y int, c int, color int) {
	C.gdImageCharUp(im, f, x, y, c, color)
}

fn C.gdImageString(im GdImagePtr, f GdFontPtr, x int, y int, s &u8, color int)

pub fn gd_image_string(im GdImagePtr, f GdFontPtr, x int, y int, s &u8, color int) {
	C.gdImageString(im, f, x, y, s, color)
}

fn C.gdImageStringUp(im GdImagePtr, f GdFontPtr, x int, y int, s &u8, color int)

pub fn gd_image_string_up(im GdImagePtr, f GdFontPtr, x int, y int, s &u8, color int) {
	C.gdImageStringUp(im, f, x, y, s, color)
}

fn C.gdImageString16(im GdImagePtr, f GdFontPtr, x int, y int, s &u16, color int)

pub fn gd_image_string16(im GdImagePtr, f GdFontPtr, x int, y int, s &u16, color int) {
	C.gdImageString16(im, f, x, y, s, color)
}

fn C.gdImageStringUp16(im GdImagePtr, f GdFontPtr, x int, y int, s &u16, color int)

pub fn gd_image_string_up16(im GdImagePtr, f GdFontPtr, x int, y int, s &u16, color int) {
	C.gdImageStringUp16(im, f, x, y, s, color)
}

// 2.0.16: for thread-safe use of gdImageStringFT and friends,
//   call this before allowing any thread to call gdImageStringFT.
//   Otherwise it is invoked by the first thread to invoke
//   gdImageStringFT, with a very small but real risk of a race condition.
//   Return 0 on success, nonzero on failure to initialize freetype.
fn C.gdFontCacheSetup() int

pub fn gd_font_cache_setup() int {
	return C.gdFontCacheSetup()
}

// Optional: clean up after application is done using fonts in
//   gdImageStringFT().
fn C.gdFontCacheShutdown()

pub fn gd_font_cache_shutdown() {
	C.gdFontCacheShutdown()
}

// 2.0.20: for backwards compatibility. A few applications did start calling
//   this function when it first appeared although it was never documented.
//   Simply invokes gdFontCacheShutdown.
fn C.gdFreeFontCache()

pub fn gd_free_font_cache() {
	C.gdFreeFontCache()
}

// Calls gdImageStringFT. Provided for backwards compatibility only.
fn C.gdImageStringTTF(im GdImagePtr, brect &int, fg int, fontlist &i8, ptsize f64, angle f64, x int, y int, string_ &i8) &i8

pub fn gd_image_string_ttf(im GdImagePtr, brect &int, fg int, fontlist &i8, ptsize f64, angle f64, x int, y int, string_ &i8) &i8 {
	return C.gdImageStringTTF(im, brect, fg, fontlist, ptsize, angle, x, y, string_)
}

// FreeType 2 text output
fn C.gdImageStringFT(im GdImagePtr, brect &int, fg int, fontlist &i8, ptsize f64, angle f64, x int, y int, string_ &i8) &i8

pub fn gd_image_string_ft(im GdImagePtr, brect &int, fg int, fontlist &i8, ptsize f64, angle f64, x int, y int, string_ &i8) &i8 {
	return C.gdImageStringFT(im, brect, fg, fontlist, ptsize, angle, x, y, string_)
}

//
//  Group: Types
//
//  typedef: gdFTStringExtra
//
//  typedef: gdFTStringExtraPtr
//
//  A structure and associated pointer type used to pass additional
//  parameters to the <gdImageStringFTEx> function. See
//  <gdImageStringFTEx> for the structure definition.
//
//  Thanks to Wez Furlong.
//
// 2.0.5: provides an extensible way to pass additional parameters.
//   Thanks to Wez Furlong, sorry for the delay.
struct GdFTStringExtra {
	flags int
	// Logical OR of gdFTEX_ values
	linespacing f64
	// fine tune line spacing for '\n'
	charmap int
	// TBB: 2.0.12: may be gdFTEX_Unicode,
	//				   gdFTEX_Shift_JIS, gdFTEX_Big5,
	//				   or gdFTEX_Adobe_Custom;
	//				   when not specified, maps are searched
	//				   for in the above order.
	hdpi int
	// if (flags & gdFTEX_RESOLUTION)
	vdpi int
	// if (flags & gdFTEX_RESOLUTION)
	xshow &i8
	// if (flags & gdFTEX_XSHOW)
	//				    then, on return, xshow is a malloc'ed
	//				    string containing xshow position data for
	//				    the last string.
	//
	//				    NB. The caller is responsible for gdFree'ing
	//				    the xshow string.
	//				
	fontpath &i8
	// if (flags & gdFTEX_RETURNFONTPATHNAME)
	//				    then, on return, fontpath is a malloc'ed
	//				    string containing the actual font file path name
	//				    used, which can be interesting when fontconfig
	//				    is in use.
	//
	//				    The caller is responsible for gdFree'ing the
	//				    fontpath string.
	//				
}

type GdFTStringExtraPtr = voidptr

// The default unless gdFTUseFontConfig(1); has been called:
//   fontlist is a full or partial font file pathname or list thereof
//   (i.e. just like before 2.0.29)
// Necessary to use fontconfig patterns instead of font pathnames
//   as the fontlist argument, unless gdFTUseFontConfig(1); has
//   been called. New in 2.0.29
// Sometimes interesting when fontconfig is used: the fontpath
//   element of the structure above will contain a gdMalloc'd string
//   copy of the actual font file pathname used, if this flag is set
//   when the call is made
// If flag is nonzero, the fontlist parameter to gdImageStringFT
//   and gdImageStringFTEx shall be assumed to be a fontconfig font pattern
//   if fontconfig was compiled into gd. This function returns zero
//   if fontconfig is not available, nonzero otherwise.
fn C.gdFTUseFontConfig(flag int) int

pub fn gd_ftu_se_font_config(flag int) int {
	return C.gdFTUseFontConfig(flag)
}

// These are NOT flags; set one in 'charmap' if you set the
//   gdFTEX_CHARMAP bit in 'flags'.
fn C.gdImageStringFTEx(im GdImagePtr, brect &int, fg int, fontlist &i8, ptsize f64, angle f64, x int, y int, string_ &i8, strex GdFTStringExtraPtr) &i8

pub fn gd_image_string_fte_x(im GdImagePtr, brect &int, fg int, fontlist &i8, ptsize f64, angle f64, x int, y int, string_ &i8, strex GdFTStringExtraPtr) &i8 {
	return C.gdImageStringFTEx(im, brect, fg, fontlist, ptsize, angle, x, y, string_,
		strex)
}

//
//  Group: Types
//
//  typedef: gdPoint
//
//  typedef: gdPointPtr
//
//  Represents a point in the coordinate space of the image; used by
//  <gdImagePolygon>, <gdImageOpenPolygon> and <gdImageFilledPolygon>
//  for polygon drawing.
//
//  > typedef struct {
//  >     int x, y;
//  > } gdPoint, *dPointPtr;
//
//
struct GdPoint {
	x int
	y int
}

type GdPointPtr = voidptr

//* *Typedef: gdRect
// * *A rectangle in the coordinate space of the image
// * *Members:
// *  x      - The x-coordinate of the upper left corner.
// *  y      - The y-coordinate of the upper left corner.
// *  width  - The width.
// *  height - The height.
// * *Typedef: gdRectPtr
// * *A pointer to a <gdRect>
//
struct GdRect {
	x      int
	y      int
	width  int
	height int
}

type GdRectPtr = voidptr

fn C.gdImagePolygon(im GdImagePtr, p GdPointPtr, n int, c int)

pub fn gd_image_polygon(im GdImagePtr, p GdPointPtr, n int, c int) {
	C.gdImagePolygon(im, p, n, c)
}

fn C.gdImageOpenPolygon(im GdImagePtr, p GdPointPtr, n int, c int)

pub fn gd_image_open_polygon(im GdImagePtr, p GdPointPtr, n int, c int) {
	C.gdImageOpenPolygon(im, p, n, c)
}

fn C.gdImageFilledPolygon(im GdImagePtr, p GdPointPtr, n int, c int)

pub fn gd_image_filled_polygon(im GdImagePtr, p GdPointPtr, n int, c int) {
	C.gdImageFilledPolygon(im, p, n, c)
}

// These functions still work with truecolor images,
//   for which they never return error.
fn C.gdImageColorAllocate(im GdImagePtr, r int, g int, b int) int

pub fn gd_image_color_allocate(im GdImagePtr, r int, g int, b int) int {
	return C.gdImageColorAllocate(im, r, g, b)
}

// gd 2.0: palette entries with non-opaque transparency are permitted.
fn C.gdImageColorAllocateAlpha(im GdImagePtr, r int, g int, b int, a int) int

pub fn gd_image_color_allocate_alpha(im GdImagePtr, r int, g int, b int, a int) int {
	return C.gdImageColorAllocateAlpha(im, r, g, b, a)
}

// Assumes opaque is the preferred alpha channel value
fn C.gdImageColorClosest(im GdImagePtr, r int, g int, b int) int

pub fn gd_image_color_closest(im GdImagePtr, r int, g int, b int) int {
	return C.gdImageColorClosest(im, r, g, b)
}

// Closest match taking all four parameters into account.
//   A slightly different color with the same transparency
//   beats the exact same color with radically different
//   transparency
fn C.gdImageColorClosestAlpha(im GdImagePtr, r int, g int, b int, a int) int

pub fn gd_image_color_closest_alpha(im GdImagePtr, r int, g int, b int, a int) int {
	return C.gdImageColorClosestAlpha(im, r, g, b, a)
}

// An alternate method
fn C.gdImageColorClosestHWB(im GdImagePtr, r int, g int, b int) int

pub fn gd_image_color_closest_hwb(im GdImagePtr, r int, g int, b int) int {
	return C.gdImageColorClosestHWB(im, r, g, b)
}

// Returns exact, 100% opaque matches only
fn C.gdImageColorExact(im GdImagePtr, r int, g int, b int) int

pub fn gd_image_color_exact(im GdImagePtr, r int, g int, b int) int {
	return C.gdImageColorExact(im, r, g, b)
}

// Returns an exact match only, including alpha
fn C.gdImageColorExactAlpha(im GdImagePtr, r int, g int, b int, a int) int

pub fn gd_image_color_exact_alpha(im GdImagePtr, r int, g int, b int, a int) int {
	return C.gdImageColorExactAlpha(im, r, g, b, a)
}

// Opaque only
fn C.gdImageColorResolve(im GdImagePtr, r int, g int, b int) int

pub fn gd_image_color_resolve(im GdImagePtr, r int, g int, b int) int {
	return C.gdImageColorResolve(im, r, g, b)
}

// Based on gdImageColorExactAlpha and gdImageColorClosestAlpha
fn C.gdImageColorResolveAlpha(im GdImagePtr, r int, g int, b int, a int) int

pub fn gd_image_color_resolve_alpha(im GdImagePtr, r int, g int, b int, a int) int {
	return C.gdImageColorResolveAlpha(im, r, g, b, a)
}

// A simpler way to obtain an opaque truecolor value for drawing on a
//   truecolor image. Not for use with palette images!
//* *Group: Color Composition
// * *Macro: gdTrueColorAlpha
// * *Compose a truecolor value from its components
// * *Parameters:
// *  r - The red channel (0-255)
// *  g - The green channel (0-255)
// *  b - The blue channel (0-255)
// *  a - The alpha channel (0-127, where 127 is fully transparent, and 0 is
// *      completely opaque).
// * *See also:
// *  - <gdTrueColorGetAlpha>
// *  - <gdTrueColorGetRed>
// *  - <gdTrueColorGetGreen>
// *  - <gdTrueColorGetBlue>
// *  - <gdImageColorExactAlpha>
//
fn C.gdImageColorDeallocate(im GdImagePtr, color int)

pub fn gd_image_color_deallocate(im GdImagePtr, color int) {
	C.gdImageColorDeallocate(im, color)
}

// Converts a truecolor image to a palette-based image,
//   using a high-quality two-pass quantization routine
//   which attempts to preserve alpha channel information
//   as well as R/G/B color information when creating
//   a palette. If ditherFlag is set, the image will be
//   dithered to approximate colors better, at the expense
//   of some obvious "speckling." colorsWanted can be
//   anything up to 256. If the original source image
//   includes photographic information or anything that
//   came out of a JPEG, 256 is strongly recommended.
//
//   Better yet, don't use these function -- write real
//   truecolor PNGs and JPEGs. The disk space gain of
//   conversion to palette is not great (for small images
//   it can be negative) and the quality loss is ugly.
//
//   DIFFERENCES: gdImageCreatePaletteFromTrueColor creates and
//   returns a new image. gdImageTrueColorToPalette modifies
//   an existing image, and the truecolor pixels are discarded.
//
//   gdImageTrueColorToPalette() returns TRUE on success, FALSE on failure.
//
fn C.gdImageCreatePaletteFromTrueColor(im GdImagePtr, dither_flag int, colors_wanted int) GdImagePtr

pub fn gd_image_create_palette_from_truecolor(im GdImagePtr, dither_flag int, colors_wanted int) GdImagePtr {
	return C.gdImageCreatePaletteFromTrueColor(im, dither_flag, colors_wanted)
}

fn C.gdImageTrueColorToPalette(im GdImagePtr, dither_flag int, colors_wanted int) int

pub fn gd_image_truecolor_to_palette(im GdImagePtr, dither_flag int, colors_wanted int) int {
	return C.gdImageTrueColorToPalette(im, dither_flag, colors_wanted)
}

fn C.gdImagePaletteToTrueColor(src GdImagePtr) int

pub fn gd_image_palette_to_truecolor(src GdImagePtr) int {
	return C.gdImagePaletteToTrueColor(src)
}

// An attempt at getting the results of gdImageTrueColorToPalette to
// *look a bit more like the original (im1 is the original and im2 is
// *the palette version
fn C.gdImageColorMatch(im1 GdImagePtr, im2 GdImagePtr) int

pub fn gd_image_color_match(im1 GdImagePtr, im2 GdImagePtr) int {
	return C.gdImageColorMatch(im1, im2)
}

// Selects quantization method used for subsequent gdImageTrueColorToPalette calls.
//   See gdPaletteQuantizationMethod enum (e.g. GD_QUANT_NEUQUANT, GD_QUANT_LIQ).
//   Speed is from 1 (highest quality) to 10 (fastest).
//   Speed 0 selects method-specific default (recommended).
//
//   Returns FALSE if the given method is invalid or not available.
//
fn C.gdImageTrueColorToPaletteSetMethod(im GdImagePtr, method int, speed int) int

pub fn gd_image_truecolor_to_palette_set_method(im GdImagePtr, method int, speed int) int {
	return C.gdImageTrueColorToPaletteSetMethod(im, method, speed)
}

//
//  Chooses quality range that subsequent call to gdImageTrueColorToPalette will aim for.
//  Min and max quality is in range 1-100 (1 = ugly, 100 = perfect). Max must be higher than min.
//  If palette cannot represent image with at least min_quality, then image will remain true-color.
//  If palette can represent image with quality better than max_quality, then lower number of colors will be used.
//  This function has effect only when GD_QUANT_LIQ method has been selected and the source image is true-color.
//
fn C.gdImageTrueColorToPaletteSetQuality(im GdImagePtr, min_quality int, max_quality int)

pub fn gd_image_truecolor_to_palette_set_quality(im GdImagePtr, min_quality int, max_quality int) {
	C.gdImageTrueColorToPaletteSetQuality(im, min_quality, max_quality)
}

// Specifies a color index (if a palette image) or an
//   RGB color (if a truecolor image) which should be
//   considered 100% transparent. FOR TRUECOLOR IMAGES,
//   THIS IS IGNORED IF AN ALPHA CHANNEL IS BEING
//   SAVED. Use gdImageSaveAlpha(im, 0); to
//   turn off the saving of a full alpha channel in
//   a truecolor image. Note that gdImageColorTransparent
//   is usually compatible with older browsers that
//   do not understand full alpha channels well. TBB
fn C.gdImageColorTransparent(im GdImagePtr, color int)

pub fn gd_image_color_transparent(im GdImagePtr, color int) {
	C.gdImageColorTransparent(im, color)
}

fn C.gdImagePaletteCopy(dst GdImagePtr, src GdImagePtr)

pub fn gd_image_palette_copy(dst GdImagePtr, src GdImagePtr) {
	C.gdImagePaletteCopy(dst, src)
}

type GdCallbackImageColor = fn (GdImagePtr, int) int

fn C.gdImageColorReplace(im GdImagePtr, src int, dst int) int

pub fn gd_image_color_replace(im GdImagePtr, src int, dst int) int {
	return C.gdImageColorReplace(im, src, dst)
}

fn C.gdImageColorReplaceThreshold(im GdImagePtr, src int, dst int, threshold f32) int

pub fn gd_image_color_replace_threshold(im GdImagePtr, src int, dst int, threshold f32) int {
	return C.gdImageColorReplaceThreshold(im, src, dst, threshold)
}

fn C.gdImageColorReplaceArray(im GdImagePtr, len int, src &int, dst &int) int

pub fn gd_image_color_replace_array(im GdImagePtr, len int, src &int, dst &int) int {
	return C.gdImageColorReplaceArray(im, len, src, dst)
}

fn C.gdImageColorReplaceCallback(im GdImagePtr, callback GdCallbackImageColor) int

pub fn gd_image_color_replace_callback(im GdImagePtr, callback GdCallbackImageColor) int {
	return C.gdImageColorReplaceCallback(im, callback)
}

fn C.gdImageGif(im GdImagePtr, out &C.FILE)

pub fn gd_image_gif(im GdImagePtr, out &C.FILE) {
	C.gdImageGif(im, out)
}

fn C.gdImagePng(im GdImagePtr, out &C.FILE)

pub fn gd_image_png(im GdImagePtr, out &C.FILE) {
	C.gdImagePng(im, out)
}

fn C.gdImagePngCtx(im GdImagePtr, out GdIOCtxPtr)

pub fn gd_image_png_ctx(im GdImagePtr, out GdIOCtxPtr) {
	C.gdImagePngCtx(im, out)
}

fn C.gdImageGifCtx(im GdImagePtr, out GdIOCtxPtr)

pub fn gd_image_gif_ctx(im GdImagePtr, out GdIOCtxPtr) {
	C.gdImageGifCtx(im, out)
}

fn C.gdImageTiff(im GdImagePtr, out_file &C.FILE)

pub fn gd_image_tiff(im GdImagePtr, out_file &C.FILE) {
	C.gdImageTiff(im, out_file)
}

fn C.gdImageTiffPtr(im GdImagePtr, size &int) voidptr

pub fn gd_image_tiff_ptr(im GdImagePtr, size &int) voidptr {
	return C.gdImageTiffPtr(im, size)
}

fn C.gdImageTiffCtx(image GdImagePtr, out GdIOCtxPtr)

pub fn gd_image_tiff_ctx(image GdImagePtr, out GdIOCtxPtr) {
	C.gdImageTiffCtx(image, out)
}

fn C.gdImageBmpPtr(im GdImagePtr, size &int, compression int) voidptr

pub fn gd_image_bmp_ptr(im GdImagePtr, size &int, compression int) voidptr {
	return C.gdImageBmpPtr(im, size, compression)
}

fn C.gdImageBmp(im GdImagePtr, out_file &C.FILE, compression int)

pub fn gd_image_bmp(im GdImagePtr, out_file &C.FILE, compression int) {
	C.gdImageBmp(im, out_file, compression)
}

fn C.gdImageBmpCtx(im GdImagePtr, out GdIOCtxPtr, compression int)

pub fn gd_image_bmp_ctx(im GdImagePtr, out GdIOCtxPtr, compression int) {
	C.gdImageBmpCtx(im, out, compression)
}

// 2.0.12: Compression level: 0-9 or -1, where 0 is NO COMPRESSION at all,
//   1 is FASTEST but produces larger files, 9 provides the best
//   compression (smallest files) but takes a long time to compress, and
//   -1 selects the default compiled into the zlib library.
fn C.gdImagePngEx(im GdImagePtr, out &C.FILE, level int)

pub fn gd_image_png_ex(im GdImagePtr, out &C.FILE, level int) {
	C.gdImagePngEx(im, out, level)
}

fn C.gdImagePngCtxEx(im GdImagePtr, out GdIOCtxPtr, level int)

pub fn gd_image_png_ctx_ex(im GdImagePtr, out GdIOCtxPtr, level int) {
	C.gdImagePngCtxEx(im, out, level)
}

fn C.gdImageWBMP(image GdImagePtr, fg int, out &C.FILE)

pub fn gd_image_wbmp(image GdImagePtr, fg int, out &C.FILE) {
	C.gdImageWBMP(image, fg, out)
}

fn C.gdImageWBMPCtx(image GdImagePtr, fg int, out GdIOCtxPtr)

pub fn gd_image_wbmpc_tx(image GdImagePtr, fg int, out GdIOCtxPtr) {
	C.gdImageWBMPCtx(image, fg, out)
}

fn C.gdImageFile(im GdImagePtr, filename &i8) int

pub fn gd_image_file(im GdImagePtr, filename &i8) int {
	return C.gdImageFile(im, filename)
}

fn C.gdSupportsFileType(filename &i8, writing int) int

pub fn gd_supports_file_type(filename &i8, writing int) int {
	return C.gdSupportsFileType(filename, writing)
}

// Guaranteed to correctly free memory returned by the gdImage*tr
//   functions
fn C.gdFree(m voidptr)

pub fn gd_free(m voidptr) {
	C.gdFree(m)
}

// Best to free this memory with gdFree(), not free()
fn C.gdImageWBMPPtr(im GdImagePtr, size &int, fg int) voidptr

pub fn gd_image_wbmpp_tr(im GdImagePtr, size &int, fg int) voidptr {
	return C.gdImageWBMPPtr(im, size, fg)
}

// 100 is highest quality (there is always a little loss with JPEG).
//   0 is lowest. 10 is about the lowest useful setting.
fn C.gdImageJpeg(im GdImagePtr, out &C.FILE, quality int)

pub fn gd_image_jpeg(im GdImagePtr, out &C.FILE, quality int) {
	C.gdImageJpeg(im, out, quality)
}

fn C.gdImageJpegCtx(im GdImagePtr, out GdIOCtxPtr, quality int)

pub fn gd_image_jpeg_ctx(im GdImagePtr, out GdIOCtxPtr, quality int) {
	C.gdImageJpegCtx(im, out, quality)
}

// Best to free this memory with gdFree(), not free()
fn C.gdImageJpegPtr(im GdImagePtr, size &int, quality int) voidptr

pub fn gd_image_jpeg_ptr(im GdImagePtr, size &int, quality int) voidptr {
	return C.gdImageJpegPtr(im, size, quality)
}

//* *Group: WebP
// * *Constant: gdWebpLossless
// * *Lossless quality threshold. When image quality is greater than or equal to
// *<gdWebpLossless>, the image will be written in the lossless WebP format.
// * *See also:
// *  - <gdImageWebpEx>
//
fn C.gdImageWebpEx(im GdImagePtr, out_file &C.FILE, quantization int)

pub fn gd_image_webp_ex(im GdImagePtr, out_file &C.FILE, quantization int) {
	C.gdImageWebpEx(im, out_file, quantization)
}

fn C.gdImageWebp(im GdImagePtr, out_file &C.FILE)

pub fn gd_image_webp(im GdImagePtr, out_file &C.FILE) {
	C.gdImageWebp(im, out_file)
}

fn C.gdImageWebpPtr(im GdImagePtr, size &int) voidptr

pub fn gd_image_webp_ptr(im GdImagePtr, size &int) voidptr {
	return C.gdImageWebpPtr(im, size)
}

fn C.gdImageWebpPtrEx(im GdImagePtr, size &int, quantization int) voidptr

pub fn gd_image_webp_ptr_ex(im GdImagePtr, size &int, quantization int) voidptr {
	return C.gdImageWebpPtrEx(im, size, quantization)
}

fn C.gdImageWebpCtx(im GdImagePtr, outfile GdIOCtxPtr, quantization int)

pub fn gd_image_webp_ctx(im GdImagePtr, outfile GdIOCtxPtr, quantization int) {
	C.gdImageWebpCtx(im, outfile, quantization)
}

fn C.gdImageHeifEx(im GdImagePtr, out_file &C.FILE, quality int, codec GdHeifCodec, chroma GdHeifChroma)

pub fn gd_image_heif_ex(im GdImagePtr, out_file &C.FILE, quality int, codec GdHeifCodec, chroma GdHeifChroma) {
	C.gdImageHeifEx(im, out_file, quality, codec, chroma)
}

fn C.gdImageHeif(im GdImagePtr, out_file &C.FILE)

pub fn gd_image_heif(im GdImagePtr, out_file &C.FILE) {
	C.gdImageHeif(im, out_file)
}

fn C.gdImageHeifPtr(im GdImagePtr, size &int) voidptr

pub fn gd_image_heif_ptr(im GdImagePtr, size &int) voidptr {
	return C.gdImageHeifPtr(im, size)
}

fn C.gdImageHeifPtrEx(im GdImagePtr, size &int, quality int, codec GdHeifCodec, chroma GdHeifChroma) voidptr

pub fn gd_image_heif_ptr_ex(im GdImagePtr, size &int, quality int, codec GdHeifCodec, chroma GdHeifChroma) voidptr {
	return C.gdImageHeifPtrEx(im, size, quality, codec, chroma)
}

fn C.gdImageHeifCtx(im GdImagePtr, outfile GdIOCtxPtr, quality int, codec GdHeifCodec, chroma GdHeifChroma)

pub fn gd_image_heif_ctx(im GdImagePtr, outfile GdIOCtxPtr, quality int, codec GdHeifCodec, chroma GdHeifChroma) {
	C.gdImageHeifCtx(im, outfile, quality, codec, chroma)
}

fn C.gdImageAvif(im GdImagePtr, out_file &C.FILE)

pub fn gd_image_avif(im GdImagePtr, out_file &C.FILE) {
	C.gdImageAvif(im, out_file)
}

fn C.gdImageAvifEx(im GdImagePtr, out_file &C.FILE, quality int, speed int)

pub fn gd_image_avif_ex(im GdImagePtr, out_file &C.FILE, quality int, speed int) {
	C.gdImageAvifEx(im, out_file, quality, speed)
}

fn C.gdImageAvifPtr(im GdImagePtr, size &int) voidptr

pub fn gd_image_avif_ptr(im GdImagePtr, size &int) voidptr {
	return C.gdImageAvifPtr(im, size)
}

fn C.gdImageAvifPtrEx(im GdImagePtr, size &int, quality int, speed int) voidptr

pub fn gd_image_avif_ptr_ex(im GdImagePtr, size &int, quality int, speed int) voidptr {
	return C.gdImageAvifPtrEx(im, size, quality, speed)
}

fn C.gdImageAvifCtx(im GdImagePtr, outfile GdIOCtxPtr, quality int, speed int)

pub fn gd_image_avif_ctx(im GdImagePtr, outfile GdIOCtxPtr, quality int, speed int) {
	C.gdImageAvifCtx(im, outfile, quality, speed)
}

//* *Group: GifAnim
// * *  Legal values for Disposal. gdDisposalNone is always used by
// *  the built-in optimizer if previm is passed.
// * *Constants: gdImageGifAnim
// * *  gdDisposalUnknown              - Not recommended
// *  gdDisposalNone                 - Preserve previous frame
// *  gdDisposalRestoreBackground    - First allocated color of palette
// *  gdDisposalRestorePrevious      - Restore to before start of frame
// * *See also:
// *  - <gdImageGifAnimAdd>
//

// empty enum

const gd_disposal_unknown = 1
const gd_disposal_none = 2
const gd_disposal_restore_background = 3
const gd_disposal_restore_previous = 4

fn C.gdImageGifAnimBegin(im GdImagePtr, out_file &C.FILE, global_cm int, loops int)

pub fn gd_image_gif_anim_begin(im GdImagePtr, out_file &C.FILE, global_cm int, loops int) {
	C.gdImageGifAnimBegin(im, out_file, global_cm, loops)
}

fn C.gdImageGifAnimAdd(im GdImagePtr, out_file &C.FILE, local_cm int, left_ofs int, top_ofs int, delay int, disposal int, previm GdImagePtr)

pub fn gd_image_gif_anim_add(im GdImagePtr, out_file &C.FILE, local_cm int, left_ofs int, top_ofs int, delay int, disposal int, previm GdImagePtr) {
	C.gdImageGifAnimAdd(im, out_file, local_cm, left_ofs, top_ofs, delay, disposal, previm)
}

fn C.gdImageGifAnimEnd(out_file &C.FILE)

pub fn gd_image_gif_anim_end(out_file &C.FILE) {
	C.gdImageGifAnimEnd(out_file)
}

fn C.gdImageGifAnimBeginCtx(im GdImagePtr, out GdIOCtxPtr, global_cm int, loops int)

pub fn gd_image_gif_anim_begin_ctx(im GdImagePtr, out GdIOCtxPtr, global_cm int, loops int) {
	C.gdImageGifAnimBeginCtx(im, out, global_cm, loops)
}

fn C.gdImageGifAnimAddCtx(im GdImagePtr, out GdIOCtxPtr, local_cm int, left_ofs int, top_ofs int, delay int, disposal int, previm GdImagePtr)

pub fn gd_image_gif_anim_add_ctx(im GdImagePtr, out GdIOCtxPtr, local_cm int, left_ofs int, top_ofs int, delay int, disposal int, previm GdImagePtr) {
	C.gdImageGifAnimAddCtx(im, out, local_cm, left_ofs, top_ofs, delay, disposal, previm)
}

fn C.gdImageGifAnimEndCtx(out GdIOCtxPtr)

pub fn gd_image_gif_anim_end_ctx(out GdIOCtxPtr) {
	C.gdImageGifAnimEndCtx(out)
}

fn C.gdImageGifAnimBeginPtr(im GdImagePtr, size &int, global_cm int, loops int) voidptr

pub fn gd_image_gif_anim_begin_ptr(im GdImagePtr, size &int, global_cm int, loops int) voidptr {
	return C.gdImageGifAnimBeginPtr(im, size, global_cm, loops)
}

fn C.gdImageGifAnimAddPtr(im GdImagePtr, size &int, local_cm int, left_ofs int, top_ofs int, delay int, disposal int, previm GdImagePtr) voidptr

pub fn gd_image_gif_anim_add_ptr(im GdImagePtr, size &int, local_cm int, left_ofs int, top_ofs int, delay int, disposal int, previm GdImagePtr) voidptr {
	return C.gdImageGifAnimAddPtr(im, size, local_cm, left_ofs, top_ofs, delay, disposal,
		previm)
}

fn C.gdImageGifAnimEndPtr(size &int) voidptr

pub fn gd_image_gif_anim_end_ptr(size &int) voidptr {
	return C.gdImageGifAnimEndPtr(size)
}

//
//  Group: Types
//
//  typedef: gdSink
//
//  typedef: gdSinkPtr
//
//    *ote:*This interface is *bsolete*and kept only for
//    *ompatibility*  Use <gdIOCtx> instead.
//
//    Represents a "sink" (destination) to which a PNG can be
//    written. Programmers who do not wish to write PNGs to a file can
//    provide their own alternate output mechanism, using the
//    <gdImagePngToSink> function. See the documentation of that
//    function for an example of the proper use of this type.
//
//    > typedef struct {
//    >     int (*ink) (void *ontext, char *uffer, int len);
//    >     void *ontext;
//    > } gdSink, *dSinkPtr;
//
//    The _sink_ function must return -1 on error, otherwise the number of
//    bytes written, which must be equal to len.
//
//    _context_ will be passed to your sink function.
//
//
struct GdSink {
	sink    fn (voidptr, &i8, int) int
	context voidptr
}

type GdSinkPtr = voidptr

fn C.gdImagePngToSink(im GdImagePtr, out GdSinkPtr)

pub fn gd_image_png_to_sink(im GdImagePtr, out GdSinkPtr) {
	C.gdImagePngToSink(im, out)
}

fn C.gdImageGd(im GdImagePtr, out &C.FILE)

pub fn gd_image_gd(im GdImagePtr, out &C.FILE) {
	C.gdImageGd(im, out)
}

fn C.gdImageGd2(im GdImagePtr, out &C.FILE, cs int, fmt int)

pub fn gd_image_gd2(im GdImagePtr, out &C.FILE, cs int, fmt int) {
	C.gdImageGd2(im, out, cs, fmt)
}

// Best to free this memory with gdFree(), not free()
fn C.gdImageGifPtr(im GdImagePtr, size &int) voidptr

pub fn gd_image_gif_ptr(im GdImagePtr, size &int) voidptr {
	return C.gdImageGifPtr(im, size)
}

// Best to free this memory with gdFree(), not free()
fn C.gdImagePngPtr(im GdImagePtr, size &int) voidptr

pub fn gd_image_png_ptr(im GdImagePtr, size &int) voidptr {
	return C.gdImagePngPtr(im, size)
}

fn C.gdImagePngPtrEx(im GdImagePtr, size &int, level int) voidptr

pub fn gd_image_png_ptr_ex(im GdImagePtr, size &int, level int) voidptr {
	return C.gdImagePngPtrEx(im, size, level)
}

// Best to free this memory with gdFree(), not free()
fn C.gdImageGdPtr(im GdImagePtr, size &int) voidptr

pub fn gd_image_gd_ptr(im GdImagePtr, size &int) voidptr {
	return C.gdImageGdPtr(im, size)
}

// Best to free this memory with gdFree(), not free()
fn C.gdImageGd2Ptr(im GdImagePtr, cs int, fmt int, size &int) voidptr

pub fn gd_image_gd2_ptr(im GdImagePtr, cs int, fmt int, size &int) voidptr {
	return C.gdImageGd2Ptr(im, cs, fmt, size)
}

// Style is a bitwise OR ( | operator ) of these.
//   gdArc and gdChord are mutually exclusive;
//   gdChord just connects the starting and ending
//   angles with a straight line, while gdArc produces
//   a rounded edge. gdPie is a synonym for gdArc.
//   gdNoFill indicates that the arc or chord should be
//   outlined, not filled. gdEdged, used together with
//   gdNoFill, indicates that the beginning and ending
//   angles should be connected to the center; this is
//   a good way to outline (rather than fill) a
//   'pie slice'.
fn C.gdImageFilledArc(im GdImagePtr, cx int, cy int, w int, h int, s int, e int, color int, style int)

pub fn gd_image_filled_arc(im GdImagePtr, cx int, cy int, w int, h int, s int, e int, color int, style int) {
	C.gdImageFilledArc(im, cx, cy, w, h, s, e, color, style)
}

fn C.gdImageArc(im GdImagePtr, cx int, cy int, w int, h int, s int, e int, color int)

pub fn gd_image_arc(im GdImagePtr, cx int, cy int, w int, h int, s int, e int, color int) {
	C.gdImageArc(im, cx, cy, w, h, s, e, color)
}

fn C.gdImageEllipse(im GdImagePtr, cx int, cy int, w int, h int, color int)

pub fn gd_image_ellipse(im GdImagePtr, cx int, cy int, w int, h int, color int) {
	C.gdImageEllipse(im, cx, cy, w, h, color)
}

fn C.gdImageFilledEllipse(im GdImagePtr, cx int, cy int, w int, h int, color int)

pub fn gd_image_filled_ellipse(im GdImagePtr, cx int, cy int, w int, h int, color int) {
	C.gdImageFilledEllipse(im, cx, cy, w, h, color)
}

fn C.gdImageFillToBorder(im GdImagePtr, x int, y int, border int, color int)

pub fn gd_image_fill_to_border(im GdImagePtr, x int, y int, border int, color int) {
	C.gdImageFillToBorder(im, x, y, border, color)
}

fn C.gdImageFill(im GdImagePtr, x int, y int, color int)

pub fn gd_image_fill(im GdImagePtr, x int, y int, color int) {
	C.gdImageFill(im, x, y, color)
}

fn C.gdImageCopy(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, w int, h int)

pub fn gd_image_copy(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, w int, h int) {
	C.gdImageCopy(dst, src, dst_x, dst_y, src_x, src_y, w, h)
}

fn C.gdImageCopyMerge(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, w int, h int, pct int)

pub fn gd_image_copy_merge(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, w int, h int, pct int) {
	C.gdImageCopyMerge(dst, src, dst_x, dst_y, src_x, src_y, w, h, pct)
}

fn C.gdImageCopyMergeGray(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, w int, h int, pct int)

pub fn gd_image_copy_merge_gray(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, w int, h int, pct int) {
	C.gdImageCopyMergeGray(dst, src, dst_x, dst_y, src_x, src_y, w, h, pct)
}

// Stretches or shrinks to fit, as needed. Does NOT attempt
//   to average the entire set of source pixels that scale down onto the
//   destination pixel.
fn C.gdImageCopyResized(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, dst_w int, dst_h int, src_w int, src_h int)

pub fn gd_image_copy_resized(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, dst_w int, dst_h int, src_w int, src_h int) {
	C.gdImageCopyResized(dst, src, dst_x, dst_y, src_x, src_y, dst_w, dst_h, src_w, src_h)
}

// gd 2.0: stretches or shrinks to fit, as needed. When called with a
//   truecolor destination image, this function averages the
//   entire set of source pixels that scale down onto the
//   destination pixel, taking into account what portion of the
//   destination pixel each source pixel represents. This is a
//   floating point operation, but this is not a performance issue
//   on modern hardware, except for some embedded devices. If the
//   destination is a palette image, gdImageCopyResized is
//   substituted automatically.
fn C.gdImageCopyResampled(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, dst_w int, dst_h int, src_w int, src_h int)

pub fn gd_image_copy_resampled(dst GdImagePtr, src GdImagePtr, dst_x int, dst_y int, src_x int, src_y int, dst_w int, dst_h int, src_w int, src_h int) {
	C.gdImageCopyResampled(dst, src, dst_x, dst_y, src_x, src_y, dst_w, dst_h, src_w,
		src_h)
}

// gd 2.0.8: gdImageCopyRotated is added. Source
//   is a rectangle, with its upper left corner at
//   srcX and srcY. Destination is the *enter*of
//   the rotated copy. Angle is in degrees, same as
//   gdImageArc. Floating point destination center
//   coordinates allow accurate rotation of
//   objects of odd-numbered width or height.
fn C.gdImageCopyRotated(dst GdImagePtr, src GdImagePtr, dst_x f64, dst_y f64, src_x int, src_y int, src_width int, src_height int, angle int)

pub fn gd_image_copy_rotated(dst GdImagePtr, src GdImagePtr, dst_x f64, dst_y f64, src_x int, src_y int, src_width int, src_height int, angle int) {
	C.gdImageCopyRotated(dst, src, dst_x, dst_y, src_x, src_y, src_width, src_height,
		angle)
}

fn C.gdImageClone(src GdImagePtr) GdImagePtr

pub fn gd_image_clone(src GdImagePtr) GdImagePtr {
	return C.gdImageClone(src)
}

fn C.gdImageSetBrush(im GdImagePtr, brush GdImagePtr)

pub fn gd_image_set_brush(im GdImagePtr, brush GdImagePtr) {
	C.gdImageSetBrush(im, brush)
}

fn C.gdImageSetTile(im GdImagePtr, tile GdImagePtr)

pub fn gd_image_set_tile(im GdImagePtr, tile GdImagePtr) {
	C.gdImageSetTile(im, tile)
}

fn C.gdImageSetAntiAliased(im GdImagePtr, c int)

pub fn gd_image_set_anti_aliased(im GdImagePtr, c int) {
	C.gdImageSetAntiAliased(im, c)
}

fn C.gdImageSetAntiAliasedDontBlend(im GdImagePtr, c int, dont_blend int)

pub fn gd_image_set_anti_aliased_dont_blend(im GdImagePtr, c int, dont_blend int) {
	C.gdImageSetAntiAliasedDontBlend(im, c, dont_blend)
}

fn C.gdImageSetStyle(im GdImagePtr, style &int, no_of_pixels int)

pub fn gd_image_set_style(im GdImagePtr, style &int, no_of_pixels int) {
	C.gdImageSetStyle(im, style, no_of_pixels)
}

// Line thickness (defaults to 1). Affects lines, ellipses,
//   rectangles, polygons and so forth.
fn C.gdImageSetThickness(im GdImagePtr, thickness int)

pub fn gd_image_set_thickness(im GdImagePtr, thickness int) {
	C.gdImageSetThickness(im, thickness)
}

// On or off (1 or 0) for all three of these.
fn C.gdImageInterlace(im GdImagePtr, interlace_arg int)

pub fn gd_image_interlace(im GdImagePtr, interlace_arg int) {
	C.gdImageInterlace(im, interlace_arg)
}

fn C.gdImageAlphaBlending(im GdImagePtr, alpha_blending_arg int)

pub fn gd_image_alpha_blending(im GdImagePtr, alpha_blending_arg int) {
	C.gdImageAlphaBlending(im, alpha_blending_arg)
}

fn C.gdImageSaveAlpha(im GdImagePtr, save_alpha_arg int)

pub fn gd_image_save_alpha(im GdImagePtr, save_alpha_arg int) {
	C.gdImageSaveAlpha(im, save_alpha_arg)
}

fn C.gdImageNeuQuant(im GdImagePtr, max_color int, sample_factor int) GdImagePtr

pub fn gd_image_neu_quant(im GdImagePtr, max_color int, sample_factor int) GdImagePtr {
	return C.gdImageNeuQuant(im, max_color, sample_factor)
}

enum GdPixelateMode {
	gd_pixelate_upperleft
	gd_pixelate_average
}

fn C.gdImagePixelate(im GdImagePtr, block_size int, mode u32) int

pub fn gd_image_pixelate(im GdImagePtr, block_size int, mode u32) int {
	return C.gdImagePixelate(im, block_size, mode)
}

struct GdScatter {
	sub        int
	plus       int
	num_colors u32
	colors     &int
	seed       u32
}

type GdScatterPtr = voidptr

fn C.gdImageScatter(im GdImagePtr, sub int, plus int) int

pub fn gd_image_scatter(im GdImagePtr, sub int, plus int) int {
	return C.gdImageScatter(im, sub, plus)
}

fn C.gdImageScatterColor(im GdImagePtr, sub int, plus int, colors &int, num_colors u32) int

pub fn gd_image_scatter_color(im GdImagePtr, sub int, plus int, colors &int, num_colors u32) int {
	return C.gdImageScatterColor(im, sub, plus, colors, num_colors)
}

fn C.gdImageScatterEx(im GdImagePtr, s GdScatterPtr) int

pub fn gd_image_scatter_ex(im GdImagePtr, s GdScatterPtr) int {
	return C.gdImageScatterEx(im, s)
}

fn C.gdImageSmooth(im GdImagePtr, weight f32) int

pub fn gd_image_smooth(im GdImagePtr, weight f32) int {
	return C.gdImageSmooth(im, weight)
}

fn C.gdImageMeanRemoval(im GdImagePtr) int

pub fn gd_image_mean_removal(im GdImagePtr) int {
	return C.gdImageMeanRemoval(im)
}

fn C.gdImageEmboss(im GdImagePtr) int

pub fn gd_image_emboss(im GdImagePtr) int {
	return C.gdImageEmboss(im)
}

fn C.gdImageGaussianBlur(im GdImagePtr) int

pub fn gd_image_gaussian_blur(im GdImagePtr) int {
	return C.gdImageGaussianBlur(im)
}

fn C.gdImageEdgeDetectQuick(src GdImagePtr) int

pub fn gd_image_edge_detect_quick(src GdImagePtr) int {
	return C.gdImageEdgeDetectQuick(src)
}

fn C.gdImageSelectiveBlur(src GdImagePtr) int

pub fn gd_image_selective_blur(src GdImagePtr) int {
	return C.gdImageSelectiveBlur(src)
}

fn C.gdImageConvolution(src GdImagePtr, filter [3]fn () f32, filter_div f32, offset f32) int

pub fn gd_image_convolution(src GdImagePtr, filter [3]fn () f32, filter_div f32, offset f32) int {
	return C.gdImageConvolution(src, filter, filter_div, offset)
}

fn C.gdImageColor(src GdImagePtr, red int, green int, blue int, alpha int) int

pub fn gd_image_color(src GdImagePtr, red int, green int, blue int, alpha int) int {
	return C.gdImageColor(src, red, green, blue, alpha)
}

fn C.gdImageContrast(src GdImagePtr, contrast f64) int

pub fn gd_image_contrast(src GdImagePtr, contrast f64) int {
	return C.gdImageContrast(src, contrast)
}

fn C.gdImageBrightness(src GdImagePtr, brightness int) int

pub fn gd_image_brightness(src GdImagePtr, brightness int) int {
	return C.gdImageBrightness(src, brightness)
}

fn C.gdImageGrayScale(src GdImagePtr) int

pub fn gd_image_gray_scale(src GdImagePtr) int {
	return C.gdImageGrayScale(src)
}

fn C.gdImageNegate(src GdImagePtr) int

pub fn gd_image_negate(src GdImagePtr) int {
	return C.gdImageNegate(src)
}

fn C.gdImageCopyGaussianBlurred(src GdImagePtr, radius int, sigma f64) GdImagePtr

pub fn gd_image_copy_gaussian_blurred(src GdImagePtr, radius int, sigma f64) GdImagePtr {
	return C.gdImageCopyGaussianBlurred(src, radius, sigma)
}

//* *Group: Accessor Macros
//
//* *Macro: gdImageTrueColor
// * *Whether an image is a truecolor image.
// * *Parameters:
// *  im - The image.
// * *Returns:
// *  Non-zero if the image is a truecolor image, zero for palette images.
//
//* *Macro: gdImageSX
// * *Gets the width (in pixels) of an image.
// * *Parameters:
// *  im - The image.
//
//* *Macro: gdImageSY
// * *Gets the height (in pixels) of an image.
// * *Parameters:
// *  im - The image.
//
//* *Macro: gdImageColorsTotal
// * *Gets the number of colors in the palette.
// * *This macro is only valid for palette images.
// * *Parameters:
// *  im - The image
//
//* *Macro: gdImageRed
// * *Gets the red component value of a given color.
// * *Parameters:
// *  im - The image.
// *  c  - The color.
//
//* *Macro: gdImageGreen
// * *Gets the green component value of a given color.
// * *Parameters:
// *  im - The image.
// *  c  - The color.
//
//* *Macro: gdImageBlue
// * *Gets the blue component value of a given color.
// * *Parameters:
// *  im - The image.
// *  c  - The color.
//
//* *Macro: gdImageAlpha
// * *Gets the alpha component value of a given color.
// * *Parameters:
// *  im - The image.
// *  c  - The color.
//
//* *Macro: gdImageGetTransparent
// * *Gets the transparent color of the image.
// * *Parameters:
// *  im - The image.
// * *See also:
// *  - <gdImageColorTransparent>
//
//* *Macro: gdImageGetInterlaced
// * *Whether an image is interlaced.
// * *Parameters:
// *  im - The image.
// * *Returns:
// *  Non-zero for interlaced images, zero otherwise.
// * *See also:
// *  - <gdImageInterlace>
//
//* *Macro: gdImagePalettePixel
// * *Gets the color of a pixel.
// * *Calling this macro is only valid for palette images.
// *No bounds checking is done for the coordinates.
// * *Parameters:
// *  im - The image.
// *  x  - The x-coordinate.
// *  y  - The y-coordinate.
// * *See also:
// *  - <gdImageTrueColorPixel>
// *  - <gdImageGetPixel>
//
//* *Macro: gdImageTrueColorPixel
// * *Gets the color of a pixel.
// * *Calling this macro is only valid for truecolor images.
// *No bounds checking is done for the coordinates.
// * *Parameters:
// *  im - The image.
// *  x  - The x-coordinate.
// *  y  - The y-coordinate.
// * *See also:
// *  - <gdImagePalettePixel>
// *  - <gdImageGetTrueColorPixel>
//
//* *Macro: gdImageResolutionX
// * *Gets the horizontal resolution in DPI.
// * *Parameters:
// *  im - The image.
// * *See also:
// *  - <gdImageResolutionY>
// *  - <gdImageSetResolution>
//
//* *Macro: gdImageResolutionY
// * *Gets the vertical resolution in DPI.
// * *Parameters:
// *  im - The image.
// * *See also:
// *  - <gdImageResolutionX>
// *  - <gdImageSetResolution>
//
// I/O Support routines.
fn C.gdNewFileCtx(arg0 &C.FILE) GdIOCtxPtr

pub fn gd_new_file_ctx(arg0 &C.FILE) GdIOCtxPtr {
	return C.gdNewFileCtx(arg0)
}

// If data is null, size is ignored and an initial data buffer is
//   allocated automatically. NOTE: this function assumes gd has the right
//   to free or reallocate "data" at will! Also note that gd will free
//   "data" when the IO context is freed. If data is not null, it must point
//   to memory allocated with gdMalloc, or by a call to gdImage[something]Ptr.
//   If not, see gdNewDynamicCtxEx for an alternative.
fn C.gdNewDynamicCtx(size int, data voidptr) GdIOCtxPtr

pub fn gd_new_dynamic_ctx(size int, data voidptr) GdIOCtxPtr {
	return C.gdNewDynamicCtx(size, data)
}

// 2.0.21: if freeFlag is nonzero, gd will free and/or reallocate "data" as
//   needed as described above. If freeFlag is zero, gd will never free
//   or reallocate "data", which means that the context should only be used
//   for *eading*an image from a memory buffer, or writing an image to a
//   memory buffer which is already large enough. If the memory buffer is
//   not large enough and an image write is attempted, the write operation
//   will fail. Those wishing to write an image to a buffer in memory have
//   a much simpler alternative in the gdImage[something]Ptr functions.
fn C.gdNewDynamicCtxEx(size int, data voidptr, free_flag int) GdIOCtxPtr

pub fn gd_new_dynamic_ctx_ex(size int, data voidptr, free_flag int) GdIOCtxPtr {
	return C.gdNewDynamicCtxEx(size, data, free_flag)
}

fn C.gdNewSSCtx(in_ GdSourcePtr, out GdSinkPtr) GdIOCtxPtr

pub fn gd_new_ssc_tx(in_ GdSourcePtr, out GdSinkPtr) GdIOCtxPtr {
	return C.gdNewSSCtx(in_, out)
}

fn C.gdDPExtractData(ctx GdIOCtxPtr, size &int) voidptr

pub fn gd_dpe_xtract_data(ctx GdIOCtxPtr, size &int) voidptr {
	return C.gdDPExtractData(ctx, size)
}

// Image comparison definitions
fn C.gdImageCompare(im1 GdImagePtr, im2 GdImagePtr) int

pub fn gd_image_compare(im1 GdImagePtr, im2 GdImagePtr) int {
	return C.gdImageCompare(im1, im2)
}

fn C.gdImageFlipHorizontal(im GdImagePtr)

pub fn gd_image_flip_horizontal(im GdImagePtr) {
	C.gdImageFlipHorizontal(im)
}

fn C.gdImageFlipVertical(im GdImagePtr)

pub fn gd_image_flip_vertical(im GdImagePtr) {
	C.gdImageFlipVertical(im)
}

fn C.gdImageFlipBoth(im GdImagePtr)

pub fn gd_image_flip_both(im GdImagePtr) {
	C.gdImageFlipBoth(im)
}

// Macros still used in gd extension up to PHP 8.0
//   so please keep these unused macros for now
// typo, kept for BC
//* *Group: Crop
// * *Constants: gdCropMode
// * GD_CROP_DEFAULT     - Same as GD_CROP_TRANSPARENT
// * GD_CROP_TRANSPARENT - Crop using the transparent color
// * GD_CROP_BLACK       - Crop black borders
// * GD_CROP_WHITE       - Crop white borders
// * GD_CROP_SIDES       - Crop using colors of the 4 corners
// * *See also:
// *  - <gdImageCropAuto>
// */
// enum gdCropMode {
//	GD_CROP_DEFAULT = 0,
//	GD_CROP_TRANSPARENT,
//	GD_CROP_BLACK,
//	GD_CROP_WHITE,
//	GD_CROP_SIDES,
//	GD_CROP_THRESHOLD
//};
//
// BGD_DECLARE(gdImagePtr) gdImageCrop(gdImagePtr src, const gdRect *rop);
// BGD_DECLARE(gdImagePtr) gdImageCropAuto(gdImagePtr im, const unsigned int mode);
// BGD_DECLARE(gdImagePtr) gdImageCropThreshold(gdImagePtr im, const unsigned int color, const float threshold);
//
// BGD_DECLARE(int) gdImageSetInterpolationMethod(gdImagePtr im, gdInterpolationMethod id);
// BGD_DECLARE(gdInterpolationMethod) gdImageGetInterpolationMethod(gdImagePtr im);
//
// BGD_DECLARE(gdImagePtr) gdImageScale(const gdImagePtr src, const unsigned int new_width, const unsigned int new_height);
//
// BGD_DECLARE(gdImagePtr) gdImageRotateInterpolated(const gdImagePtr src, const float angle, int bgcolor);
//
// typedef enum {
//	GD_AFFINE_TRANSLATE = 0,
//	GD_AFFINE_SCALE,
//	GD_AFFINE_ROTATE,
//	GD_AFFINE_SHEAR_HORIZONTAL,
//	GD_AFFINE_SHEAR_VERTICAL
//} gdAffineStandardMatrix;
//
// BGD_DECLARE(int) gdAffineApplyToPointF (gdPointFPtr dst, const gdPointFPtr src, const double affine[6]);
// BGD_DECLARE(int) gdAffineInvert (double dst[6], const double src[6]);
// BGD_DECLARE(int) gdAffineFlip (double dst_affine[6], const double src_affine[6], const int flip_h, const int flip_v);
// BGD_DECLARE(int) gdAffineConcat (double dst[6], const double m1[6], const double m2[6]);
//
// BGD_DECLARE(int) gdAffineIdentity (double dst[6]);
// BGD_DECLARE(int) gdAffineScale (double dst[6], const double scale_x, const double scale_y);
// BGD_DECLARE(int) gdAffineRotate (double dst[6], const double angle);
// BGD_DECLARE(int) gdAffineShearHorizontal (double dst[6], const double angle);
// BGD_DECLARE(int) gdAffineShearVertical(double dst[6], const double angle);
// BGD_DECLARE(int) gdAffineTranslate (double dst[6], const double offset_x, const double offset_y);
// BGD_DECLARE(double) gdAffineExpansion (const double src[6]);
// BGD_DECLARE(int) gdAffineRectilinear (const double src[6]);
// BGD_DECLARE(int) gdAffineEqual (const double matrix1[6], const double matrix2[6]);
// BGD_DECLARE(int) gdTransformAffineGetImage(gdImagePtr *st, const gdImagePtr src, gdRectPtr src_area, const double affine[6]);
// BGD_DECLARE(int) gdTransformAffineCopy(gdImagePtr dst, int dst_x, int dst_y, const gdImagePtr src, gdRectPtr src_region, const double affine[6]);
///*gdTransformAffineCopy(gdImagePtr dst, int x0, int y0, int x1, int y1,
//		      const gdImagePtr src, int src_width, int src_height,
//		      const double affine[6]);
//
enum GdCropMode {
	gd_crop_default = 0
	gd_crop_transparent
	gd_crop_black
	gd_crop_white
	gd_crop_sides
	gd_crop_threshold
}

fn C.gdImageCrop(src GdImagePtr, crop &GdRect) GdImagePtr

pub fn gd_image_crop(src GdImagePtr, crop &GdRect) GdImagePtr {
	return C.gdImageCrop(src, crop)
}

fn C.gdImageCropAuto(im GdImagePtr, mode u32) GdImagePtr

pub fn gd_image_crop_auto(im GdImagePtr, mode u32) GdImagePtr {
	return C.gdImageCropAuto(im, mode)
}

fn C.gdImageCropThreshold(im GdImagePtr, color u32, threshold f32) GdImagePtr

pub fn gd_image_crop_threshold(im GdImagePtr, color u32, threshold f32) GdImagePtr {
	return C.gdImageCropThreshold(im, color, threshold)
}

fn C.gdImageSetInterpolationMethod(im GdImagePtr, id GdInterpolationMethod) int

pub fn gd_image_set_interpolation_method(im GdImagePtr, id GdInterpolationMethod) int {
	return C.gdImageSetInterpolationMethod(im, id)
}

fn C.gdImageGetInterpolationMethod(im GdImagePtr) GdInterpolationMethod

pub fn gd_image_get_interpolation_method(im GdImagePtr) GdInterpolationMethod {
	return C.gdImageGetInterpolationMethod(im)
}

fn C.gdImageScale(src GdImagePtr, new_width u32, new_height u32) GdImagePtr

pub fn gd_image_scale(src GdImagePtr, new_width u32, new_height u32) GdImagePtr {
	return C.gdImageScale(src, new_width, new_height)
}

fn C.gdImageRotateInterpolated(src GdImagePtr, angle f32, bgcolor int) GdImagePtr

pub fn gd_image_rotate_interpolated(src GdImagePtr, angle f32, bgcolor int) GdImagePtr {
	return C.gdImageRotateInterpolated(src, angle, bgcolor)
}

enum GdAffineStandardMatrix {
	gd_affine_translate = 0
	gd_affine_scale
	gd_affine_rotate
	gd_affine_shear_horizontal
	gd_affine_shear_vertical
}

fn C.gdAffineApplyToPointF(dst GdPointFPtr, src GdPointFPtr, affine &f64) int

pub fn gd_affine_apply_to_point_f(dst GdPointFPtr, src GdPointFPtr, affine &f64) int {
	return C.gdAffineApplyToPointF(dst, src, affine)
}

fn C.gdAffineInvert(dst &f64, src &f64) int

pub fn gd_affine_invert(dst &f64, src &f64) int {
	return C.gdAffineInvert(dst, src)
}

fn C.gdAffineFlip(dst_affine &f64, src_affine &f64, flip_h int, flip_v int) int

pub fn gd_affine_flip(dst_affine &f64, src_affine &f64, flip_h int, flip_v int) int {
	return C.gdAffineFlip(dst_affine, src_affine, flip_h, flip_v)
}

fn C.gdAffineConcat(dst &f64, m1 &f64, m2 &f64) int

pub fn gd_affine_concat(dst &f64, m1 &f64, m2 &f64) int {
	return C.gdAffineConcat(dst, m1, m2)
}

fn C.gdAffineIdentity(dst &f64) int

pub fn gd_affine_identity(dst &f64) int {
	return C.gdAffineIdentity(dst)
}

fn C.gdAffineScale(dst &f64, scale_x f64, scale_y f64) int

pub fn gd_affine_scale(dst &f64, scale_x f64, scale_y f64) int {
	return C.gdAffineScale(dst, scale_x, scale_y)
}

fn C.gdAffineRotate(dst &f64, angle f64) int

pub fn gd_affine_rotate(dst &f64, angle f64) int {
	return C.gdAffineRotate(dst, angle)
}

fn C.gdAffineShearHorizontal(dst &f64, angle f64) int

pub fn gd_affine_shear_horizontal(dst &f64, angle f64) int {
	return C.gdAffineShearHorizontal(dst, angle)
}

fn C.gdAffineShearVertical(dst &f64, angle f64) int

pub fn gd_affine_shear_vertical(dst &f64, angle f64) int {
	return C.gdAffineShearVertical(dst, angle)
}

fn C.gdAffineTranslate(dst &f64, offset_x f64, offset_y f64) int

pub fn gd_affine_translate(dst &f64, offset_x f64, offset_y f64) int {
	return C.gdAffineTranslate(dst, offset_x, offset_y)
}

fn C.gdAffineExpansion(src &f64) f64

pub fn gd_affine_expansion(src &f64) f64 {
	return C.gdAffineExpansion(src)
}

fn C.gdAffineRectilinear(src &f64) int

pub fn gd_affine_rectilinear(src &f64) int {
	return C.gdAffineRectilinear(src)
}

fn C.gdAffineEqual(matrix1 &f64, matrix2 &f64) int

pub fn gd_affine_equal(matrix1 &f64, matrix2 &f64) int {
	return C.gdAffineEqual(matrix1, matrix2)
}

fn C.gdTransformAffineGetImage(dst &GdImagePtr, src GdImagePtr, src_area GdRectPtr, affine &f64) int

pub fn gd_transform_affine_get_image(dst &GdImagePtr, src GdImagePtr, src_area GdRectPtr, affine &f64) int {
	return C.gdTransformAffineGetImage(dst, src, src_area, affine)
}

fn C.gdTransformAffineCopy(dst GdImagePtr, dst_x int, dst_y int, src GdImagePtr, src_region GdRectPtr, affine &f64) int

pub fn gd_transform_affine_copy(dst GdImagePtr, dst_x int, dst_y int, src GdImagePtr, src_region GdRectPtr, affine &f64) int {
	return C.gdTransformAffineCopy(dst, dst_x, dst_y, src, src_region, affine)
}

fn C.gdTransformAffineBoundingBox(src GdRectPtr, affine &f64, bbox GdRectPtr) int

pub fn gd_transform_affine_bounding_box(src GdRectPtr, affine &f64, bbox GdRectPtr) int {
	return C.gdTransformAffineBoundingBox(src, affine, bbox)
}

//* *Group: Image Comparison
// * *Constants:
// *  GD_CMP_IMAGE       - Actual image IS different
// *  GD_CMP_NUM_COLORS  - Number of colors in pallette differ
// *  GD_CMP_COLOR       - Image colors differ
// *  GD_CMP_SIZE_X      - Image width differs
// *  GD_CMP_SIZE_Y      - Image heights differ
// *  GD_CMP_TRANSPARENT - Transparent color differs
// *  GD_CMP_BACKGROUND  - Background color differs
// *  GD_CMP_INTERLACE   - Interlaced setting differs
// *  GD_CMP_TRUECOLOR   - Truecolor vs palette differs
// * *See also:
// *  - <gdImageCompare>
//
// resolution affects ttf font rendering, particularly hinting
// pixels per inch
// Version information functions
fn C.gdMajorVersion() int

pub fn gd_major_version() int {
	return C.gdMajorVersion()
}

fn C.gdMinorVersion() int

pub fn gd_minor_version() int {
	return C.gdMinorVersion()
}

fn C.gdReleaseVersion() int

pub fn gd_release_version() int {
	return C.gdReleaseVersion()
}

fn C.gdExtraVersion() &i8

pub fn gd_extra_version() &i8 {
	return C.gdExtraVersion()
}

fn C.gdVersionString() &i8

pub fn gd_version_string() &i8 {
	return C.gdVersionString()
}

// newfangled special effects
// GD_H
// GDFX_H
