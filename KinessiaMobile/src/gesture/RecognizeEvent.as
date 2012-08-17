package gesture {

	import flash.events.Event;

	/**
	 * @author Aymeric
	 */
	public class RecognizeEvent extends Event {
		
		public static const CIRCLE_IDENTIFIED:String = "CIRCLE_IDENTIFIED";

		public function RecognizeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
