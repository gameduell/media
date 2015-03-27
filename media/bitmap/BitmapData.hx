package media.bitmap;

import types.Data;
import media.bitmap.BitmapComponentFormat;
import media.bitmap.ImageFormat;

class BitmapData
{
    public var data (default, null): Data;

    public var width (default, null): Int;
    public var height (default, null): Int;
    public var componentFormat (default, null): BitmapComponentFormat;
    public var originalFileFormat (default, null): ImageFormat;
    public var hasAlpha (default, null): Bool;
    public var hasPremultipliedAlpha (default, null): Bool;

    public function new(data: Data,
                        width: Int,
                        height: Int,
                        componentFormat: BitmapComponentFormat,
                        originalFileFormat: ImageFormat,
                        ?hasAlpha: Bool = false,
                        ?hasPremultipliedAlpha: Bool = false)
    {
        this.data = data;
        this.width = width;
        this.height = height;
        this.componentFormat = componentFormat;
        this.originalFileFormat = originalFileFormat;
        this.hasAlpha = hasAlpha;
        this.hasPremultipliedAlpha = hasPremultipliedAlpha;
    }
}