/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.sound {
	
	import com.greensock.TweenLite;
	import flash.events.EventDispatcher;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import frankenstein.events.SoundEvent;



	/**
	* Evènement dispatché lorsque le volume change
	* 
	* @eventType SoundEvent.VOLUME_CHANGE
	*/
	[Event(name="volume_change", type="frankenstein.events.SoundEvent")]

	/**
	* Evènement dispatché lorsque le volume général est coupé
	* 
	* @eventType SoundEvent.MUTE
	*/
	[Event(name="mute", type="frankenstein.events.SoundEvent")]

	/**
	* Evènement dispatché lorsque le volume général est réactivé
	* 
	* @eventType SoundEvent.UNMUTE
	*/
	[Event(name="unmute", type="frankenstein.events.SoundEvent")]


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 28 oct 2009<br />
	 * 		<b>Version </b> 1.6.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Manager du volume global du player.<br />
	 * 	La classe est entièrement statique.
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		SoundManager.addEventListener(SoundEvent.VOLUME_CHANGE, _onVolumeChange);
	 * 		SoundManager.addEventListener(SoundEvent.MUTE, _onMute);
	 * 		SoundManager.addEventListener(SoundEvent.UNMUTE, _onUnMute);
	 * 		SoundManager.toggle();
	 * 		
	 * 		function _onVolumeChange(e : SoundEvent):void{
	 * 			trace("volume general", SoundManager.volume);
	 * 		}
	 * 		
	 * 		
	 * 		function _onMute(e : SoundEvent):void{
	 * 			trace("volume général coupé");
	 * 		}
	 * 		
	 * 		
	 * 		function _onUnMute(e : SoundEvent):void{
	 * 			trace("volume général réactivé");
	 * 		}
	 * 	</pre>
	 * </listing>
	 * 
	 * @see flash.media.SoundMixer
	 */
	 public class SoundManager extends EventDispatcher {
		
		
		//static
		private static var _instance : SoundManager;
		
		private var _volume : Number = 1;
		private var _maxVolume : Number = 1;
		
		private var _isMutedDispatched : Boolean;
		
		private var _isToogleOn : Boolean = true;
				
		//--------------------------------------
		//					STATIC
		//--------------------------------------
		/**
		 * Coupe / remet le son avec fade
		 * 
		 * @param timeToToggle
		 * Temps pour le tween
		 * 
		 * @return
		 */
		public static function toggle(timeToToggle : Number = 0.5) : void {
			_getInstance().toggleSound(timeToToggle);
		}
		
		
		/**
		 * Modifie le volume général avec un fade.
		 * 
		 * @param newVolume
		 * Nouveau volume de 0 à 1.
		 * 
		 * @param timeToChange
		 * Temps pour le tween.
		 * 
		 * @return
		 */		
		public static function tweenVolume(newVolume : Number, timeToChange : Number = 1) : void {
			_getInstance().tweenVolume(newVolume, timeToChange);
		}
		
		/**
		 * Volume général.
		 * 
		 * @param newVolume
		 * Nouveau volume de 0 à 1.
		 * 
		 * @return
		 */
		public static function get volume() : Number {
			return _getInstance().volume;
		}
		
		public static function set volume(newVolume : Number) : void {
			_getInstance().volume = newVolume;
		}
		
		/**
		 * Volume maximal disponible.<br />
		 * Permet par exemple d'empécher que le son soit trop fort, parceque le volume 
		 * de tous les sons est trop élevé.
		 * 
		 */
		public static function get maxVolume() : Number {
			return _getInstance().maxVolume;
		}
		
		public static function set maxVolume(newVolume : Number) : void {
			_getInstance().maxVolume = newVolume;
		}
		
		
		/**
		 * Ajoute un écouteur d'évènements.
		 * 
		 * @param type
		 * Le type d'évènement à écouter.
		 * 
		 * @param listener
		 * La méthode appelée lorsque l'évènement est dispatché.
		 * 
		 * @param useCapture.
		 *  
		 * @param priority
		 * Priorité d'écoute.
		 * 
		 * @param useWeakReference
		 * Référence faible.
		 * 
		 */
		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false):void {
			_getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Retire l'écouteur d'évènements.
		 * 
		 * @param type
		 * Le type d'évènement qui est écouté.
		 * 
		 * @param listener
		 * La méthode appelée lorsque l'évènement est dispatché.
		 * 
		 */
		public static function removeEventListener(type : String, listener : Function):void {
			_getInstance().removeEventListener(type, listener);
		}

		//----------------------------------------------
		//				 CTR
		//----------------------------------------------
		
		/**
		 * @private
		 */
		private static function _getInstance() : SoundManager {
			if (_instance == null) {
				_instance = new SoundManager(new SoundManagerEnforcer());
			}
					
			return _instance;
		}

		/**
		 * @private
		 */
		public function SoundManager(enforcer : SoundManagerEnforcer) {
		}

		//--------------------------------------
		//			VOLUME PRINCIPAL
		//--------------------------------------
		
		/**
		 * @private
		 */
		public function toggleSound(timeToToggle : Number) : void {
			
			tweenVolume(!_isToogleOn ? _maxVolume : 0, timeToToggle);
			
			var e : SoundEvent;
			if (!_isToogleOn) {
				e = new SoundEvent(SoundEvent.UNMUTE);
				_isMutedDispatched = false;
				_isToogleOn = true;
			}
			else {
				e = new SoundEvent(SoundEvent.MUTE);
				_isMutedDispatched = true;
				_isToogleOn = false;
			}
			dispatchEvent(e);
		}

		/**
		 * @private
		 */
		public function tweenVolume(newVolume : Number, timeToChange : Number = 1) : void {
			if (newVolume > _maxVolume)
				newVolume = _maxVolume;
			
			TweenLite.to(this, timeToChange, {volume : newVolume, overwrite : true});
		}

		/**
		 * @private
		 */
		public function set volume(newVolume : Number) : void {
			
			if (newVolume > _maxVolume)
				newVolume = _maxVolume;
			
			if (newVolume == 0 && _volume > 0 && !_isMutedDispatched){
				dispatchEvent(new SoundEvent(SoundEvent.MUTE));
				_isMutedDispatched = true;
			}
			
			
			if (newVolume > 0 && _volume == 0 && _isMutedDispatched){
				dispatchEvent(new SoundEvent(SoundEvent.UNMUTE));
				_isMutedDispatched = false;
			}
			
			
			_volume = newVolume;
			
			var t : SoundTransform = SoundMixer.soundTransform;
			t.volume = _volume;
			SoundMixer.soundTransform = t;
			
			var e : SoundEvent = new SoundEvent(SoundEvent.VOLUME_CHANGE);
			e.volume = _volume;
			dispatchEvent(e);	
		}
		
		/**
		 * @private
		 */
		public function get volume() : Number {
			return _volume;
		}
		
		/**
		 * @private
		 */
		public function get maxVolume() : Number {
			return _maxVolume;
		}
		
		/**
		 * @private
		 */
		public function set maxVolume(maxVolume : Number) : void {
			_maxVolume = maxVolume;
			
			if (_volume > _maxVolume)
				volume = _maxVolume;
		}


		public static function get isMuted() : Boolean {
			return !_getInstance()._isToogleOn;
		}



		
	}
}

class SoundManagerEnforcer {
	public function SoundManagerEnforcer() {
		//do nana	
	}
}