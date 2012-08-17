/**
 * The $1 Gesture Recognizer
 *
 *		Jacob O. Wobbrock
 * 		The Information School
 *		University of Washington
 *		Mary Gates Hall, Box 352840
 *		Seattle, WA 98195-2840
 *		wobbrock@u.washington.edu
 *
 *		Andrew D. Wilson
 *		Microsoft Research
 *		One Microsoft Way
 *		Redmond, WA 98052
 *		awilson@microsoft.com
 *
 *		Yang Li
 *		Department of Computer Science and Engineering
 * 		University of Washington
 *		The Allen Center, Box 352350
 *		Seattle, WA 98195-2840
 * 		yangli@cs.washington.edu
 *
 *		Actionscript conversion: Christoph Ketzler christoph@ketzler.de
 */



package kinessia.gesture {

	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Recognizer {
		
		public static var NumPoints:int = 64;
		

		public static var SquareSize:Number = 250.0;
		public static var HalfDiagonal = 0.5 * Math.sqrt(250.0 * 250.0 + 250.0 * 250.0);
		public static var AngleRange = 45.0;
		public static var AnglePrecision = 2.0;
		public static var Phi = 0.5 * (-1.0 + Math.sqrt(5.0)); // Golden Ratio
		public var Templates:Array;
		
		
		public function Recognizer(){
				this.Templates = new Array();
		}
		
		public function recognize(points)
		{
			points = Resample(points, NumPoints);
			points = RotateToZero(points);
			points = ScaleToSquare(points, SquareSize);
			points = TranslateToOrigin(points);
		
			var b = +Infinity;
			var t;
			for (var i = 0; i < this.Templates.length; i++)
			{
				var d = DistanceAtBestAngle(points, this.Templates[i], -AngleRange, +AngleRange, AnglePrecision);
				if (d < b)
				{
					b = d;
					t = i;
				}
			}
			var score = 1.0 - (b / HalfDiagonal);
			return new Result(this.Templates[t].Name, score);
		};
		//
		// add/delete new templates
		//
		public function addTemplate(name, points)
		{
			this.Templates[this.Templates.length] = new Template(name, points); // append new template
			var num = 0;
			for (var i = 0; i < this.Templates.length; i++)
			{
				if (this.Templates[i].Name == name)
					num++;
			}
			return num;
		}

		
		// Helper functions
		
		public static function Resample(points, n)
		{
			var I = PathLength(points) / (n - 1); // interval length
			var D = 0.0;
			var newpoints = new Array(points[0]);
			for (var i = 1; i < points.length; i++)
			{
				var d = Distance(points[i - 1], points[i]);
				if ((D + d) >= I)
				{
					var qx = points[i - 1].x + ((I - D) / d) * (points[i].x - points[i - 1].x);
					var qy = points[i - 1].y + ((I - D) / d) * (points[i].y - points[i - 1].y);
					var q = new Point(qx, qy);
					newpoints[newpoints.length] = q; // append new point 'q'
					points.splice(i, 0, q); // insert 'q' at position i in points s.t. 'q' will be the next i
					D = 0.0;
				}
				else D += d;
			}
			// somtimes we fall a rounding-error short of adding the last point, so add it if so
			if (newpoints.length == n - 1)
			{
				newpoints[newpoints.length] = points[points.length - 1];
			}
			return newpoints;
		}
		public static function RotateToZero(points)
		{
			var c = Centroid(points);
			var theta = Math.atan2(c.y - points[0].y, c.x - points[0].x);
			return RotateBy(points, -theta);
		}
		
		public static function ScaleToSquare(points, size)
		{
			var B = BoundingBox(points);
			var newpoints = new Array();
			for (var i = 0; i < points.length; i++)
			{
				var qx = points[i].x * (size / B.width);
				var qy = points[i].y * (size / B.height);
				newpoints[newpoints.length] = new Point(qx, qy);
			}
			return newpoints;
		}			
		public static function TranslateToOrigin(points)
		{
			var c = Centroid(points);
			var newpoints = new Array();
			for (var i = 0; i < points.length; i++)
			{
				var qx = points[i].x - c.x;
				var qy = points[i].y - c.y;
				newpoints[newpoints.length] = new Point(qx, qy);
			}
			return newpoints;
		}
		
		public static function DistanceAtBestAngle(points, T, a, b, threshold)
		{
			var x1 = Phi * a + (1.0 - Phi) * b;
			var f1 = DistanceAtAngle(points, T, x1);
			var x2 = (1.0 - Phi) * a + Phi * b;
			var f2 = DistanceAtAngle(points, T, x2);
			while (Math.abs(b - a) > threshold)
			{
				if (f1 < f2)
				{
					b = x2;
					x2 = x1;
					f2 = f1;
					x1 = Phi * a + (1.0 - Phi) * b;
					f1 = DistanceAtAngle(points, T, x1);
				}
				else
				{
					a = x1;
					x1 = x2;
					f1 = f2;
					x2 = (1.0 - Phi) * a + Phi * b;
					f2 = DistanceAtAngle(points, T, x2);
				}
			}
			return Math.min(f1, f2);
		}
		
		public static function PathLength(points)
		{
			var d = 0.0;
			for (var i = 1; i < points.length; i++)
				d += Distance(points[i - 1], points[i]);
			return d;
		}
		
		public static function Distance(p1, p2)
		{
			var dx = p2.x - p1.x;
			var dy = p2.y - p1.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		public static function Centroid(points)
		{
			var x = 0.0, y = 0.0;
			for (var i = 0; i < points.length; i++)
			{
				x += points[i].x;
				y += points[i].y;
			}
			x /= points.length;
			y /= points.length;
			return new Point(x, y);
		}
		public static function RotateBy(points, theta) 
		{
			var c = Centroid(points);
			var cos = Math.cos(theta);
			var sin = Math.sin(theta);
			
			var newpoints = new Array();
			for (var i = 0; i < points.length; i++)
			{
				var qx = (points[i].x - c.x) * cos - (points[i].y - c.y) * sin + c.x
				var qy = (points[i].x - c.x) * sin + (points[i].y - c.y) * cos + c.y;
				newpoints[newpoints.length] = new Point(qx, qy);
			}
			return newpoints;
		}
		public static function BoundingBox(points)
		{
			var minX = +Infinity, maxX = -Infinity, minY = +Infinity, maxY = -Infinity;
			for (var i = 0; i < points.length; i++)
			{
				if (points[i].x < minX)
					minX = points[i].x;
				if (points[i].x > maxX)
					maxX = points[i].x;
				if (points[i].y < minY)
					minY = points[i].y;
				if (points[i].y > maxY)
					maxY = points[i].y;
			}
			return new Rectangle(minX, minY, maxX - minX, maxY - minY);
		}
		
		public static function DistanceAtAngle(points, T, theta)
		{
			var newpoints = RotateBy(points, theta);
			return PathDistance(newpoints, T.Points);
		}
		
		public static function PathDistance(pts1, pts2)
		{
			var d = 0.0;
			for (var i = 0; i < pts1.length; i++) // assumes pts1.length == pts2.length
				d += Distance(pts1[i], pts2[i]);
			return d / pts1.length;
		}
	}
}