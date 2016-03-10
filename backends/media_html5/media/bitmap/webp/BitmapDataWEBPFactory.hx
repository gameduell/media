package media.bitmap.webp;

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

        var data: WebPImageData = decoder.WebPDecodeARGB(imageData.uint8Array, imageData.offsetLength);

        if (data == null)
            return null;

        var newData: Data = new Data(data.data.length);
        newData.writeIntArray(data.data, DataType.DataTypeUInt8);

        return new BitmapData(newData, data.width, data.height, BitmapComponentFormat.ARGB8888, ImageFormat.ImageFormatWEBP, true, true);
    }
}
