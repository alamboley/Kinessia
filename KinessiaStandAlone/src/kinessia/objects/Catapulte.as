package kinessia.objects {

	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.ContactEvent;
	import Box2DAS.Dynamics.Joints.b2RevoluteJoint;
	import Box2DAS.Dynamics.Joints.b2RevoluteJointDef;

	import kinessia.characters.Declik;
	import kinessia.events.KinessiaEvent;
	import kinessia.ui.Hud;

	import com.citrusengine.objects.PhysicsObject;
	import com.citrusengine.objects.platformer.Platform;

	import org.osflash.signals.Signal;

	/**
	 * @author Aymeric
	 */
	public class Catapulte extends PhysicsObject {

		public var onBeginContact:Signal;

		private var _declik:Declik;

		public function Catapulte(name:String, params:Object = null) {

			super(name, params);
			onBeginContact = new Signal(ContactEvent);
		}

		public function know(declik:Declik):void {
			_declik = declik;
		}

		override public function destroy():void {

			onBeginContact.removeAll();
			_fixture.removeEventListener(ContactEvent.BEGIN_CONTACT, _handleBeginContact);
			super.destroy();
		}

		public function initJoint($platformJoint:Platform):void {

			var platformJoint:Platform = $platformJoint;

			var jointDefPlatform:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDefPlatform.Initialize(_body, platformJoint.body, new V2(15, 12));

			b2RevoluteJoint(_box2D.world.CreateJoint(jointDefPlatform));
		}

		override protected function createFixture():void {

			super.createFixture();
			_fixture.m_reportBeginContact = true;
			_fixture.addEventListener(ContactEvent.BEGIN_CONTACT, _handleBeginContact);
		}

		override protected function defineFixture():void {

			super.defineFixture();

			_fixtureDef.density = 0.1;
			_fixtureDef.restitution = 0;
		}

		private function _handleBeginContact(cEvt:ContactEvent):void {

			onBeginContact.dispatch(cEvt);

			if (cEvt.other.GetBody().GetUserData() is Circle) {

				_declik.velocityCatapulte = new V2(50, -5);
				cEvt.fixture.GetBody().ApplyImpulse(new V2(100, 50), new V2(width, 0));
			}
		}
		
		public function shot(kEvt:KinessiaEvent):void {

			_declik.velocityCatapulte = new V2(50, -5);
			_body.ApplyImpulse(new V2(100, 50), new V2(width, 0));
		}
	}
}