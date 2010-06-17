package {
	import org.flixel.*;
	import com.game.Metagame.MenuState;
	
	[SWF(width="800", height="600", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Metagame extends FlxGame
	{
		public function Metagame():void
		{
			super(400,300,MenuState,2);
			FlxState.bgColor = 0xff888888;
			useDefaultHotKeys = false;
		}
	}
}
