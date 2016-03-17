package media.bitmap.webp;

import webpjs.WebPDecoder.VP8Status;
import types.DataType;
import types.DataInputStream;
import types.haxeinterop.HaxeInputInteropStream;
import types.Data;
import types.InputStream;
import webpjs.WebPDecoder;

using types.haxeinterop.DataBytesTools;
using haxe.io.Bytes;

@:access(media.bitmap.BitmapData)
@:access(haxe.io.Bytes)
class BitmapDataWEBPFactory
{
    static public function decodeStream(input: InputStream): BitmapData
    {
        var decoder = new WebPDecoder();
        return null;
    }

    static public function decodeData(imageData: Data, flipRGB: Bool = true): BitmapData
    {
        trace("decoding starts");
        var decoder = new WebPDecoder();

        var WebPImage = { width:{value:0},height:{value:0} }

        var tmpData = new Data(64 * 64);

        tmpData.writeIntArray([for (i in 0 ... 64*64) 1], DataType.DataTypeInt8);

        var array = imageData.readIntArray(imageData.offsetLength, types.DataType.DataTypeUInt8);

        var data: Dynamic = decoder.WebPDecodeRGBA(array, imageData.offsetLength, WebPImage.width, WebPImage.height);

        var features: WebPBitstreamFeatures = {width: 0, height: 0, pad: null, has_animation: false, has_alpha: false, format: 0};

        var result: VP8Status = decoder.WebPGetFeatures(array, imageData.offsetLength, features);

        trace(result);
        trace(features);

        trace(WebPImage.width, WebPImage.height);

        if (data == null)
        {
            trace("NULL DATA!!!!");
            return new BitmapData(tmpData, 64, 64, BitmapComponentFormat.RGBA8888, ImageFormat.ImageFormatPNG, true, true);
        }
        else
        {
            //trace("HFUGNKERNGJRGNKREJGNRGNELKNGL");
           // trace(data.length);
        }

        var newData: Data = new Data(data.length);
        newData.writeIntArray(data, DataType.DataTypeUInt8);

        return new BitmapData(newData, WebPImage.width.value, WebPImage.height.value, BitmapComponentFormat.RGBA8888, ImageFormat.ImageFormatPNG, true, true);
    }
}
