/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.sound.players {
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import frankenstein.events.SoundEvent;
	import frankenstein.sound.pluginTweenMax.FunctionPlugin;
	import frankenstein.sound.type.ISound;
	import frankenstein.time.Waiter;



	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 28 oct 2009<br />
	 * 		<b>Version </b> 1.6.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>1.6.0 by nicobush</li>
	 * 				<li>1.6.1 by nicobush : ajout des méthodes resume et stopTweenVolume</li>
	 * 				<li>1.6.2 by nicobush : ajout de la méthodes fadeOutAndStop</li>
	 * 				
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	La classe SoundPlayer permet de lire tout type de ISound.<br />
	 * 	Elle permet de gérer facilement les fade, pause, stop sur les sons.<br />
	 * 	Elle est utilisé par les objets MusicPlayer et Voice.<br />
	 * 	<br />
	 * 	La classe est entièrement statique.
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		var sndTransform : SoundTransform = new SoundTransform();
	 * 		sndTransform.volume = 0.8;
	 * 		var sndOptions : SoundOptions = new SoundOptions(sndTransform);
	 * 	
	 * 		var snd : AdvancedSound = new AdvancedSound(new URLRequest("son.mp3"), null, sndOptions));
	 * 		SoundPlayer.play(snd);
	 *  </pre>
	 * </listing>
	 * 	
	 * 
	 * @see frankenstein.sound.type.ISound
	 */
	public dynamic class SoundPlayer extends EventDispatcher {		

		
		private static var _instance : SoundPlayer;
		private var _soundsList : Dictionary;
		private var _soundsWaitingVolume : Dictionary;

		
		private var _idx : uint;

		
		//----------------------------------------------
		//					SINGLETON
		//----------------------------------------------
		
		/**
		 * @private
		 */
		private static function _getInstance() : SoundPlayer {
			if (_instance == null) {
				_instance = new SoundPlayer(new SoundPlayerEnforcer());
			}
					
			return _instance;
		}

		
		/**
		 * @private
		 */
		public function SoundPlayer(enforcer : SoundPlayerEnforcer) {
			_soundsList = new Dictionary();
			_soundsWaitingVolume = new Dictionary();
			enforcer = null;
			
			TweenPlugin.activate([FunctionPlugin]);
		}

		
		//----------------------------------------------
		//				SOUND
		//----------------------------------------------
		
		/**
		 * Joue un son sur un nouveau channel.
		 * 
		 * @param snd
		 * Le son à jouer.
		 * 
		 * @return
		 * L'index du son joué.
		 */
		public static function play(snd : ISound) : uint {
			return _getInstance().play(snd);
		}

		
		/**
		 * @private
		 */
		public function play(snd : ISound) : uint {
			_idx++;
			_soundsList[_idx] = snd;
			_soundsWaitingVolume[_idx] = -1;
			
			_playSnd(snd, _idx);
			
			//on met un waiter sinon dans l'imbrication de ISound, on se melange les index
//			Waiter.waitFrames(1, this, _playSnd, [snd, _idx]);
			/*
			snd.playSound(_idx);
			snd.addEventListener(SoundEvent.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
			 */
			/*
			trace(this, "play");
			_traceSoundsList();
			 */

			
			return _idx;
		}

		
		private function _playSnd(snd : ISound, idx : uint) : void {
			//trace(this, "_playSnd", idx);
			
			snd.playSound(idx);
			snd.addEventListener(SoundEvent.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
			
			if (_soundsWaitingVolume[_idx] != -1) {
				setVolume(_idx, _soundsWaitingVolume[_idx]);
			}
			
			delete _soundsWaitingVolume[_idx];
		}

		
		
		
		/**
		 * Arrête un son spécifique.
		 * 
		 * @param idxSound
		 * L'index du son à arrêter.
		 * 
		 * @return
		 */
		public static function stop(idxSound : uint) : void {
			_getInstance().stop(idxSound);
		}

		
		/**
		 * @private
		 */
		public function stop(idxSound : uint) : void {
			
			var snd : ISound = _soundsList[idxSound] as ISound;
			if (snd != null) {
				snd.stop(idxSound);
				_removeSound(idxSound);
			}
		}

		
		/**
		 * Met le son spécifié en pause.
		 * 
		 * @param idxSound
		 * L'index du son à mettre en pause.
		 * 
		 */
		public static function pause(idxSound : uint) : void {
			_getInstance().pause(idxSound);
		}


		
		/**
		 * @private
		 */		
		public function pause(idxSound : uint) : void {
			var snd : ISound = _soundsList[idxSound] as ISound;
			snd.pause(idxSound);
		}
		
		

		/**
		 * Relance un son en pause.
		 * 
		 * @param idxSound
		 * L'index du son à relancer.
		 * 
		 */
		public static function resume(idxSound : uint) : void {
			_getInstance().resume(idxSound);
		}

		

		/**
		 * @private
		 */		
		public function resume(idxSound : uint) : void {
			var snd : ISound = _soundsList[idxSound] as ISound;
			snd.playSound(idxSound);
		}
		

		/**
		 * Fadeout le son et le supprime à la fin.
		 * 
		 * @param idxSound
		 * Index du son.
		 * 
		 * @param endVolume
		 * Volume de destination.
		 * 
		 * @param timeToFade
		 * Durée (en secondes) du fade.
		 * 
		 * @return
		 */
		public static function fadeOutAndStop(idxSound : uint, endVolume : Number = 0, timeToFade : Number = 1, callback : Function = null) : void {
			_getInstance().fadeOutAndStop(idxSound, endVolume, timeToFade, callback);
		}

		
		/**
		 * @private
		 */
		public function fadeOutAndStop(idxSound : uint, endVolume : Number = 0, timeToFade : Number = 1, callback : Function = null) : void {
			addEventListener( SoundEvent.TWEEN_SOUND_COMPLETE , _fadeOutComplete , false , 0 , true );
			tweenVolume( idxSound, endVolume, timeToFade, callback );
		}
		
		
		/**
		 * @private
		 */
		 private function _fadeOutComplete( e : SoundEvent ) : void{
		 	stop( e.soundIdx );
		 	removeEventListener( SoundEvent.TWEEN_SOUND_COMPLETE , _fadeOutComplete );
		 }

		
		//----------------------------------------------
		//				 EVENT
		//----------------------------------------------

		private function _onSoundComplete(e : SoundEvent) : void {
			
			_removeSound(e.soundIdx);
			
			/*
			trace(this, "_onSoundComplete");
			_traceSoundsList();
			 */

			var e2 : SoundEvent = new SoundEvent(SoundEvent.SOUND_COMPLETE);
			e2.soundIdx = e.soundIdx;
			dispatchEvent(e2);
		}

		
		//----------------------------------------------
		//				SOUND VOLUME
		//----------------------------------------------
		
		/**
		 * Modifie le volume d'un son avec fade.
		 * 
		 * @param idxSound
		 * Index du son.
		 * 
		 * @param newVolume
		 * Nouveau volume de 0 à 1.
		 * 
		 * @param timeToChange
		 * Durée du fade (en secondes).
		 * 
		 * @param callback
		 * Méthode de callback.
		 *  
		 * @return
		 */
		public static function tweenVolume(idxSound : uint, newVolume : Number, timeToChange : Number = 1, callback : Function = null) : void {
			_getInstance().tweenVolume(idxSound, newVolume, timeToChange, callback);
		}

		
		/**
		 * @private
		 */		
		public function tweenVolume(idxSound : uint, newVolume : Number, timeToChange : Number = 1, callback : Function = null) : void {
			
			var snd : ISound = getSound(idxSound);
			
			if (snd != null) {
				TweenLite.to(snd, timeToChange, {functionPlugin:{setter: "setVolume", setterParams: [idxSound], getter : "getVolume", getterParams: [idxSound], destValue: newVolume}, onComplete: _onTweenComplete, onCompleteParams : [idxSound, callback], overwrite: false});	 
			} else {
				_onTweenComplete(idxSound, callback);
			}
		}

		
		private function _onTweenComplete(idxSound : uint, callback : Function = null) : void {
			var e : SoundEvent = new SoundEvent(SoundEvent.TWEEN_SOUND_COMPLETE);
			e.soundIdx = idxSound;
			dispatchEvent(e);
			
			if (callback != null)
				callback();
		}

		
		/**
		 * Modifie le volume d'un son (pas de fade).
		 * 
		 * @param idxSound
		 * Index du son.
		 * 
		 * @param newVolume
		 * Nouveau volume de 0 à 1.
		 * 
		 * @return
		 */
		public static function setVolume(idxSound : uint, newVolume : Number) : void {
			_getInstance().setVolume(idxSound, newVolume);
		}

		
		/**
		 * @private
		 */				
		public function setVolume(idxSound : uint, newVolume : Number) : void {
			
			//si on est dans l'attente d'une frame pour le son
			//on stocke la valeur
			if (_soundsWaitingVolume[_idx]) {
				_soundsWaitingVolume[_idx] = newVolume;
				return;
			}
			
			var snd : ISound = getSound(idxSound);
			
			if (snd != null) {
				snd.setVolume(idxSound, newVolume);
			}
			
			//trace(this, "setVolume", newVolume);
		}

		
		/**
		 * Retourne le volume d'un son spécifique.
		 * 
		 * @param idxSound
		 * Index du son.
		 * 
		 * @return
		 * Le volume du son
		 * 
		 */
		public static function getVolume(idxSound : uint) : Number {
			return _getInstance().getVolume(idxSound);
		}

		
		/**
		 * @private
		 */		
		public function getVolume(idxSound : uint) : Number {
			var snd : ISound = getSound(idxSound);
			if (snd != null)
				return snd.getVolume(idxSound);
			
			return 0; 	
		}

		
		/**
		 * Modifie le volume d'un son avec fade.
		 * 
		 * @param idxSound
		 * Index du son.
		 * 
		 * @param endVolume
		 * Nouveau volume.
		 * 
		 * @param timeToFade
		 * Durée (en secondes) du fade.
		 * 
		 * @return
		 */
		public static function fadeIn(idxSound : uint, endVolume : Number = 1, timeToFade : Number = 1, callback : Function = null) : void {
			_getInstance().fadeIn(idxSound, endVolume, timeToFade, callback);
		}

		
		/**
		 * @private
		 */	 
		public function fadeIn(idxSound : uint, endVolume : Number = 1, timeToFade : Number = 1, callback : Function = null) : void {
			tweenVolume(idxSound, endVolume, timeToFade, callback);
		}

		
		
		
		
		public static function fadeInAndPlay(snd : ISound, timeToFade : Number = 1, callback : Function = null) : uint {
			return _getInstance().fadeInAndPlay(snd, timeToFade, callback);
		}
		
		public function fadeInAndPlay(snd : ISound, timeToFade : Number = 1, callback : Function = null) : uint {
			var idx : uint = play(snd);
			setVolume(idx, 0);
			fadeIn(idx, 1, timeToFade, callback);
			return idx;
		}
		
		
		
		
		/**
		 * Modifie le volume d'un son avec fade.
		 * 
		 * @param idxSound
		 * Index du son.
		 * 
		 * @param endVolume
		 * Nouveau volume.
		 * 
		 * @param timeToFade
		 * Durée (en secondes) du fade.
		 * 
		 * @return
		 */
		public static function fadeOut(idxSound : uint, endVolume : Number = 0, timeToFade : Number = 1, callback : Function = null) : void {
			_getInstance().fadeOut(idxSound, endVolume, timeToFade, callback);
		}

		
		/**
		 * @private
		 */
		public function fadeOut(idxSound : uint, endVolume : Number = 0, timeToFade : Number = 1, callback : Function = null) : void {
			tweenVolume(idxSound, endVolume, timeToFade, callback);
		}

		
		/**
		 * Arrete les tween volume en cours sur un son.
		 * 
		 * @param idxSound
		 * Index du son.
		 * 
		 * @return
		 */
		public static function stopTweenVolume(idxSound : uint):void{
			_getInstance().stopTweenVolume(idxSound);
		}
		
		/**
		 * @private
		 */
		public function stopTweenVolume(idxSound : uint):void{
			 var snd : ISound = getSound(idxSound);
			 TweenLite.killTweensOf(snd);
		}
		
		
		
		
		//----------------------------------------------
		//				SOUNDCHANNELLIST
		//----------------------------------------------

		private function _removeSound(idx : uint) : void {
			if (_soundsList[idx]) {
				_soundsList[idx].removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
				delete _soundsList[idx];
			}
		}

		
		/**
		 * Retourne l'objet ISound selon l'index spécifié 
		 * 
		 * @param soundIdx Index du sound 
		 */
		public static function getSound(soundIdx : uint) : ISound {
			return _getInstance().getSound(soundIdx);
		}

		
		/**
		 * @private 
		 */
		public function getSound(soundIdx : uint) : ISound {
			return _soundsList[soundIdx];
		}


		/**
		 * Trace tous les sons en cours de lecture
		 */
		public static function traceSoundsList() : void {
			_getInstance().traceSoundsList();
		}

		
		public function traceSoundsList() : void {
			trace("---------------");
			for (var i : Object in _soundsList) {
				trace(i + " : " + _soundsList[i]);
			}
			trace("******************\n\n");
		}

		
		//--------------------------------------
		//				STATIC EVENT DISPATCHER					
		//--------------------------------------
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
		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
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
		public static function removeEventListener(type : String, listener : Function) : void {
			_getInstance().removeEventListener(type, listener);
		}	
	}
}

class SoundPlayerEnforcer {

	public function SoundPlayerEnforcer() {
		//do nada
	}
}
