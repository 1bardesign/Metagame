package com.game.Metagame
{
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		//[Embed(source="../../../data/MenuBack.png")] private var ImgBack:Class;
		[Embed(source="../../../data/04B03.TTF", fontName="F04B", embedAsCFF="false", mimeType="application/x-font-truetype")]
			private var F04:Class; //EMBED THE FONT HERE
		//TODO SOUNDS
		
		private var _t1:FlxText; //TEXT HELPER OBJECT
		
		override public function create():void
		{
			//set up the basic text for now so we aren't confused
			_t1 = new FlxText(FlxG.width/2,FlxG.height/2,200,"Press Z + X to begin");
			_t1.alignment = "center";
			_t1.setFormat("F04B");
			_t1.size = 16;
			_t1.color = 0xFFFFFF;
			_t1.antialiasing = true;
			add(_t1);
			
			_t1 = new FlxText(FlxG.width/2,FlxG.height/2 + 20,200,"Copyright (C) 2010 The Metanet Community.");
			_t1.alignment = "center";
			_t1.setFormat("F04B");
			_t1.size = 8;
			_t1.color = 0xFFFFFF;
			_t1.antialiasing = true;
			add(_t1);
			
			_t1 = new FlxText(FlxG.width/2,FlxG.height/2 + 30,200,"All rights reserved.");
			_t1.alignment = "center";
			_t1.setFormat("F04B");
			_t1.size = 8;
			_t1.color = 0xFFFFFF;
			_t1.antialiasing = true;
			add(_t1);
			
			//track the number of loads in a save
			var save:FlxSave = new FlxSave();
			if(save.bind("Metagame"))
			{
				if(save.data.loads == null)
					save.data.loads = 0;
				else
					save.data.loads++;
				FlxG.log("Number of Loads: "+save.data.loads);
			}
		}

		override public function update():void
		{
			//Z + X were pressed, fade out and change to play state
			//TODO: A BUTTON MENU
			if(FlxG.keys.Z && FlxG.keys.X)
			{
				FlxG.flash.start(0xffffffff,0.5);
				FlxG.fade.start(0xff000000,1,onFade);
			}

			super.update();
		}
		
		private function onFade():void
		{
			FlxG.state = new PlayState();
		}
	}
}
