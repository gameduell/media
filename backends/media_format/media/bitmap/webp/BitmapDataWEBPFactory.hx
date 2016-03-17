package media.bitmap.webp;

import webpjs.WebPDecoder;
import types.DataInputStream;
import haxe.io.BytesData;
import media.bitmap.BitmapData;

import haxe.io.Bytes;

import types.Data;
import types.InputStream;
import types.haxeinterop.HaxeInputInteropStream;
using types.haxeinterop.DataBytesTools;

@:access(media.bitmap.BitmapData)
@:access(haxe.io.Bytes)
class BitmapDataWEBPFactory
{
    static public function decodeStream(input: InputStream): BitmapData
    {
        return null;
    }

    static public function decodeData(imageData: Data, flipRGB: Bool = true): BitmapData
    {
        var webpdata = imageData.uint8Array;

        var buf = WebPDecoder._malloc(webpdata.length * js.html.Uint8Array.BYTES_PER_ELEMENT);

        WebPDecoder.HEAPU8.set(webpdata, buf);

        var resultCode = WebPDecoder._initializeWebPDecoding(buf, webpdata.length);


        var width = WebPDecoder._getFeaturesWidth();
        var height = WebPDecoder._getFeaturesHeight();

        var outputPointer = WebPDecoder._decodeWebP(buf, webpdata.length);
        var bitmapView = new js.html.Uint8Array(WebPDecoder.HEAPU8.buffer, outputPointer, width * height * 4);

        var bitmapViewToReturn = new js.html.Uint8Array(width * height * 4);
        bitmapViewToReturn.set(bitmapView);

        var data = new Data(0);
        data.arrayBuffer = bitmapViewToReturn.buffer;

        WebPDecoder._free(buf);
        WebPDecoder._free(outputPointer);

        return new BitmapData(data, width, height, BitmapComponentFormat.RGBA8888, ImageFormat.ImageFormatPNG, true, true);
    }
}
