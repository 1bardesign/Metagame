package com.game.Metagame
{
	import org.flixel.*;

	public class Player extends FlxSprite
	{
		[Embed(source="../../../data/robot.png")] private var ImgPlayer:Class;
		
		private var _keys:Object;
		private var _inputThrust:FlxPoint;
		private var _airThrustMultiplier:Number;
		private var _crouching:Boolean;
		private var _crouchThrustMultiplier:Number;
		private var _crouchJumpMultiplier:Number;
		private var _groundDrag:Number;
		private var _airDrag:Number;
		private var _jumping:Boolean;
		private var _jumpTimer:Number; //variable that times the length of each jump
		private var _jumpDuration:Number;
		private var _gravity:Number; //should we have gravity be global or per-object?
		private var _gibs:FlxEmitter; //hooray! maybe use more than one, for more cinematic deaths.
		public var collideVsTiles:Function;
		
		public function Player(X:int,Y:int)
		{
			super(X,Y);
			loadGraphic(ImgPlayer,true,true,32,32);
			
			//bounding box tweaks
			width = 14;
			height = 25;
			offset.x = 9;
			offset.y = 2;
			
			//input. This should be expanded later,
			//I'm just doing it like this with a generic object so I don't need to go through and find all explicit references later.
			_keys = new Object();
			_keys.left="A";
			_keys.right="D"
			_keys.jump="W";
			_keys.crouch="SPACE";
			
			//basic player physics
			_inputThrust = new FlxPoint(2/3,3); //running and jump input thrust
			_airThrustMultiplier = 1/2;
			_crouchThrustMultiplier = 0.3;
			_crouchJumpMultiplier = 0.5;
			_groundDrag = 0.8;
			_airDrag = 0.9;
			//1-gD=(1-aD)/aTM should roughly hold for smooth running jumps.
			_jumpDuration = 30;
			_gravity = 0.3;
			maxVelocity.x = 10;
			maxVelocity.y = 10;
			
			//animations
			addAnimation("idle", [0]); //SECOND FRAME LOOKS PFF LAME, WILL NEED EITHER 3 FRAMES OR NO ANIM
			addAnimation("run", [2, 3, 4, 5, 6, 7, 8], 0.2);
			addAnimation("jumpup", [3,4],0.07,false);
			addAnimation("jumpdown", [6,7],0.07,false);
			addAnimation("crouch", [10]);
		}
		
		override public function update():void
		{
			//MOVEMENT

			//drag
			velocity.x *= onFloor?_groundDrag:_airDrag; //technically, this should be based on the force of gravity, but that would feel weird.
			//velocity.y *= onFloor?_groundDrag:_airDrag;
			//surface friction for the vertical component seems unfun.
			//for now I've disabled vertical drag totally because it caused problems with variable-height jumping.
			
			//input
			_crouching = FlxG.keys.pressed(_keys.crouch);
			var thrustDir:int = int(FlxG.keys.pressed(_keys.right))-int(FlxG.keys.pressed(_keys.left)); //1 is right, -1 is left.
			if (thrustDir != 0)
			{
				facing = thrustDir>0?RIGHT:LEFT;
				acceleration.x += thrustDir*_inputThrust.x;
				if (!onFloor)
					acceleration.x *= _airThrustMultiplier; //less thrust in the air
				if(_crouching)
					acceleration.x *= _crouchThrustMultiplier; //less thrust while crouching
			}
			if(FlxG.keys.justPressed(_keys.jump) && onFloor)
			{
				acceleration.y -= _inputThrust.y*(_crouching ? _crouchJumpMultiplier : 1);
				_jumpTimer = 1; //after this timer elapses (gets to zero), the player can no longer control the vertical of the jump
				_jumping = true;
			}
			if (_jumping) //tick down and such
			{
				_jumpTimer -= 1/_jumpDuration;
				if (FlxG.keys.justReleased(_keys.jump) || _jumpTimer < 0)
					_jumping = false;
			}
			if (FlxG.keys.pressed(_keys.jump) && _jumping)
			{
				acceleration.y -= _gravity*Math.pow(_jumpTimer,0.7); //_inputThrust.y*_jumpTimer^2; //this is unphysical. Its purpose is to allow variable height jumps.
			}
			//TODO: Aiming
			
			super.updateMotion();
			collideVsTiles();
			
			acceleration.x = 0;
			acceleration.y = _gravity;
			//this acceleration reset means player.update() must come after every other object updates (which would make sense, anyway).
			//in order to prevent this from being required we'd have to have separate impulse variables.
			
			//ANIMATION
			if(_crouching)
			{
				play("crouch");
			}
			else if(velocity.y < 0)
			{
				play("jumpup");
			}
			else if(velocity.y > 0)
			{
				play("jumpdown");
			}
			else if(thrustDir == 0)
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
			
			//UPDATE ANIMATION
			super.updateAnimation();
			super.updateFlickering();
		}
		
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void
		{
			//if(velocity.y > 50)
				//FlxG.play(SndLand); ---------------------------------------------------ADD LANDING SOUND
			onFloor = true;
			_jumping = false;
			_jumpTimer = 0;
			return super.hitBottom(Contact,Velocity);
		}
	}
}