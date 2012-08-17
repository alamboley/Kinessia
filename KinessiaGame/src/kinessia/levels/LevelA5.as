package kinessia.levels {

	import flash.display.Bitmap;
	import Box2DAS.Dynamics.ContactEvent;

	import kinessia.characters.Declik;
	import kinessia.characters.TheWalker;
	import kinessia.effects.DrawCircle;
	import kinessia.network.NetworkEvent;
	import kinessia.objects.Catapulte;
	import kinessia.objects.Circle;
	import kinessia.objects.Croquis;
	import kinessia.objects.Piece;
	import kinessia.video.Video;

	import com.citrusengine.objects.platformer.Platform;
	import com.citrusengine.objects.platformer.Sensor;
	import com.greensock.TweenMax;
	
	import fl.video.VideoEvent;

	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	/**
	 * @author Aymeric
	 */
	public class LevelA5 extends ALevel {
		
		private var _catapulte:Catapulte;
		private var _circle:Circle;
		
		private var _startCatapulte:Sensor;
		private var _croquis1:Croquis, _croquis2:Croquis;
		
		private var _piece:Piece;
		private var _bulle:Sensor;
		
		private var _startWalker:Sensor;
		private var _walker:TheWalker;
		
		private var _videoEnd:Video;

		public function LevelA5(levelObjectsMC:MovieClip) {
			super(levelObjectsMC);
		}

		override public function initialize():void {

			super.initialize();

			_addContactRestartLevel();

			_catapulte = Catapulte(getFirstObjectByType(Catapulte));
			_catapulte.initJoint(Platform(getObjectByName("PlatformJoint")));
			_catapulte.know(_declik);
			
			_startCatapulte = Sensor(getObjectByName("StartCatapulte"));
			_startCatapulte.onBeginContact.add(_catapulteReady);
			
			_croquis1 = Croquis(getObjectByName("Croquis1"));
			_croquis2 = Croquis(getObjectByName("Croquis2"));

			_piece = Piece(getFirstObjectByType(Piece));
			_piece.onBeginContact.add(_pieceTaken);
			
			_ce.addEventListener(NetworkEvent.CIRCLE_DRAW, _circleDraw);
			
			_startWalker = Sensor(getObjectByName("StartWalker"));
			_startWalker.onBeginContact.add(_awakeWalker);
			
			_walker = TheWalker(getFirstObjectByType(TheWalker));
		}
		
		override public function destroy():void {
			
			super.destroy();
		}
		
		override protected function _endLevel(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is TheWalker) {
				//lvlEnded.dispatch();
				
				_videoEnd = new Video();
				_videoEnd.alpha = 0;
				addChild(_videoEnd);
				_videoEnd.x = 470;
				_videoEnd.y = 325;
				
				_ce.sound.stopSound("KinessiaTheme");
				_ce.playing = false;
				
				TweenMax.to(_videoEnd, 2, {alpha:1, onComplete:function():void{_ce.playing = false; _videoEnd.myVideo.theVideo.play();}});
				
				_videoEnd.myVideo.theVideo.addEventListener(VideoEvent.COMPLETE, _end);
			}
		}
		
		private function _end(vEvt:VideoEvent):void {
			
			_videoEnd.myVideo.theVideo.removeEventListener(VideoEvent.COMPLETE, _end);
			
			var endScreen:Bitmap = new Bitmap(new EndScreen(0, 0));
			endScreen.alpha = 0;
			endScreen.x = -5;
			addChild(endScreen);
			
			TweenMax.to(endScreen, 1, {alpha:1, onComplete:function():void{_videoEnd.myVideo.theVideo = null;_videoEnd.myVideo = null;}});
		}
		
		private function _catapulteReady(cEvt:ContactEvent):void {
			
			if (cEvt.other.GetBody().GetUserData() is Declik) {
				
				_startCatapulte.kill = true;
				
				_ce.dispatchEvent(new NetworkEvent(NetworkEvent.START_CATAPULTE));
				
				_croquis1.anim = _croquis2.anim = "white";
				
				setTimeout(_addBulle, 0);
			}
		}
		
		private function _addBulle():void {
			
			_bulle = new Sensor("bulle", {x:-250, y:200, view:"objects/bulle.swf"});
			add(_bulle);
		}

		private function _circleDraw(nEvt:NetworkEvent):void {
			
			_ce.removeEventListener(NetworkEvent.CIRCLE_DRAW, _circleDraw);
			
			_circle = new Circle("Circle", {view:DrawCircle, x:450, y:50, radius:15});
			add(_circle);
			_circle.gravity = 0;

			var timer:Timer = new Timer(200, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, _circleFall);
			timer.start();
		}

		private function _circleFall(tEvt:TimerEvent):void {
			
			_circle.gravity = 1.6;
			
			tEvt.target.stop();
			tEvt.target.removeEventListener(TimerEvent.TIMER_COMPLETE, _circleFall);			
		}

		private function _pieceTaken(cEvt:ContactEvent):void {

			if (cEvt.other.GetBody().GetUserData() is Declik) {

				_declik.velocityCatapulte = null;
				
				_croquis1.anim = _croquis2.anim = "black";

				_ce.dispatchEvent(new NetworkEvent(NetworkEvent.END_CATAPULTE));
				
				_bulle.kill = true;
			}
		}
		
		private function _awakeWalker(cEvt:ContactEvent):void {
			
			if (cEvt.other.GetBody().GetUserData() is Declik) {
				_startWalker.kill = true;
				_walker.awake = true;
			}
		}
	}
}
