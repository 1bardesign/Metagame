package com.game.Metagame
{
	import org.flixel.*;

	public class Player extends FlxSprite
	{
		[Embed(source="../../../data/robot.png")] private var ImgPlayer:Class;
		private var _jumpPower:int;
		private var _jumpTime:Number;
		private var _jumping:Boolean;
		private var _up:Boolean;
		private var _down:Boolean;
		private var _gibs:FlxEmitter; //hooray! maybe use more than one, for more cinematic deaths.
		
		public function Player(X:int,Y:int)
		{
			super(X,Y);
			loadGraphic(ImgPlayer,true,true,32,32);
			
			//bounding box tweaks
			width = 14;
			height = 25;
			offset.x = 9;
			offset.y = 2;
			
			//basic player physics
			var runSpeed:uint = 150;
			drag.x = runSpeed*5;
			acceleration.y = 480;
			_jumpPower = 135;
			_jumpTime = 0
			maxVelocity.x = runSpeed;
			maxVelocity.y = 1000;
			
			//animations
			addAnimation("idle", [0]); //SECOND FRAME LOOKS PFF LAME, WILL NEED EITHER 3 FRAMES OR NO ANIM
			addAnimation("run", [2, 3, 4, 5, 6, 7, 8], 17);
			addAnimation("jumpup", [3,4],8,false);
			addAnimation("jumpdown", [6,7],8,false);
		}
		
		override public function update():void
		{
			//MOVEMENT
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
			{
				facing = LEFT;
				if (_jumping)
					acceleration.x -= drag.x / 2;
				else
					acceleration.x -= drag.x;
			}
			else if(FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				if (_jumping)
					acceleration.x += drag.x / 2;
				else
					acceleration.x += drag.x;
			}
			if(FlxG.keys.justPressed("UP") && onFloor)
			{
				velocity.y = -_jumpPower;
				_jumpTime = 3;
				_jumping = true;
			}
			else if (FlxG.keys.pressed("UP") && _jumping)
			{
				velocity.y += -_jumpPower*(2*_jumpTime^3)*FlxG.elapsed;
			}
			if (_jumping) //tick down and such
			{
				_jumpTime -= FlxG.elapsed*10;
				if (FlxG.keys.justReleased("UP") || _jumpTime < 0)
					_jumping = false;
				}
			
			//TODO: Aiming?
			
			//ANIMATION
			if(velocity.y < 0)
			{
				play("jumpup");
			}
			else if(velocity.y > 0)
			{
				play("jumpdown");
			}
			else if(velocity.x == 0)
			{
				play("idle");
			}
			else
			{
				play("run");
			}
			//interaction
			//if(FlxG.keys.justPressed("C"))
			//{
				//do interaction stuff here
			//}
			//UPDATE POSITION AND ANIMATION
			super.update();
		}
		
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void
		{
			//if(velocity.y > 50)
				//FlxG.play(SndLand); ---------------------------------------------------ADD LANDING SOUND
			onFloor = true;
			_jumping = false;
			_jumpTime = 0;
			return super.hitBottom(Contact,Velocity);
		}
		
		override public function hitSide(Contact:FlxObject,Velocity:Number):void
		{
			if (velocity.x > 30)
				velocity.x = -velocity.x*(2/3);
			else
				super.hitSide(Contact,Velocity);
		}
		
	}
}
