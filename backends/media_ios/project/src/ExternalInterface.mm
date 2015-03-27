/*
 * Copyright (c) 2003-2015 GameDuell GmbH, All Rights Reserved
 * This document is strictly confidential and sole property of GameDuell GmbH, Berlin, Germany
 */

#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#include <hx/CFFI.h>
#include <types/NativeData.h>

#include "BitmapLoaderIOS.h"

static value media_ios_loadBitmap(value fileUrl, value nativeData)
{
    NativeData* ptr = ((NativeData*)val_data(nativeData));
	return [BitmapLoaderIOS loadBitmap:fileUrl outData:ptr];
}
DEFINE_PRIM (media_ios_loadBitmap, 2);


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


/// OTHER
extern "C" void media_ios_main ()
{
	val_int(0); // Fix Neko init
	
}
DEFINE_ENTRY_POINT (media_ios_main);


extern "C" int media_ios_register_prims () { return 0; }