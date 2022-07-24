package;

import flixel.FlxG;
import flixel.FlxSprite;

using flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{
	static inline var gravity = 900;
	static inline var speed = 75;
	static inline var maxSpeed = 300;
	static inline var jumpForce = 150;
	static inline var jumpTimer = 1;

	var _isJumping:Bool;
	var _jumpTimer:Float;

	public function new()
	{
		super();

		_jumpTimer = -1;
		_isJumping = false;

		loadGraphic(AssetPaths.player__png, true, 12, 13);
		animation.add("idle", [0]);
		animation.add("walk", [0, 1], 15);
		animation.add("dead", [2]);
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);
		animation.play("idle");

		acceleration.y = gravity;
		drag.x = 500;
		// maxVelocity.set(maxSpeed, maxSpeed);

		FlxG.camera.follow(this, PLATFORMER);
	}

	override function update(elapsed:Float)
	{
		playerControls();
		this.bound(0, FlxG.width, 0, FlxG.height);

		if (_jumpTimer >= 0)
			_jumpTimer -= elapsed;

		if (isTouching(FLOOR))
		{
			_isJumping = false;
			_jumpTimer = 0;
			acceleration.y = 0;
		}

		if (_jumpTimer <= 0 && _isJumping)
		{
			velocity.y = 0;
			_isJumping = false;
		}

		if (!_isJumping)
		{
			acceleration.y = gravity;
		}

		super.update(elapsed);
	}

	function playerControls()
	{
		var up:Bool = FlxG.keys.pressed.UP || FlxG.keys.pressed.W || FlxG.keys.pressed.SPACE;
		var left:Bool = FlxG.keys.pressed.LEFT || FlxG.keys.pressed.A;
		var right:Bool = FlxG.keys.pressed.RIGHT || FlxG.keys.pressed.D;
		var down:Bool = FlxG.keys.pressed.DOWN || FlxG.keys.pressed.S;

		if (up && isTouching(FLOOR) && !_isJumping)
		{
			_jumpTimer = jumpTimer;
			_isJumping = true;

			velocity.y = -jumpForce;
		}

		if (left && right)
		{
			animation.play("idle");
			return;
		}

		if (left)
		{
			velocity.x = -speed;
			animation.play("walk");
			facing = LEFT;
		}
		else if (right)
		{
			velocity.x = speed;
			animation.play("walk");
			facing = RIGHT;
		}
		else
		{
			animation.play("idle");
		}
	}
}
