package media.bitmap.png;

import haxe.io.BytesInput;
import media.bitmap.BitmapData;
import types.DataOutputStream;
import haxe.io.Bytes;
import types.haxeinterop.HaxeInputInteropStream;
import types.haxeinterop.HaxeOutputInteropStream;
import format.png.Tools;
import format.png.Reader;
import types.InputStream;
import types.Data;

import types.haxeinterop.DataBytesTools;

import format.png.Data;
import media.bitmap.ImageFormat;

@:access(media.bitmap.BitmapData)
class BitmapDataPNGFactory
{
    public static function decodeStream(input : InputStream) : BitmapData
	{
        var haxeInput = new HaxeInputInteropStream(input);
        var png = new Reader (haxeInput).read();
        var header = Tools.getHeader(png);


        switch(header.color)
        {
            case ColTrue(alpha):

                var bytes : Bytes = Tools.extract32(png);
                var data = new types.Data(bytes.length);
                var dataOutputStream = new DataOutputStream(data);
                var bytesInputStream = new BytesInput(bytes);

                for(i in 0...cast (bytes.length / 4))
                {
                    var b = bytesInputStream.readByte();
                    var g = bytesInputStream.readByte();
                    var r = bytesInputStream.readByte();
                    var a = bytesInputStream.readByte();

                    dataOutputStream.writeInt(r, DataTypeUInt8);
                    dataOutputStream.writeInt(g, DataTypeUInt8);
                    dataOutputStream.writeInt(b, DataTypeUInt8);
                    dataOutputStream.writeInt(a, DataTypeUInt8);
                }

                return new BitmapData(data, header.width, header.height, BitmapComponentFormatRGBA8888, ImageFormatPNG);

            default:
                throw "Unsupported PNG, only RGB(A) is currently supported";

        }
}
}