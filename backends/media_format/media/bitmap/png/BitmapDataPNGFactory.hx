package media.bitmap.png;

import media.bitmap.BitmapData;

import haxe.io.BytesInput;

import types.DataOutputStream;

import format.png.Tools;
import format.png.Reader;

import haxe.io.Bytes;

import types.Data;
import types.InputStream;
import types.haxeinterop.HaxeInputInteropStream;
import types.haxeinterop.HaxeOutputInteropStream;
using types.haxeinterop.DataBytesTools;

@:access(media.bitmap.BitmapData)
class BitmapDataPNGFactory
{
    public static function decodeStream(input : InputStream) : BitmapData
    {
        var haxeInput = new HaxeInputInteropStream(input);
        var png = new Reader(haxeInput).read();
        var header = Tools.getHeader(png);
        switch(header.color)
        {
            case ColTrue(alpha):

                var bytes: Bytes = Tools.extract32(png); // TODO Maybe we find a faster way to deliver this data

                var data = new types.Data(bytes.length);

                var dataStream = new DataOutputStream(data);

                var bytesStream = new HaxeOutputInteropStream(dataStream);

                bytesStream.writeBytes(bytes, 0, bytes.length);

                return new BitmapData(data, header.width, header.height, BitmapComponentFormat.BGRA8888, ImageFormatPNG);

            default:
                throw "Unsupported PNG, only RGB(A) is currently supported";

        }
    }
}