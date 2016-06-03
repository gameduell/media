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
 
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#include <hx/CFFI.h>
#include <types/NativeData.h>
#include "webpi/webp/decode.h"

static BOOL _hasAlpha;
static BOOL _hasPremultipliedAlpha;
static unsigned int _width;
static unsigned int _height;
static unsigned int _pixelFormat; // 0 = RGBA8888, 1 = RGB565, 2 = A8
static const char* _errorMessage;

@interface BitmapLoaderIOS : NSObject

+ (value) loadAsyncBitmap:(NativeData*)imageData outData:(NativeData*)outData flipRGB:(BOOL)flipRGB callback:(value*)callback;
+ (value) loadAsyncWebPBitmap:(NativeData*)imageData outData:(NativeData*)outData flipRGB:(BOOL)flipRGB callback:(value*)callback;

+ (value) loadBitmap:(NativeData*)imageData outData:(NativeData*)outData flipRGB:(BOOL)flipRGB;
+ (value) loadWebPBitmap:(NativeData*)imageData outData:(NativeData*)outData flipRGB:(BOOL)flipRGB;

+ (value) getWidth;
+ (value) getHeight;
+ (value) hasAlpha;
+ (value) hasPremultipliedAlpha;
+ (value) getPixelFormat;
+ (value) getErrorMessage;

@end