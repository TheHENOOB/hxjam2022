package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

class StartState extends FlxState
{
	var _text:FlxText;
	var _timer:FlxTimer;

	override function create()
	{
		super.create();

		_text = new FlxText();
		_text.alignment = CENTER;
		_text.size = 16;
		_text.text = "HENOOB CREATIONS\nStickmaniart Games\nJimmyBiscuit\n\nPresents An Game For The HaxeJam 2022";
		_text.screenCenter();
		add(_text);

		_timer = new FlxTimer().start(5, (_) -> startGame());
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.SPACE || FlxG.keys.justReleased.ENTER)
		{
			_timer.cancel();
			startGame();
		}

		super.update(elapsed);
	}

	function startGame()
	{
		FlxG.switchState(new PlayState());
	}
}
