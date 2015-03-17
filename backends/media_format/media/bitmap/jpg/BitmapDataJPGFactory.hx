/**
 * @author kgar
 * @date  13/03/15 
 * Copyright (c) 2014 GameDuell GmbH
 */
package media.bitmap.jpg;

import media.bitmap.BitmapData;

import types.DataOutputStream;


import haxe.io.Bytes;

import types.Data;
import types.InputStream;
import types.haxeinterop.HaxeInputInteropStream;
import types.haxeinterop.HaxeOutputInteropStream;
import hxd.res.NanoJpeg;

using types.haxeinterop.DataBytesTools;

@:access(media.bitmap.BitmapData)
class BitmapDataJPGFactory
{
   public static function decodeStream(input : InputStream): BitmapData
    {

        var haxeInput = new HaxeInputInteropStream(input);
        var jpgData = new Data(0);
        input.readIntoData(jpgData);
		var decodedJpeg = NanoJpeg.decode(jpgData.getBytes());

        var bytes: Bytes = decodedJpeg.pixels; 

        var width  = decodedJpeg.width;
        var height = decodedJpeg.height;

        /// convert to BGRA8888
        var w = 0, r = 0;
        var rgba = haxe.io.Bytes.alloc(width * height * 4);
        for(y in 0...height) 
        {
			for(x in 0...width) 
			{
				rgba.set(w++,bytes.get(r+2)); // r
				rgba.set(w++,bytes.get(r+1)); // g
				rgba.set(w++,bytes.get(r));   // b
				rgba.set(w++,1); // set alpha to 1
				r += 4;
			}
		}

        var data = new types.Data(rgba.length);

        var dataStream = new DataOutputStream(data);

        var bytesStream = new HaxeOutputInteropStream(dataStream);

        return new BitmapData(data, width, height, BitmapComponentFormat.BGRA8888, ImageFormatPNG);
    }

}
