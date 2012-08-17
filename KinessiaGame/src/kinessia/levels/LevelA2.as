package kinessia.levels {

	import Box2DAS.Dynamics.ContactEvent;

	import kinessia.characters.Declik;
	import kinessia.network.NetworkEvent;
	import kinessia.objects.Croquis;
	import kinessia.objects.Piece;

	import com.citrusengine.objects.platformer.Sensor;

	import flash.display.MovieClip;
	import flash.utils.setTimeout;

	/**
	 * @author Aymeric
	 */
	public class LevelA2 extends ALevel {

		private const _HERO_GRAVITY:Number = 0.6;

		private var _pieceCaught:Boolean;

		private var _heroInitGravity:Number;

		private var _microphoneSensor:Sensor;
		private var _croquis:Croquis;
		private var _piece:Piece;
		private var _bulle:Sensor;

		public function LevelA2(levelObjectsMC:MovieClip) {
			super(levelObjectsMC);
		}

		override public function initialize():void {

			super.initialize();

			_heroInitGravity = _declik.gravity;

			_addContactRestartLevel();

			_addMusicalSensor();

			_microphoneSensor = Sensor(getObjectByName("Microphone"));
			_microphoneSensor.onBeginContact.add(_addMicrophone);

			_croquis = Croquis(getFirstObjectByType(Croquis));

			_piece = Piece(getFirstObjectByType(Piece));
			_piece.onBeginContact.add(_pieceTaken);
		}

		override public function destroy():void {

			super.destroy();
		}

		override protected function _endLevel(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik && _pieceCaught == true) {
				lvlEnded.dispatch();
			}
		}

		private function _addMicrophone(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {

				cEvt.fixture.GetBody().GetUserData().kill = true;

				_declik.gravity = _HERO_GRAVITY;

				_ce.dispatchEvent(new NetworkEvent(NetworkEvent.START_MICRO));

				_croquis.anim = "white";

				setTimeout(_addBulle, 0);
			}

		}

		private function _addBulle():void {
			
			_bulle = new Sensor("bulle", {x:-550, y:330, view:"objects/bulle.swf"});
			add(_bulle);
		}

		private function _pieceTaken(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {

				_declik.gravity = _heroInitGravity;
				
				_pieceCaught = true;

				_ce.dispatchEvent(new NetworkEvent(NetworkEvent.STOP_MICRO));

				_croquis.anim = "black";
				
				_bulle.kill = true;
				
				_declik.stopFlying();
			}
		}
	}
}
