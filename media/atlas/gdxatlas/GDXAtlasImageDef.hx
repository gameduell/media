package media.atlas.gdxatlas;

class GDXAtlasImageDef
{
    public var name: String = null;
    public var rotated: Bool = false;
    public var x: Int = 0;
    public var y: Int = 0;
    public var sizeWidth: Int = 0;
    public var sizeHeight: Int = 0;
    public var origSizeWidth: Int = 0;
    public var origSizeHeight: Int = 0;
    public var offsetX: Int = 0;
    public var offsetY: Int = 0;
    public var index: Int = 0;

    public function new()
    {
    }

    public function toString(): String
    {
        return "[GDXAtlasImageDef name:"+ name + " rotated:" + rotated + " xy:" + x + ", " + y + " size:" + sizeWidth + ", "+ sizeHeight + " orig:" + origSizeWidth + ", "+ origSizeHeight + " offset:" + offsetX + ", "+ offsetY + " index: " + index + "]";
    }

}
