package media.bitmap.png;

import types.InputStream;

extern class BitmapDataPNGFactory
{
	static public function decodeStream(input: InputStream): BitmapData;
}