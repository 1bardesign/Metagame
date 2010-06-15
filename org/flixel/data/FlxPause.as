package org.flixel.data
{
	import org.flixel.*;

	/**
	 * This is the default flixel pause screen.
	 * It can be overridden with your own <code>FlxLayer</code> object.
	 */
	public class FlxPause extends FlxGroup
	{
		[Embed(source="key_minus.png")] private var ImgKeyMinus:Class;
		[Embed(source="key_plus.png")] private var ImgKeyPlus:Class;
		[Embed(source="key_0.png")] private var ImgKey0:Class;
		[Embed(source="key_p.png")] private var ImgKeyP:Class;

		/**
		 * Constructor.
		 */
		public function FlxPause()
		{
			super();
			scrollFactor.x = 0;
			scrollFactor.y = 0;
			var w:uint = 80;
			var h:uint = 92;
			x = 10;
			y = (FlxG.height-h)/2;
			add((new FlxSprite()).createGraphic(w,h,0xaa000000,true),true);			
			add((new FlxText(0,0,w,"PAUSED")).setFormat(null,16,0xffffff,"center"),true);
			add(new FlxSprite(4,26,ImgKeyP),true);
			add(new FlxText(16,26,w-16,"Pause Game"),true);
			add(new FlxSprite(4,40,ImgKey0),true);
			add(new FlxText(16,40,w-16,"Mute Sound"),true);
			add(new FlxSprite(4,54,ImgKeyMinus),true);
			add(new FlxText(16,54,w-16,"Sound Down"),true);
			add(new FlxSprite(4,68,ImgKeyPlus),true);
			add(new FlxText(16,68,w-16,"Sound Up"),true);
		}
	}
}
