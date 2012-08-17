package kinessia.network {

	import flash.events.Event;

	/**
	 * @author Aymeric
	 */
	public class NetworkEvent extends Event {
		
		public static const CONNECTED:String = "CONNECTED";
		
		public static const LEVEL_COMPLETE:String = "LEVEL_COMPLETE";
		public static const RESTART_LEVEL:String = "RESTART_LEVEL";
		
		public static const TALK:String = "TALK";
		public static const SKIP:String = "SKIP";
		public static const FULLSCREEN:String = "FULLSCREEN";
		public static const PAUSE_GAME:String = "PAUSE_GAME";
		public static const SOUND_GAME:String = "SOUND_GAME";
		
		public static const COIN_TAKEN:String = "COIN_TAKEN";
		
		public static const START_MICRO:String = "START_MICRO";
		public static const STOP_MICRO:String = "STOP_MICRO";
		
		public static const START_PACMAN:String = "START_PACMAN";
		public static const END_PACMAN:String = "END_PACMAN";
		
		public static const START_CATAPULTE:String = "START_CATAPULTE";
		public static const CIRCLE_DRAW:String = "CIRCLE_DRAW";
		public static const END_CATAPULTE:String = "END_CATAPULTE";
		
		public static const JUMP:String = "JUMP";
		public static const ONGROUND:String = "ONGROUND";
		public static const STATIONARY:String = "STATIONARY";
		
		public static const LEFT:String = "LEFT";
		public static const RIGHT:String = "RIGHT";
		public static const IMMOBILE:String = "IMMOBILE";
		
		public static const FLY:String = "FLY";
		public static const NOT_FLY:String = "NOT_FLY";
		

		public function NetworkEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
