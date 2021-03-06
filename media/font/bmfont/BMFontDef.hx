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

    public function copy(destination: BMFontDef): Void
    {
        destination.name = name;
        destination.size = size;
        destination.pageFileNames = pageFileNames;

        destination.smooth = smooth;
        destination.unicode = unicode;
        destination.italic = italic;
        destination.bold = bold;
        destination.fixedHeight = fixedHeight;
        destination.charSet = charSet;
        destination.stretchH = stretchH;
        destination.aa = aa;
        destination.paddingUp = paddingUp;
        destination.paddingRight = paddingRight;
        destination.paddingDown = paddingDown;
        destination.paddingLeft = paddingLeft;
        destination.spacingHorizontal = spacingHorizontal;
        destination.spacingVertical = spacingVertical;
        destination.outline = outline;
        destination.lineHeight = lineHeight;
        destination.base = base;
        destination.xHeight = xHeight;
        destination.texWidth = texWidth;
        destination.texHeight = texHeight;
        destination.pageCount = pageCount;
        destination.alphaChannel = alphaChannel;
        destination.redChannel = redChannel;
        destination.greenChannel = greenChannel;
        destination.blueChannel = blueChannel;
        destination.charMap = charMap;
        destination.kerningsMap = kerningsMap;
        destination.packed = packed;
    }
}
