package media.bitmap;

import media.bitmap.jpg.BitmapDataJPGFactory;
import media.bitmap.png.BitmapDataPNGFactory;
import types.Data;

#if (ios || android)
extern class BitmapLoader
{
    /// Returns bitmapData with raw pixels in RGB(A) order. If flipRGB is set to true you get BGR(A). Its is set to true by default for backwards compatibility.
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true): BitmapData;
}
#else
class BitmapLoader
{
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true): BitmapData
    {
        switch (imageFormat)
        {
            case ImageFormat.ImageFormatPNG: return BitmapDataPNGFactory.decodeData(data, flipRGB);
            case ImageFormat.ImageFormatJPG: return BitmapDataJPGFactory.decodeData(data, flipRGB);
            default: return null;
        }
    }
}
#end