package kinessia.network {

	import kinessia.art.ArtEvent;

	import net.user1.reactor.IClient;
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.Room;

	import com.greensock.TweenMax;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.sensors.Accelerometer;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	/**
	 * @author Aymeric
	 */
	public class Network extends Sprite {

		private const _MICRO_FLY_LEVEL:Number = 0.85;

		private var _reactor:Reactor;
		private var _room:Room;

		private var _home:MovieClip;

		private var _accelX:Number, _accelY:Number;

		private var _accelerometer:Accelerometer;

		private var _currentHStatus:String, _currentVStatus:String;

		private var _uniqueID:String;
		private var _tabMsgFromGame:Array;
		private var _lengthTab:uint;

		private var _micArray:Array;
		private var _timer:Timer;

		public function Network(home:MovieClip) {

			_reactor = new Reactor();
			_reactor.connect("169.254.64.229", 9110);
			//_reactor.connect("localhost", 9110);
			// _reactor.connect("tryunion.com", 80);

			_home = home;

			_tabMsgFromGame = [];
			_tabMsgFromGame = [NetworkEvent.CONNECTED, NetworkEvent.PAUSE_GAME, NetworkEvent.SOUND_GAME, NetworkEvent.FLY, NetworkEvent.NOT_FLY];
			_lengthTab = _tabMsgFromGame.length;

			_reactor.addEventListener(ReactorEvent.READY, _connexionRoom);
		}

		private function _connexionRoom(rEvt:ReactorEvent):void {

			_room = _reactor.getRoomManager().joinRoom("Kinessia");

			TweenMax.to(_home, 0.3, {alpha:0, onComplete:function():void {
				_home.gotoAndStop("login");
			}});
			TweenMax.to(_home, 0.3, {alpha:1, delay:0.3, onComplete:function():void {
				_home.login_btn.addEventListener(MouseEvent.CLICK, _connectedToRoom);
			}});

			_accelerometer = new Accelerometer();

			_accelerometer.addEventListener(AccelerometerEvent.UPDATE, _accelerometerHandler);

			this.addEventListener(Event.ENTER_FRAME, _ef);
		}

		private function _connectedToRoom(tEvt:MouseEvent):void {

			_uniqueID = _home.login_txt.text;
			_room.addMessageListener(_uniqueID, _messageFromGame);

			_home.login_btn.removeEventListener(TouchEvent.TOUCH_TAP, _connectedToRoom);
			
			_room.sendMessage(_uniqueID, true, null, NetworkEvent.CONNECTED);

			this.dispatchEvent(new ArtEvent(ArtEvent.REMOVE_HOME));
		}

		private function _messageFromGame(fromClient:IClient, message:String):void {

			if (!_checkMsgFromGame(message)) {
				trace("provient du jeu : " + message);
				if (message == ArtEvent.SKIP || message == NetworkEvent.TALK) {
					this.dispatchEvent(new ArtEvent(message));
				} else {

					this.dispatchEvent(new NetworkEvent(message));
				}

			}
		}

		private function _accelerometerHandler(aEvt:AccelerometerEvent):void {

			_accelX = aEvt.accelerationX;
			_accelY = aEvt.accelerationY;
		}

		private function _ef(evt:Event):void {

			if ((_accelX > 0.7) && (_currentVStatus != "onground")) {
				_room.sendMessage(_uniqueID, true, null, NetworkEvent.ONGROUND);
				_currentVStatus = "onground";
			}

			if ((_accelX < -0.7) && (_currentVStatus != "jump")) {
				_room.sendMessage(_uniqueID, true, null, NetworkEvent.JUMP);
				_currentVStatus = "jump";
			}

			if (((_accelX < 0.7) && (_accelX > -0.7)) && (_currentVStatus != "stationary")) {
				_room.sendMessage(_uniqueID, true, null, NetworkEvent.STATIONARY);
				_currentVStatus = "stationary";
			}

			if ((_accelY > 0.7) && (_currentHStatus != "right")) {
				_room.sendMessage(_uniqueID, true, null, NetworkEvent.RIGHT);
				_currentHStatus = "right";
			}

			if ((_accelY < -0.7) && (_currentHStatus != "left")) {
				_room.sendMessage(_uniqueID, true, null, NetworkEvent.LEFT);
				_currentHStatus = "left";
			}

			if (((_accelY < 0.7) && (_accelY > -0.7)) && (_currentHStatus != "immobile")) {
				_room.sendMessage(_uniqueID, true, null, NetworkEvent.IMMOBILE);
				_currentHStatus = "immobile";
			}

		}

		public function drawCircleForCatapulte():void {
			_room.sendMessage(_uniqueID, true, null, NetworkEvent.CIRCLE_DRAW);
		}

		public function hudInfo(tEvt:MouseEvent):void {

			switch (tEvt.target.name) {

				case "skip":
					_room.sendMessage(_uniqueID, true, null, NetworkEvent.SKIP);
					this.dispatchEvent(new ArtEvent(ArtEvent.SKIP));

					break;

				case "fullscreen":

					_room.sendMessage(_uniqueID, true, null, NetworkEvent.FULLSCREEN);

					if (tEvt.target.currentFrameLabel == "fullscreen") {
						tEvt.target.gotoAndStop("normal");
					} else {
						tEvt.target.gotoAndStop("fullscreen");
					}

					break;

				case "pause":

					_room.sendMessage(_uniqueID, true, null, NetworkEvent.PAUSE_GAME);

					if (tEvt.target.currentFrameLabel == "play") {
						tEvt.target.gotoAndStop("pause");
					} else {
						tEvt.target.gotoAndStop("play");
					}

					break;

				case "sound":

					_room.sendMessage(_uniqueID, true, null, NetworkEvent.SOUND_GAME);

					if (tEvt.target.currentFrameLabel == "play") {
						tEvt.target.gotoAndStop("mute");
					} else {
						tEvt.target.gotoAndStop("play");
					}

					break;

			}

		}

		public function catchMic($value:Boolean):void {

			if ($value == true) {

				_timer = new Timer(100);

				_micArray = [];

				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, _timeMic);

			} else {
				
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _timeMic);
				
				_timer.reset();
				
				_timer = null;
			}
		}

		private function _timeMic(tEvt:TimerEvent):void {

			var max:Number = 0;

			for (var i:uint = 0; i < _micArray.length; ++i) {
				if (_micArray[i] > max)
					max = _micArray[i];
			}

			(max > _MICRO_FLY_LEVEL) ? _room.sendMessage(_uniqueID, true, null, NetworkEvent.FLY) : _room.sendMessage(_uniqueID, true, null, NetworkEvent.NOT_FLY);
			_micArray = [];
		}

		public function sampleData(sdEvt:SampleDataEvent):void {

			var byteArray:ByteArray = sdEvt.data;

			while (sdEvt.data.bytesAvailable > 0) {
				_micArray.push(byteArray.readByte());
			}
		}

		private function _checkMsgFromGame(message:String):Boolean {

			for (var i:uint = 0; i < _lengthTab; ++i) {

				if (message == _tabMsgFromGame[i])
					return true;
			}

			return false;
		}
	}
}