package kinessia.levels {

	import com.greensock.TweenMax;
	import Box2DAS.Dynamics.ContactEvent;

	import kinessia.characters.Conservateur;
	import kinessia.characters.Declik;
	import kinessia.network.BulleSynch;
	import kinessia.network.NetworkEvent;

	import flash.display.MovieClip;
	import flash.events.Event;

	/**
	 * @author Aymeric
	 */
	public class LevelA1 extends ALevel {
		
		private var _bulle:BulleSynch;
		private var _conservateur:Conservateur;

		public function LevelA1(levelObjectsMC:MovieClip) {
			super(levelObjectsMC);
		}

		override public function initialize():void {

			super.initialize();

			_addMusicalSensor();
			
			_bulle = new BulleSynch();
			addChildAt(_bulle, 1);
			TweenMax.to(_bulle, 0.4, {alpha:1, delay:1});
			
			_bulle.x = 100;
			_bulle.y = 350;			
			_bulle.texte.text = "Entre ce numéro : " + _network.uniqueID;
			
			_declik.controlsEnabled = false;

			_conservateur = Conservateur(getFirstObjectByType(Conservateur));
			_conservateur.onBeginContact.addOnce(_talk);
			_conservateur.anim = "idle";
			
			_ce.addEventListener(NetworkEvent.CONNECTED, _connected);
			_ce.addEventListener(NetworkEvent.SKIP, _skip);
		}

		private function _connected(nEvt:NetworkEvent):void {
			
			_ce.removeEventListener(NetworkEvent.CONNECTED, _connected);
			
			_declik.controlsEnabled = true;
			
			removeChild(_bulle);
			_bulle = null;
		}

		private function _talk(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {
				
				_ce.dispatchEvent(new NetworkEvent(NetworkEvent.TALK));
				
				_conservateur.anim = "talk";
				_ce.sound.playSound("Conservateur", 1, 0);
				_ce.sound.getSoundChannel("Conservateur").addEventListener(Event.SOUND_COMPLETE, _soundComplete);
				_declik.controlsEnabled = false;
			}
		}

		private function _soundComplete(evt:Event):void {

			_ce.dispatchEvent(new NetworkEvent(NetworkEvent.SKIP));
		}

		private function _skip(nEvt:NetworkEvent):void {

			_ce.removeEventListener(NetworkEvent.SKIP, _skip);

			if (_ce.sound.currPlayingSounds["Conservateur"] != undefined) {

				_ce.sound.playSound("KinessiaTheme");

				_ce.sound.stopSound("Conservateur");
				_conservateur.anim = "idle";
				_ce.sound.getSoundChannel("Conservateur").removeEventListener(Event.SOUND_COMPLETE, _soundComplete);
				_declik.controlsEnabled = true;
			}
		}

		override public function destroy():void {

			super.destroy();
		}
	}
}
