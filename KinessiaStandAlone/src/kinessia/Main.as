package kinessia {

	import kinessia.events.KinessiaEvent;
	import kinessia.levels.ALevel;
	import kinessia.levels.LevelManager;
	import kinessia.pacman.Pacman;
	import kinessia.ui.Hud;
	import kinessia.ui.HudEvent;

	import com.citrusengine.core.CitrusEngine;

	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * @author Aymeric
	 */
	public class Main extends CitrusEngine {

		private var _levelManager:LevelManager;
		
		private var _hud:Hud;

		private var _pacman:Pacman;

		private var _soundOn:Boolean;
		private var _tmpLvlCoin:uint;

		public function Main() {

			super();

			this.addEventListener(Event.ADDED_TO_STAGE, _init);
		}

		private function _init(evt:Event):void {

			this.removeEventListener(Event.ADDED_TO_STAGE, _init);
			
			stage.scaleMode = StageScaleMode.EXACT_FIT;

			this.console.addCommand("fullscreen", _fullscreen);
			this.console.addCommand("pause", _pauseGame);
			this.console.addCommand("sound", _soundGame);
			this.console.addCommand("reset", _restartLevel);
			this.console.addCommand("next", _nextLevel);
			this.console.addCommand("goto", _goto);

			sound.addSound("KinessiaTheme", "sounds/KinessiaTheme.mp3");
			sound.addSound("Collect", "sounds/collect.mp3");
			sound.addSound("Hurt", "sounds/hurt.mp3");
			sound.addSound("Jump", "sounds/jump.mp3");
			sound.addSound("Kill", "sounds/kill.mp3");
			sound.addSound("Si", "sounds/si.mp3");
			sound.addSound("Do", "sounds/do.mp3");
			sound.addSound("Re", "sounds/re.mp3");
			sound.addSound("Mi", "sounds/mi.mp3");
			
			_hud = new Hud();
			addChild(_hud);
			_hud.addEventListener(HudEvent.PAUSE, _pauseGame);
			_hud.addEventListener(HudEvent.SOUND, _soundGame);
			_hud.addEventListener(HudEvent.FULLSCREEN, _fullscreen);
			_hud.addEventListener(HudEvent.COIN, _addCoin);
			_hud.visible = false;

			_levelManager = new LevelManager();
			_levelManager.onLevelChanged.add(_onLevelChanged);
			
			this.addEventListener(KinessiaEvent.START_PACMAN, _pacmanGame);
			stage.addEventListener(KinessiaEvent.END_PACMAN, _pacmanGame);
		}

		private function _onLevelChanged(lvl:ALevel):void {

			state = lvl;

			lvl.lvlEnded.add(_nextLevel);
			lvl.restartLevel.add(_restartLevel);
		}

		private function _restartLevel():void {
			
			_hud.coin.coin_txt.text = String(uint(_hud.coin.coin_txt.text) - _tmpLvlCoin);
			_tmpLvlCoin = 0;

			state = _levelManager.currentLevel;
		}

		private function _nextLevel():void {
			
			_tmpLvlCoin = 0;
			_levelManager.nextLevel();
		}

		private function _goto($level:int):void {

			_levelManager.gotoLevel($level);
		}

		private function _pacmanGame(kEvt:KinessiaEvent):void {

			if (kEvt.type == KinessiaEvent.START_PACMAN) {

				_pacman = new Pacman();
				addChild(_pacman);
				_pacman.x = 350;
				_pacman.y = 300;

			} else {

				_pacman.destroy();
				removeChild(_pacman);
				_pacman = null;
			}
		}

		private function _fullscreen(hEvt:HudEvent = null):void {

			if (stage.displayState == "normal") {
				stage.displayState = "fullScreen";
			} else {
				stage.displayState = "normal";
			}
		}

		private function _pauseGame(hEvt:HudEvent = null):void {
			this.playing = !this.playing;
		}

		private function _soundGame(hEvt:HudEvent = null):void {

			var st:SoundTransform = SoundMixer.soundTransform;

			if (_soundOn) {
				st.volume = 1;
			} else {
				st.volume = 0;
			}

			SoundMixer.soundTransform = st;
			_soundOn = !_soundOn;
		}
		
		private function _addCoin(hEvt:HudEvent):void {
			_hud.coin.coin_txt.text = String(uint(_hud.coin.coin_txt.text) + 1);
			++_tmpLvlCoin;
		}
	}
}
