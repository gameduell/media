package webpjs;

import types.Data;
import types.InputStream;

@:native("window.WebPDecoder")
extern class WebPDecoder {
    public var WebPDecoderConfig: WebPDecoderConfig;

    function new():Void;

    function WebPDecodeARGB(data: js.html.Uint8Array, dataSize: Int, ?width: Int, ?height: Int): WebPImageData;
    function WebPGetDecoderVersion(a: Dynamic): Int;
    function WebPGetFeatures(data: js.html.Uint8Array , dataSize: Int, input: InputStream): VP8Status;
}

typedef WebPImageData = {
    var data: Array<Int>;
    var width: Int;
    var height: Int;
}

typedef WebPDecoderConfig = {
    var input: Dynamic;
    var output: Dynamic;
    var options: Dynamic;
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