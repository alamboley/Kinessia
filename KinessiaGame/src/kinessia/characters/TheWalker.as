﻿package kinessia.characters {

	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.V2;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.Joints.b2RevoluteJoint;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2FixtureDef;

	import com.citrusengine.math.MathVector;
	import com.citrusengine.objects.PhysicsObject;

	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;

	public class TheWalker extends PhysicsObject {

		public var speed:Number = 1;
		public var enemyClass:String = "com.citrusengine.objects.platformer.Hero";
		public var enemyKillVelocity:Number = 3;
		public var startingDirection:String = "left";
		public var hurtDuration:Number = 3000;
		public var leftBound:Number = -100000;
		public var rightBound:Number = 100000;

		private var _hurtTimeoutID:Number = 0;
		private var _hurt:Boolean = false;

		private var _awake:Boolean;

		// If the animation is with code :
		private var tScale:Number;
		private var m_offset:V2 = new V2();
		private var m_chassis:b2Body;
		private var m_wheel:b2Body;
		private var m_motorJoint:b2RevoluteJoint;
		private var m_motorOn:Boolean = true;
		private var m_motorSpeed:Number;

		public function TheWalker(name:String, params:Object = null) {

			super(name, params);

			if (startingDirection == "left") {
				_inverted = true;
			}


			// For the fun here is the Walker animated with code, coming from Box2D WCK !!
			// _theWalkerWithCode();
		}

		override public function destroy():void {

			_fixture.removeEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
			clearTimeout(_hurtTimeoutID);
			super.destroy();
		}

		override public function update(timeDelta:Number):void {

			super.update(timeDelta);

			var position:V2 = _body.GetPosition();
			var velocity:V2 = _body.GetLinearVelocity();
			
			if (_awake) {

				// Turn around when they pass their left/right bounds
				if ((_inverted && position.x * 30 < leftBound) || (!_inverted && position.x * 30 > rightBound))
					_inverted = !_inverted;

				if (!_hurt) {

					if (_inverted)
						velocity.x = -speed;
					else
						velocity.x = speed;
				} else {
					velocity.x = 0;
				}
			} else {
				velocity.x = 0;
			}

			_body.SetLinearVelocity(velocity);

			updateAnimation();
		}

		public function hurt():void {
			
			//_hurt = true;
			//_hurtTimeoutID = setTimeout(endHurtState, hurtDuration);
		}

		override protected function createBody():void {

			super.createBody();
			_body.SetFixedRotation(true);
		}

		override protected function defineFixture():void {

			super.defineFixture();
			_fixtureDef.friction = 0;
		}

		override protected function createFixture():void {

			super.createFixture();
			_fixture.m_reportBeginContact = true;
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, handleBeginContact);
		}

		private function handleBeginContact(e:ContactEvent):void {

			var colliderBody:b2Body = e.other.GetBody();
			var enemyClassClass:Class = flash.utils.getDefinitionByName(enemyClass) as Class;

			if (colliderBody.GetUserData() is enemyClassClass && colliderBody.GetLinearVelocity().y > enemyKillVelocity)
				hurt();

			// Collision angle, // The normal property doesn't come through all the time. I think doesn't come through against sensors.
			if (e.normal) {
				var collisionAngle:Number = new MathVector(e.normal.x, e.normal.y).angle * 180 / Math.PI;
				if (collisionAngle < 45 || collisionAngle > 135) {
					_inverted = !_inverted;
				}
			}
		}

		private function updateAnimation():void {
			if (_awake) {
				_animation = "walk";
			} else {
				_animation = "idle";
			}
		}

		private function endHurtState():void {
			_hurt = false;
			// kill = true;
		}
		
		public function get awake():Boolean {
			return _awake;
		}

		public function set awake(awake:Boolean):void {
			_awake = awake;
		}

		private function _theWalkeWithnCode():void {

			// scale walker by variable to easily change size
			tScale = _box2D.scale * 2;

			// Set position in world space
			m_offset = new V2(120.0 / _box2D.scale, 250 / _box2D.scale);
			m_motorSpeed = -2.0;
			m_motorOn = true;
			var pivot:V2 = new V2(0.0, -24.0 / tScale);

			b2Def.body.type = b2Body.b2_dynamicBody;

			b2Def.polygon.SetAsBox(75 / tScale, 30 / tScale);
			b2Def.fixture.shape = b2Def.polygon;
			b2Def.fixture.density = 1.0;
			b2Def.fixture.filter.groupIndex = -1;
			b2Def.body.position.v2 = V2.add(pivot, m_offset);
			m_chassis = _box2D.world.CreateBody(b2Def.body);
			m_chassis.CreateFixture(b2Def.fixture);

			b2Def.circle.m_radius = 48 / tScale;
			b2Def.fixture.shape = b2Def.circle;
			b2Def.fixture.density = 1.0;
			b2Def.fixture.filter.groupIndex = -1;
			b2Def.body.position.v2 = V2.add(pivot, m_offset);
			m_wheel = _box2D.world.CreateBody(b2Def.body);
			m_wheel.CreateFixture(b2Def.fixture);

			var po:V2 = V2.add(pivot, m_offset);
			b2Def.revoluteJoint.Initialize(m_wheel, m_chassis, po);
			b2Def.revoluteJoint.collideConnected = false;
			b2Def.revoluteJoint.motorSpeed = m_motorSpeed;
			b2Def.revoluteJoint.maxMotorTorque = 400.0;
			b2Def.revoluteJoint.enableMotor = m_motorOn;
			m_motorJoint = _box2D.world.CreateJoint(b2Def.revoluteJoint) as b2RevoluteJoint;
			b2Def.revoluteJoint.enableMotor = false;

			var wheelAnchor:V2 = V2.add(pivot, new V2(0, -0.8));

			wheelAnchor = new V2(0.0, 24.0 / tScale);
			wheelAnchor.add(pivot);

			CreateLeg(-1.0, wheelAnchor);
			CreateLeg(1.0, wheelAnchor);

			m_wheel.SetTransform(m_wheel.GetPosition(), 120.0 * Math.PI / 180.0);
			CreateLeg(-1.0, wheelAnchor);
			CreateLeg(1.0, wheelAnchor);

			m_wheel.SetTransform(m_wheel.GetPosition(), -120.0 * Math.PI / 180.0);
			CreateLeg(-1.0, wheelAnchor);
			CreateLeg(1.0, wheelAnchor);

			b2Def.fixture.filter.groupIndex = 0;
		}

		private function CreateLeg(s:Number, wheelAnchor:V2):void {

			var p1:V2 = new V2(162 * s / tScale, 183 / tScale);
			var p2:V2 = new V2(216 * s / tScale, 36 / tScale);
			var p3:V2 = new V2(129 * s / tScale, 57 / tScale);
			var p4:V2 = new V2(93 * s / tScale, -24 / tScale);
			var p5:V2 = new V2(180 * s / tScale, -45 / tScale);
			var p6:V2 = new V2(75 * s / tScale, -111 / tScale);

			var sd1:b2PolygonShape = new b2PolygonShape();
			var sd2:b2PolygonShape = new b2PolygonShape();
			var fd1:b2FixtureDef = new b2FixtureDef();
			var fd2:b2FixtureDef = new b2FixtureDef();
			fd1.shape = sd1;
			fd2.shape = sd2;
			fd1.filter.groupIndex = -1;
			fd1.friction = 0.8;
			fd2.filter.groupIndex = -1;
			fd1.density = 1.0;
			fd2.density = 1.0;

			if (s > 0.0) {
				sd1.Set(Vector.<V2>([p3, p2, p1]));
				sd2.Set(Vector.<V2>([V2.subtract(p6, p4), V2.subtract(p5, p4), new V2()]));
			} else {
				sd1.Set(Vector.<V2>([p2, p3, p1]));
				sd2.Set(Vector.<V2>([V2.subtract(p5, p4), V2.subtract(p6, p4), new V2()]));
			}

			var bd1:b2BodyDef = new b2BodyDef();
			var bd2:b2BodyDef = new b2BodyDef();
			bd1.type = b2Body.b2_dynamicBody;
			bd2.type = b2Body.b2_dynamicBody;
			bd1.position.v2 = m_offset;
			bd2.position.v2 = V2.add(p4, m_offset);

			bd1.angularDamping = 10.0;
			bd2.angularDamping = 10.0;

			var body1:b2Body = _box2D.world.CreateBody(bd1);
			var body2:b2Body = _box2D.world.CreateBody(bd2);

			body1.CreateFixture(fd1);
			body2.CreateFixture(fd2);

			sd1.destroy();
			sd2.destroy();
			fd1.destroy();
			fd2.destroy();
			bd1.destroy();
			bd2.destroy();


			// Using a soft distance constraint can reduce some jitter.
			// It also makes the structure seem a bit more fluid by
			// acting like a suspension system.
			b2Def.distanceJoint.dampingRatio = 0.5;
			b2Def.distanceJoint.frequencyHz = 10.0;

			b2Def.distanceJoint.Initialize(body1, body2, V2.add(p2, m_offset), V2.add(p5, m_offset));
			_box2D.world.CreateJoint(b2Def.distanceJoint);

			b2Def.distanceJoint.Initialize(body1, body2, V2.add(p3, m_offset), V2.add(p4, m_offset));
			_box2D.world.CreateJoint(b2Def.distanceJoint);

			b2Def.distanceJoint.Initialize(body1, m_wheel, V2.add(p3, m_offset), V2.add(wheelAnchor, m_offset));
			_box2D.world.CreateJoint(b2Def.distanceJoint);

			b2Def.distanceJoint.Initialize(body2, m_wheel, V2.add(p6, m_offset), V2.add(wheelAnchor, m_offset));
			_box2D.world.CreateJoint(b2Def.distanceJoint);

			b2Def.revoluteJoint.Initialize(body2, m_chassis, V2.add(p4, m_offset));
			_box2D.world.CreateJoint(b2Def.revoluteJoint);
		}

		/*public override function EnterFrame():void {

		if (Input.kp('A')) {
		// A
		m_chassis.SetAwake(true)
		m_motorJoint.SetMotorSpeed(-m_motorSpeed);
		}
		if (Input.kp('S')) {
		// S
		m_chassis.SetAwake(true);
		m_motorJoint.SetMotorSpeed(0.0);
		}
		if (Input.kp('D')) {
		// D
		m_chassis.SetAwake(true);
		m_motorJoint.SetMotorSpeed(m_motorSpeed);
		}
		if (Input.kp('M')) {
		// M
		m_chassis.SetAwake(true);
		m_motorJoint.EnableMotor(!m_motorJoint.IsMotorEnabled());
		}

		super.EnterFrame();
		}*/

	}
}