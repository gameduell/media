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

package webpjs;

import types.Data;
import types.InputStream;

@:native("window.Module")
extern class WebPDecoder {
    static var HEAPU8: Dynamic;
    static function _initializeWebPDecoding(buf: Dynamic, length: Int): Dynamic;
    static function _getFeaturesWidth(): Int;
    static function _getFeaturesHeight(): Int;
    static function _malloc(v: Dynamic): Dynamic;
    static function _decodeWebP(bug: Dynamic, length: Int): Dynamic;
    static function _free(v: Dynamic): Dynamic;
}

@:enum
abstract VP8Status(Int)
{
    var VP8_STATUS_OUT_OF_MEMORY = 1;
    var VP8_STATUS_INVALID_PARAM = 2;
    var VP8_STATUS_BITSTREAM_ERROR = 3;
    var VP8_STATUS_UNSUPPORTED_FEATURE = 4;
    var VP8_STATUS_SUSPENDED = 5;
    var VP8_STATUS_USER_ABORT = 6;
    var VP8_STATUS_NOT_ENOUGH_DATA = 7;
}