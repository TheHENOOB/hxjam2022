package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

class HUD extends FlxSpriteGroup
{
	var _timerSprite:FlxText;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);

		_timerSprite = new FlxText(10, 10);
		add(_timerSprite);
	}

	override function update(elapsed:Float)
	{
		_timerSprite.text = Std.string(Math.floor(PlayState.timer));

		super.update(elapsed);
	}
}
