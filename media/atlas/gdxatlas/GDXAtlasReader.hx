/*
 * Copyright (c) 2003-2016, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
