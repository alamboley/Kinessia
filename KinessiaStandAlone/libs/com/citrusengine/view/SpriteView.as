﻿package com.citrusengine.view
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	/**
	 * SpriteView is the first official implementation of a Citrus Engine "view". It creates and manages graphics using the traditional
	 * Flash display list (addChild(), removeChild()) using DisplayObjects (MovieClips, Bitmaps, etc).
	 * 
	 * <p>You might think, "Is there any other way to display graphics in Flash?", and the answer is yes. Many Flash game programmers
	 * prefer to use other rendering methods. The most common alternative is called "blitting", which is what Flixel uses. There are
	 * also 3D games on the way that will use Adobe Molehill to render graphics.</p>
	 * 
	 * <p>At the time of this writing, Citrus Engine only supports the SpriteView as a view manager. However, Citrus Engine will
	 * may support other rendering methods such as blitting in the future.</p> 
	 */	
	public class SpriteView extends CitrusView
	{
		private var _viewRoot:Sprite;
		
		public function SpriteView(root:Sprite)
		{
			super(root, ISpriteView);
			
			_viewRoot = new Sprite();
			root.addChild(_viewRoot);
		}
		
		/**
		 * @inherit 
		 */		
		override public function update():void
		{
			super.update();
			
			//Update Camera
			if (cameraTarget)
			{
				var diffX:Number = (-cameraTarget.x + cameraOffset.x) - _viewRoot.x;
				var diffY:Number = (-cameraTarget.y + cameraOffset.y) - _viewRoot.y;
				var velocityX:Number = diffX * cameraEasing.x;
				var velocityY:Number = diffY * cameraEasing.y;
				_viewRoot.x += velocityX;
				_viewRoot.y += velocityY;
				
				//Constrain to camera bounds
				if (cameraBounds)
				{
					if (-_viewRoot.x <= cameraBounds.left || cameraBounds.width < cameraLensWidth)
						_viewRoot.x = -cameraBounds.left;
					else if (-_viewRoot.x + cameraLensWidth >= cameraBounds.right)
						_viewRoot.x = -cameraBounds.right + cameraLensWidth;
					
					if (-_viewRoot.y <= cameraBounds.top || cameraBounds.height < cameraLensHeight)
						_viewRoot.y = -cameraBounds.top;
					else if (-_viewRoot.y + cameraLensHeight >= cameraBounds.bottom)
						_viewRoot.y = -cameraBounds.bottom + cameraLensHeight;
				}
			}
			
			//Update art positions
			for (var object:Object in _viewObjects)
			{
				updateArt(object as ISpriteView, _viewObjects[object]);
			}
		}
		
		/**
		 * @inherit 
		 */		
		override protected function createArt(citrusObject:Object):Object
		{
			var viewObject:ISpriteView = citrusObject as ISpriteView;
			
			//Create the MovieClip and call initialize on it, if it is supported
			var art:DisplayObject = createArtObject(viewObject);
			if (art.hasOwnProperty("initialize"))
				art["initialize"](viewObject);
			
			//Create the container sprite (group) if it has not been created yet.
			while (viewObject.group >= _viewRoot.numChildren)
				_viewRoot.addChild(new Sprite());
			
			//Add the sprite to the appropriate group
			Sprite(_viewRoot.getChildAt(viewObject.group)).addChild(art);
			
			//Perform an initial update
			updateArt(viewObject, art);
			
			return art;
		}
		
		/**
		 * @inherit 
		 */		
		override protected function destroyArt(citrusObject:Object):void
		{
			var mc:DisplayObject = _viewObjects[citrusObject];
			if (!mc)
			{
				//TODO Can this case happen? If so, can we prevent it from CitrusView first?
				trace("Warning: The citrus object " + citrusObject + " does not have a view conterpart to destroy.");
				return;
			}
			mc.parent.removeChild(mc);
		}
		
		/**
		 * @inherit 
		 */		
		override protected function updateArt(citrusObject:Object, art:Object):void
		{
			var sprite:DisplayObject = art as DisplayObject;
			var viewObject:ISpriteView = citrusObject as ISpriteView;
			
			//position = object position + (camera position * inverse parallax)
			sprite.x = viewObject.x + (-_viewRoot.x * (1 - viewObject.parallax)) + viewObject.offsetX;
			sprite.y = viewObject.y + (-_viewRoot.y * (1 - viewObject.parallax)) + viewObject.offsetY;
			sprite.rotation = viewObject.rotation;
			sprite.visible = viewObject.visible;
			sprite.scaleX = viewObject.inverted ? -1 : 1;
			
			if (art is MovieClip)
			{
				var mc:MovieClip = art as MovieClip;
				if (viewObject.animation != null && viewObject.animation != "" && mc.currentFrameLabel != viewObject.animation)
					mc.gotoAndStop(viewObject.animation);
					
			}
			
		}
		
		private function createArtObject(citrusObject:ISpriteView):DisplayObject
		{
			if (citrusObject.view is String)
			{
				var classString:String = citrusObject.view;
				var suffix:String = classString.substring(classString.length - 4).toLowerCase();
				if (suffix == ".swf" || suffix == ".png" || suffix == ".gif" || suffix == ".jpg")
				{
					return new ExternalArt();
				}
				else
				{
					var artClass:Class = getDefinitionByName(classString) as Class;
					return new artClass();
				}
			}
			else if (citrusObject.view is Class)
			{
				return new citrusObject.view();
			}
			else
			{
				throw new Error("The SpriteView doesn't know how to create a graphic object from the provided CitrusObject " + citrusObject);
				return null;
			}
		}
	}
}