/*
 * Copyright (c) 2003-2016, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef __GNUC__
  #define JAVA_EXPORT __attribute__ ((visibility("default"))) JNIEXPORT
#else
  #define JAVA_EXPORT JNIEXPORT
#endif

#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#include <jni.h>
#include <hx/CFFI.h>
#include <types/NativeData.h>

#include "lodepng.h"
#include "jpgd.h"
#include "webpi/webp/decode.h"

// async temp arguments
static value* _onImageLoadedCallback = NULL;
static value _imageData;
static value _nativeData;
static value _flipRGB;
static value _result;

static bool _hasAlpha;
static bool _hasPremultipliedAlpha;
static unsigned int _width;
static unsigned int _height;
static unsigned int _pixelFormat; // 0 = RGBA8888, 1 = RGB565, 2 = A8
static const char* _errorMessage;

static void media_android_setArguments(value imageData, value nativeData, value flipRGB, value callback)
{
    _imageData = imageData;
    _nativeData = nativeData;
    _flipRGB = flipRGB;

    if (_onImageLoadedCallback == NULL)
    {
        _onImageLoadedCallback = alloc_root();
    }

    *_onImageLoadedCallback = callback;
}
DEFINE_PRIM (media_android_setArguments, 4);


static value media_android_loadBitmapFromPng (value imageData, value nativeData, value flipRGB)
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
DEFINE_PRIM (media_android_loadBitmapFromPng, 3);


static value media_android_loadBitmapFromJpg (value imageData, value nativeData, value flipRGB)
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
DEFINE_PRIM (media_android_loadBitmapFromJpg, 3);

static value media_android_loadBitmapFromWebP (value imageData, value nativeData, value flipRGB)
{
    NativeData* ptrIn = ((NativeData*)val_data(imageData));
    NativeData* ptrOut = ((NativeData*)val_data(nativeData));
    bool flip = val_bool(flipRGB);

    WebPBitstreamFeatures features;
    int width, height;
    int byteCount = 0;
    unsigned char* webp = ptrIn->ptr;

    size_t webpsize = ptrIn->allocedLength;

    VP8StatusCode featuresResult = WebPGetFeatures((uint8_t*)webp, webpsize, &features);

    if (featuresResult != VP8_STATUS_OK)
    {
        _errorMessage = "error: bad feature result";
        return alloc_bool(false);
    }
    else
    {
        _errorMessage = "noerror";
    }

    if (features.has_alpha)
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

    _width = features.width;
    _height = features.height;
    byteCount = _width * _height * 4;

    unsigned char* image = WebPDecodeRGBA((uint8_t*)webp, webpsize, &width, &height);

    if (width != _width || height != _height)
    {
        _errorMessage = "Invalid image features!";
        return alloc_bool(false);
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
    if (flip && (_pixelFormat == 1 || _pixelFormat == 0))
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

    // Convert to RGB565
    if(_pixelFormat == 1)
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
DEFINE_PRIM (media_android_loadBitmapFromWebP, 3);

static value media_android_getWidth()
{
    return alloc_int(_width);
}
DEFINE_PRIM (media_android_getWidth, 0);


static value media_android_getHeight()
{
    return alloc_int(_height);
}
DEFINE_PRIM (media_android_getHeight, 0);


static value media_android_hasAlpha()
{
    return alloc_bool(_hasAlpha);
}
DEFINE_PRIM (media_android_hasAlpha, 0);


static value media_android_hasPremultipliedAlpha()
{
    return alloc_bool(_hasPremultipliedAlpha);
}
DEFINE_PRIM (media_android_hasPremultipliedAlpha, 0);


static value media_android_getPixelFormat()
{
    return alloc_int(_pixelFormat);
}
DEFINE_PRIM (media_android_getPixelFormat, 0);

static value media_android_getErrorString()
{
    return alloc_string(_errorMessage);
}
DEFINE_PRIM (media_android_getErrorString, 0);


/// JNI calls
struct AutoHaxe
{
	int base;
	const char *message;

	AutoHaxe(const char *inMessage)
	{
		base = 0;
		message = inMessage;
		gc_set_top_of_stack(&base,true);
	}
	~AutoHaxe()
	{
		gc_set_top_of_stack(0,true);
	}
};

extern "C" {
	JAVA_EXPORT void JNICALL Java_org_haxe_duell_media_MediaNativeInterface_loadPngWithStaticArguments(JNIEnv* env);
	JAVA_EXPORT void JNICALL Java_org_haxe_duell_media_MediaNativeInterface_loadJpgWithStaticArguments(JNIEnv* env);
	JAVA_EXPORT void JNICALL Java_org_haxe_duell_media_MediaNativeInterface_loadWebPWithStaticArguments(JNIEnv* env);
	JAVA_EXPORT void JNICALL Java_org_haxe_duell_media_MediaNativeInterface_finishAsyncLoading(JNIEnv* env);
};

JAVA_EXPORT void JNICALL Java_org_haxe_duell_media_MediaNativeInterface_loadPngWithStaticArguments(JNIEnv* env)
{
	_result = media_android_loadBitmapFromPng(_imageData, _nativeData, _flipRGB);
}

JAVA_EXPORT void JNICALL Java_org_haxe_duell_media_MediaNativeInterface_loadJpgWithStaticArguments(JNIEnv* env)
{
	_result = media_android_loadBitmapFromJpg(_imageData, _nativeData, _flipRGB);
}

JAVA_EXPORT void JNICALL Java_org_haxe_duell_media_MediaNativeInterface_loadWebPWithStaticArguments(JNIEnv* env)
{
	_result = media_android_loadBitmapFromWebP(_imageData, _nativeData, _flipRGB);
}

JAVA_EXPORT void JNICALL Java_org_haxe_duell_media_MediaNativeInterface_finishAsyncLoading(JNIEnv* env)
{
    AutoHaxe haxe("finishAsyncLoading");

	val_call1(*_onImageLoadedCallback, _result);

	// cleanup
	media_android_setArguments(NULL, NULL, NULL, NULL);
	_result = NULL;
}


/// OTHER
extern "C" void media_android_main ()
{
	val_int(0); // Fix Neko init
}
DEFINE_ENTRY_POINT (media_android_main);


extern "C" int media_android_register_prims () { return 0; }