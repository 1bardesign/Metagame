package com.game.Metagame
{
	import org.flixel.*;

	public class Level extends FlxGroup
	{
		//mostly internal stuff, but some of it's used for drawing and logic ==
		private var data:String;			//the raw data
		private var dataArray:Array;		//post-split data
		protected var name:String;			//the level's name
		protected var author:String;			//the author(s)
		protected var dimensions:Array;		//the dimensions
		protected var leveldata:String;		//all the actual level data collected
		protected var pStartPos:Array;		//the player's starting position.
				//NB PROCESSING OF THE SCREEN STRINGS IS DONE BY THE SCREEN OBJECT
		public var screenArray:Array;			//a 3D array of the screens: <3 this one
		//actual flxobject stuff ==============================================
		public var screens:FlxGroup;
		public var curscreen:Screen;
		public var player:Player;
		
		public function Level(input:String)
		{
			//BROKEN! ARRAYS NEED FIXING!
			super();
			/* DATA FORMAT:
			 * #name#author#x|y|z#scr1|scr2|scr3|...#px1|py1|px2|py2|pz3#
			 * hooray! we get to do some fun processing now!
			 * >_<; boring rubbish, but it's just string stuff anyway. */
			//the data, in case we need it for something later.
			data = input;
			dataArray = data.split("#"); // using split now, cheers matt
			//the level's name
			name = dataArray[1]; //[0] is "" because of the preceding #
			//the author
			author = dataArray[2];
			//the dimensions
			dimensions = dataArray[3].split("|");
			//the screens! yay! finally some juiciness!
			screenArray = new Array(dimensions[0]);
			screens = new FlxGroup;
			var screenDataArray:Array = dataArray[4].split("|").reverse(); //we want it flipped so we can pop stuff out of it.
			for (var x:Number=0;x<dimensions[0];x++)
			{
				screenArray[x] = new Array(dimensions[1]); //adding 2d-ness
				for (var y:Number=0;y<dimensions[1];y++)
				{
					screenArray[x][y] = new Array(dimensions[2]); //adding 3d-ness
					for (var z:Number=0;z<dimensions[2];z++)
					{ //add the screens to the y-axis array
						var screenString:String = screenDataArray.pop(); //temp string
						var screen:Screen = new Screen(screenString, this, new Array(x,y,z));
						screenArray[x][y][z] = screen;
						screens.add(screen);
					}
				}
			}
			//the player position
			pStartPos = dataArray[5].split("|");
			//TODO: THE REST
			
			add(screens); //hooray for metagrouping!
			
			//update the current screen
			
			curscreen = screenArray[pStartPos[2]-1][pStartPos[3]-1][pStartPos[4]-1];
			
			//--------PLAYER
			
			player = new Player(pStartPos[0],pStartPos[1]);
			player.collideVsLevel = function():void
			{
				FlxU.collide(curscreen.tiles,curscreen.objects);
			}
			curscreen.objects.add(player); //add it to the screen's objects!
			//-----------------------DONE--------------------------------------
			
		}
		
		override public function render():void
		{
			curscreen.render();
			//player.render();
		}
		
		override public function update():void
		{
			curscreen.update(); //can be extended later
		}
		
	}
}
