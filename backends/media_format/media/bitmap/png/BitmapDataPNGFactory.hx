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

        /// improve performance a bit, and doesn't seem to work with all browsers
        reader.checkCRC = false;

        var png = reader.read();
        var header = Tools.getHeader(png);

        var data: haxe.io.Bytes = haxe.io.Bytes.alloc(header.width * header.height * 4);

        var bytes: Bytes = Tools.extractRGBAPremultipliedAlpha(png, data, flipRGB);

        var data = bytes.getTypesData();

        return new BitmapData(data, header.width, header.height, flipRGB ? BitmapComponentFormat.BGRA8888 : BitmapComponentFormat.RGBA8888, ImageFormat.ImageFormatPNG, true, true);
    }
}
