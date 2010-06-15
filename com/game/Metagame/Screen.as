package com.game.Metagame
{
	import org.flixel.*;

	public class Screen extends FlxGroup
	{
		//THE BASIC GAME SCREEN OF TILES AND OBJECTS! HOORAY!
		
		[Embed(source="../../../data/tilebase.png")] private var ImgTiles:Class;
		[Embed(source="../../../data/tilelines.png")] private var ImgLines:Class;
		
		//mostly internal stuff, but some of it's used for drawing and logic ==
		protected var _screendata:String;	//all the actual data collected
		protected var _tilestring:String;	//the string of tiles, postprocessing helper object
		protected var _objectstring:String;	//the string of objects, preprocessing
		protected var _level:Level; 		//the level the screen is a part of
		protected var _position:Array; 		//the xyz position in the level
		//actual flxobject stuff ==============================================
		public var _tiles:FlxGroup;
		public var _objects:FlxGroup;
		
		public function Screen(data:String, level:Level, position:String)
		{
			//------------PREPROCESSING THE DATA--------------------------------
			//DATA FORMAT: [tiles][objects][OTHER STUFF NEED TO FIGURE FORMAT LATER]
			//POSITION FORMAT: [x|y|z]
			/* hooray! we get to do some fun processing now!
			 * >_<; boring rubbish, but it's just string stuff anyway. */
			//the data, in case we need it for something later.
			_screendata = data;
			//helper vars
			var n1:uint = 0;
			var n2:uint = 0;
			/* splitting it into useful chunks
			 * they're separated by [] */
			//the screen's tiles
			var mapstring:String;
			n1 = data.indexOf("[",0) + 1;
			n2 = data.indexOf("]",n1);
			mapstring = data.slice(n1,n2);
			//the screen's objects
			n1 = n2+1;
			n2 = data.indexOf("]",n1);
			_objects = data.slice(n1,n2);
			//-----------------------DONE--------------------------------------
			
			//-------TILE PROCESSING----------------------------
			//initialise the tiles first
			_tiles = new FlxGroup();
			
			//now initialise the string we're going to load
			//into the FlxTileMap
			_tilestring = "";
			//hooray, some iteration -_-
			//map is 25x18 for the record.
			for(i=0;i-1<mapstring.length/18;i++) {
			for(j=0;j<25;j++) 
			{
				_tilestring += mapstring.chatAt(((i)*25)+j) + ",";
			}
			_tilestring += "\n"
			}
			var tilemap:FlxTilemap;
			tilemap = new FlxTilemap;
			tilemap.collideIndex = 1;
			tilemap.loadMap(_tilestring,ImgTiles,16);
			_tiles.add(_tiles);
			//--------------------------------------------------
			
			//-------OBJECT PROCESSING--------------------------
			//OBJECT PROCESSING HERE
			_objects = new FlxGroup();
			//--------------------------------------------------
			
			super();
			
		}
		
		override public function update():void
		{
			FlxU.collide(_tiles,_objects);
			FlxU.collide(_objects,_objects);
			super.update();
		}
		
	}
}
