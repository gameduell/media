package media.font.bmfont;

import de.polygonal.ds.IntIntHashTable;
import de.polygonal.ds.IntHashTable;

class BMFontDef
{
    public var name: String;
    public var size: Int;
    public var pageFileNames: Array<String>;

    public var smooth: Bool;
    public var unicode: Bool;
    public var italic: Bool;
    public var bold: Bool;
    public var fixedHeight: Bool;
    public var charSet: Int;
    public var stretchH: Int;
    public var aa: Int;
    public var paddingUp: Int;
    public var paddingRight: Int;
    public var paddingDown: Int;
    public var paddingLeft: Int;
    public var spacingHorizontal: Int;
    public var spacingVertical: Int;
    public var outline: Int;
    public var lineHeight: Float;
    public var base: Float;
    public var xHeight: Float;
    public var texWidth: Int;
    public var texHeight: Int;
    public var pageCount: Int;
    public var alphaChannel: Int;
    public var redChannel: Int;
    public var greenChannel: Int;
    public var blueChannel: Int;
    public var charMap: IntHashTable<BMFontCharDef>;
    public var kerningsMap: IntIntHashTable;
    public var packed: Bool;

    public function new()
    {
        pageFileNames = new Array();
    }

    public function toString(): String
    {
        return "[FontDef name=" + name + " size=" + size + " textures=" + pageFileNames +"]";
    }

    static public function kerningKey(first: Int, second: Int): Int
    {
        return (first << 16) | second;
    }
}
