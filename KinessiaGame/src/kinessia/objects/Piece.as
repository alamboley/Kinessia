package kinessia.objects {

	import Box2DAS.Dynamics.ContactEvent;

	import kinessia.characters.Declik;

	import com.citrusengine.objects.platformer.Sensor;

	/**
	 * @author Aymeric
	 */
	public class Piece extends Sensor {

		private var _label:String;

		public function Piece(name:String, params:Object = null) {
			super(name, params);

			_animation = _label;
		}
		
		override public function destroy():void {
			super.destroy();
		}

		override protected function handleBeginContact(e:ContactEvent):void {
			
			super.handleBeginContact(e);

			if (e.other.GetBody().GetUserData() is Declik) {
				kill = true;
			}
		}

		public function get label():String {
			return _label;
		}

		public function set label(value:String):void {
			_label = value;
		}
		
		
	}
}
