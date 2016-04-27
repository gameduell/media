package media.bitmap;

import types.Data;

extern class BitmapLoader
{
    /// Returns bitmapData with raw pixels in RGB(A) order. If flipRGB is set to true you get BGR(A). Its is set to true by default for backwards compatibility.
    /// scale is only used for SVG loading to scale up or down the canvas
    static public function bitmapFromImageData(data: Data, imageFormat: ImageFormat, flipRGB: Bool = true, scale: Float = 1.0): BitmapData;
}