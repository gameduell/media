package media.bitmap.png;

import haxe.io.BytesInput;
import media.bitmap.BitmapData;
import types.DataOutputStream;
import haxe.io.Bytes;
import types.haxeinterop.HaxeInputInteropStream;
import format.png.Tools;
import format.png.Reader;
import types.InputStream;
import types.Data;

@:access(media.bitmap.BitmapData)
class BitmapDataPNGFactory
{
    public static function decodeStream(input : InputStream) : BitmapData
    {
        var haxeInput = new HaxeInputInteropStream(input);
        var png = new Reader(haxeInput).read();
        var header = Tools.getHeader(png);
        switch(header.color)
        {
            case ColTrue(alpha):

                var bytes: Bytes = Tools.extract32(png); // TODO Maybe we find a faster way to deliver this data

                var data = new types.Data(bytes.length);
                var dataOutputStream = new DataOutputStream(data);
                var bytesInputStream = new BytesInput(bytes);

                for(i in 0...cast (bytes.length / 4))
                {
                    var h = bytesInputStream.readInt32();
                    dataOutputStream.writeInt(h, DataTypeInt32);
                }

                return new BitmapData(data, header.width, header.height, BitmapComponentFormat.BGRA8888, ImageFormatPNG);

            default:
                throw "Unsupported PNG, only RGB(A) is currently supported";

        }
    }
}