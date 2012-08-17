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
 
package kinessia.gesture
{
	public class Result {
			
		public var Name:String;
		public var Score;
		
		public function Result(name, score) // constructor
		{
			this.Name = name;
			this.Score = score;
		}
	}
}