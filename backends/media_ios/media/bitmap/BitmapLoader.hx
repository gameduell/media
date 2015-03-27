package media.bitmap;

import types.Data;
import cpp.Lib;

import media.bitmap.BitmapData;

class BitmapLoader
{
    static private var media_ios_loadBitmap = Lib.load ("media_ios", "media_ios_loadBitmap", 2);

    static private var media_ios_getWidth = Lib.load ("media_ios", "media_ios_getWidth", 0);
    static private var media_ios_getHeight = Lib.load ("media_ios", "media_ios_getHeight", 0);
    static private var media_ios_hasAlpha = Lib.load ("media_ios", "media_ios_hasAlpha", 0);
    static private var media_ios_hasPremultipliedAlpha = Lib.load ("media_ios", "media_ios_hasPremultipliedAlpha", 0);
    static private var media_ios_getPixelFormat = Lib.load ("media_ios", "media_ios_getPixelFormat", 0);

    static public function bitmapForFileUrl(fileUrl: String): BitmapData
    {
        var resultData: Data = new Data(0);

        var result: Bool = media_ios_loadBitmap(fileUrl, resultData.nativeData);

        if (!result)
        {
            resultData = null;
            return null;
        }

        var fileExtension: String = fileUrl.split(".").pop().toLowerCase();

        var width: Int = media_ios_getWidth();
        var height: Int = media_ios_getHeight();
        var hasAlpha: Bool = media_ios_hasAlpha();
        var hasPremultipliedAlpha: Bool = media_ios_hasPremultipliedAlpha();
        var pixelFormat: Int = media_ios_getPixelFormat();

        var bitmapComponentFormat: BitmapComponentFormat = bitmapComponentFormatFromPixelFormat(pixelFormat);
        var imageFormat: ImageFormat = imageFormatFromFileExtension(fileExtension);

        return new BitmapData(resultData, width, height, bitmapComponentFormat, imageFormat, hasAlpha, hasPremultipliedAlpha);
    }

    static private function bitmapComponentFormatFromPixelFormat(pixelFormat: Int): BitmapComponentFormat
    {
        switch pixelFormat
        {
            case 0: return BitmapComponentFormat.ARGB8888;
            case 1: return BitmapComponentFormat.RGB565;
            case 2: return BitmapComponentFormat.A8;
            default: return BitmapComponentFormat.ARGB8888;
        }
    }

    static private function imageFormatFromFileExtension(fileExtension: String): ImageFormat
    {
        switch(fileExtension)
        {
            case "png": return ImageFormat.ImageFormatPNG;
            case "jpg": return ImageFormat.ImageFormatJPG;
            default: return ImageFormat.ImageFormatOther;
        }
    }
}
