package com.citrusengine.physics
{
	import Box2DAS.Dynamics.b2DebugDraw;
	
	import com.citrusengine.core.CitrusObject;
	import com.citrusengine.view.ISpriteView;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * This displays Box2D's debug graphics. It does so properly through Citrus Engine's view manager. Box2D by default
	 * sets visible to false, so you'll need to set the Box2D object's visible property to true in order to see the debug graphics. 
	 */	
	public class Box2DDebugArt extends MovieClip
	{
		private var _box2D:Box2D;
		private var _debugDrawer:b2DebugDraw;
		
		public function Box2DDebugArt()
		{
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
			addEventListener(Event.REMOVED, destroy);
		}
		
		private function destroy(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			removeEventListener(Event.REMOVED, destroy);
		}
		
		public function initialize(citrusObject:ISpriteView):void
		{
			_box2D = citrusObject as Box2D;
			
			_debugDrawer = new b2DebugDraw();
			addChild(_debugDrawer);
			_debugDrawer.world = _box2D.world;
			_debugDrawer.scale = _box2D.scale;
		}
		
		override public function get visible():Boolean
		{
			return super.visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			if (super.visible == value)
				return;
			
			super.visible = value;
			
			if (!visible)
				_debugDrawer.graphics.clear();
		}
		
		private function handleEnterFrame(e:Event):void
		{
			if (visible)
				_debugDrawer.Draw();
		}
	}
}