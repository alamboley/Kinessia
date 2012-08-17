package kinessia.events {

	import flash.events.Event;

	/**
	 * @author Aymeric
	 */
	public class KinessiaEvent extends Event {
		
		public static const START_PACMAN:String = "START_PACMAN";
		public static const END_PACMAN:String = "END_PACMAN";
		
		public static const CIRCLE_IDENTIFIED:String = "CIRCLE_IDENTIFIED";

		public function KinessiaEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
