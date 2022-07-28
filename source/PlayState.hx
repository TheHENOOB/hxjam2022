package;

import Util.getSound;
import Util.setMultipleTiles;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;

class PlayState extends FlxState
{
	public static var state:GameState;
	public static var signal:FlxTypedSignal<GameState->Void>;

	public static inline var gravity:Float = 900;

	static inline var _zoom:Float = 3;
	static inline var _hardspam:Float = 10;
	static inline var _hardmax:Float = 30;

	// Bg Colors
	static inline var _pink:FlxColor = 0xFF6E2C6B;

	var timer(default, set):Int;

	var _realtimer:Float;
	var _player:Player;
	var _map:FlxOgmo3Loader;
	var _tilemapcalm:FlxTilemap;
	var _tilemapangry:FlxTilemap;
	var _hud:HUD;
	var _hudCam:FlxCamera;
	var _runwarning:Bool;
	var _calmmusic:FlxSound;
	var _angrymusic:FlxSound;
	var _monsters:FlxTypedGroup<Monster>;

	override function create()
	{
		super.create();

		FlxG.camera.zoom = _zoom;

		FlxG.camera.color = _pink;

		_calmmusic = new FlxSound();
		_calmmusic.loadEmbedded(getSound("assets/music/calm"), true);
		_calmmusic.play();

		_angrymusic = new FlxSound();
		_angrymusic.loadEmbedded(getSound("assets/music/anger"), true);
		_angrymusic.volume = 0;
		_angrymusic.play();

		signal = new FlxTypedSignal();
		signal.add(stateSignal);

		#if debug
		FlxG.console.registerFunction("setTimer", setTimer);
		#end

		_player = new Player();

		_monsters = new FlxTypedGroup();

		_map = new FlxOgmo3Loader(AssetPaths.base__ogmo, AssetPaths.level__json);

		_tilemapcalm = _map.loadTilemap(AssetPaths.tiles_calm__png);
		_tilemapcalm.follow();
		setMultipleTiles(_tilemapcalm, 3, 13, ANY);
		setMultipleTiles(_tilemapcalm, 1, 2, NONE);

		_tilemapangry = _map.loadTilemap(AssetPaths.tiles_angry__png);
		_tilemapangry.visible = false;

		FlxG.camera.setScrollBoundsRect(_tilemapcalm.x, _tilemapcalm.y, _tilemapcalm.width, _tilemapcalm.height);
		FlxG.worldBounds.set(_tilemapcalm.x, _tilemapcalm.y, _tilemapcalm.width + 100, _tilemapcalm.height + 100); // collision checking for the entire level

		// Layers
		add(_tilemapangry);
		add(_tilemapcalm);
		add(_monsters);
		_map.loadEntities(placeEntities);

		// This was an pain in the ass since I never touched on FlxCamera, Ill make changes after jam
		_hud = new HUD(_tilemapcalm.width, 0);
		_hudCam = new FlxCamera(0, Std.int(-(FlxG.height / 2)), Std.int(FlxG.width / _zoom), Std.int(FlxG.height / _zoom), _zoom);
		_hudCam.bgColor = FlxColor.TRANSPARENT;
		_hudCam.focusOn(new FlxPoint(_hud.x + 140, _hud.y));
		FlxG.cameras.add(_hudCam);
		add(_hud);

		timer = 30;
		_realtimer = 1;

		state = CALM;

		// FlxG.watch.add(FlxG.cameras, "list");
		// FlxG.watch.add(_hud, "x");
	}

	override function update(elapsed:Float)
	{
		if (timer >= -_hardmax)
		{
			_realtimer -= elapsed;
		}

		if (_realtimer <= 0)
		{
			timer--;
			_realtimer = 1;
		}

		super.update(elapsed);

		FlxG.collide(_player, _tilemapcalm);
		FlxG.collide(_monsters, _tilemapcalm);
	}

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				_player.setPosition(entity.x, entity.y);
				add(_player);
			case "monster":
				_monsters.add(new Monster(entity.x, entity.y));
		}
	}

	function stateSignal(t:GameState)
	{
		if (t == CALM && state == CALM)
			return;

		switch (t)
		{
			case(CALM):
				_tilemapcalm.visible = true;
				_tilemapangry.visible = false;
				_calmmusic.volume = 1;
				_angrymusic.volume = 0;
				FlxG.camera.bgColor = _pink;
			case(WARNING):
				_tilemapcalm.visible = !_tilemapcalm.visible;
				_tilemapangry.visible = !_tilemapangry.visible;
				FlxG.camera.bgColor = (FlxG.camera.bgColor == _pink) ? FlxColor.BLACK : _pink;
				if (!_runwarning)
					warning();
			case(ANGRY(i)):
				_tilemapcalm.visible = false;
				_tilemapangry.visible = true;
				FlxG.camera.bgColor = FlxColor.BLACK;
				_runwarning = false;
		}

		_monsters.forEach((m:Monster) -> m.curState = t);

		PlayState.state = t;
	}

	function warning()
	{
		_runwarning = true;

		FlxTween.num(0, 1, 10, {}, (i:Float) ->
		{
			_angrymusic.volume = i;
		});

		FlxTween.num(1, 0, 10, {}, (i:Float) ->
		{
			_calmmusic.volume = i;
		});
	}

	function set_timer(t:Int)
	{
		if (t <= 0)
		{
			signal.dispatch(ANGRY(Math.floor(Math.abs(t) / 10)));
		}
		else if (t <= 10)
		{
			signal.dispatch(WARNING);
		}
		else
		{
			signal.dispatch(CALM);
		}

		_hud.timer = t;

		return timer = t;
	}

	#if debug
	function setTimer(t:Int)
	{
		timer = t;
	}
	#end
}

enum GameState
{
	CALM;
	WARNING;
	ANGRY(level:Int);
}
