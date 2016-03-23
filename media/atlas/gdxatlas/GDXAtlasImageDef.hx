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
