package webpjs;

import types.Data;
import types.InputStream;

@:native("window.WebPDecoder")
extern class WebPDecoder {
    function new():Void;

    function WebPDecodeARGB(data: Dynamic, dataSize: Int, width: { value : Int } , height: { value : Int } ): Dynamic;
    function WebPDecodeRGBA(data: Dynamic, dataSize: Int, width: { value : Int } , height: { value : Int } ): Dynamic;
    function WebPDecodeRGB(data: Dynamic, dataSize: Int, width: { value : Int } , height: { value : Int } ): Dynamic;

    function WebPGetFeatures(data: Dynamic, dataSize: Int, features: Dynamic): VP8Status;
}

typedef WebPBitstreamFeatures = {
var width: Int;         // Width in pixels, as read from the bitstream.
var height: Int;       // Height in pixels, as read from the bitstream.
var has_alpha: Bool;    // True if the bitstream contains an alpha channel.
var has_animation: Bool;  // True if the bitstream is an animation.
var format: Int;         // 0 = undefined (/mixed), 1 = lossy, 2 = lossless

var pad: Dynamic;    // padding for later use
};

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