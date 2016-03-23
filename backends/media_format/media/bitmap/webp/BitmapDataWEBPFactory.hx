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
