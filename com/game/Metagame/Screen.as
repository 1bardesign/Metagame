package com.game.Metagame
{
	import org.flixel.*;

	public class Screen extends FlxGroup
	{
		//THE BASIC GAME SCREEN OF TILES AND OBJECTS! HOORAY!
		
		[Embed(source="../../../data/tilebase.png")] private var ImgTiles:Class;
		[Embed(source="../../../data/tilelines.png")] private var ImgLines:Class;
		
		//mostly internal stuff, but some of it's used for drawing and logic ==
		protected var screendata:String;	//all the actual data collected
		protected var chunks:Array;			//chunks of data		
		protected var tilestring:String;	//the string of tiles, postprocessing helper object
		protected var objectstring:String;	//the string of objects, preprocessing
		protected var level:Level; 		//the level the screen is a part of
		protected var position:Array; 		//the xyz position in the level
		//actual flxobject stuff ==============================================
		public var tiles:FlxGroup;
		public var objects:FlxGroup;
		
		public function Screen(data:String, level:Level, position:Array)
		{
			super();
			//------------PREPROCESSING THE DATA--------------------------------
			//DATA FORMAT: tiles/objects/OTHER STUFF NEED TO FIGURE FORMAT
			//THIS HAS CHANGED FROM [] separation to / separation. Still plan to
				//use bangs for object etc separation.
			/* hooray! we get to do some fun processing now!
			 * >_<; boring rubbish, but it's just string stuff anyway. */
			//the data, in case we need it for something later.
			screendata = data;
			/* splitting it into useful chunks
			 * they're separated by [] */
			chunks = screendata.split("/"); //works afaik, 0 based array produced
			FlxG.log(chunks);
			//the screen's tiles preprocessing, internal helper used later
			var mapstring:String = chunks[0];
			//the screen's objects
			objectstring = chunks[1];
			//get the position array
			position = position;
			//-----------------------DONE--------------------------------------
			
			//-------TILE PROCESSING----------------------------
			//initialise the tiles first
			tiles = new FlxGroup();
			
			//now initialise the string we're going to load
			//into the FlxTileMap
			tilestring = "";
			//hooray, some iteration -_-;
			//map is 25x18 for the record.
			for (var i:Number=0;i-1<mapstring.length/18;i++) {
			for (var j:Number=0;j<25;j++) 
			{
				//put some processing in here once we're using more than 1 and 0
				tilestring += mapstring.charAt(((i)*25)+j) + ",";
			}
			tilestring += "\n";
			}
			var tilemap:FlxTilemap;
			tilemap = new FlxTilemap;
			tilemap.collideIndex = 1;
			tilemap.loadMap(tilestring,ImgTiles,16);
			tiles.add(tilemap);
			//--------------------------------------------------
			
			//-------OBJECT PROCESSING--------------------------
			//OBJECT PROCESSING HERE
			objects = new FlxGroup();
			//--------------------------------------------------
			add(tiles); //tiles behind objects
			add(objects);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		protected function overlapped(Object1:FlxObject,Object2:FlxObject):void
		{
			//CALLED WHEN SHIT OVERLAPS LATER
		}
		
	}
}
