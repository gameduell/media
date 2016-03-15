package media.bitmap;

import types.Data;
import cpp.Lib;

import media.bitmap.BitmapData;

class BitmapLoader
{
    // Generic because on iOS it can load multiple formats like jpg, png, tiff, etc
    static private var media_ios_loadBitmapGeneric = Lib.load ("media_ios", "media_ios_loadBitmapGeneric", 3);
    static private var media_ios_loadWebPBitmapGeneric = Lib.load ("media_ios", "media_ios_loadWebPBitmapGeneric", 3);

    static private var media_ios_getWidth = Lib.load ("media_ios", "media_ios_getWidth", 0);
    static private var media_ios_getHeight = Lib.load ("media_ios", "media_ios_getHeight", 0);
    static private var media_ios_hasAlpha = Lib.load ("media_ios", "media_ios_hasAlpha", 0);
    static private var media_ios_hasPremultipliedAlpha = Lib.load ("media_ios", "media_ios_hasPremultipliedAlpha", 0);
    static private var media_ios_getPixelFormat = Lib.load ("media_ios", "media_ios_getPixelFormat", 0);
    static private var media_ios_getErrorString = Lib.load ("media_ios", "media_ios_getErrorString", 0);

    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true): BitmapData
    {
        var resultData: Data = new Data(0);

        var result: Bool = false;

        switch (imageFormat)
        {
            case ImageFormat.ImageFormatPNG: result = media_ios_loadBitmapGeneric(data.nativeData, resultData.nativeData, flipRGB);
            case ImageFormat.ImageFormatJPG: result = media_ios_loadBitmapGeneric(data.nativeData, resultData.nativeData, flipRGB);
            case ImageFormat.ImageFormatWEBP: result = media_ios_loadWebPBitmapGeneric(data.nativeData, resultData.nativeData, flipRGB);
            default: result = false;
        }

        if (!result)
        {
            trace("Error: " + media_ios_getErrorString());
            resultData = null;
            return null;
        }

        var width: Int = media_ios_getWidth();
        var height: Int = media_ios_getHeight();
        var hasAlpha: Bool = media_ios_hasAlpha();
        var hasPremultipliedAlpha: Bool = media_ios_hasPremultipliedAlpha();
        var pixelFormat: Int = media_ios_getPixelFormat();

        var bitmapComponentFormat: BitmapComponentFormat = bitmapComponentFormatFromPixelFormat(pixelFormat, flipRGB);

        return new BitmapData(resultData, width, height, bitmapComponentFormat, imageFormat, hasAlpha, hasPremultipliedAlpha);
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
