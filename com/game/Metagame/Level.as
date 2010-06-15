package com.game.Metagame
{
	import org.flixel.*;

	public class Level extends FlxGroup
	{
		//mostly internal stuff, but some of it's used for drawing and logic ==
		private var _data:String;			//private because it's not useful for much
		public var _name:String;			//the level's name
		public var _author:String;			//the author(s)
		public var _dimensions:Array;		//the dimensions //NEED TO UPDATE FOR 3D
		public var _leveldata:String;		//all the actual level data collected
		public var _screenString:String;	//the string of screen data, preprocessing
				//NB PROCESSING OF THE SCREEN STRINGS IS DONE BY THE SCREEN OBJECT
		public var _screenArray:Array 		//a 3D array of the screens
		//actual flxobject stuff ==============================================
		public var _screens:FlxGroup;
		public var _curscreen:Screen;
		
		public function Level(data:String)
		{
			/* DATA FORMAT:
			 * #name#author#x|y|z#scr1|scr2|scr3|...#
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
			_dimensions = new Array;
			for(i=0;i<3;i++;)
			{
				n1 = n2+1;
				if (i < 2-1)
					n2 = data.indexOf("|",n1);
				else
					n2 = data.indexOf("#",n1);
				_dimensions[i] = data.slice(n1,n2);
			}
			//the screens! yay! finally some juiciness!
			_screenArray = new Array;
			_screens = new FlxGroup;
			for(x=0;x<_dimensions[0];x++;) { _screenArray[x] = new Array; //adding 2d-ness
				for(y=0;y<_dimensions[1];y++;) { _screenArray[x][y] = new Array; //adding 3d-ness
				for(z=0;z<_dimensions[2];z++;) { //add the screens to the y-axis array
				n1 = n2+1;
				if ((x != _dimensions[0] - 1) && (y != _dimensions[1] - 1) && (z != _dimensions[2] - 1))
					n2 = data.indexOf("|",n1);
				else
					n2 = data.indexOf("#",n1);
				_screenString = data.slice(n1,n2);
				var screen:Screen = new Screen(_screenString, this, "["+x+"|"+y"|"+z+"]");
				_screenArray[x][y][z] = screen;
				_screens.add = screen;
			} } }
			//TODO: THE REST
			
			//-----------------------DONE--------------------------------------
			
			super();
			
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}
}
