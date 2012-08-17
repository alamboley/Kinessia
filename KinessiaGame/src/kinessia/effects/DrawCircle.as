package kinessia.effects {

	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author Aymeric
	 */
	public class DrawCircle extends Shape {

		private var _color:uint;
		private var _alpha:Number;
		private var _thickness:Number;

		private var _angle:uint;

		public function DrawCircle() {

			_thickness = 5;
			_color = 0x000000;
			_alpha = 1;

			this.graphics.clear();
			this.graphics.lineStyle(_thickness, _color, _alpha);

			this.graphics.moveTo(40, 0);

			_angle = 0;

			this.addEventListener(Event.ENTER_FRAME, _ef);
		}

		private function _getArcPoint(oX:Number, oY:Number, oANGLE:Number, oRADIUS:Number):Point {

			var pts:Point = new Point();
			pts.x = oX + Math.cos(oANGLE) * oRADIUS;
			pts.y = oY + Math.sin(oANGLE) * oRADIUS;
			return pts;
		}

		private function _ef(evt:Event):void {

			var pts:Point = _getArcPoint(0, 0, (_angle * Math.PI / 180), 40);
			this.graphics.lineTo(pts.x, pts.y);

			_angle += 15;

			if (_angle > 360) {

				this.removeEventListener(Event.ENTER_FRAME, _ef);
				this.graphics.endFill();
			}
		}
	}
}
