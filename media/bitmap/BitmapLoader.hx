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

/// This class is not thread-safe.
extern class BitmapLoader
{
    /// Returns bitmapData with raw pixels in RGB(A) order. If flipRGB is set to true you get BGR(A). Its is set to true by default for backwards compatibility.
    /// scale is only used for SVG loading to scale up or down the canvas
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true,
                                               scale: Float = 1.0): BitmapData;

    /// The same behavior as `bitmapFromImageData`, except it tries to do the decoding async in the platforms where
    /// possible. The result is returned to the callback.
    static public function bitmapFromImageDataAsync(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true,
                                                    scale: Float = 1.0, callback: BitmapData -> Void = null): Void;
}