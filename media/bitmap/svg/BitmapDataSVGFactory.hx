package media.bitmap.svg;

import types.Data;
import types.InputStream;

import media.bitmap.BitmapData;
import media.bitmap.BitmapComponentFormat;
import media.bitmap.ImageFormat;

import vectorx.ColorStorage;
import vectorx.svg.SvgContext;

import aggx.core.geometry.AffineTransformer;

using types.DataStringTools;

class BitmapDataSVGFactory
{
    static public function decodeData(data: Data, flipRGB: Bool, scale: Float): BitmapData
    {
		var svgContext: SvgContext = new SvgContext();
        var svgXml = Xml.parse(data.readString());
        var svgData = SvgContext.parseSvg(svgXml);

        var renderWidth = svgData.viewBox.width * scale;
        var renderHeight = svgData.viewBox.height * scale;

        var colorStorage = new ColorStorage(
            Math.ceil(renderWidth),
            Math.ceil(renderHeight));

        var scaleX = renderWidth / svgData.viewBox.width;
        var scaleY = renderHeight / svgData.viewBox.height;
        var transform = AffineTransformer.scaler(scaleX, scaleY);
        svgContext.renderVectorBinToColorStorage(svgData, colorStorage, transform);

        var bitmapData = bitmapDataFromColorStorage(colorStorage);
        bitmapData.data.offset = 0;

        return bitmapData;
    }

    private static function bitmapDataFromColorStorage(colorStorage: ColorStorage): BitmapData
    {
        var hasAlpha = true;
        var hasPremultipliedAlpha = false;

        return new BitmapData(colorStorage.data, colorStorage.width, colorStorage.height,
            BitmapComponentFormat.RGBA8888, ImageFormat.ImageFormatSVG, hasAlpha, hasPremultipliedAlpha);
    }
}
