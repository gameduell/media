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