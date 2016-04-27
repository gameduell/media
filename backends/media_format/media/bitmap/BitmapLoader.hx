package media.bitmap;

import media.bitmap.webp.BitmapDataWEBPFactory;
import media.bitmap.jpg.BitmapDataJPGFactory;
import media.bitmap.png.BitmapDataPNGFactory;
import media.bitmap.svg.BitmapDataSVGFactory;
import types.Data;

class BitmapLoader
{
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true, scale: Float = 1.0): BitmapData
    {
        switch (imageFormat)
        {
            case ImageFormat.ImageFormatSVG: return BitmapDataSVGFactory.decodeData(data, flipRGB, scale);
            case ImageFormat.ImageFormatPNG: return BitmapDataPNGFactory.decodeData(data, flipRGB);
            case ImageFormat.ImageFormatJPG: return BitmapDataJPGFactory.decodeData(data, flipRGB);
            case ImageFormat.ImageFormatWEBP: return BitmapDataWEBPFactory.decodeData(data, flipRGB);
            default: return null;
        }
    }
}
