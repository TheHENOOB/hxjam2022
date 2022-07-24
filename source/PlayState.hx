package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var _player:Player;
	var _map:FlxOgmo3Loader;
	var _tilemap:FlxTilemap;

	override function create()
	{
		super.create();

		FlxG.camera.zoom = 3;

		bgColor = FlxColor.GRAY;

		_player = new Player();

		_map = new FlxOgmo3Loader(AssetPaths.base__ogmo, AssetPaths.level__json);
		_tilemap = _map.loadTilemap(AssetPaths.tiles__png);
		_tilemap.follow();
		_tilemap.setTileProperties(1, ANY);
		_map.loadEntities(placeEntities);

		FlxG.camera.setScrollBoundsRect(_tilemap.x, _tilemap.y, _tilemap.width, _tilemap.height);
		FlxG.worldBounds.set(_tilemap.x, _tilemap.y, _tilemap.width, _tilemap.height); // collision checking for the entire level

		// Layers
		add(_tilemap);
		add(_player);
	}

	override function update(elapsed:Float)
	{
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
