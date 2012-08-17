package kinessia.levels {

	import Box2DAS.Dynamics.ContactEvent;

	import kinessia.characters.Declik;
	import kinessia.objects.Croquis;

	import com.citrusengine.objects.platformer.Sensor;

	import flash.display.MovieClip;

	/**
	 * @author Aymeric
	 */
	public class LevelA4 extends ALevel {
		
		private var _croquis:Croquis;
		
		private var _startCroquis:Sensor;
		private var _endCroquis:Sensor;

		public function LevelA4(levelObjectsMC:MovieClip) {
			super(levelObjectsMC);
		}
		
		override public function initialize():void {
			
			super.initialize();
			
			_addContactRestartLevel();
			
			_croquis = Croquis(getFirstObjectByType(Croquis));
			
			_startCroquis = Sensor(getObjectByName("StartCroquis"));
			_startCroquis.onBeginContact.add(_animate);
			
			_endCroquis = Sensor(getObjectByName("EndCroquis"));
			_endCroquis.onBeginContact.add(_animate);
		}
		
		override public function destroy():void {
			
			super.destroy();
		}
		
		private function _animate(cEvt:ContactEvent):void {
			
			if (cEvt.other.GetBody().GetUserData() is Declik) {
				
				if (cEvt.fixture.GetBody().GetUserData().name == "StartCroquis") {
					_croquis.anim = "white";
				} else {
					_croquis.anim = "black";
				}
			}
			
			cEvt.fixture.GetBody().GetUserData().kill = true;
		}
	}
}
