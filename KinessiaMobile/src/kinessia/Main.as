package kinessia {

	import kinessia.sound.Ring;
	import gesture.Gesture;
	import gesture.RecognizeEvent;

	import kinessia.art.ArtEvent;
	import kinessia.art.ScreenGame;
	import kinessia.network.Network;
	import kinessia.network.NetworkEvent;

	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	/**
	 * @author Aymeric
	 */
	public class Main extends Sprite {

		public var home:MovieClip;

		private var _screenGame:ScreenGame;

		private var _network:Network;
		private var _gesture:Gesture;
		
		private var _level:uint;
		private var _tmpLvlCoin:uint;
		
		private var _ring:Ring;

		public function Main() {

			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			_level = 1; 
			
			_ring = new Ring();
			
			_network = new Network(home);
			addChild(_network);
			// Network is a Sprite instead of an EventDispatcher because of the EnterFrame

			_network.addEventListener(NetworkEvent.LEVEL_COMPLETE, _gameOnPhone);
			_network.addEventListener(NetworkEvent.RESTART_LEVEL, _gameOnPhone);

			_network.addEventListener(ArtEvent.REMOVE_HOME, _artHandler);
			_network.addEventListener(NetworkEvent.TALK, _artHandler);
			_network.addEventListener(ArtEvent.SKIP, _artHandler);

			_network.addEventListener(NetworkEvent.START_MICRO, _gameOnPhone);
			_network.addEventListener(NetworkEvent.STOP_MICRO, _gameOnPhone);
			
			_network.addEventListener(NetworkEvent.START_PACMAN, _gameOnPhone);
			_network.addEventListener(NetworkEvent.END_PACMAN, _gameOnPhone);

			_network.addEventListener(NetworkEvent.START_CATAPULTE, _gameOnPhone);
			_network.addEventListener(NetworkEvent.END_CATAPULTE, _gameOnPhone);

			_network.addEventListener(NetworkEvent.COIN_TAKEN, _addCoin);
		}

		private function _artHandler(aEvt:ArtEvent):void {

			switch (aEvt.type) {

				case ArtEvent.REMOVE_HOME:

					_network.removeEventListener(ArtEvent.REMOVE_HOME, _artHandler);
					removeChild(home);
					home = null;

					_screenGame = new ScreenGame();
					addChild(_screenGame);
					_screenGame.alpha = 0;
					TweenMax.to(_screenGame, 0.4, {alpha:1});
					
					_screenGame.skip.addEventListener(MouseEvent.CLICK, _network.hudInfo);
					_screenGame.fullscreen.addEventListener(MouseEvent.CLICK, _network.hudInfo);
					_screenGame.pause.addEventListener(MouseEvent.CLICK, _network.hudInfo);
					_screenGame.sound.addEventListener(MouseEvent.CLICK, _network.hudInfo);
					
					break;
					
				case NetworkEvent.TALK:
					
					_screenGame.skip.visible = true;
					_screenGame.textfield.visible = true;
					_screenGame.playText();	
					break;
					
				case ArtEvent.SKIP:
				
					_network.removeEventListener(ArtEvent.SKIP, _artHandler);
					
					_screenGame.skip = null;
					_screenGame.stopText();
					_screenGame.textfield  = null;
					
					_screenGame.gotoAndStop("game");
					
					_screenGame.earth.addEventListener(MouseEvent.CLICK, _screenGame.question);
					
					break;
			}
		}

		private function _gameOnPhone(nEvt:NetworkEvent):void {

			switch (nEvt.type) {

				case NetworkEvent.LEVEL_COMPLETE:
					
					++_level;
					_screenGame.level = _level;
					_tmpLvlCoin = 0;
					break;

				case NetworkEvent.RESTART_LEVEL:
				
					switch (_level) {
						
						case 2:
							_screenGame.piece1.gotoAndStop("search");
							break;
							
						case 3:
							_screenGame.piece2.gotoAndStop("search");
							break;
							
						case 5:
							_screenGame.piece3.gotoAndStop("search");
							break;
					}
				
					_screenGame.coin.coin_txt.text = String(uint(_screenGame.coin.coin_txt.text) - _tmpLvlCoin);

					_tmpLvlCoin = 0;
					break;

				case NetworkEvent.START_MICRO:
				
					_ring.play();

					_screenGame.texte.gotoAndStop("start_micro");
					_screenGame.earth.gotoAndStop("init");
					
					trace("microphone support :" + Microphone.isSupported);

					var microphone:Microphone = Microphone.getMicrophone();
					_network.catchMic(true);
					microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, _network.sampleData);

					break;

				case NetworkEvent.STOP_MICRO:
				
					_ring.play();

					_screenGame.piece1.gotoAndStop("find");
					_screenGame.texte.gotoAndStop("fiche1");
					_screenGame.earth.gotoAndStop("youknow");
					
					_network.catchMic(false);
					
					microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, _network.sampleData);
					microphone = null;

					break;
					
				case NetworkEvent.START_PACMAN:
				
					_ring.play();
					
					_screenGame.texte.gotoAndStop("start_pacman");
					_screenGame.earth.gotoAndStop("init");
				
					break;
					
				case NetworkEvent.END_PACMAN:
				
					_ring.play();
					
					_screenGame.piece2.gotoAndStop("find");
					_screenGame.texte.gotoAndStop("fiche2");
					_screenGame.earth.gotoAndStop("youknow");
					
					break;

				case NetworkEvent.START_CATAPULTE:
				
					_ring.play();
				
					_screenGame.texte.gotoAndStop("start_catapulte");
					_screenGame.earth.gotoAndStop("init");

					_gesture = new Gesture();
					_screenGame.addChild(_gesture);
					_gesture.addEventListener(RecognizeEvent.CIRCLE_IDENTIFIED, _drawCircleForCatapulte);

					break;
					
				case NetworkEvent.END_CATAPULTE:
				
					_ring.play();
					
					_screenGame.piece3.gotoAndStop("find");
					_screenGame.texte.gotoAndStop("fiche3");
					_screenGame.earth.gotoAndStop("youknow");
					
					break;
			}
			
		}

		private function _drawCircleForCatapulte(rEvt:RecognizeEvent):void {

			_gesture.removeEventListener(RecognizeEvent.CIRCLE_IDENTIFIED, _drawCircleForCatapulte);
			_screenGame.removeChild(_gesture);
			_gesture = null;

			_network.drawCircleForCatapulte();
		}

		private function _addCoin(nEvt:NetworkEvent):void {
			
			_screenGame.coin.coin_txt.text = String(uint(_screenGame.coin.coin_txt.text) + 1);
			++_tmpLvlCoin;
		}
	}
}