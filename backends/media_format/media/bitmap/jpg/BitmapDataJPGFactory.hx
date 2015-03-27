/**
 * @author kgar
 * @date  13/03/15 
 * Copyright (c) 2014 GameDuell GmbH
 */
package media.bitmap.jpg;

import media.bitmap.BitmapData;

import haxe.io.Bytes;

import types.Data;
import types.InputStream;
import types.haxeinterop.HaxeInputInteropStream;
import hxd.res.NanoJpeg;

using types.haxeinterop.DataBytesTools;

@:access(media.bitmap.BitmapData)
class BitmapDataJPGFactory
{
   public static function decodeStream(input : InputStream): BitmapData
   {
        var haxeInput = new HaxeInputInteropStream(input);

        var jpgData = new Data(input.bytesAvailable);
        input.readIntoData(jpgData);

		var decodedJpeg = NanoJpeg.decode(jpgData.getBytes());

        var bytes: Bytes = decodedJpeg.pixels;
        var width  = decodedJpeg.width;
        var height = decodedJpeg.height;

        var data = bytes.getTypesData();

        return new BitmapData(data, width, height, BitmapComponentFormat.ARGB8888, ImageFormat.ImageFormatJPG, false, false);
    }
}
