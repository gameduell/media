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

#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#include <hx/CFFI.h>
#include <types/NativeData.h>

#include "BitmapLoaderIOS.h"

static value media_ios_loadAsyncBitmapGeneric(value imageData, value nativeData, value flipRGB, value callback)
{
    NativeData* ptrIn = ((NativeData*)val_data(imageData));
    NativeData* ptrOut = ((NativeData*)val_data(nativeData));
    bool flip = val_bool(flipRGB);

    value *__callback = alloc_root();
    *__callback = callback;

	return [BitmapLoaderIOS loadAsyncBitmap:ptrIn outData:ptrOut flipRGB:flip callback:__callback];
}
DEFINE_PRIM (media_ios_loadAsyncBitmapGeneric, 4);

static value media_ios_loadBitmapGeneric(value imageData, value nativeData, value flipRGB)
{
    NativeData* ptrIn = ((NativeData*)val_data(imageData));
    NativeData* ptrOut = ((NativeData*)val_data(nativeData));
    bool flip = val_bool(flipRGB);
	return [BitmapLoaderIOS loadBitmap:ptrIn outData:ptrOut flipRGB:flip];
}
DEFINE_PRIM (media_ios_loadBitmapGeneric, 3);

static value media_ios_loadAsyncWebPBitmapGeneric(value imageData, value nativeData, value flipRGB, value callback)
{
    NativeData* ptrIn = ((NativeData*)val_data(imageData));
    NativeData* ptrOut = ((NativeData*)val_data(nativeData));
    bool flip = val_bool(flipRGB);

    value *__callback = alloc_root();
    *__callback = callback;

	return [BitmapLoaderIOS loadAsyncWebPBitmap:ptrIn outData:ptrOut flipRGB:flip callback:__callback];
}
DEFINE_PRIM (media_ios_loadAsyncWebPBitmapGeneric, 4);

static value media_ios_loadWebPBitmapGeneric(value imageData, value nativeData, value flipRGB)
{
    NativeData* ptrIn = ((NativeData*)val_data(imageData));
    NativeData* ptrOut = ((NativeData*)val_data(nativeData));
    bool flip = val_bool(flipRGB);
	return [BitmapLoaderIOS loadWebPBitmap:ptrIn outData:ptrOut flipRGB:flip];
}
DEFINE_PRIM (media_ios_loadWebPBitmapGeneric, 3);


static value media_ios_getWidth()
{
    return [BitmapLoaderIOS getWidth];

}
DEFINE_PRIM (media_ios_getWidth, 0);


static value media_ios_getHeight()
{
    return [BitmapLoaderIOS getHeight];

}
DEFINE_PRIM (media_ios_getHeight, 0);


static value media_ios_hasAlpha()
{
    return [BitmapLoaderIOS hasAlpha];

}
DEFINE_PRIM (media_ios_hasAlpha, 0);


static value media_ios_hasPremultipliedAlpha()
{
    return [BitmapLoaderIOS hasPremultipliedAlpha];

}
DEFINE_PRIM (media_ios_hasPremultipliedAlpha, 0);


static value media_ios_getPixelFormat()
{
    return [BitmapLoaderIOS getPixelFormat];

}
DEFINE_PRIM (media_ios_getPixelFormat, 0);

static value media_ios_getErrorString()
{
    return [BitmapLoaderIOS getErrorMessage];
}
DEFINE_PRIM (media_ios_getErrorString, 0);

/// OTHER
extern "C" void media_ios_main ()
{
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (media_ios_main);


extern "C" int media_ios_register_prims () { return 0; }