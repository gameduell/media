/*
 * File TimelineData
 * Created by akir on 19/02/15
 * Project ABC
 * Copyright (c) 2014 GameDuell GmbH
 */

package media.animation;

class TimelineData
{
    public var tweens (default, default): Array<TweenData>;
    public var values (default, default): Array<Float>;
    public var times (default, default): Array<Float>;

    public function new(tweens: Array<TweenData>, times: Array<Float>, values: Array<Float>)
    {
        this.tweens = new Array<TweenData>();
        for (tween in tweens)
        {
            this.tweens.push(tween);
        }

        this.values = new Array<Float>();
        for (value in values)
        {
            this.values.push(value);
        }

        this.times = new Array<Float>();
        for (time in times)
        {
            this.times.push(time);
        }
    }
}
