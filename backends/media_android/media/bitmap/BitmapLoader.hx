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

package media.bitmap;

import hxjni.JNI;
import types.Data;
import cpp.Lib;

import media.bitmap.BitmapData;

import media.bitmap.svg.BitmapDataSVGFactory;

class BitmapLoader
{
    // lazily initialized for async loads
    static private var jni_loadPngAsync: Dynamic = null;
    static private var jni_loadJpgAsync: Dynamic = null;
    static private var jni_loadWebPAsync: Dynamic = null;

    static private var media_android_setArguments = Lib.load ("media_android", "media_android_setArguments", 4);

    static private var media_android_loadBitmapFromPng = Lib.load ("media_android", "media_android_loadBitmapFromPng", 3);
    static private var media_android_loadBitmapFromJpg = Lib.load ("media_android", "media_android_loadBitmapFromJpg", 3);
    static private var media_android_loadBitmapFromWebP = Lib.load ("media_android", "media_android_loadBitmapFromWebP", 3);

    static private var media_android_getWidth = Lib.load ("media_android", "media_android_getWidth", 0);
    static private var media_android_getHeight = Lib.load ("media_android", "media_android_getHeight", 0);
    static private var media_android_hasAlpha = Lib.load ("media_android", "media_android_hasAlpha", 0);
    static private var media_android_hasPremultipliedAlpha = Lib.load ("media_android", "media_android_hasPremultipliedAlpha", 0);
    static private var media_android_getPixelFormat = Lib.load ("media_android", "media_android_getPixelFormat", 0);
    static private var media_android_getErrorString = Lib.load ("media_android", "media_android_getErrorString", 0);

    static private var executing: Bool = false;

    static private function lazilyInitializeJNIFunctions()
    {
        if (jni_loadPngAsync == null)
        {
            jni_loadPngAsync = JNI.createStaticMethod("org/haxe/duell/media/MediaBitmapLoader", "loadPngAsync", "()V");
            jni_loadJpgAsync = JNI.createStaticMethod("org/haxe/duell/media/MediaBitmapLoader", "loadJpgAsync", "()V");
            jni_loadWebPAsync = JNI.createStaticMethod("org/haxe/duell/media/MediaBitmapLoader", "loadWebPAsync", "()V");
        }
    }

    static public function bitmapFromImageDataAsync(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true,
                                                    scale: Float = 1.0, callback: BitmapData -> Void = null): Void
    {
        if (callback == null)
        {
            return;
        }

        if (imageFormat == ImageFormat.ImageFormatSVG)
        {
            callback(BitmapDataSVGFactory.decodeData(data, flipRGB, scale));
            return;
        }

        if (executing)
        {
            throw "bitmapFromImageDataAsync is not thread-safe AND one execution is already pending";
        }

        executing = true;

        var resultData: Data = new Data(0);

        media_android_setArguments(data.nativeData, resultData.nativeData, flipRGB, onImageLoaded.bind(callback, flipRGB, imageFormat, resultData));

        lazilyInitializeJNIFunctions();

        switch (imageFormat)
        {
            case ImageFormat.ImageFormatPNG: jni_loadPngAsync();
            case ImageFormat.ImageFormatJPG: jni_loadJpgAsync();
            case ImageFormat.ImageFormatWEBP: jni_loadWebPAsync();
            default:
            {
                media_android_setArguments(null, null, false, null);
                executing = false;
                callback(null);
            }
        }
    }

    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true, scale: Float = 1.0): BitmapData
    {
        if (imageFormat == ImageFormat.ImageFormatSVG)
        {
            return BitmapDataSVGFactory.decodeData(data, flipRGB, scale);
        }

        var resultData: Data = new Data(0);
        var result: Bool = false;

        switch (imageFormat)
        {
            case ImageFormat.ImageFormatPNG: result = media_android_loadBitmapFromPng(data.nativeData, resultData.nativeData, flipRGB);
            case ImageFormat.ImageFormatJPG: result = media_android_loadBitmapFromJpg(data.nativeData, resultData.nativeData, flipRGB);
            case ImageFormat.ImageFormatWEBP: result = media_android_loadBitmapFromWebP(data.nativeData, resultData.nativeData, flipRGB);
            default: result = false;
        }

        return onImageLoaded(null, flipRGB, imageFormat, resultData, result);
    }

    static public function onImageLoaded(callback: BitmapData -> Void, flipRGB: Bool, imageFormat: ImageFormat, resultData: Data, result: Bool): BitmapData
    {
        if (!result)
        {
            trace("Error: " + media_android_getErrorString());
            resultData = null;

            executing = false;

            if (callback != null)
            {
                callback(null);
            }

            return null;
        }

        var width: Int = media_android_getWidth();
        var height: Int = media_android_getHeight();
        var hasAlpha: Bool = media_android_hasAlpha();
        var hasPremultipliedAlpha: Bool = media_android_hasPremultipliedAlpha();
        var pixelFormat: Int = media_android_getPixelFormat();

        var bitmapComponentFormat: BitmapComponentFormat = bitmapComponentFormatFromPixelFormat(pixelFormat, flipRGB);
        var bitmapData: BitmapData = new BitmapData(resultData, width, height, bitmapComponentFormat, imageFormat, hasAlpha, hasPremultipliedAlpha);

        executing = false;

        if (callback != null)
        {
            callback(bitmapData);
        }

        return bitmapData;
    }

    static private function bitmapComponentFormatFromPixelFormat(pixelFormat: Int, flipRGB: Bool): BitmapComponentFormat
    {
        switch pixelFormat
        {
            case 0: return flipRGB ? BitmapComponentFormat.BGRA8888 : BitmapComponentFormat.RGBA8888;
            case 1: return flipRGB ? BitmapComponentFormat.BGR565 : BitmapComponentFormat.RGB565;
            case 2: return BitmapComponentFormat.A8;
            default: return flipRGB ? BitmapComponentFormat.BGRA8888 : BitmapComponentFormat.RGBA8888;
        }
    }
}
