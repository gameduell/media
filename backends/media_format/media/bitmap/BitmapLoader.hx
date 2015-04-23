package media.bitmap;

import media.bitmap.jpg.BitmapDataJPGFactory;
import media.bitmap.png.BitmapDataPNGFactory;
import types.Data;

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
