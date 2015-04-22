package media.bitmap.png;

import types.DataInputStream;
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
    static public function decodeStream(input: InputStream): BitmapData
    {
        var haxeInput = new HaxeInputInteropStream(input);
        var reader = new Reader(haxeInput);

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

    static public function decodeData(imageData: Data, flipRGB: Bool = true): BitmapData
    {
        var haxeInput = new HaxeInputInteropStream(new DataInputStream(imageData));
        var reader = new Reader(haxeInput);

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

                // Is already BGRA8888
                var bytes: Bytes = Tools.extract32(png, data);

                if (!flipRGB)
                {
                    invertRGB(bytes);
                }

                var data = bytes.getTypesData();

                return new BitmapData(data, header.width, header.height, BitmapComponentFormat.BGRA8888, ImageFormat.ImageFormatPNG, true, true);

            default:
        throw "Unsupported PNG, only RGB(A) is currently supported";

        }
    }

    /**
		Iverts from BGRA to RGBA and the other way by reversing bytes.
	**/
    private static function invertRGB(b: haxe.io.Bytes)
    {
        #if flash10
        var bytes = b.getData();
        if( bytes.length < 1024 ) bytes.length = 1024;
        flash.Memory.select(bytes);
        #end
        inline function bget(p) {
        #if flash10
            return flash.Memory.getByte(p);
        #else
            return b.get(p);
        #end
        }
        inline function bset(p,v) {
        #if flash10
            flash.Memory.setByte(p,v);
        #else
            return b.set(p,v);
        #end
        }
        var p = 0;
        for( i in 0...b.length >> 2 ) {
            var b = bget(p);
          //  var g = bget(p + 1);
            var r = bget(p + 2);
           // var a = bget(p + 3);
            bset(p++, r);
            p++;//bset(p++, g);
            bset(p++, b);
            p++;
           // bset(p++, a);
        }
    }
}