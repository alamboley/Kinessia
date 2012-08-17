package kinessia.levels {

	import Box2DAS.Dynamics.ContactEvent;

	import kinessia.characters.Declik;
	import kinessia.objects.Croquis;
	import kinessia.objects.Piece;

	import com.citrusengine.objects.CitrusSprite;
	import com.citrusengine.objects.platformer.Sensor;

	import flash.display.MovieClip;
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;

	/**
	 * @author Aymeric
	 */
	public class LevelA2 extends ALevel {

		private const _MICRO_FLY_LEVEL:Number = 10;
		private const _HERO_GRAVITY:Number = 0.5;

		private var _pieceCaught:Boolean;

		private var _heroInitGravity:Number;

		private var _microphoneSensor:Sensor;
		private var _popUp:CitrusSprite;
		private var _croquis:Croquis;
		private var _piece:Piece;

		private var _microphone:Microphone;

		public function LevelA2(levelObjectsMC:MovieClip) {
			super(levelObjectsMC);
		}

		override public function initialize():void {

			super.initialize();
			
			_pieceCaught = false;
			
			_hud.panneau.panneau1.gotoAndStop("search");

			_heroInitGravity = _declik.gravity;

			_addContactRestartLevel();

			_addMusicalSensor();

			_microphoneSensor = Sensor(getObjectByName("Microphone"));
			_microphoneSensor.onBeginContact.addOnce(_addMicrophone);
			_microphoneSensor.onBeginContact.add(_showText);
			_microphoneSensor.onEndContact.add(_hideText);
			
			_popUp = CitrusSprite(getObjectByName("PopUp"));

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

		private function _showText(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {

				_popUp.visible = true;
			}
		}

		private function _hideText(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {

				_popUp.visible = false;
			}
		}

		private function _addMicrophone(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {

				_declik.gravity = _HERO_GRAVITY;

				_croquis.anim = "white";

				_microphone = Microphone.getMicrophone();
				_microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, _sampleData);
			}
		}

		private function _sampleData(sdEvt:SampleDataEvent):void {

			while (sdEvt.data.bytesAvailable) {

				if (sdEvt.data.readFloat() * 50 > _MICRO_FLY_LEVEL) {
					_declik.microFly = true;
				} else {
					_declik.microFly = false;
				}
			}
		}


		private function _pieceTaken(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {
				
				_ce.sound.playSound("Collect", 1, 0);

				_declik.gravity = _heroInitGravity;

				_pieceCaught = true;

				_croquis.anim = "black";

				_declik.stopFlying();

				_microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, _sampleData);
				_microphone = null;
				
				_hud.panneau.panneau1.gotoAndStop("found");
			}
		}
	}
}
