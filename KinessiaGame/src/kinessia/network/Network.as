package kinessia.network {

	import net.user1.reactor.IClient;
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.Room;

	import com.citrusengine.core.CitrusEngine;

	import flash.events.EventDispatcher;

	/**
	 * @author Aymeric
	 */
	public class Network extends EventDispatcher {

		private static var _instance:Network;

		private var _ce:CitrusEngine;
		private var _reactor:Reactor;
		private var _room:Room;

		private var _uniqueID:String;

		private var _tabMsgFromIphone:Array;
		private var _lengthTab:uint;

		public function Network() {

			_instance = this;
			_ce = CitrusEngine.getInstance();

			_uniqueID = "1234567";
			// _generateRandomString(7);

			_reactor = new Reactor();

			_reactor.connect("localhost", 9110);
			// _reactor.connect("tryunion.com", 80);


			_tabMsgFromIphone = [];
			_tabMsgFromIphone = [NetworkEvent.CONNECTED, NetworkEvent.SKIP, NetworkEvent.FULLSCREEN, NetworkEvent.PAUSE_GAME, NetworkEvent.SOUND_GAME, NetworkEvent.JUMP, NetworkEvent.ONGROUND, NetworkEvent.STATIONARY, NetworkEvent.RIGHT, NetworkEvent.LEFT, NetworkEvent.IMMOBILE, NetworkEvent.FLY, NetworkEvent.NOT_FLY, NetworkEvent.CIRCLE_DRAW];
			_lengthTab = _tabMsgFromIphone.length;

			_reactor.addEventListener(ReactorEvent.READY, _createRoom);
		}

		public static function getInstance():Network {
			return _instance;
		}

		public function addLevelListener(level:String):void {

			switch (level) {
				
				case "A1":
					_ce.addEventListener(NetworkEvent.TALK, _messageToIphone);
					_ce.addEventListener(NetworkEvent.SKIP, _messageToIphone);
					break;

				case "A2":
					_ce.addEventListener(NetworkEvent.START_MICRO, _messageToIphone);
					_ce.addEventListener(NetworkEvent.STOP_MICRO, _messageToIphone);
					break;

				case "A3":
					_ce.addEventListener(NetworkEvent.START_PACMAN, _messageToIphone);
					_ce.addEventListener(NetworkEvent.END_PACMAN, _messageToIphone);
					break;

				case "A5":
					_ce.addEventListener(NetworkEvent.START_CATAPULTE, _messageToIphone);
					_ce.addEventListener(NetworkEvent.END_CATAPULTE, _messageToIphone);
					break;
			}

		}

		private function _generateRandomString(newLength:uint = 1, userAlphabet:String = "123456789"):String {

			var alphabet:Array = userAlphabet.split("");
			var alphabetLength:int = alphabet.length;
			var randomLetters:String = "";
			for (var i:uint = 0; i < newLength; i++) {
				randomLetters += alphabet[int(Math.floor(Math.random() * alphabetLength))];
			}
			return randomLetters;
		}

		private function _createRoom(rEvt:ReactorEvent):void {

			_reactor.removeEventListener(ReactorEvent.READY, _createRoom);

			_room = _reactor.getRoomManager().createRoom("Kinessia");
			_room.join();

			_room.addMessageListener(_uniqueID, _messageFromIphone);

			_ce.addEventListener(NetworkEvent.COIN_TAKEN, _messageToIphone);
			this.addEventListener(NetworkEvent.LEVEL_COMPLETE, _messageToIphone);
			this.addEventListener(NetworkEvent.RESTART_LEVEL, _messageToIphone);
		}

		private function _messageToIphone(nEvt:NetworkEvent):void {

			trace("Jeu envoit :" + nEvt.type);

			_room.sendMessage(_uniqueID, true, null, nEvt.type);

			switch (nEvt.type) {
				
				case NetworkEvent.TALK:
					_ce.removeEventListener(NetworkEvent.TALK, _messageToIphone);
					break;
				
				case NetworkEvent.SKIP:
					_ce.removeEventListener(NetworkEvent.SKIP, _messageToIphone);
					break;

				case NetworkEvent.START_MICRO:
					_ce.removeEventListener(NetworkEvent.START_MICRO, _messageToIphone);
					break;

				case NetworkEvent.STOP_MICRO:
					_ce.removeEventListener(NetworkEvent.STOP_MICRO, _messageToIphone);
					break;

				case NetworkEvent.START_PACMAN:
					_ce.removeEventListener(NetworkEvent.START_PACMAN, _messageToIphone);
					break;

				case NetworkEvent.END_PACMAN:
					_ce.removeEventListener(NetworkEvent.END_PACMAN, _messageToIphone);
					break;

				case NetworkEvent.START_CATAPULTE:
					_ce.removeEventListener(NetworkEvent.START_CATAPULTE, _messageToIphone);
					break;

				case NetworkEvent.END_CATAPULTE:
					_ce.removeEventListener(NetworkEvent.END_CATAPULTE, _messageToIphone);
					break;
			}

		}

		private function _messageFromIphone(fromClient:IClient, message:String):void {

			if (_checkMsgFromIphone(message)) {
				trace("provient de l'iphone : " + message);
				_ce.dispatchEvent(new NetworkEvent(message));
			}
		}

		private function _checkMsgFromIphone(message:String):Boolean {

			for (var i:uint = 0; i < _lengthTab; ++i) {

				if (message == _tabMsgFromIphone[i])
					return true;
			}

			return false;
		}

		public function get uniqueID():String {
			return _uniqueID;
		}
	}
}
