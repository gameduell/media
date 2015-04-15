/**
 * @author kgar
 * @date  13/03/15 
 * Copyright (c) 2014 GameDuell GmbH
 */
package media.bitmap.jpg;
import types.Data;
import types.InputStream;

extern class BitmapDataJPGFactory
{
    static public function decodeStream(input: InputStream): BitmapData;
    static public function decodeData(imageData: Data): BitmapData;
}
