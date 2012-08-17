package kinessia.characters {

	import kinessia.objects.AnimateSensor;

	/**
	 * @author Aymeric
	 */
	public class Conservateur extends AnimateSensor {

		public function Conservateur(name:String, params:Object = null) {
			super(name, params);
		}
		
		override public function destroy():void {
			
			super.destroy();
		}
	}
}
