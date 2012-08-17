package kinessia.sound {

	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	/**
	 * @author Aymeric
	 */
	public class Ring extends Sound {

		public function Ring(stream:URLRequest = null, context:SoundLoaderContext = null) {
			super(stream, context);
		}
	}
}
