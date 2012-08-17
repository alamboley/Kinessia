package kinessia.ui {

	import flash.events.Event;

	/**
	 * @author Aymeric
	 */
	public class HudEvent extends Event {
		
		public static const PAUSE:String = "PAUSE";
		public static const SOUND:String = "SOUND";
		public static const FULLSCREEN:String = "FULLSCREEN";
		public static const COIN:String = "COIN";

		public function HudEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
