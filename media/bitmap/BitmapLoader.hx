package media.bitmap;

import types.Data;

extern class BitmapLoader
{
    /// Returns bitmapData with raw pixels in RGB(A) order. If flipRGB is set to true you get BGR(A). Its is set to true by default for backwards compatibility.
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true): BitmapData;
}