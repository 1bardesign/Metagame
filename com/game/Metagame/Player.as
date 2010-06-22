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
		private var _boxData:Object; //bounding boxes list
		private var _health:Number;
		private var _gibs:FlxEmitter; //hooray! maybe use more than one, for more cinematic deaths.
		public var collideVsLevel:Function;
		
		public function Player(X:int,Y:int)
		{
			super(X,Y);
			loadGraphic(ImgPlayer,true,true,40,40);
			
			//input. This should be expanded later,
			//I'm just doing it like this with a generic object so I don't need to go through and find all explicit references later.
			_keys = new Object();
			_keys.left="LEFT";
			_keys.right="RIGHT"
			_keys.jump="Z";
			_keys.crouch="X";
			//_keys.forward="UP";
			//_keys.backward="DOWN"; //for once we've got 3d.
			
			//basic player physics
			_inputThrust = new FlxPoint(2/3,3); //running and jump input thrust
			_airThrustMultiplier = 0.5;
			_crouchThrustMultiplier = 0.3;
			_crouchJumpMultiplier = 0.5; //don't know what happened here, I don't rememeber touching it. Back to 0.5
			_groundDrag = 0.8;
			_airDrag = 0.9;
			//1-gD=(1-aD)/aTM should roughly hold for smooth running jumps.
			_jumpDuration = 30;
			_gravity = 0.3;
			maxVelocity.x = 10;
			maxVelocity.y = 10;
			
			//health
			_health = 100
			
			//the player will have several states (standing, crouching, rolling etc) with different bounding boxes
			//this probably shouldn't be a generic object
			_boxData = new Object();
			_boxData.stand = {w:15,h:30,ox:12,oy:4};
			_boxData.crouch = {w:15,h:15,ox:12,oy:20};
			
			//set bounding box
			x -= width/2;
			y -= height; //the player's starting point should refer to the bottom of the sprite
			changeBoxes("stand");
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2, 3, 5, 6, 7], 0.2);
			addAnimation("jumpup", [2,3],0.07,false);
			addAnimation("jumpdown", [6,7],0.07,false);
			addAnimation("crouch", [4]);
		}
		
		override public function update():void
		{
			if(_health<=0)
			{
				//player is dead
			}
			
			//MOVEMENT
			//drag
			velocity.x *= onFloor?_groundDrag:_airDrag; //technically, this should be based on the force of gravity, but that would feel weird.
			//velocity.y *= onFloor?_groundDrag:_airDrag;
			//surface friction for the vertical component seems unfun.
			//for now I've disabled vertical drag totally because it caused problems with variable-height jumping.
			
			//input
						
			if(_crouching != FlxG.keys.pressed(_keys.crouch))
			{
				//we're switching states of crouchingness
				//adjust bounding box
				if(_crouching)
				{
					changeBoxes("stand");
					/*height = 30;
					offset.y = 4;
					y -= 10;*/
				}
				else
				{
					changeBoxes("crouch");
					/*height = 15;
					offset.y = 20;
					y += 16;*/
				}
			}
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
				acceleration.y -= _gravity*Math.pow(_jumpTimer,0.7); //this is unphysical. Its purpose is to allow variable height jumps.
			}
			//TODO: Aiming
			
			//We're not calling super.update().
			//The reason is that we want to collide between updateMotion and updateAnimation,
			//so we need to trigger them manually.
			super.updateMotion();
			collideVsLevel();
			
			acceleration.x = 0;
			acceleration.y = _gravity;
			//this acceleration reset means player.update() must come after every other object updates (which would make sense, anyway).
			//If we were to prevent this from being required we'd have to have separate impulse variables.
			
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
			
			//UPDATE ANIMATION
			super.updateAnimation();
			super.updateFlickering();
		}
		
		private function changeBoxes(stateID:String):void
		{
			var newState:Object = _boxData[stateID];
			y -= newState.h-height;
			x -= (newState.w-width)/2;
			width = newState.w;
			height = newState.h;
			offset.x = newState.ox;
			offset.y = newState.oy;
		}
		
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void
		{
			//if(velocity.y > 50)
				//FlxG.play(SndLand); ---------------------------------------------------ADD LANDING SOUND
			onFloor = true;
			_jumping = false;
			_jumpTimer = 0;
			super.hitBottom(Contact,Velocity);
		}
	}
}
