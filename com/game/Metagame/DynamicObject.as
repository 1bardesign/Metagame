package com.game.Metagame
{
	import org.flixel.*;

	public class DynamicObject extends FlxSprite
	{		
		protected var onLeft:Boolean;
		protected var onRight:Boolean;
		protected var onTop:Boolean;
		protected var groundDrag:Number;
		protected var airDrag:Number;
		protected var gravity:Number; //should we have gravity be global or per-object?
		protected var boxData:Object; //bounding boxes list
		protected var level:Level; //allows it to access the level object.
		public function DynamicObject(X:int,Y:int,lvl:Level)
		{
			super(X,Y);
			
			//The level reference
			level = lvl;
		}
		
		override public function update():void
		{
			
			//drag
			velocity.x *= onFloor?groundDrag:airDrag; //technically, this should be based on the force of gravity, but that would feel weird.
			velocity.y *= airDrag
			//surface friction for the vertical component seems unfun.
			
			super.updateMotion();
			onLeft=onRight=onTop=false;
			collideVsLevel();
						
			acceleration.x = 0;
			acceleration.y = gravity;
			//this acceleration reset means player.update() must come after every other object updates (which would make sense, anyway).
			//If we were to prevent this from being required we'd have to have separate impulse variables.
			
			//UPDATE ANIMATION
			super.updateAnimation();
			super.updateFlickering();
		}
		
		protected function changeBoxes(stateID:String):void
		{
			var newState:Object = boxData[stateID];
			y -= newState.h-height;
			x -= (newState.w-width)/2;
			width = newState.w;
			height = newState.h;
			offset.x = newState.ox;
			offset.y = newState.oy;
		}
		
		public function collideVsLevel():void
		{
			FlxU.collide(level.curscreen.tiles,level.curscreen.objects);
		}
		
		override public function hitLeft(Contact:FlxObject,Velocity:Number):void
		{
			onLeft=true;
			super.hitLeft(Contact,Velocity);
		}
		override public function hitRight(Contact:FlxObject,Velocity:Number):void
		{
			onRight=true;
			super.hitRight(Contact,Velocity);
		}
		override public function hitTop(Contact:FlxObject,Velocity:Number):void
		{
			onTop=true;
			super.hitTop(Contact,Velocity);
		}
	}
}
