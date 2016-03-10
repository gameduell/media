package media.bitmap;

import media.bitmap.BitmapData;
import media.bitmap.ImageFormat;
import media.bitmap.webp.BitmapDataWEBPFactory;
import types.Data;

class BitmapLoader
{
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true): BitmapData
    {
        switch (imageFormat)
        {
            case ImageFormat.ImageFormatWEBP: return BitmapDataWEBPFactory.decodeData(data, flipRGB);
            default: return null;
        }
    }
}
