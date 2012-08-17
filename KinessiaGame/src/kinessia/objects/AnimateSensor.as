package kinessia.objects {

	import com.citrusengine.objects.platformer.Sensor;

	/**
	 * @author Aymeric
	 */
	public class AnimateSensor extends Sensor {

		private var _anim:String = "idle";

		public function AnimateSensor(name:String, params:Object = null) {
			super(name, params);
		}

		override public function destroy():void {

			super.destroy();
		}
		

		override public function update(timeDelta:Number):void {

			super.update(timeDelta);

			_updateAnimation();
		}

		private function _updateAnimation():void {

			_animation = _anim;
		}

		public function get anim():String {
			return _anim;
		}

		public function set anim(value:String):void {
			_anim = value;
		}
	}
}
