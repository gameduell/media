/*
 * File AnimationData
 * Created by akir on 12/02/15
 * Project ABC
 * Copyright (c) 2014 GameDuell GmbH
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
