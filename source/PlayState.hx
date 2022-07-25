package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public static var timer:Float;

	var _player:Player;
	var _map:FlxOgmo3Loader;
	var _tilemap:FlxTilemap;
	var _hud:HUD;
	var _hudCam:FlxCamera;

	override function create()
	{
		super.create();

		FlxG.camera.zoom = 3;

		bgColor = FlxColor.GRAY;

		timer = 30;

		_player = new Player();

		_map = new FlxOgmo3Loader(AssetPaths.base__ogmo, AssetPaths.level__json);
		_tilemap = _map.loadTilemap(AssetPaths.tiles__png);
		_tilemap.follow();
		_tilemap.setTileProperties(1, ANY);
		_map.loadEntities(placeEntities);

		FlxG.camera.setScrollBoundsRect(_tilemap.x, _tilemap.y, _tilemap.width, _tilemap.height);
		FlxG.worldBounds.set(_tilemap.x, _tilemap.y, _tilemap.width + 100, _tilemap.height + 100); // collision checking for the entire level

		// Layers
		add(_tilemap);
		add(_player);

		// This was an pain in the ass, I am not going to touch on alignment on this thing
		_hud = new HUD(_tilemap.width, 0);
		_hudCam = new FlxCamera(0, Std.int(-(FlxG.height / 2)), Std.int(FlxG.width / 3), Std.int(FlxG.height / 3), 3);
		_hudCam.bgColor = FlxColor.TRANSPARENT;
		_hudCam.focusOn(new FlxPoint(_hud.x + 140, _hud.y));
		FlxG.cameras.add(_hudCam);
		add(_hud);

		FlxG.watch.add(FlxG.cameras, "list");
		FlxG.watch.add(_hud, "x");
	}

	override function update(elapsed:Float)
	{
		timer -= elapsed;

		super.update(elapsed);

		FlxG.collide(_player, _tilemap);
	}

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				_player.setPosition(entity.x, entity.y);
		}
	}
}
