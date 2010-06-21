package com.game.Metagame
{
	import org.flixel.*;

	public class Level extends FlxGroup
	{
		//mostly internal stuff, but some of it's used for drawing and logic ==
		private var _data:String;			//the raw data
		protected var _name:String;			//the level's name
		protected var _author:String;			//the author(s)
		protected var _dimensions:Array;		//the dimensions
		protected var _leveldata:String;		//all the actual level data collected
		protected var _screenString:String;	//the string of screen data, preprocessing
		protected var _pStartPos:Array;		//the player's starting position.
				//NB PROCESSING OF THE SCREEN STRINGS IS DONE BY THE SCREEN OBJECT
		public var _screenArray:Array;			//a 3D array of the screens: <3 this one
		//actual flxobject stuff ==============================================
		public var _screens:FlxGroup;
		public var _curscreen:Screen;
		public var _player:Player;
		
		public function Level(data:String)
		{
			//BROKEN! ARRAYS NEED FIXING!
			super();
			/* DATA FORMAT:
			 * #name#author#x|y|z#scr1|scr2|scr3|...#px1|py1|px2|py2|pz3#
			 * hooray! we get to do some fun processing now!
			 * >_<; boring rubbish, but it's just string stuff anyway. */
			//the data, in case we need it for something later.
			_data = data;
			//helper vars
			var n1:uint = 0; var n2:uint = 0;
			/* splitting it into useful chunks
			 * most of them are separated by crunches */
			//the level's name
			n1 = data.indexOf("#",0) + 1;
			n2 = data.indexOf("#",n1);
			_name = data.slice(n1,n2);
			//the level's author (for bragging rights etc)
			n1 = n2+1;
			n2 = data.indexOf("#",n1);
			_author = data.slice(n1,n2);
			//the dimensions
			_dimensions = new Array(3);
			for (var i:Number=0;i<3;i++)
			{
				n1 = n2+1;
				if (i < 2)
					n2 = data.indexOf("|",n1);
				else
					n2 = data.indexOf("#",n1);
				_dimensions[i] = Number(data.slice(n1,n2));
			}
			//the screens! yay! finally some juiciness!
			_screenArray = new Array(_dimensions[0]);
			_screens = new FlxGroup;
			for (var x:Number=0;x<_dimensions[0];x++){ _screenArray[x] = new Array(_dimensions[1]); //adding 2d-ness
				for (var y:Number=0;y<_dimensions[1];y++){ _screenArray[x][y] = new Array(_dimensions[2]); //adding 3d-ness
				for (var z:Number=0;z<_dimensions[2];z++){ //add the screens to the y-axis array
				n1 = n2+1;
				if ((x != _dimensions[0] - 1) && (y != _dimensions[1] - 1) && (z != _dimensions[2] - 1))
					n2 = data.indexOf("|",n1);
				else
					n2 = data.indexOf("#",n1);
				_screenString = data.slice(n1,n2);
				var screen:Screen = new Screen(_screenString, this, new Array(x,y,z));
				_screenArray[x][y][z] = screen;
				_screens.add(screen);
			} } }
			//the player position
			_pStartPos = new Array(5);
			for (i=0;i<5;i++)
			{
				n1 = n2+1;
				if (i < 4) //5 indexes
					n2 = data.indexOf("|",n1);
				else
					n2 = data.indexOf("#",n1);
				_pStartPos[i] = Number(data.slice(n1,n2));
			}
			//TODO: THE REST
			
			add(_screens); //hooray for metagrouping!
			
			//update the current screen
			
			_curscreen = _screenArray[_pStartPos[2]-1][_pStartPos[3]-1][_pStartPos[4]-1];
			
			//--------PLAYER
			
			_player = new Player(_pStartPos[0],_pStartPos[1]);
			_player.collideVsTiles=function():void{
				FlxU.collide(_curscreen._tiles,_curscreen._objects);
			}
			_curscreen._objects.add(_player); //add it to the screen's objects!
			//-----------------------DONE--------------------------------------
			
		}
		
		override public function render():void
		{
			_curscreen.render();
			_player.render();
		}
		
		override public function update():void
		{
			_curscreen.update(); //can be extended later
			_player.update();
		}
		
	}
}
