/*
 * File SpineJSONParser
 * Created by akir on 12/02/15
 * Project ABC
 * Copyright (c) 2014 GameDuell GmbH
 */

package media.animation.spine;

import haxe.ds.Vector;

class SpineJSONParser
{
	private var data: String;
	private var startIndex: Int;
	private var endIndex: Int;

	public function new(data: String)
	{
		this.data = data;
		this.startIndex = 0;
		this.endIndex = data.length;
	}

    public function parse(): Map<String, AnimationData>
    {
		startIndex = data.indexOf("animations") + "animations".length + 1;

		var animations = new Map<String, AnimationData>();
		if (!findObject("{", "}"))
		{
			return animations;
		}

		var oldEnd: Int = endIndex;

		while (startIndex < endIndex)
		{
			var name: String = findNextString();

			if (name == "" || !findObject("{", "}"))
			{
				break;
			}

			var animationData = parseAnimationData();
			animations.set(name, animationData);

			startIndex = endIndex;
			endIndex = oldEnd;
		}

		return animations;
    }

	private function parseAnimationData(): AnimationData
	{
		var xTimeline: TimelineData = null;
		var yTimeline: TimelineData = null;
		var rTimeline: TimelineData = null;
		var sxTimeline: TimelineData = null;
		var syTimeline: TimelineData = null;
		var cATimeline: TimelineData = null;
		var cRTimeline: TimelineData = null;
		var cGTimeline: TimelineData = null;
		var cBTimeline: TimelineData = null;

		var oldEnd: Int = endIndex;

		while (startIndex < endIndex)
		{
			var name = findNextString();
			if (!findObject("[", "]"))
			{
				break;
			}

			while (name != "rotate" && name != "color" && name != "translate" && name != "scale")
			{
				name = findNextString();
			}

			startIndex = data.indexOf("[", startIndex) + 1;

			switch (name)
			{
				case "rotate":
					rTimeline = parseFloatTimeline();
				case "color":
					var timelines: Array<TimelineData> = parseColorTimeline();
					cRTimeline = timelines[0];
					cGTimeline = timelines[1];
					cBTimeline = timelines[2];
					cATimeline = timelines[3];
				case "scale":
					var timelines: Array<TimelineData> = parseVec2Timeline();
					sxTimeline = timelines[0];
					syTimeline = timelines[1];
				case "translate":
					var timelines: Array<TimelineData> = parseVec2Timeline();
					xTimeline = timelines[0];
					yTimeline = timelines[1];
			}

			endIndex = oldEnd;
		}
		endIndex = oldEnd;

		var animationData = new AnimationData(xTimeline, yTimeline, rTimeline, sxTimeline, syTimeline, cRTimeline, cGTimeline, cBTimeline, cATimeline);
		return animationData;
	}

	private function parseFloatTimeline(): TimelineData
	{
		var oldEnd: Int = endIndex;
		var times = new Array<Float>();
		var values = new Array<Float>();
		var tweens = new Array<TweenData>();

		while (startIndex < endIndex)
		{
			if (!findObject("{", "}"))
			{
				break;
			}

			parseKeyframe(times, values, null, null, null, tweens);

			startIndex = endIndex;
			endIndex = oldEnd;
		}

		tweens.pop();

		if (tweens.length == 0)
		{
			return null;
		}

		return new TimelineData(tweens, times, values);
	}

	private function parseColorTimeline(): Array<TimelineData>
	{
		var timelines = new Array<TimelineData>();

		var oldEnd: Int = endIndex;
		var times = new Array<Float>();
		var rValues = new Array<Float>();
		var gValues = new Array<Float>();
		var bValues = new Array<Float>();
		var aValues = new Array<Float>();
		var tweens = new Array<TweenData>();

		while (startIndex < endIndex)
		{
			if (!findObject("{", "}"))
			{
				break;
			}

			parseKeyframe(times, rValues, gValues, bValues, aValues, tweens);

			startIndex = endIndex;
			endIndex = oldEnd;
		}

		tweens.pop();

		if (tweens.length > 0)
		{
			timelines.push(new TimelineData(tweens, times, rValues));
			timelines.push(new TimelineData(tweens, times, gValues));
			timelines.push(new TimelineData(tweens, times, bValues));
			timelines.push(new TimelineData(tweens, times, aValues));
		}
		else
		{
			timelines.push(null);
			timelines.push(null);
			timelines.push(null);
			timelines.push(null);
		}

		return timelines;
	}

	private function parseVec2Timeline(): Array<TimelineData>
	{
		var timelines = new Array<TimelineData>();

		var oldEnd: Int = endIndex;
		var times = new Array<Float>();
		var xValues = new Array<Float>();
		var yValues = new Array<Float>();
		var tweens = new Array<TweenData>();

		while (startIndex < endIndex)
		{
			if (!findObject("{", "}"))
			{
				break;
			}

			parseKeyframe(times, xValues, yValues, null, null, tweens);

			startIndex = endIndex;
			endIndex = oldEnd;
		}

		tweens.pop();

		if (tweens.length > 0)
		{
			timelines.push(new TimelineData(tweens, times, xValues));
			timelines.push(new TimelineData(tweens, times, yValues));
		}
		else
		{
			timelines.push(null);
			timelines.push(null);
		}

		return timelines;
	}

	private function parseKeyframe(times: Array<Float>, values0: Array<Float>, values1: Array<Float>, values2: Array<Float>, values3: Array<Float>, tweens: Array<TweenData>): Void
	{
		var name: String = findNextString();
		var tweenEncountered = false;
		while (name != "")
		{
			switch(name)
			{
				case "time":
					times.push(parseFloat());
				case "angle":
					values0.push(parseFloat());
				case "color":
					var values: Array<Float> = parseColor();
					values0.push(values[0]);
					values1.push(values[1]);
					values2.push(values[2]);
					values3.push(values[3]);
				case "x":
					values0.push(parseFloat());
				case "y":
					values1.push(parseFloat());
				case "curve":
					tweens.push(parseTween());
					tweenEncountered = true;
			}

			name = findNextString();
		}

		if (!tweenEncountered)
		{
			tweens.push(new TweenData(TweenType.Linear));
		}
	}

	private function parseTween(): TweenData
	{
		if (findNextString() != "")
			return new TweenData(TweenType.Linear);

		startIndex = data.indexOf("[", startIndex) + 1;
		var values = new Vector<Float>(4);
		for (i in 0...4)
		{
			var end: Int = data.indexOf(",", startIndex);
			if (end > endIndex)
			{
				end = endIndex;
			}
			values[i] = Std.parseFloat(data.substring(startIndex, end));
			startIndex = end + 1;
		}

		var tween = new TweenData(TweenType.Bezier);
		tween.parameters.push(values[1]);
		tween.parameters.push(values[3]);

		return tween;
	}

	private function parseColor(): Array<Float>
	{
		var rgba = new Array<Float>();

		var color: String = findNextString();
		for (i in 0...4)
		{
			var value: Int = charCodeToInt(color.charCodeAt(i * 2)) * 16 + charCodeToInt(color.charCodeAt(i * 2 + 1));
			rgba[i] = value / 255.0;
		}

		return rgba;
	}

	private function charCodeToInt(code: Int): Int
	{
		if (code >= '0'.code && code <= '9'.code)
		{
			return code - '0'.code;
		}

		return code - 'a'.code + 10;
	}

	private function parseFloat(): Float
	{
		var start: Int = data.indexOf(":", startIndex) + 1;
		var end: Int = data.indexOf(",", start);
		if (end > endIndex || end == -1)
		{
			end = endIndex;
		}
		return Std.parseFloat(data.substring(start, end));
	}

	private function findNextString(): String
	{
		var firstQuoteIndex: Int = data.indexOf("\"", startIndex) + 1;
		var secondQuoteIndex: Int = data.indexOf("\"", firstQuoteIndex);
		if (firstQuoteIndex == 0 || firstQuoteIndex >= endIndex || secondQuoteIndex >= endIndex)
		{
			return "";
		}

		startIndex = secondQuoteIndex + 1;
		return data.substring(firstQuoteIndex, secondQuoteIndex);
	}

	private function findObject(open: String, close: String): Bool
	{
		var balance = 1;
		var start: Int = data.indexOf(open, startIndex) + 1;
		if (start == 0)
		{
			return false;
		}

		while (balance > 0 && start < endIndex)
		{
			++start;
			if (data.charAt(start) == open)
			{
				++balance;
			}
			if (data.charAt(start) == close)
			{
				--balance;
			}
		}
		endIndex = start;
		return balance == 0;
	}
}
