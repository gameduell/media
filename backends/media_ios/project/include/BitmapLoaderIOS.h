/*
 * Copyright (c) 2003-2015 GameDuell GmbH, All Rights Reserved
 * This document is strictly confidential and sole property of GameDuell GmbH, Berlin, Germany
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#include <hx/CFFI.h>
#include <types/NativeData.h>

static BOOL _hasAlpha;
static BOOL _hasPremultipliedAlpha;
static unsigned int _width;
static unsigned int _height;
static unsigned int _pixelFormat; // 0 = RGBA8888, 1 = RGB565, 2 = A8

@interface BitmapLoaderIOS : NSObject

+ (value) loadBitmap:(NativeData*)imageData outData:(NativeData*)outData;

+ (value) getWidth;
+ (value) getHeight;
+ (value) hasAlpha;
+ (value) hasPremultipliedAlpha;
+ (value) getPixelFormat;

@end