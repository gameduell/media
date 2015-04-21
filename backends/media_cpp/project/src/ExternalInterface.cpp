#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#include <hx/CFFI.h>
#include <types/NativeData.h>

#include "lodepng.h"

#include <stdio.h>
#include <stdlib.h>

static bool _hasAlpha;
static bool _hasPremultipliedAlpha;
static unsigned int _width;
static unsigned int _height;
static unsigned int _pixelFormat; // 0 = RGBA8888, 1 = RGB565, 2 = A8

static value media_cpp_loadBitmap(value imageData, value nativeData)
{
    NativeData* ptrIn = ((NativeData*)val_data(imageData));
    NativeData* ptrOut = ((NativeData*)val_data(nativeData));

    unsigned error;

    unsigned char* image;
    unsigned width, height;

    unsigned char* png = ptrIn->ptr;
    size_t pngsize = ptrIn->allocedLength;

    LodePNGState state;
    lodepng_state_init(&state);
    state.info_raw.colortype = LCT_RGBA;
    state.info_raw.bitdepth = 8;

    error = lodepng_decode(&image, &width, &height, &state, png, pngsize);

    if(error)
     {
        lodepng_state_cleanup(&state);
        printf("error %u: %s\n", error, lodepng_error_text(error));
        return alloc_bool(false);
     }

    _width = width;
    _height = height;
    _pixelFormat = 0;

    const LodePNGColorMode color = state.info_png.color;

    if (lodepng_is_alpha_type(&color))
    {
        _hasAlpha = true;
        _hasPremultipliedAlpha = true;
    }
    else
    {
         _hasAlpha = false;
         _hasPremultipliedAlpha = false;
    }

    lodepng_state_cleanup(&state);

	ptrOut->ptr = (uint8_t*)image;
    ptrOut->allocedLength = width * height * 4;
    ptrOut->offsetLength = width * height * 4;

	return alloc_bool(true);
}
DEFINE_PRIM (media_cpp_loadBitmap, 2);


static value media_cpp_getWidth()
{
    return alloc_int(_width);
}
DEFINE_PRIM (media_cpp_getWidth, 0);


static value media_cpp_getHeight()
{
    return alloc_int(_height);
}
DEFINE_PRIM (media_cpp_getHeight, 0);


static value media_cpp_hasAlpha()
{
    return alloc_bool(_hasAlpha);
}
DEFINE_PRIM (media_cpp_hasAlpha, 0);


static value media_cpp_hasPremultipliedAlpha()
{
    return alloc_bool(_hasPremultipliedAlpha);
}
DEFINE_PRIM (media_cpp_hasPremultipliedAlpha, 0);


static value media_cpp_getPixelFormat()
{
    return alloc_int(_pixelFormat);
}
DEFINE_PRIM (media_cpp_getPixelFormat, 0);


/// OTHER
extern "C" void media_cpp_main ()
{
	val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT (media_cpp_main);


extern "C" int media_cpp_register_prims () { return 0; }