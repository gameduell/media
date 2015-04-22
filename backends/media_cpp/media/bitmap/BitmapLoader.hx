package media.bitmap;

import types.Data;
import cpp.Lib;

import media.bitmap.BitmapData;

class BitmapLoader
{
    static private var media_cpp_loadBitmapFromPng = Lib.load ("media_cpp", "media_cpp_loadBitmapFromPng", 3);
    static private var media_cpp_loadBitmapFromJpg = Lib.load ("media_cpp", "media_cpp_loadBitmapFromJpg", 3);

    static private var media_cpp_getWidth = Lib.load ("media_cpp", "media_cpp_getWidth", 0);
    static private var media_cpp_getHeight = Lib.load ("media_cpp", "media_cpp_getHeight", 0);
    static private var media_cpp_hasAlpha = Lib.load ("media_cpp", "media_cpp_hasAlpha", 0);
    static private var media_cpp_hasPremultipliedAlpha = Lib.load ("media_cpp", "media_cpp_hasPremultipliedAlpha", 0);
    static private var media_cpp_getPixelFormat = Lib.load ("media_cpp", "media_cpp_getPixelFormat", 0);

    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true): BitmapData
    {
        var resultData: Data = new Data(0);

        var result: Bool = false;

        switch (imageFormat)
        {
            case ImageFormat.ImageFormatPNG: result = media_cpp_loadBitmapFromPng(data.nativeData, resultData.nativeData, flipRGB);
            case ImageFormat.ImageFormatJPG: result = media_cpp_loadBitmapFromJpg(data.nativeData, resultData.nativeData, flipRGB);
            default: result = false;
        }

        if (!result)
        {
            resultData = null;
            return null;
        }

        var width: Int = media_cpp_getWidth();
        var height: Int = media_cpp_getHeight();
        var hasAlpha: Bool = media_cpp_hasAlpha();
        var hasPremultipliedAlpha: Bool = media_cpp_hasPremultipliedAlpha();
        var pixelFormat: Int = media_cpp_getPixelFormat();

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
