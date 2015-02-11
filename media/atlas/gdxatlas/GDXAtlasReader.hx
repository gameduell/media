package media.atlas.gdxatlas;

import haxe.io.Path;
class GDXAtlasReader
{
    static var currentAtlas: GDXAtlasDef = null;

    public static function readFromString(fileAsString: String): GDXAtlasDef
    {
        currentAtlas = new GDXAtlasDef();

        if (Std.is(fileAsString, String))
        {
            var lines = fileAsString.split("\n");

            // First line should be emtpy
            lines.shift();

            var line: String = lines.shift();

            removeEnterFromLine(line);
            parseAtlasImageName(line);

            // TODO Ignore Size for now
            line = lines.shift();

            // We do this check to support two output formats of the .atlas file
            var checkLineArray: Array<String> = line.split(":");
            if (checkLineArray[0] == "size")
            {
                // TODO Ignore Format for now
                lines.shift();
            }
            else
            {
                // Size was actually already format
            }

            // TODO Ignore Filter for now
            lines.shift();

            // TODO Ignore Repeat for now
            lines.shift();

            // Here a block of AtlasImageDef starts. It contains 7 Lines
            while(lines.length > 6)
            {
                processBlock(lines.splice(0, 7));
            }
        }

        var out = currentAtlas;
        currentAtlas = null;
        return out;
    }

    // This is to make it work on Windows
    static private function removeEnterFromLine(line: String): Void
    {
        if (line.charCodeAt(line.length - 1) == 13)
        {
            line = line.substr(0, line.length - 1);
        }
    }

    static private function parseAtlasImageName(line: String): Void
    {
        currentAtlas.atlasImageName = line;
    }

    static private function processBlock(block: Array<String>): Void
    {
        var atlasImageDef: GDXAtlasImageDef = new GDXAtlasImageDef();

        var currentLine: String;

        currentLine = block.shift();
        removeEnterFromLine(currentLine);
        atlasImageDef.name = currentLine + "." + Path.extension(currentAtlas.atlasImageName);

        currentLine = block.shift();
        removeEnterFromLine(currentLine);
        currentLine.toLowerCase();

        if (currentLine.split(" ").pop() == "true")
        {
            atlasImageDef.rotated = true;
        }

        var stringIntArray: Array<String> = getNumbersFromLine(block.shift());
        atlasImageDef.x = Std.parseInt(stringIntArray[0]);
        atlasImageDef.y = Std.parseInt(stringIntArray[1]);

        stringIntArray = getNumbersFromLine(block.shift());
        atlasImageDef.sizeWidth = Std.parseInt(stringIntArray[0]);
        atlasImageDef.sizeHeight = Std.parseInt(stringIntArray[1]);

        stringIntArray = getNumbersFromLine(block.shift());
        atlasImageDef.origSizeWidth = Std.parseInt(stringIntArray[0]);
        atlasImageDef.origSizeHeight = Std.parseInt(stringIntArray[1]);

        stringIntArray = getNumbersFromLine(block.shift());
        atlasImageDef.offsetX = Std.parseInt(stringIntArray[0]);
        atlasImageDef.offsetY = Std.parseInt(stringIntArray[1]);

        stringIntArray = getNumbersFromLine(block.shift());
        atlasImageDef.index = Std.parseInt(stringIntArray[0]);

        currentAtlas.imageDefinitions.push(atlasImageDef);
    }

    static function getNumbersFromLine(line: String): Array<String>
    {
        removeEnterFromLine(line);
        line.toLowerCase();

        return line.split(": ").pop().split(", ");
    }
}
