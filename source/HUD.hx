package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class HUD extends FlxSpriteGroup
{
	public var timer:Float;

	var _timerSprite:FlxText;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);

		_timerSprite = new FlxText(10, 10);
		add(_timerSprite);
	}

	override function update(elapsed:Float)
	{
		_timerSprite.text = Std.string(Math.floor(timer));

		if (timer <= 0)
		{
			_timerSprite.color = FlxColor.RED;
		}
		else
		{
			_timerSprite.color = FlxColor.WHITE;
		}

		super.update(elapsed);
	}
}
