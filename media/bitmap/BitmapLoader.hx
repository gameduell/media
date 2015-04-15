package media.bitmap;

import media.bitmap.jpg.BitmapDataJPGFactory;
import types.DataInputStream;
import media.bitmap.png.BitmapDataPNGFactory;
import types.Data;

#if ios
extern class BitmapLoader
{
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat): BitmapData;
}
#else
class BitmapLoader
{
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat): BitmapData
    {
        switch (imageFormat)
        {
            case ImageFormat.ImageFormatPNG: return BitmapDataPNGFactory.decodeStream(new DataInputStream(data));
            case ImageFormat.ImageFormatJPG: return BitmapDataJPGFactory.decodeData(data);
            default: return null;
        }
    }
}
#end