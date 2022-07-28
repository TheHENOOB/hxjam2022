package;

import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDirectionFlags;

// An modified version of flixel.math.FlxVelocity.moveTowardsPoint that adds an Y parameter
function moveTowardsPoint(Source:FlxSprite, Target:FlxPoint, SpeedX:Float, SpeedY:Float, MaxTime:Int = 0)
{
	var a:Float = FlxAngle.angleBetweenPoint(Source, Target);

	if (MaxTime > 0)
	{
		var d:Int = FlxMath.distanceToPoint(Source, Target);

		//	We know how many pixels we need to move, but how fast?
		SpeedX = Std.int(d / (MaxTime / 1000));
		SpeedY = Std.int(d / (MaxTime / 1000));
	}

	Source.velocity.x = Math.cos(a) * SpeedX;
	Source.velocity.y = Math.sin(a) * SpeedY;

	Target.putWeak();
}

// Get multiple tiles (DRY)
function setMultipleTiles(target:FlxTilemap, min:Int, max:Int, value:FlxDirectionFlags)
{
	for (i in min...max)
	{
		target.setTileProperties(i, value);
	}
}

inline function getSound(path:String):String
{
	#if html5
	return path + ".mp3";
	#elseif desktop
	return path + ".ogg";
	#else
	return "";
	#end
}
