package com.game.Metagame
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		[Embed(source="../../../data/tilebase.png")] private var ImgTiles:Class;
		//[Embed(source="../../../data/map.txt",mimeType="application/octet-stream")] private var TxtMap:Class;
		[Embed(source="../../../data/04B03.TTF", fontName="F04B", embedAsCFF="false", mimeType="application/x-font-truetype")]
			private var F04:Class; //EMBED THE FONT
		//TODO SOUNDS
		
		//VARIABLES
		public var _player:Player;
		public var _blocks:FlxGroup;
		public var _tiles:FlxTilemap;
		public var _tilemap:String;
		
		override public function create():void
		{
			_tilemap = "1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1\n1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1\n1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,1\n1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,1\n1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1\n1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1\n1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1\n1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1\n1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1\n1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1\n1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1\n1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,1,1\n1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1"
			
			//TODO: SCREENCHANGING
			//TODO: MAP FORMAT & LOADING FROM OTHER PLACES
			
				//load map ?
				/* map format: #name#author#x#y#tiles|objects#
				 * just like n, but with x and y dimensions for non-screensize levels
				 * < screensize levels should otherwise be filled with tiles */
			
			//no mouse in game
			FlxG.mouse.hide();
			
			//DUMMY MAP LOADING
			
			_blocks = new FlxGroup();
			
			_tiles = new FlxTilemap();
			_tiles.collideIndex = 1;
			_tiles.loadMap(_tilemap,ImgTiles,16);
			_blocks.add(_tiles);
			add(_tiles);
			_tiles = new FlxTilemap();
			_tiles.collideIndex = 1;
			_tiles.loadMap(_tilemap,ImgTiles,16);
			_blocks.add(_tiles);
			add(_tiles);
			
			//ADD PLAYER TO THE GAME
			_player = new Player(100,100);
			add(_player);
			
			//unfade
			FlxG.flash.start(0xff000000,0.5);
			
			//track the number of plays in a save
			var save:FlxSave = new FlxSave();
			if(save.bind("Metagame"))
			{
				if(save.data.plays == null)
					save.data.plays = 0;
				else
					save.data.plays++;
				FlxG.log("Number of plays: "+save.data.plays);
			}
		}

		override public function update():void
		{
			
			//GAME LOGIC HERE
			
			//collisions with environment
			FlxU.collide(_tiles,_player);
			// FOR WHEN WE NEED OBJ-OBJ INTERACTION WITHOUT COLLISION
			//FlxU.overlap(_objects,_objects,overlapped);
			
			super.update();

		}
		
		protected function overlapped(Object1:FlxObject,Object2:FlxObject):void
		{
			//CALLED WHEN SHIT OVERLAPS
		}
	}
}
