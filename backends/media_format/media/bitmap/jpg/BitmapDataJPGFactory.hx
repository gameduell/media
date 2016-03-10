/**
 * @author kgar
 * @date  13/03/15 
 * Copyright (c) 2014 GameDuell GmbH
 */
package media.bitmap.jpg;

import media.bitmap.BitmapData;

import haxe.io.Bytes;
import jpg.Reader;

import types.Data;
import types.InputStream;
import types.haxeinterop.HaxeInputInteropStream;

using types.haxeinterop.DataBytesTools;
using haxe.io.Bytes;

@:access(haxe.io.Bytes)
@:access(media.bitmap.BitmapData)
class BitmapDataJPGFactory
{
    static public function decodeStream(input : InputStream): BitmapData
    {
        var haxeInput = new HaxeInputInteropStream(input);

        var jpgData = new Data(input.bytesAvailable);
        input.readIntoData(jpgData);

       return decodeData(jpgData);
    }

    static public function decodeData(imageData: Data, flipRGB: Bool = true): BitmapData
    {
        var haxeBytes: haxe.io.Bytes = imageData.getBytes();
        var jpgReader: jpg.Reader = new jpg.Reader(haxeBytes);
        jpgReader.parse();

        var width: Int = jpgReader.width;
        var height: Int = jpgReader.height;

        var bgraData: haxe.io.Bytes = jpgReader.getData(width, height, true, flipRGB);
        var bitmapData = bgraData.getTypesData();

        return new BitmapData(bitmapData, width, height, flipRGB ? BitmapComponentFormat.BGRA8888 : BitmapComponentFormat.RGBA8888, ImageFormat.ImageFormatJPG, false, false);
    }

}
