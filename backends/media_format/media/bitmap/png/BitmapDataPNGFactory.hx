package media.bitmap.png;

import media.bitmap.BitmapData;

import format.png.Tools;
import format.png.Reader;

import haxe.io.Bytes;

import types.Data;
import types.InputStream;
import types.haxeinterop.HaxeInputInteropStream;
using types.haxeinterop.DataBytesTools;

@:access(media.bitmap.BitmapData)
class BitmapDataPNGFactory
{
    public static function decodeStream(input : InputStream) : BitmapData
    {
        var haxeInput = new HaxeInputInteropStream(input);

        var reader = new Reader(haxeInput);
        reader.checkCRC = false;

        var png = reader.read();
        var header = Tools.getHeader(png);
        switch(header.color)
        {
            case ColTrue(alpha):

                var bytes: Bytes = Tools.extract32(png);
                var data = bytes.getTypesData();

                return new BitmapData(data, header.width, header.height, BitmapComponentFormat.BGRA8888, ImageFormat.ImageFormatPNG, true, true);

            default:
                throw "Unsupported PNG, only RGB(A) is currently supported";

        }
    }
}