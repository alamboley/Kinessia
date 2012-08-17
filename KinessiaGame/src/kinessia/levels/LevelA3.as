package kinessia.levels {

	import Box2DAS.Dynamics.ContactEvent;

	import kinessia.characters.Declik;
	import kinessia.network.NetworkEvent;

	import com.citrusengine.objects.platformer.Sensor;

	import flash.display.MovieClip;
	import flash.utils.setTimeout;

	/**
	 * @author Aymeric
	 */
	public class LevelA3 extends ALevel {
		
		private var _pacmanSensor:Sensor;
		private var _bulle:Sensor;

		public function LevelA3(levelObjectsMC:MovieClip) {
			super(levelObjectsMC);
		}

		override public function initialize():void {

			super.initialize();

			_addContactRestartLevel();

			_pacmanSensor = Sensor(getObjectByName("Pacman"));
			_pacmanSensor.onBeginContact.add(_addPacman);
		}
		
		override public function destroy():void {
			
			super.destroy();
		}

		private function _addPacman(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {

				cEvt.fixture.GetBody().GetUserData().kill = true;

				_ce.dispatchEvent(new NetworkEvent(NetworkEvent.START_PACMAN));

				_declik.controlsEnabled = false;
				_declik.visible = false;

				stage.addEventListener(NetworkEvent.END_PACMAN, _endPacman);
				
				setTimeout(_addBulle, 0);
			}
		}
		
		private function _addBulle():void {
			
			_bulle = new Sensor("bulle", {x:2420, y:70, view:"objects/bulle.swf"});
			add(_bulle);
		}

		private function _endPacman(nEvt:NetworkEvent):void {

			stage.removeEventListener(NetworkEvent.END_PACMAN, _endPacman);
			_ce.dispatchEvent(new NetworkEvent(NetworkEvent.END_PACMAN));
			
			_declik.controlsEnabled = true;
			_declik.visible = true;
			
			_bulle.kill = true;
		}
	}
}
