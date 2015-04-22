package media.bitmap.png;

import types.Data;
import types.InputStream;

extern class BitmapDataPNGFactory
{
	static public function decodeStream(input: InputStream): BitmapData;
	static public function decodeData(imageData: Data, flipRGB: Bool = true): BitmapData;
}