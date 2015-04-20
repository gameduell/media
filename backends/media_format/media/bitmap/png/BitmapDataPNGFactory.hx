package media.bitmap.png;

import haxe.io.BytesData;
import media.bitmap.BitmapData;

import format.png.Tools;
import format.png.Reader;

import haxe.io.Bytes;

import types.Data;
import types.InputStream;
import types.haxeinterop.HaxeInputInteropStream;
using types.haxeinterop.DataBytesTools;

@:access(media.bitmap.BitmapData)
@:access(haxe.io.Bytes)
class BitmapDataPNGFactory
{
    static public function decodeStream(input : InputStream) : BitmapData
    {
        var haxeInput = new HaxeInputInteropStream(input);

        var reader = new Reader(haxeInput);
        reader.checkCRC = false;

        var png = reader.read();
        var header = Tools.getHeader(png);
        switch(header.color)
        {
            case ColTrue(alpha):

                #if html5
                var data: haxe.io.Bytes = new haxe.io.Bytes(header.width * header.height * 4, new BytesData()); // This is 2x faster on Chrome, but a little slower on FireFox and Safari
                #else
                var data: haxe.io.Bytes = haxe.io.Bytes.alloc(header.width * header.height * 4);
                #end

                var bytes: Bytes = Tools.extract32(png, data);
                var data = bytes.getTypesData();

                return new BitmapData(data, header.width, header.height, BitmapComponentFormat.BGRA8888, ImageFormat.ImageFormatPNG, true, true);

            default:
                throw "Unsupported PNG, only RGB(A) is currently supported";

        }
    }
}