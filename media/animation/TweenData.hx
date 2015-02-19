/*
 * File TweenData
 * Created by akir on 19/02/15
 * Project ABC
 * Copyright (c) 2014 GameDuell GmbH
 */

package media.animation;

class TweenData
{
    public var type (default, default): TweenType;
    public var parameters (default, default): Array<Float>;

    public function new(type: TweenType)
    {
        this.type = type;
        parameters = new Array<Float>();
    }
}
