package;

import Util.getSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class StartState extends FlxState
{
	final LOGOS:Array<String> = [
		AssetPaths.HENOOB__png,
		AssetPaths.stickmaniart__png,
		AssetPaths.jimmybiscuit__png,
		AssetPaths.hxjam__png
	];
	final SOUND:Array<Int> = [1, 2, 1, 3];

	public var _timer:FlxTimer;

	var _logocounter:Int;
	var _logos:Array<FlxSprite>;
	var _truecounter:Int;
	var _gamestarted:Bool;

	override function create()
	{
		super.create();

		FlxG.sound.play(getSound("assets/sounds/beep1"));

		_timer = new FlxTimer();
		_timer.start(3, (_) -> _logocounter++, LOGOS.length + 1);

		_logocounter = 0;
		_truecounter = 0;
		_logos = [];

		FlxG.watch.add(this, "_timer");

		for (i in LOGOS)
		{
			var target = new FlxSprite();
			target.loadGraphic(i);
			target.screenCenter();
			target.kill();

			_logos.push(target);
			add(_logos[_logos.length - 1]);
		}

		_logos[0].revive();

		_gamestarted = false;
	}

	override function update(elapsed:Float)
	{
		if (_truecounter < _logocounter && _logos[_logocounter] != null)
		{
			remove(_logos[_truecounter]);
			_logos[_logocounter].revive();
			_truecounter++;

			FlxG.sound.play(getSound("assets/sounds/beep" + (SOUND[_truecounter])));
		}

		if (_logos[_logocounter] == null)
		{
			startGame();
		}

		if (FlxG.keys.justReleased.SPACE || FlxG.keys.justReleased.ENTER)
		{
			startGame();
		}

		super.update(elapsed);
	}

	function startGame()
	{
		if (_gamestarted)
			return;

		FlxG.cameras.fade(FlxColor.BLACK, 1, false, () ->
		{
			FlxG.switchState(new PlayState());
		});
	}
}
