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
 
 package gesture {

	public class Template {
		
		public var Name:String;
		public var Points:Array;
		
		public function Template(name, points) // constructor
		{
			this.Name = name;
			this.Points = Recognizer.Resample(points, Recognizer.NumPoints);
			this.Points = Recognizer.RotateToZero(this.Points);
			this.Points = Recognizer.ScaleToSquare(this.Points, Recognizer.SquareSize);
			this.Points = Recognizer.TranslateToOrigin(this.Points);
		}
	}
}