/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.sound.type {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import frankenstein.events.ContentEvent;
	import frankenstein.events.SoundEvent;
	import frankenstein.sound.players.SoundPlayer;


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 4 nov 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * 	Séquence de sons qui seront joués les uns à la suite des autres sans blanc.
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		//joue le son1.mp3, un silence de 500ms puis le son2.mp3
	 * 		var seq : Sequence = new Sequence();
	 * 		seq.addSound(new AdvancedSound(new URLRequest("son1.mp3")));
	 * 		seq.addSound(new Silence(500));
	 * 		seq.addSound(new AdvancedSound(new URLRequest("son2.mp3")));
	 * 		SoundPlayer.play(snd);	
	 * 	</pre>
	 * </listing>
	 * 
	 * @author n.bush
	 * @project TweenMaxFunction
	 * @date 4 nov. 2009
	 * 
	 */
	public class Sequence extends EventDispatcher implements ISound {

		private var _soundsList : Array;
		private var _elementsToLoad : Array;

		private var _currentSoundLoading : int = -1;
		private var _currentSoundPlaying : int = -1;

		private var _isLoaded : Boolean = false;

		private var _idxSoundPlaying : int = -1;

		private var _volume : Number = 1;
		private var _soundIdx : uint; 

		
		/**
		 * Crée une nouvelle Séquence.
		 */
		public function Sequence() {
			_soundsList = [];
		}

		
		//----------------------------------------------
		//				ADD
		//----------------------------------------------
		
		/**
		 * Ajoute un son à la séquence.
		 * 
		 * @param sound
		 * Le son à ajouter (type ISound)
		 * 
		 */
		public function addSound(sound : ISound) : void {
			_soundsList.push(sound);
		}

		
		//--------------------------------------
		//					LOADING
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function internalLoad() : void {
			_elementsToLoad = [];
			
			//on defini les elements à charger
			for (var i : uint = 0;i < _soundsList.length; i++) {
				if (!_soundsList[i].isLoaded)
					_elementsToLoad.push(_soundsList[i]);
			}

			_loadNextSound();		
		}

		
		private function _loadNextSound() : void {
			_currentSoundLoading++;
			
			if (_currentSoundLoading >= _elementsToLoad.length) {
				_isLoaded = true;
				var e : ContentEvent = new ContentEvent(ContentEvent.READY);
				dispatchEvent(e);
			} else {
				_loadCurrentSound();
			}
		}

		
		private function _loadCurrentSound() : void {
			var sound : ISound = _elementsToLoad[_currentSoundLoading];
			sound.addEventListener(ProgressEvent.PROGRESS, _onSoundLoading, false, 0, true);
			sound.addEventListener(Event.COMPLETE, _onSoundLoaded, false, 0, true);
			sound.internalLoad();
		}

		
		private function _onSoundLoading(e : ContentEvent) : void {	
			var alreadyLoaded : Number = _currentSoundLoading / _elementsToLoad.length * 100;
			var currentLoaded : Number = 1 / _elementsToLoad.length * e.percentage;
			
			var e2 : ContentEvent = new ContentEvent(ContentEvent.INITIALIZING);
			e2.percentage = alreadyLoaded + currentLoaded;
			dispatchEvent(e2);
		}

		
		private function _onSoundLoaded(e : ContentEvent) : void {
			var sound : ISound = _elementsToLoad[_currentSoundLoading];
			sound.removeEventListener(ContentEvent.INITIALIZING, _onSoundLoading);
			sound.removeEventListener(ContentEvent.READY, _onSoundLoaded);
			
			_loadNextSound();
		}

		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded() : Boolean {
			//si au moins un des media est external, alors le groupe l'est
			for (var i : uint = 0;i < _soundsList.length; i++) {
				var sound : ISound = _soundsList[i] as ISound;
				
				if (!sound.isLoaded)
					return false;
			}
			
			return true;
		}

		
		//--------------------------------------
		//					PLAY / STOP 
		//--------------------------------------
		/**
		 * @inheritDoc
		 */
		public function playSound(soundIdx : uint) : void {
			
			//trace(this, "SEQUENCE IDX = ", soundIdx);

			_soundIdx = soundIdx;
			
			SoundPlayer.addEventListener(SoundEvent.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
			_playNextSound();
		}

		
		private function _onSoundComplete(event : SoundEvent) : void {
			if (event.soundIdx == _idxSoundPlaying) {
				_playNextSound();
			}
		}

		
		private function _playNextSound(e : SoundEvent = null) : void {
			_currentSoundPlaying++;
			
			if (_currentSoundPlaying < _soundsList.length) {
				_idxSoundPlaying = SoundPlayer.play(_soundsList[_currentSoundPlaying]);
				
				//trace(this, "CURRENT SOUND IDX = ", _idxSoundPlaying);
				
				//SoundPlayer.setVolume(_idxSoundPlaying, _volume);
			} else {
				SoundPlayer.removeEventListener(SoundEvent.SOUND_COMPLETE, _onSoundComplete);
				
				var e2 : SoundEvent = new SoundEvent(SoundEvent.SOUND_COMPLETE);
				e2.soundIdx = _soundIdx;
				dispatchEvent(e2);
				
				_idxSoundPlaying = -1;
			}	
		}

		
		/**
		 * @inheritDoc
		 */
		public function stop(idxSound : uint) : void {
			
			SoundPlayer.removeEventListener(SoundEvent.SOUND_COMPLETE, _onSoundComplete);
			
			//trace(this, "stop");

			if (_idxSoundPlaying != -1) {
				SoundPlayer.stop(_idxSoundPlaying);
				_idxSoundPlaying = -1;
			}
		}

		
		//--------------------------------------
		//					VOLUME					
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function getVolume(soundIdx : uint) : Number {
			return _volume;
		}

		
		/**
		 * @inheritDoc
		 */
		public function setVolume(soundIdx : uint, v : Number) : void {
			
			_volume = v;
			
			if (_idxSoundPlaying != -1) {
				SoundPlayer.setVolume(_idxSoundPlaying, v);	
			}
		}

		
		/**
		 * @inheritDoc
		 */
		public function get soundOptions() : SoundOptions {
			return null;
		}

		
		/**
		 * @inheritDoc
		 */
		public function pause(soundIdx : uint) : void {
		}
	}
}


