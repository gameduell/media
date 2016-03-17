package media.bitmap;

import media.bitmap.webp.BitmapDataWEBPFactory;
import media.bitmap.jpg.BitmapDataJPGFactory;
import media.bitmap.png.BitmapDataPNGFactory;
import types.Data;

class BitmapLoader
{
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true): BitmapData
    {
        switch (imageFormat)
        {
            case ImageFormat.ImageFormatPNG: return BitmapDataWEBPFactory.decodeData(data, flipRGB);
            case ImageFormat.ImageFormatJPG: return BitmapDataWEBPFactory.decodeData(data, flipRGB);
            default: return null;
        }
    }
}
