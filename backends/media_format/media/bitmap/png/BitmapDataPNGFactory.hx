package media.bitmap.png;

import types.DataInputStream;
import haxe.io.BytesData;
import media.bitmap.BitmapData;

import png.Tools;
import png.Reader;

import haxe.io.Bytes;

import types.Data;
import types.InputStream;
import types.haxeinterop.HaxeInputInteropStream;
using types.haxeinterop.DataBytesTools;

@:access(media.bitmap.BitmapData)
@:access(haxe.io.Bytes)
class BitmapDataPNGFactory
{
    static public function decodeStream(input: InputStream): BitmapData
    {
        var haxeInput = new HaxeInputInteropStream(input);
        var reader = new Reader(haxeInput);

        var png = reader.read();
        var header = Tools.getHeader(png);

        var data: haxe.io.Bytes = haxe.io.Bytes.alloc(header.width * header.height * 4);

        var bytes: Bytes = Tools.extractRGBAPremultipliedAlpha(png, data, true);

        var data = bytes.getTypesData();

        return new BitmapData(data, header.width, header.height, BitmapComponentFormat.BGRA8888, ImageFormat.ImageFormatPNG, true, true);
    }

    static public function decodeData(imageData: Data, flipRGB: Bool = true): BitmapData
    {
        var haxeInput = new HaxeInputInteropStream(new DataInputStream(imageData));
        var reader = new Reader(haxeInput);

        var png = reader.read();
        var header = Tools.getHeader(png);

        var data: haxe.io.Bytes = haxe.io.Bytes.alloc(header.width * header.height * 4);

        var bytes: Bytes = Tools.extractRGBAPremultipliedAlpha(png, data, flipRGB);

        var data = bytes.getTypesData();

        return new BitmapData(data, header.width, header.height, flipRGB ? BitmapComponentFormat.BGRA8888 : BitmapComponentFormat.RGBA8888, ImageFormat.ImageFormatPNG, true, true);
    }
}
