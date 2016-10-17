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
	private var input: String;
	private var currentIndex: Int;

	public static function readFromString(fileAsString: String): GDXAtlasDef
	{
		var reader = new GDXAtlasReader(fileAsString);
		return reader.readAtlas();
	}

	private function new(file: String)
	{
		input = file;
		currentIndex = 0;
	}

	private function readAtlas(): GDXAtlasDef
	{
		var result = new GDXAtlasDef();

		result.atlasImageName = readString();
		var extension: String = result.atlasImageName.substr(result.atlasImageName.indexOf("."));
		skipToNextLine();	// Skip size
		skipToNextLine();	// Skip format
		skipToNextLine();	// Skip filtering
		skipToNextLine();	// Skip repeat mode

		while (!isEndReached(currentIndex))
		{
			var def = new GDXAtlasImageDef();
			def.name = readString() + extension;
			skipString();	// rotate:
			def.rotated = compareString("true");
			skipString();

			skipString();	// xy: X, Y
			def.x = readInt();
			skipString();
			def.y = readInt();

			skipString();	// size: W, H
			def.sizeWidth = readInt();
			skipString();
			def.sizeHeight = readInt();

			skipString();	// orig: X, Y
			def.origSizeWidth = readInt();
			skipString();
			def.origSizeHeight = readInt();

			skipString();	// offset: X, Y
			def.offsetX = readInt();
			skipString();
			def.offsetY = readInt();

			skipString();	// index: I
			def.index = readInt();

			result.imageDefinitions.push(def);
		}

		return result;
	}

	private function skipWhitespace(index: Int): Int
	{
		while (isWhitespace(index) && !isEndReached(index))
		{
			++index;
		}
		return index;
	}

	private inline function isWhitespace(index: Int): Bool
	{
		var char: Int = input.charCodeAt(index);
		return (char == ' '.code || char == '\t'.code || char == '\r'.code || char == '\n'.code);
	}

	private inline function isEndReached(index: Int): Bool
	{
		return index >= input.length;
	}

	private function skipToNextLine(): Void
	{
		while (input.charCodeAt(currentIndex) != '\n'.code && input.charCodeAt(currentIndex) != '\r'.code && !isEndReached(currentIndex))
		{
			++currentIndex;
		}
		++currentIndex;
	}

	private function skipString(): Void
	{
		while (!isWhitespace(currentIndex) && !isEndReached(currentIndex))
		{
			++currentIndex;
		}
		currentIndex = skipWhitespace(currentIndex);
	}

	private function readString(): String
	{
		if (isEndReached(currentIndex))
		{
			return null;
		}

		currentIndex = skipWhitespace(currentIndex);

		var start: Int = currentIndex;
		var end: Int = currentIndex;
		while (!isWhitespace(end) && !isEndReached(end))
		{
			++end;
		}

		currentIndex = end;
		currentIndex = skipWhitespace(currentIndex);
		return input.substring(start, end);
	}

	private inline function compareString(value: String): Bool
	{
		var index: Int = currentIndex;
		var valueIndex: Int = 0;
		while (!isEndReached(index) && valueIndex < value.length && input.charCodeAt(index) == value.charCodeAt(valueIndex))
		{
			++index;
			++valueIndex;
		}

		return valueIndex == value.length;
	}

	private function readInt(): Int
	{
		var result: Int = 0;

		var negate: Bool = false;
		if (input.charCodeAt(currentIndex) == '-'.code)
		{
			negate = true;
			++currentIndex;
		}
		else if (input.charCodeAt(currentIndex) == '+'.code)
		{
			++currentIndex;
		}

		var char: Int = input.charCodeAt(currentIndex);
		while (!isEndReached(currentIndex) && char >= '0'.code && char <= '9'.code)
		{
			result *= 10;
			result += char - '0'.code;
			++currentIndex;
			char = input.charCodeAt(currentIndex);
		}

		if (negate)
		{
			result = -result;
		}

		currentIndex = skipWhitespace(currentIndex);

		return result;
	}
}
