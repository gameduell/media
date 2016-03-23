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

package media.bitmap;

import types.Data;
import media.bitmap.BitmapComponentFormat;
import media.bitmap.ImageFormat;

class BitmapData
{
    public var data (default, null): Data;

    public var width (default, null): Int;
    public var height (default, null): Int;
    public var componentFormat (default, null): BitmapComponentFormat;
    public var originalFileFormat (default, null): ImageFormat;
    public var hasAlpha (default, null): Bool;
    public var hasPremultipliedAlpha (default, null): Bool;

    public function new(data: Data,
                        width: Int,
                        height: Int,
                        componentFormat: BitmapComponentFormat,
                        originalFileFormat: ImageFormat,
                        ?hasAlpha: Bool = false,
                        ?hasPremultipliedAlpha: Bool = false)
    {
        this.data = data;
        this.width = width;
        this.height = height;
        this.componentFormat = componentFormat;
        this.originalFileFormat = originalFileFormat;
        this.hasAlpha = hasAlpha;
        this.hasPremultipliedAlpha = hasPremultipliedAlpha;
    }
}