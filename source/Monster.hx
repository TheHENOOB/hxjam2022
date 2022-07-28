package;

import PlayState.GameState;
import flixel.FlxG;
import flixel.FlxSprite;

class Monster extends FlxSprite
{
	public var curState(default, set):GameState;

	var _gravity:Float;
	var _statefunc:Float->Void;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);

		loadGraphic(AssetPaths.monster__png, true, 14, 25);

		animation.add("idle_calm", [0, 1], 1);
		animation.add("float_calm", [3]);
		animation.add("warning", [4, 0], 1);
		animation.add("idle_angry", [4]);
		animation.add("float_angry", [5]);

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		_gravity = PlayState.gravity;

		acceleration.y = _gravity;
	}

	override function update(elapsed:Float)
	{
		_statefunc(elapsed);

		super.update(elapsed);
	}

	function calm(elapsed:Float)
	{
		animation.play("idle_calm");
	}

	function warning(elapsed:Float)
	{
		animation.play("warning");
	}

	function angry(elapsed:Float) {}

	function set_curState(t:GameState)
	{
		switch (t)
		{
			case CALM:
				_statefunc = calm;
			case WARNING:
				_statefunc = warning;
			case ANGRY(_):
				_statefunc = angry;
		}

		return curState = t;
	}
}
