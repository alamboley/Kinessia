package kinessia.objects {

	import Box2DAS.Collision.Shapes.b2CircleShape;

	import com.citrusengine.objects.PhysicsObject;

   /**
    * @author Aymeric
    */
   public class Circle extends PhysicsObject {
      
      private var _radius:Number;

      public function Circle(name:String, params:Object = null) {
         super(name, params);
      }
      
      override public function destroy():void {
      	super.destroy();
      }
      
      override protected function createShape():void {
         
         _shape = new b2CircleShape();
         b2CircleShape(_shape).m_radius = _radius;
      }
      
      public function get radius():Number {
         return _radius * _box2D.scale;
      }
      
      public function set radius(value:Number):void {
         _radius = value / _box2D.scale;
      }
   }
}