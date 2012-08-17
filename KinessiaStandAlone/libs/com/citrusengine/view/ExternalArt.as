package com.citrusengine.view
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * This class is used in the SpriteView whenever an external file (JPG, PNG, SWF) is specified as a CitrusObject's view.
	 * This class loads the file into memory, tells it which animation state to play, and sets its registration point, all
	 * according to the data that the CitrusObject passes it.
	 */	
	public class ExternalArt extends MovieClip
	{
		/**
		 * You will want to set this to true if you plan on using Bitmaps that will be rotated at any point in your game. 
		 */		
		public static var smoothBitmaps:Boolean = false;
		
		/**
		 * The loader object that loaded your graphic. 
		 */		
		public var loader:Loader;
		
		/**
		 * This will be a valid pointer if your extsernal art is a SWF. 
		 */		
		public var movieClipContent:MovieClip;
		
		private var _registration:String;
		
		/**
		 * Creates an external art object. The SpriteView creates these for you when a CitrusObject.view property is a path
		 * to a JPG, PNG, or SWF. 
		 */		
		public function ExternalArt()
		{
			super();
		}
		
		/**
		 * Does any initialization to the graphics object based on the properties of the CitrusObject.
		 * For example, this is where the CitrusObject's registration is stored.
		 * 
		 * <p>This will commonly need to be overridden for special handling such as custom tinting.</p>
		 */		
		public function initialize(citrusObject:ISpriteView):void
		{
			loader = new Loader();
			addChild(loader);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete, false, 0, true);
			loader.load(new URLRequest(citrusObject.view));
			_registration = citrusObject.registration;
		}
		
		/**
		 * Passes the currentFrameLabel to the MovieClip that was loaded in. 
		 */		
		override public function get currentFrameLabel():String
		{
			if (movieClipContent)
				return movieClipContent.currentFrameLabel;
			else
				return super.currentFrameLabel;
		}
		
		/**
		 * Passes the desired frame or label to the MovieClip that was loaded in. 
		 */		
		override public function gotoAndStop(frame:Object, scene:String=null):void
		{
			if (frame == null || frame == "")
				return;
			
			if (movieClipContent)
				movieClipContent.gotoAndStop(frame, scene);
				
		}
		
		protected function handleLoadComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoadComplete);
			movieClipContent = loader.content as MovieClip;
			
			//Quick way to make sure all bitmaps smooth upon load.
			if (smoothBitmaps && loader.content is Bitmap)
				Bitmap(loader.content).smoothing = true;
			
			if (_registration == "center")
			{
				loader.x = (-loader.width / 2);
				loader.y = (-loader.height / 2);
			}
		}
	}
}