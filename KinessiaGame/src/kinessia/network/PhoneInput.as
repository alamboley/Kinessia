package kinessia.network {

	import com.citrusengine.core.CitrusEngine;
	import com.citrusengine.core.Input;

	/**
	 * @author Aymeric
	 */
	public class PhoneInput extends Input {
		
		private var _ce:CitrusEngine;

		private var _enabled:Boolean = true;

		private var _phoneJump:Boolean;
		private var _firstJump:Boolean;
		private var _phoneDirection:String;
		private var _fly:Boolean;
		
		private var _pacmanClimb:String;

		public function PhoneInput() {
			super();
		}

		override public function set enabled(value:Boolean):void {
			
			super.enabled = value;

			_ce = CitrusEngine.getInstance();
			
			if (_enabled) {
				
				_ce.addEventListener(NetworkEvent.JUMP, _onPhoneJump);
				_ce.addEventListener(NetworkEvent.ONGROUND, _onPhoneJump);
				_ce.addEventListener(NetworkEvent.STATIONARY, _onPhoneJump);
				
				_ce.addEventListener(NetworkEvent.LEFT, _onPhoneDirection);
				_ce.addEventListener(NetworkEvent.RIGHT, _onPhoneDirection);
				_ce.addEventListener(NetworkEvent.IMMOBILE, _onPhoneDirection);
				
				_ce.addEventListener(NetworkEvent.FLY, _onMicroFly);
				_ce.addEventListener(NetworkEvent.NOT_FLY, _onMicroFly);
				
			} else {
				
				_ce.removeEventListener(NetworkEvent.JUMP, _onPhoneJump);
				_ce.removeEventListener(NetworkEvent.ONGROUND, _onPhoneJump);
				_ce.removeEventListener(NetworkEvent.STATIONARY, _onPhoneJump);
				
				_ce.removeEventListener(NetworkEvent.LEFT, _onPhoneDirection);
				_ce.removeEventListener(NetworkEvent.RIGHT, _onPhoneDirection);
				_ce.removeEventListener(NetworkEvent.IMMOBILE, _onPhoneDirection);
				
				_ce.removeEventListener(NetworkEvent.FLY, _onMicroFly);
				_ce.removeEventListener(NetworkEvent.NOT_FLY, _onMicroFly);
			}
		}

		override public function initialize():void {
			
			super.initialize();

			_ce = CitrusEngine.getInstance();
			
			_ce.addEventListener(NetworkEvent.JUMP, _onPhoneJump);
			_ce.addEventListener(NetworkEvent.ONGROUND, _onPhoneJump);
			_ce.addEventListener(NetworkEvent.STATIONARY, _onPhoneJump);
			
			_ce.addEventListener(NetworkEvent.LEFT, _onPhoneDirection);
			_ce.addEventListener(NetworkEvent.RIGHT, _onPhoneDirection);
			_ce.addEventListener(NetworkEvent.IMMOBILE, _onPhoneDirection);
			
			_ce.addEventListener(NetworkEvent.FLY, _onMicroFly);
			_ce.addEventListener(NetworkEvent.NOT_FLY, _onMicroFly);
		}
		
		public function justJumped():Boolean {
			
			if (_phoneJump == true) {
				
				if (_firstJump == true) {
					_firstJump = false;
					return true;
				}
			}
			
			return false;
		}

		public function get phoneJump():Boolean {
			return _phoneJump;
		}

		public function get phoneDirecton():String {
			return _phoneDirection;
		}
		
		public function get phoneMicroFly():Boolean {
			return _fly;
		}
		
		public function set phoneMicroFly(value:Boolean):void {
			_fly = value;
		}
		
		public function get pacmanClimb():String {
			return _pacmanClimb;
		}

		private function _onPhoneJump(nEvt:NetworkEvent):void {
			
			switch (nEvt.type) {
				
				case "JUMP":
					_phoneJump = _firstJump = true;
					_pacmanClimb = "up";
					break;
					
				case "ONGROUND":
					_phoneJump = _firstJump = false;
					_pacmanClimb = "down";
					break;
					
				case "STATIONARY":
					_pacmanClimb = "stationary";
					break;
			}
		}

		private function _onPhoneDirection(nEvt:NetworkEvent):void {

			switch (nEvt.type) {

				case "LEFT":
					_phoneDirection = "left";
					break;

				case "RIGHT":
					_phoneDirection = "right";
					break;

				case "IMMOBILE":
					_phoneDirection = "immobile";
					break;
			}
		}
		
		private function _onMicroFly(nEvt:NetworkEvent):void {

			switch (nEvt.type) {
				
				case "FLY":
					_fly = true;
					break;
				
				case "NOT_FLY":
					_fly = false;
					break;
			}
		}
	}
}
