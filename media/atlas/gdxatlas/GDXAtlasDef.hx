package media.atlas.gdxatlas;

class GDXAtlasDef
{
    public var atlasImageName: String;
    public var imageDefinitions: Array<GDXAtlasImageDef>;

    public function new()
    {
        imageDefinitions = new Array();
    }

    public function toString(): String
    {
        return "[GDXAtlasDef name=" + atlasImageName + " imageDefs = " + imageDefinitions + "]";
    }
}
