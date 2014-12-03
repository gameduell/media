package media.font.bmfont;

import types.Data;
import de.polygonal.ds.IntIntHashTable;
import de.polygonal.ds.M;
import de.polygonal.ds.IntHashTable;
//import haxe.io.Bytes;
//import haxe.io.BytesInput;
//import sys.io.FileInput;

using StringTools;
/*
enum ReadStatus
{
    COMPLETE;
    PROGRESS;
    ERROR;
}
*/

/* https://71squared.com/glyphdesigner has a commandline tool and a binary output,
 * we might autogenerate fonts on compile time "Build plugin :-)" */
class BMFontReader
{
    //static var bytes: Bytes;
    static var currentFont: BMFontDef = null;

    public static function readFromString(fileAsString: String): BMFontDef
    {
        currentFont = new BMFontDef();

        if (Std.is(fileAsString, String))
        {
            var lines = fileAsString.split("\n");
            while (lines.length > 0)
            {
                var line = lines.shift();

                if (line.charCodeAt(line.length - 1) == 13)
                {
                    line = line.substr(0, line.length - 1);
                }
                readLine(line);
            }
        }

        if (currentFont.kerningsMap == null)
        {
            currentFont.kerningsMap = new IntIntHashTable(2, 2, false, 2);
        }

        // TODO throw error if this font has no x char.
        currentFont.xHeight = currentFont.charMap.get(FontConstants.xHeightCharCode).height;

        // TODO  Check for replacementCharCode existence.

        var out = currentFont;
        currentFont = null;
        return out;
    }

    // TODO implement binary reader
    public static function readFromBinaryFile(fileAsBytes: Data): BMFontDef
    {
    /*
        Reader.bytes = cast fileAsString;
        var input = new BytesInput(Reader.bytes);

        input.position = 0;
        if (input.readByte() != 66 || input.readByte() != 77 || input.readByte() != 70) throw "Invalid bmfont file";
        if (input.readByte() != 3) throw "Invalid bmfont file version";
        while (readBlock(input) == PROGRESS) { }

        Reader.bytes = null;
    */
        return null;
    }

    static function readLine(str: String): Void
    {
        var token = str.split(" ").shift();
        switch(token)
        {
            case "info":
                readInfoStr(str);
            case "common":
                readCommonStr(str);
            case "page":
                readPagesStr(str);
            case "chars":
                readCharsStr(str);
            case "char":
                readCharStr(str);
            case "kernings":
                readKerningsStr(str);
            case "kerning":
                readKerningStr(str);
        }
    }

    static private function readInfoStr(str: String): Void
    {
        var tokens = str.split(" ");
        tokens.reverse();
        while (tokens.length > 0)
        {
            var t = tokens.pop();
            var datum = t.split("=");
            var data = datum[1];
            switch(datum[0]) {
                case "face":
                    currentFont.name = data;
                case "size":
                    currentFont.size = Std.parseInt(data);
                case "bold":
                    currentFont.bold = data == "1";
                case "italic":
                    currentFont.italic= data == "1";
                case "charset":
//hm
                case "unicode":
                    currentFont.unicode = data == "1";
                case "stretchH":
                    currentFont.stretchH = Std.parseInt(data);
                case "smooth":
                    currentFont.smooth = data == "1";
                case "aa":
                    currentFont.aa = Std.parseInt(data);
                case "padding":
                    var pd = data.split(",");
                    currentFont.paddingLeft = Std.parseInt(pd[0]);
                    currentFont.paddingUp = Std.parseInt(pd[1]);
                    currentFont.paddingRight = Std.parseInt(pd[2]);
                    currentFont.paddingDown = Std.parseInt(pd[3]);
                case "spacing":
                    var spc = data.split(",");
                    currentFont.spacingHorizontal = Std.parseInt(spc[0]);
                    currentFont.spacingVertical = Std.parseInt(spc[1]);
                case "outline":
                    currentFont.outline = Std.parseInt(data);
            }
        }
    }

    static private function readCommonStr(str: String): Void
    {
        var tokens = str.split(" ");
        tokens.reverse();
        while (tokens.length > 0)
        {
            var t = tokens.pop();
            var datum = t.split("=");
            var data = datum[1];
            switch(datum[0])
            {
                case "lineHeight":
                    currentFont.lineHeight = Std.parseFloat(data);
                case "base":
                    currentFont.base = Std.parseFloat(data);
                case "scaleW":
                    currentFont.texWidth = Std.parseInt(data);
                case "scaleH":
                    currentFont.texHeight = Std.parseInt(data);
                case "pages":
                    currentFont.pageCount = Std.parseInt(data);
                case "packed":
                    currentFont.packed = data == "1";
            }
        }
    }

    static private function readPagesStr(str: String): Void
    {
        currentFont.pageFileNames = [];
        var tokens = str.split(" ");
        tokens.reverse();
        while (tokens.length > 0)
        {
            var t = tokens.pop();
            var datum = t.split("=");
            var data = datum[1];
            switch(datum[0])
            {
                case "file":
                    currentFont.pageFileNames.push(data.split('"').join(""));
            }
        }
    }

    static private function readCharsStr(str: String): Void
    {
        var tokens = str.split(" ");
        tokens.reverse();
        while (tokens.length > 0)
        {
            var t = tokens.pop();
            var datum = t.split("=");
            var data = datum[1];
            switch(datum[0])
            {
                case "count":
                    var numberOfChars: Int = Std.parseInt(data);
                    numberOfChars = M.nextPow2(numberOfChars);
                    currentFont.charMap = new IntHashTable<BMFontCharDef>(numberOfChars, numberOfChars, false, numberOfChars);
            }
        }
    }

    static private function readCharStr(str: String): Void
    {
        var tokens = str.split(" ");
        tokens.reverse();
        var char = new BMFontCharDef();
        while (tokens.length > 0)
        {
            var t = tokens.pop();
            var datum = t.split("=");
            var data = datum[1];
            switch(datum[0])
            {
                case "id":
                    char.charCode = Std.parseInt(data);
                case "x":
                    char.x = Std.parseFloat(data);
                case "y":
                    char.y = Std.parseFloat(data);
                case "width":
                    char.width = Std.parseFloat(data);
                    char.halfWidth = char.width * 0.5;
                case "height":
                    char.height = Std.parseFloat(data);
                    char.halfHeight = char.height * 0.5;
                case "xoffset":
                    char.xOffset = Std.parseFloat(data);
                case "yoffset":
                    char.yOffset = Std.parseFloat(data);
                case "xadvance":
                    char.xAdvance = Std.parseFloat(data);
                case "page":
                    char.page = Std.parseInt(data);
                case "chnl":
                    char.channel = Std.parseInt(data);
            }
        }
        currentFont.charMap.set(char.charCode, char);
    }

    static private function readKerningsStr(str: String): Void
    {
        var tokens = str.split(" ");
        tokens.reverse();
        while (tokens.length > 0)
        {
            var t = tokens.pop();
            var datum = t.split("=");
            var data = datum[1];
            switch(datum[0])
            {
                case "count":
                    var numberOfKernings: Int = Std.parseInt(data);
                    numberOfKernings = M.nextPow2(numberOfKernings);
                    currentFont.kerningsMap = new IntIntHashTable(numberOfKernings, numberOfKernings, false, numberOfKernings);
            }
        }
    }

    static private function readKerningStr(str: String): Void
    {
        var tokens = str.split(" ");
        tokens.reverse();

        var firstChar: Int = 0;
        var secondChar: Int = 0;
        var amountKerning: Int = 0;

        while (tokens.length > 0)
        {
            var t = tokens.pop();
            var datum = t.split("=");
            var data = datum[1];
            switch(datum[0])
            {
                case "first":
                    firstChar = Std.parseInt(data);
                case "second":
                    secondChar = Std.parseInt(data);
                case "amount":
                    amountKerning = Std.parseInt(data);
            }
        }
        currentFont.kerningsMap.set(BMFontDef.kerningKey(firstChar, secondChar), amountKerning);
    }

/// Logic for reading binary fnt files. Maybe we need this for performance.
/*
    static function readBlock(input:BytesInput):ReadStatus {
        if (input.position == input.length) return COMPLETE;
        var id = input.readByte();
        switch(id) {
            case 1:
                readInfo(input, input.readInt32());
            case 2:
                readCommon(input, input.readInt32());
            case 3:
                readPages(input, input.readInt32());
            case 4:
                readChars(input, input.readInt32());
            case 5:
                readKerningPairs(input, input.readInt32());
            default:
                return ERROR;
        }
        return PROGRESS;
    }

    static function readKerningPairs(input:BytesInput, blockSize:Int)
    {

        var target = input.position + blockSize;
        while (input.position < target) {
            readPair(input);
        }
    }

    static function readPair(reader:BytesInput)
    {
        var first = reader.readUInt16();
        var second = reader.readUInt16();
        var amount = reader.readInt8();
        var firstChar = currentFont.charMap[first];
        var secondChar = currentFont.charMap[second];
//The idea here is that during rendering, the second character of a pair to be drawn will offset its position backwards by the kerning value
        if (firstChar != null && secondChar != null) secondChar.kerningPairs[first] = amount;
    }

    static function readChars(input:BytesInput, blockSize:Int)
    {
        var target = input.position + blockSize;
        currentFont.charMap = new Vector<BMFontCharDef>(256);
        var numChars = blockSize / 20;
        var charIdx = 0;
        while (charIdx++<numChars) {
            readChar(input);
        }
    }

    static public function readUnsignedInt(input:BytesInput):Int
    {
        var ch1 = input.readByte();
        var ch2 = input.readByte();
        var ch3 = input.readByte();
        var ch4 = input.readByte();

        return input.bigEndian ?(ch1 << 24) |(ch2 << 16) |(ch3 << 8) | ch4 : (ch4 << 24) |(ch3 << 16) |(ch2 << 8) | ch1;
    }

    static function readChar(input:BytesInput) {
        var char = new BMFontCharDef();
        char.id = readUnsignedInt(input);

        char.x = input.readUInt16();
        char.y = input.readUInt16();
        char.width = input.readUInt16();
        char.height = input.readUInt16();
        char.halfWidth = Std.int(char.width) >> 1;
        char.halfHeight = Std.int(char.height) >> 1;
        char.xOffset = input.readInt16();
        char.yOffset = input.readInt16();
        char.xAdvance = input.readInt16();

        char.page = input.readByte();
        char.channel = input.readByte();

        currentFont.charMap[char.id] = char;
    }

    static inline function readZeroTerminatedString(input:BytesInput):String {
        var out:String = "";
        var byte:Int = 0;
        while ((byte = input.readByte()) != 0) out += String.fromCharCode(byte);
        return out;
    }

    static function readPages(input:BytesInput, blockSize:Int)
    {
        var target = input.position + blockSize;
        var idx = 0;
        currentFont.pageFileNames = new Array<String>();
        while (input.position < target) {
            currentFont.pageFileNames[idx++] = readZeroTerminatedString(input);
        }
    }

    static function readCommon(input:BytesInput, blockSize:Int) {

        currentFont.lineHeight = input.readUInt16();
        currentFont.base = input.readUInt16();
        currentFont.texWidth = input.readUInt16();
        currentFont.texHeight = input.readUInt16();
        currentFont.pageCount = input.readUInt16();
        currentFont.packed = input.readByte() & 1 > 0;
        currentFont.alphaChannel = input.readByte();
        currentFont.redChannel = input.readByte();
        currentFont.greenChannel = input.readByte();
        currentFont.blueChannel = input.readByte();
    }

    static function readInfo(input:BytesInput, blockSize:Int)
    {
        var start = input.position;
        var end = input.position + blockSize;
        var pre:Int = input.position;
        currentFont.size = input.readInt16();

        var bits = input.readByte();
        currentFont.smooth = bits & 128 > 0;
        currentFont.unicode = bits & 64 > 0;
        currentFont.italic = bits & 32 > 0;
        currentFont.bold = bits & 16 > 0;
        currentFont.fixedHeight = bits & 8 > 0;

        currentFont.charSet = input.readByte();
        currentFont.stretchH = input.readUInt16();
        currentFont.aa = input.readByte();
        currentFont.paddingUp = input.readByte();
        currentFont.paddingRight = input.readByte();
        currentFont.paddingDown = input.readByte();
        currentFont.paddingLeft = input.readByte();
        currentFont.spacingHorizontal = input.readByte();
        currentFont.spacingVertical = input.readByte();
        currentFont.outline = input.readByte();

        currentFont.name = readZeroTerminatedString(input);
    }
    */
}
