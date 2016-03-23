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
