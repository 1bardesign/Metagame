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
		public var _level:Level;
		
		override public function create():void
		{
			var data:String = "#test level#geti#1|1|1#11111111111111111111111111000000000000000000000001100000000000000000000000110001100000000000000000011000111110000000000001111100011110000000011000011110000000000000011100000011000000000000000000000001100000011111100000000000111100001111111111110000011100000111111111111000001100000000000000000000000110011100000000000000011111000000000000000111111111100000000000000010001111111111000000000001000111111111111111111111111111111#120|100|1|1|1#";
			
			_level = new Level(data);
			add(_level);
			
			//unfade
			FlxG.flash.start(0xff000000,20);
			
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
			super.update();
		}

	}
}
