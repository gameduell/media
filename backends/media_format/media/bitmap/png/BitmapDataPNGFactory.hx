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
        var png = new Reader(haxeInput).read();
        var header = Tools.getHeader(png);
        switch(header.color)
        {
            case ColTrue(alpha):

                var bytes: Bytes = Tools.extract32(png); // TODO Maybe we find a faster way to deliver this data

                var data = bytes.getTypesData();

                return new BitmapData(data, header.width, header.height, BitmapComponentFormat.ARGB8888, ImageFormatPNG, true, true);

            default:
                throw "Unsupported PNG, only RGB(A) is currently supported";

        }
    }
}