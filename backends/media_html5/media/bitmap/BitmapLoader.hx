package media.bitmap;

import media.bitmap.BitmapData;
import media.bitmap.ImageFormat;
import media.bitmap.webp.BitmapDataWEBPFactory;
import media.bitmap.svg.BitmapDataSVGFactory;
import types.Data;

class BitmapLoader
{
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true, scale: Float = 1.0): BitmapData
    {
        switch (imageFormat)
        {
            case ImageFormat.ImageFormatSVG: return BitmapDataSVGFactory.decodeData(data, flipRGB, scale);
            case ImageFormat.ImageFormatJPG: return BitmapDataWEBPFactory.decodeData(data, flipRGB);
            case ImageFormat.ImageFormatPNG: return BitmapDataWEBPFactory.decodeData(data, flipRGB);
            default: return null;
        }
    }
}
