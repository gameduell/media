/*
 * Copyright (c) 2003-2016, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package media.bitmap.webp;

import webpjs.WebPDecoder.VP8Status;
import types.DataType;
import types.DataInputStream;
import types.haxeinterop.HaxeInputInteropStream;
import types.Data;
import types.InputStream;
import webpjs.WebPDecoder;

using types.haxeinterop.DataBytesTools;
using haxe.io.Bytes;

@:access(media.bitmap.BitmapData)
@:access(haxe.io.Bytes)
class BitmapDataWEBPFactory
{
    static public function decodeStream(input: InputStream): BitmapData
    {
        var decoder = new WebPDecoder();
        return null;
    }

    static public function decodeData(imageData: Data, flipRGB: Bool = true): BitmapData
    {
        trace("decoding starts");
        var decoder = new WebPDecoder();

        var WebPImage = { width:{value:0},height:{value:0} }

        var tmpData = new Data(64 * 64);

        tmpData.writeIntArray([for (i in 0 ... 64*64) 1], DataType.DataTypeInt8);

        var array = imageData.readIntArray(imageData.offsetLength, types.DataType.DataTypeUInt8);

        var data: Dynamic = decoder.WebPDecodeRGBA(array, imageData.offsetLength, WebPImage.width, WebPImage.height);

        var features: WebPBitstreamFeatures = {width: 0, height: 0, pad: null, has_animation: false, has_alpha: false, format: 0};

        var result: VP8Status = decoder.WebPGetFeatures(array, imageData.offsetLength, features);

        trace(result);
        trace(features);

        trace(WebPImage.width, WebPImage.height);

        if (data == null)
        {
            trace("NULL DATA!!!!");
            return new BitmapData(tmpData, 64, 64, BitmapComponentFormat.RGBA8888, ImageFormat.ImageFormatPNG, true, true);
        }
        else
        {
            //trace("HFUGNKERNGJRGNKREJGNRGNELKNGL");
           // trace(data.length);
        }

        var newData: Data = new Data(data.length);
        newData.writeIntArray(data, DataType.DataTypeUInt8);

        return new BitmapData(newData, WebPImage.width.value, WebPImage.height.value, BitmapComponentFormat.RGBA8888, ImageFormat.ImageFormatPNG, true, true);
    }
}
