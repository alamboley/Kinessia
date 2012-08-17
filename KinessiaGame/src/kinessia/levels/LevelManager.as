package kinessia.levels {

	import org.osflash.signals.Signal;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author Aymeric
	 */
	public class LevelManager {
		
		private static var _instance:LevelManager;

		public var onLevelChanged:Signal;

		private var _levels:Array;
		private var _currentIndex:uint;
		private var _currentLevel:ALevel;

		public function LevelManager() {
			
			_instance = this;

			onLevelChanged = new Signal(ALevel);
			_currentIndex = 0;

			_levels = [];
			_levels["Level"] = [LevelA1, LevelA2, LevelA3, LevelA4, LevelA5];
			_levels["Name"] = ["A1", "A2", "A3", "A4", "A5"];
			_levels["SWF"] = ["levels/levelA1.swf", "levels/levelA2.swf", "levels/levelA3.swf", "levels/levelA4.swf", "levels/levelA5.swf"];

			gotoLevel();
		}
		
		public static function getInstance():LevelManager {
			return _instance;
		}


		public function destroy():void {
			onLevelChanged.removeAll();
			_currentLevel = null;
		}

		public function nextLevel():void {

			if (_currentIndex < _levels["Level"].length - 1)
				++_currentIndex;

			gotoLevel();
		}

		public function prevLevel():void {

			if (_currentIndex > 0)
				--_currentIndex;

			gotoLevel();
		}

		public function gotoLevel():void {

			if (_currentLevel != null)
				_currentLevel.lvlEnded.remove(_onLevelEnded);

			var loader:Loader = new Loader();
			loader.load(new URLRequest(_levels["SWF"][_currentIndex]));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _levelSWFLoaded);
		}

		private function _levelSWFLoaded(evt:Event):void {

			_currentLevel = ALevel(new _levels["Level"][_currentIndex](evt.target.loader.content));
			_currentLevel.lvlEnded.add(_onLevelEnded);

			onLevelChanged.dispatch(currentLevel);

			evt.target.removeEventListener(Event.COMPLETE, _levelSWFLoaded);
			evt.target.loader.unloadAndStop();
		}

		private function _onLevelEnded():void {

		}


		public function get currentLevel():ALevel {
			return _currentLevel;
		}

		public function set currentLevel(currentLevel:ALevel):void {
			_currentLevel = currentLevel;
		}
		
		public function get nameCurrentLevel():String {
			return _levels["Name"][_currentIndex];
		}
	}
}
