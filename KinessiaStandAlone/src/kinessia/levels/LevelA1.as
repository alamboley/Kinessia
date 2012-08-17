package kinessia.levels {

	import Box2DAS.Dynamics.ContactEvent;

	import kinessia.characters.Conservateur;
	import kinessia.characters.Declik;

	import com.citrusengine.objects.CitrusSprite;

	import flash.display.MovieClip;

	/**
	 * @author Aymeric
	 */
	public class LevelA1 extends ALevel {
		
		private var _conservateur:Conservateur;
		private var _popUp:CitrusSprite;

		public function LevelA1(levelObjectsMC:MovieClip) {
			super(levelObjectsMC);
		}

		override public function initialize():void {

			super.initialize();

			_addMusicalSensor();

			_conservateur = Conservateur(getFirstObjectByType(Conservateur));
			
			_popUp = CitrusSprite(getObjectByName("PopUp"));
			
			_conservateur.onBeginContact.addOnce(_playMusic);
			_conservateur.onBeginContact.add(_talk);
			_conservateur.onEndContact.add(_notTalk);
			
			_conservateur.anim = "idle";
		}
		
		private function _playMusic(cEvt:ContactEvent):void {
			
			if (cEvt.other.GetBody().GetUserData() is Declik) {
				_ce.sound.playSound("KinessiaTheme");
			}
		}

		private function _talk(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {
				_conservateur.anim = "talk";
				_popUp.visible = true;
			}
		}
		
		private function _notTalk(cEvt:ContactEvent):void {
			
			if (cEvt.other.GetBody().GetUserData() is Declik) {
				_conservateur.anim = "idle";
				_popUp.visible = false;
			}
		}

		override public function destroy():void {
			
			super.destroy();
		}
	}
}
