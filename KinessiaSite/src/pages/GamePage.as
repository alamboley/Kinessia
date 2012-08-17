﻿package pages {	import com.gaiaframework.api.IBitmap;	import com.gaiaframework.api.IBitmapSprite;	import com.gaiaframework.templates.AbstractPage;	import com.greensock.TweenMax;	import flash.display.Bitmap;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	public class GamePage extends AbstractPage {		private var _background:Bitmap;		private var _text:Sprite;		private var _screen:Sprite;		private var _arrow:Sprite;		private const _MAX:uint = 3;		private var _compteur:uint;		private var _text1:Bitmap, _text2:Bitmap, _text3:Bitmap;		private var _img1:Bitmap, _img2:Bitmap, _img3:Bitmap;		private var _premierPlan:Bitmap;		public function GamePage() {			super();			alpha = 0;		}		override public function transitionIn():void {			super.transitionIn();			TweenMax.to(this, 0.3, {alpha:1, onComplete:transitionInComplete});			_background = new Bitmap(IBitmap(assets.imgGame).bitmapData);			_background.x = (stage.stageWidth - _background.width) / 2;			addChild(_background);			_compteur = 1;			_text = new Sprite();			addChild(_text);			_text3 = new Bitmap(IBitmap(assets.gameTxt3).bitmapData);			_text.addChild(_text3);			_text2 = new Bitmap(IBitmap(assets.gameTxt2).bitmapData);			_text.addChild(_text2);			_text1 = new Bitmap(IBitmap(assets.gameTxt1).bitmapData);			_text.addChild(_text1);			_text2.visible = _text3.visible = false;			_text.x = (stage.stageWidth - _text.width) / 2 - 250;			_text.y = 275;			_screen = new Sprite();			addChild(_screen);			_img3 = new Bitmap(IBitmap(assets.gameImg3).bitmapData);			_screen.addChild(_img3);			_img2 = new Bitmap(IBitmap(assets.gameImg2).bitmapData);			_screen.addChild(_img2);			_img1 = new Bitmap(IBitmap(assets.gameImg1).bitmapData);			_screen.addChild(_img1);			_img2.visible = _img3.visible = false;			_screen.x = (stage.stageWidth - _screen.width) / 2 + 250;			_screen.y = 280;			_arrow = new Sprite();			addChild(_arrow);			_arrow.addChild(IBitmapSprite(assets.rightOver).container);			_arrow.addChild(IBitmapSprite(assets.right).container);			_arrow.x = (stage.stageWidth - _arrow.width) / 2 - 75;			_arrow.y = 275;			IBitmapSprite(assets.right).visible = true;			IBitmapSprite(assets.rightOver).name = "rightOver";			IBitmapSprite(assets.right).name = "right";			IBitmapSprite(assets.rightOver).buttonMode = true;			_premierPlan = new Bitmap(IBitmap(assets.premierPlan).bitmapData);			addChild(_premierPlan);			_premierPlan.x = (stage.stageWidth - _premierPlan.width) / 2 + 250;			_premierPlan.y = 480;			IBitmapSprite(assets.rightOver).addEventListener(MouseEvent.CLICK, _click);			IBitmapSprite(assets.right).addEventListener(MouseEvent.MOUSE_OVER, _over);			IBitmapSprite(assets.rightOver).addEventListener(MouseEvent.MOUSE_OUT, _out);			stage.addEventListener(Event.RESIZE, _onResize);		}		private function _click(mEvt:MouseEvent):void {			switch (mEvt.target.name) {				case "rightOver":					++_compteur;					for (var i:uint = 1; i <= _MAX; ++i) {												this["_text" + i].visible = false;						this["_text" + i].alpha = 0;												this["_img" + i].visible = false;						this["_img" + i].alpha = 0;						if (_compteur == i) {							this["_text" + i].visible = this["_img" + i].visible = true;							TweenMax.to(this["_text" + i], 0.5, {alpha:1});							TweenMax.to(this["_img" + i], 0.5, {alpha:1});						}					}					if (_compteur == _MAX)						_compteur = 0;					break;			}		}		private function _over(mEvt:MouseEvent):void {			switch (mEvt.target.name) {				case "right":					IBitmapSprite(assets.right).visible = false;					IBitmapSprite(assets.rightOver).visible = true;					break;			}		}		private function _out(mEvt:MouseEvent):void {			switch (mEvt.target.name) {				case "rightOver":					IBitmapSprite(assets.right).visible = true;					IBitmapSprite(assets.rightOver).visible = false;					break;			}		}		private function _onResize(evt:Event):void {			_background.x = (stage.stageWidth - _background.width) / 2;			_text.x = (stage.stageWidth - _text.width) / 2 - 250;			_screen.x = (stage.stageWidth - _screen.width) / 2 + 250;			_arrow.x = (stage.stageWidth - _arrow.width) / 2 - 75;		}		override public function transitionOut():void {			stage.removeEventListener(Event.RESIZE, _onResize);			IBitmapSprite(assets.rightOver).removeEventListener(MouseEvent.CLICK, _click);			IBitmapSprite(assets.right).removeEventListener(MouseEvent.MOUSE_OVER, _over);			IBitmapSprite(assets.rightOver).removeEventListener(MouseEvent.MOUSE_OUT, _out);			super.transitionOut();			TweenMax.to(this, 0.3, {alpha:0, onComplete:transitionOutComplete});		}	}}