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

package media.animation;

import media.animation.TimelineData;

class AnimationData
{
    public var positionX (default, default): TimelineData;
    public var positionY (default, default): TimelineData;
    public var rotation (default, default): TimelineData;
    public var scaleX (default, default): TimelineData;
    public var scaleY (default, default): TimelineData;
    public var alpha (default, default): TimelineData;
    public var colorR (default, default): TimelineData;
    public var colorG (default, default): TimelineData;
    public var colorB (default, default): TimelineData;

    public function new(x: TimelineData, y: TimelineData, r: TimelineData, sx: TimelineData, sy: TimelineData, cR: TimelineData, cG: TimelineData, cB: TimelineData, a: TimelineData)
    {
        positionX = x;
        positionY = y;
        rotation = r;
        scaleX = sx;
        scaleY = sy;
        alpha = a;
        colorR = cR;
        colorG = cG;
        colorB = cB;
    }
}
