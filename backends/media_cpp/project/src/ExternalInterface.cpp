#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#include <hx/CFFI.h>
#include <types/NativeData.h>

#include "lodepng.h"
#include "jpgd.h"

static bool _hasAlpha;
static bool _hasPremultipliedAlpha;
static unsigned int _width;
static unsigned int _height;
static unsigned int _pixelFormat; // 0 = RGBA8888, 1 = RGB565, 2 = A8
static const char* _errorMessage;

static value media_cpp_loadBitmapFromPng (value imageData, value nativeData, value flipRGB)
{
    NativeData* ptrIn = ((NativeData*)val_data(imageData));
    NativeData* ptrOut = ((NativeData*)val_data(nativeData));
    bool flip = val_bool(flipRGB);

    unsigned error;

    unsigned char* image;
    unsigned width, height;

    int byteCount = 0;

    unsigned char* png = ptrIn->ptr;
    size_t pngsize = ptrIn->allocedLength;

    LodePNGState state;
    lodepng_state_init(&state);
    state.info_raw.colortype = LCT_RGBA;
    state.info_raw.bitdepth = 8;

    error = lodepng_decode(&image, &width, &height, &state, png, pngsize);

    _errorMessage = lodepng_error_text(error);

    if(error)
    {
        lodepng_state_cleanup(&state);
        return alloc_bool(false);
    }

    _width = width;
    _height = height;

    byteCount = width * height * 4;

    const LodePNGColorMode color = state.info_png.color;

    if (lodepng_is_alpha_type(&color))
    {
        _hasAlpha = true;
        _hasPremultipliedAlpha = true;

        _pixelFormat = 0;
    }
    else
    {
        _hasAlpha = false;
        _hasPremultipliedAlpha = false;

        _pixelFormat = 1;
    }

    // Premultiply alpha
    if (_hasAlpha)
    {
        unsigned char stride = 4;
        float r,g,b, aFraction;

        for(unsigned int i = 0; i != _width * _height; ++i)
        {
            aFraction = (float)image[i * stride + 3] / 255.0f;
            b = (float)image[i * stride + 2];
            g = (float)image[i * stride + 1];
            r = (float)image[i * stride + 0];

            image[i * stride + 0] = (unsigned char)(r * aFraction);
            image[i * stride + 1] = (unsigned char)(g * aFraction);
            image[i * stride + 2] = (unsigned char)(b * aFraction);
        }
    }

    // Flip RGB
    if (flip && !lodepng_is_greyscale_type(&color) && (_pixelFormat == 1 || _pixelFormat == 0))
    {
        unsigned char stride = 4;
        unsigned char r,b;

        for(unsigned int i = 0; i != _width * _height; ++i)
        {
            r = image[i * stride + 0];
            b = image[i * stride + 2];
            image[i * stride + 0] = b;
            image[i * stride + 2] = r;
        }
    }

    lodepng_state_cleanup(&state);

    if(_pixelFormat == 1) // Convert to RGB565
    {
        byteCount = _width * _height * 2;
        void* tempData = malloc(byteCount);
        unsigned int *inPixel32 = (unsigned int*)image;
        unsigned short *outPixel16 = (unsigned short*)tempData;
        for(unsigned int i = 0; i != _width * _height; ++i, ++inPixel32)
            *outPixel16++ = (unsigned short)(((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) |
                                            ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) |
                                            ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0));
        free(image);
        image = (unsigned char*)tempData;
    }

	ptrOut->ptr = (uint8_t*)image;
    ptrOut->allocedLength = byteCount;
    ptrOut->offsetLength = byteCount;

	return alloc_bool(true);
}
DEFINE_PRIM (media_cpp_loadBitmapFromPng, 3);


static value media_cpp_loadBitmapFromJpg (value imageData, value nativeData, value flipRGB)
{
    NativeData* ptrIn = ((NativeData*)val_data(imageData));
    NativeData* ptrOut = ((NativeData*)val_data(nativeData));
    bool flip = val_bool(flipRGB);

    int width, height, actual_comps;
    int req_comps = 4;
    int byteCount = 0;

    unsigned char* png = ptrIn->ptr;
    size_t pngsize = ptrIn->allocedLength;

    // First we export it to RGBA8888 to then convert it to RGB565
    unsigned char* image = jpgd::decompress_jpeg_image_from_memory(png, pngsize, &width, &height, &actual_comps, req_comps);

    if (image == NULL)
    {
        _errorMessage = "Failed decoding source image to jpg.";
        return alloc_bool(false);
    }
    else
    {
        _errorMessage = "noerror";
    }

    _width = width;
    _height = height;

    _hasAlpha = false;
    _hasPremultipliedAlpha = false;
    _pixelFormat = 1; // RGB565

    if (flip)
    {
        for(unsigned int i = 0; i != _width * _height; ++i)
        {
            unsigned char r = image[i * 4 + 0];
            unsigned char b = image[i * 4 + 2];
            image[i * 4 + 0] = b;
            image[i * 4 + 2] = r;
        }
    }

    byteCount = _width * _height * 2;
    void* tempData = malloc(byteCount);
    unsigned int *inPixel32 = (unsigned int*)image;
    unsigned short *outPixel16 = (unsigned short*)tempData;

    for(unsigned int i = 0; i != _width * _height; ++i, ++inPixel32)
                *outPixel16++ = (unsigned short)(((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) |
                                                ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) |
                                                ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0));

    free(image);
    image = (unsigned char*)tempData;

    ptrOut->ptr = (uint8_t*)image;
    ptrOut->allocedLength = byteCount;
    ptrOut->offsetLength = byteCount;

    return alloc_bool(true);
}
DEFINE_PRIM (media_cpp_loadBitmapFromJpg, 3);

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

static value media_cpp_getErrorString()
{
    return alloc_string(_errorMessage);
}
DEFINE_PRIM (media_cpp_getErrorString, 0);


/// OTHER
extern "C" void media_cpp_main ()
{
	val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT (media_cpp_main);


extern "C" int media_cpp_register_prims () { return 0; }