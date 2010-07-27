package com.game.Metagame
{
	import org.flixel.*;

	public class Screen extends FlxGroup
	{
		//THE BASIC GAME SCREEN OF TILES AND OBJECTS! HOORAY!
		
		[Embed(source="../../../data/tilebase.png")] private var ImgTiles:Class;
		[Embed(source="../../../data/tilemask.png")] private var ImgMask:Class;
		[Embed(source="../../../data/tilelines.png")] private var ImgLines:Class;
		
		//mostly internal stuff, but some of it's used for drawing and logic ==
		protected var screendata:String;	//all the actual data collected
		protected var chunks:Array;			//chunks of data		
		protected var tilestring:String;	//the string of tiles, postprocessing helper object
		protected var objectstring:String;	//the string of objects, preprocessing
		protected var level:Level; 		//the level the screen is a part of
		public var position:Array; 		//the xyz position in the level
		//actual flxobject stuff ==============================================
		public var tiles:FlxGroup;
		public var decor:FlxGroup;
		public var FGMask:FlxTilemap;
		public var BGMask:FlxTilemap;
		public var objects:FlxGroup;
		
		public function Screen(data:String, level:Level, pos:Array)
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
			//the screen's tiles preprocessing, internal helper used later
			var mapstring:String = chunks[0];
			//the screen's mask string.
			var maskstring:String = chunks[1];
			//the screen's objects
			objectstring = chunks[2];
			//get the position array
			position = pos; //note to self, never use duplicate names >_>
			//-----------------------DONE--------------------------------------
			
			//-------TILE PROCESSING----------------------------
			//initialise the tiles first
			tiles = new FlxGroup();
			decor = new FlxGroup();
			
			//now initialise the string we're going to load
			//into the FlxTileMap
			tilestring = "";
			var topstring:String = "";
			var leftstring:String = "";
			var rightstring:String = "";
			var bottomstring:String = "";
			//hooray, some iteration -_-;
			//map is 25x17 for the record.
			for (var i:Number=0;i-1<mapstring.length/17;i++) {
			for (var j:Number=0;j<25;j++) 
			{
				var index:Number = ((i)*25)+j;
				//put some processing in here once we're using more than 1 and 0
				tilestring += mapstring.charAt(index) + ",";
				if (mapstring.charAt(index) == "1")
				{
					//if (index - 26 >= 0) {}
					if (index - 25 >= 0 && mapstring.charAt(index - 25) == "0") { topstring += "1,"; }
					else { topstring += "0,"; }
					//if (index - 24 >= 0) {}
					if (j != 0 && index - 1 >= 0 && mapstring.charAt(index - 1) == "0") { leftstring += "2,"; }
					else { leftstring += "0,"; }
					if (j != 24 && index + 1 <= 424 && mapstring.charAt(index + 1) == "0") { rightstring += "3,"; }
					else { rightstring += "0,"; }
					//if (index + 24 <= 424) {}
					if (index + 25 <= 424 && mapstring.charAt(index + 25) == "0") { bottomstring += "4,"; }
					else { bottomstring += "0,"; }
					//if (index + 26 <= 424) {}
				}
				else
				{
					topstring += "0,";
					leftstring += "0,";
					rightstring += "0,";
					bottomstring += "0,";
				}
			}
			tilestring += "\n";
			topstring += "\n";
			leftstring += "\n";
			rightstring += "\n";
			bottomstring += "\n";
			}
			//helper object
			var tilemap:FlxTilemap;
			//used for tiles first
			tilemap = new FlxTilemap;
			tilemap.loadMap(tilestring,ImgTiles,16);
			tiles.add(tilemap);
			//now reuse the delicious helper for the lines
			//bottom is the bottom map
			tilemap = new FlxTilemap;
			tilemap.y = +1;
			tilemap.loadMap(bottomstring,ImgLines,16);
			decor.add(tilemap);
			//left and right on top of that
			tilemap = new FlxTilemap;
			tilemap.loadMap(leftstring,ImgLines,16);
			decor.add(tilemap);
			tilemap = new FlxTilemap;
			tilemap.loadMap(rightstring,ImgLines,16);
			decor.add(tilemap);
			//then the top on top
			tilemap = new FlxTilemap;
			tilemap.y = -1;
			tilemap.loadMap(topstring,ImgLines,16);
			decor.add(tilemap);
			//--------------------------------------------------
			
			//-------MASK PROCESSING----------------------------
			//THIS IS SIMILAR TO THE ABOVE, BUT DOES 2 MAPS AT ONCE
			//initialise the maps first
			FGMask = new FlxTilemap;
			BGMask = new FlxTilemap;
			
			//now initialise the strings we're going to load
			//into the FlxTileMaps
			var FGstring:String = "";
			var BGstring:String = "";
			//hooray, more iteration
			for (i=0;i-1<maskstring.length/17;i++) {
			for (j=0;j<25;j++) 
			{
				//1 = can move backwards
				//2 = can move forwards
				//3 = can move both ways
				if (maskstring.charAt(((i)*25)+j) == "0")
				{
					FGstring += "0,";
					BGstring += "0,";
				}
				else if (maskstring.charAt(((i)*25)+j) == "1")
				{
					FGstring += "0,";
					BGstring += "1,";
				}
				else if (maskstring.charAt(((i)*25)+j) == "2")
				{
					FGstring += "1,";
					BGstring += "0,";
				}
				else if (maskstring.charAt(((i)*25)+j) == "3")
				{
					FGstring += "1,";
					BGstring += "1,";
				}
			}
			FGstring += "\n";
			BGstring += "\n";
			}
			FGMask.loadMap(FGstring,ImgMask,16);
			FGMask.collideIndex = 1;
			BGMask.loadMap(BGstring,ImgMask,16);
			BGMask.collideIndex = 1;
			//--------------------------------------------------
			
			//-------OBJECT PROCESSING--------------------------
			//OBJECT PROCESSING HERE
			objects = new FlxGroup();
			//--------------------------------------------------
			add(BGMask);
			add(tiles); //tiles behind objects
			add(decor); //decor above tiles
			add(objects);
			add(FGMask);
		}
		
		override public function update():void
		{
			super.update();
			//for if this needs extension
		}
		
	}
}
