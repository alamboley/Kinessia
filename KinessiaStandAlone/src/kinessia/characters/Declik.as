package kinessia.characters {

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.b2Body;

	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.platformer.Hero;

	/**
	 * @author Aymeric
	 */
	public class Declik extends Hero {

		private const _MAX_FLY_VELOCITY_Y:int = -5;
		private const _FLY_VELOCITY_Y:uint = 4;

		private var _velocityCatapulte:V2;

		private var _microFly:Boolean;
		private var _securityMicro:Boolean = false;

		public function Declik(name:String, params:Object = null) {

			super(name, params);

			enemyClass = Bullzor;
			hurtDuration = 1700;
		}

		override public function destroy():void {
			super.destroy();
		}

		override public function update(timeDelta:Number):void {

			super.update(timeDelta);

			var velocity:V2 = _body.GetLinearVelocity();

			if (controlsEnabled) {

				if (_microFly == true && _securityMicro == false) {
					if (velocity.y > _MAX_FLY_VELOCITY_Y) {
						velocity.y -= _FLY_VELOCITY_Y;
					}
				}
			}

			if (_velocityCatapulte != null) {
				_body.SetLinearVelocity(_velocityCatapulte);
			} else {
				_body.SetLinearVelocity(velocity);
			}
		}

		override protected function handleBeginContact(e:ContactEvent):void {

			var colliderBody:b2Body = e.other.GetBody();

			if (_enemyClass && colliderBody.GetUserData() is _enemyClass) {

				if (_body.GetLinearVelocity().y < killVelocity && !_hurt && !colliderBody.GetUserData().hurt) {

					hurt();
					// fling the hero
					var hurtVelocity:V2 = _body.GetLinearVelocity();
					hurtVelocity.y = -hurtVelocityY;
					hurtVelocity.x = hurtVelocityX;
					if (colliderBody.GetPosition().x > _body.GetPosition().x)
						hurtVelocity.x = -hurtVelocityX;
					_body.SetLinearVelocity(hurtVelocity);

				} else {

					_springOffEnemy = colliderBody.GetPosition().y * _box2D.scale - height;
					if (!colliderBody.GetUserData().hurtedByHero) {
						onGiveDamage.dispatch();
						colliderBody.GetUserData().hurtedByHero = true;
					}
					
				}
			}


			// Collision angle, The normal property doesn't come through all the time. I think doesn't come through against sensors.
			if (e.normal) {

				var collisionAngle:Number = new MathVector(e.normal.x, e.normal.y).angle * 180 / Math.PI;
				if (collisionAngle > 45 && collisionAngle < 135) {
					_groundContacts.push(e.other);
					_onGround = true;
				}
			}
		}

		public function set microFly($value:Boolean):void {
			_microFly = $value;
		}

		public function stopFlying():void {
			_securityMicro = true;
		}

		public function get velocityCatapulte():V2 {
			return _velocityCatapulte;
		}

		public function set velocityCatapulte(velocityCatapulte:V2):void {
			_velocityCatapulte = velocityCatapulte;
		}
	}
}

