/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.sound.players {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import frankenstein.sound.type.AdvancedSound;


	/**
	* Evènement dispatché lorsque la musique est chargée
	* 
	* @eventType Event.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]

	/**
	* Evènement dispatché lorsque la musique est en cours de chargement
	* 
	* @eventType ProgressEvent.PROGRESS
	*/
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	

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
	 * 	Manager de musique du site.<br />
	 * 	Il permet de gérer le musique independamment des autres sons. <br />
	 * 	Ex : il est quelquefois utile de couper la musique pendant les vidéos du site<br />
	 * 	<br />
	 * 	Le MusicPlayer dispose de deux modes de lectures :
	 * 	<ul> 
	 * 		<li>normal : la musique se joue avec volume fixe</li>
	 * 		<li>wave : le volume change dans le temps sous forme de vague</li>
	 * 	</ul>
	 * 	<br />
	 * 	La classe est entièrement statique.
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		var musicMp3 : AdvancedSound = new AdvancedSound(new URLRequest("music.mp3"));
	 * 		MusicPlayer.addEventListener(Event.COMPLETE, _onMusicLoaded);
	 * 		MusicPlayer.loadAndWave(musicMp3);
	 * 		
	 * 		
	 * 		function _onMusicLoaded(e : Event):void{
	 * 			trace("music loaded");
	 * 		}  
	 *  </pre>
	 * </listing>
	 * 	
	 * 
	 * @see frankenstein.sound.type.AdvancedSound
	 */
	public class MusicPlayer extends EventDispatcher {
		//static
		private static var _instance : MusicPlayer;
		
		private var _isLoaded : Boolean = false;
		private var _isPlaying : Boolean = false;
		private var _isWaving : Boolean = false;
		
		private var _autoPlay : Boolean = false;
		
		private var _toggleTime : Number = 1;
		
		private var _doWave : Boolean;
		private var _minWaveVolume : Number;
		private var _waveDelay : Number;
		
		
		private var _maxVolume : Number;
		
		private var _sound : AdvancedSound;	
		
		private var _soundIdx : uint;
		private var _isPaused : Boolean;


		//----------------------------------------------
		//				 SINGLETON
		//----------------------------------------------
		
		/**
		 * @private
		 */
		private static function _getInstance() : MusicPlayer {
			if (_instance == null) {
				_instance = new MusicPlayer(new MusicPlayerEnforcer());
			}
					
			return _instance;
		}

		/**
		 * @private
		 */
		public function MusicPlayer(p : MusicPlayerEnforcer) {
		}

		//----------------------------------------------
		//				VOLUME MUSIQUE
		//----------------------------------------------
		
		/**
		 * Coupe / remet le son avec fade.
		 * 
		 * @param timeToToggle
		 * Temps pour le tween.
		 * 
		 * @return
		 */
		public static function toggle(timeToToggle : Number = NaN) : void {
			_getInstance().toggle(timeToToggle);
		}
		
		/**
		 * @private
		 */
		public function toggle(timeToToggle : Number = NaN) : void {
			
			var duration : Number = isNaN(timeToToggle) ? _toggleTime : timeToToggle;
			
			if (_isPlaying){
				_fadeOut(duration);
			}
			else {
				_fadeIn(duration);
			}
		}
		
		
		private function _fadeIn(duration : Number) : void {
			if (_isWaving){
				wave();
			}
			else {
				if (_isPlaying){
					tweenVolume(_maxVolume, duration);
				}
				else {
					play();
					volume = 0;
					tweenVolume(_maxVolume, duration);
				}
			}
		}
		
		/**
		 * Réalise un fadeIn sur la musique
		 * 
		 * @param duration
		 * Temps en secondes.
		 * 
		 */
		public static function fadeIn(duration : Number = 1):void{
			_getInstance()._fadeIn(duration);
		}
		
		
		private function _fadeOut(duration : Number = 1) : void {
			tweenVolume(0, duration, _pause);
		}		

		/**
		 * Réalise un fadeOut sur la musique
		 * 
		 * @param duration
		 * Temps en secondes.
		 * 
		 */
		public static function fadeOut(duration : Number = 1) : void {
			_getInstance()._fadeOut(duration);
		}
		
		
		/**
		 * Modifie le volume de la musique avec un fade.
		 * 
		 * @param newVolume
		 * Nouveau volume (entre 0 à 1).
		 * 
		 * @param timeToChange
		 * Temps pour le tween (en secondes).
		 * 
		 * @return
		 */
		public static function tweenVolume(newVolume : Number, duration : Number = 1) : void {
			_getInstance().tweenVolume(newVolume, duration, null);
		}
	
		/**
		 * @private
		 */	
		public function tweenVolume(newVolume : Number, duration : Number = 1, callback : Function = null) : void {
			//TweenLite.to(this, duration, {volume : newVolume, overwrite : true, onUpdate: _changeVolume, onComplete : callback});
			SoundPlayer.tweenVolume(_soundIdx, newVolume, duration, callback);
		}
		
		
		/**
		 * Volume de la musique
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
		 * @private
		 */
		public function set volume(newVolume : Number) : void {
			_changeVolume(newVolume);
		}
		
		/**
		 * @private
		 */
		public function get volume() : Number {
			return SoundPlayer.getVolume(_soundIdx);
		}
		
		private function _changeVolume(volume : uint) : void {
			if (!_isLoaded) {
				return;
			}
			
			SoundPlayer.setVolume(_soundIdx, volume);
		}
		
		//--------------------------------------
		//				 LOAD
		//--------------------------------------
		
 		
		private function _setSound(snd : AdvancedSound):void{
			_sound = snd;
			_maxVolume = 1//_sound.soundOptions.transform.volume;
			_sound.soundOptions.loops = int.MAX_VALUE;
		}
		
		/**
		 * Charge un son
		 * 
		 * @param snd le son à charger
		 */
		public static function load(snd : AdvancedSound):void{
			_getInstance().load(snd);
		}
		
		
		/**
		 * @private
		 */
		public function load(snd : AdvancedSound):void{
			_setSound(snd);
			if (!_sound.isLoaded){
				_sound.addEventListener(Event.COMPLETE, _onSoundLoaded);
				_sound.addEventListener(ProgressEvent.PROGRESS, _onSoundLoading);
				_sound.internalLoad();
			}
			else {
				_onSoundLoaded();
			}
		}
		
		
		private function _onSoundLoaded(event : Event = null) : void {
			_sound.removeEventListener(Event.COMPLETE, _onSoundLoaded);
			_sound.removeEventListener(ProgressEvent.PROGRESS, _onSoundLoading);
			
			_isLoaded = true;
			
			if (_autoPlay){
				if (_doWave)
					wave();
				else {
					play();
					volume = 0;
					tweenVolume(1);
				}
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function _onSoundLoading(event : ProgressEvent) : void {
			dispatchEvent(event.clone());
		}

		/**
		 * Charge un son et le joue.
		 * 
		 * @param snd
		 * Le son à charger.
		 * 
		 */
		public static function loadAndPlay(snd : AdvancedSound):void {
			_getInstance().loadAndPlay(snd);
		}
		
		/**
		 * @private
		 */
		public function loadAndPlay(snd : AdvancedSound):void {
			_autoPlay = true;
			load(snd);			
		}
		
		
		
		/**
		 * Charge un son et le joue en wave.
		 * 
		 * @param snd
		 * Le son à charger.
		 * 
		 */
		public static function loadAndWave(snd : AdvancedSound):void {
			_getInstance().loadAndWave(snd);
		}
		
		/**
		 * @private
		 */
		public function loadAndWave(snd : AdvancedSound):void {
			_autoPlay = true;
			_doWave = true;
			load(snd);	
		}
		
		
		//----------------------------------------------
		//				CONTROL
		//----------------------------------------------
		
		/**
		 * Joue la musique.
		 * 
		 * @return
		 */
		public static function play() : void {
			_getInstance().play();
		}
		
		/**
		 * @private
		 */
		public function play(e : Event = null) : void {
			if (!_isLoaded || _isPlaying) {
				return;
			}
			
			_isPlaying = true;
			
//			trace(this, "play", _isPaused);
			
			if (_isPaused){
				 SoundPlayer.resume(_soundIdx);
				 _isPaused = false;
			}
			else
				_soundIdx = SoundPlayer.play(_sound);
		}
		
		
		
		/**
		 * Relance la musique d'ambiance au début.
		 * 
		 * @return
		 */
		public static function restart() : void {
			_getInstance().restart();
		}
		
		/**
		 * @private
		 */
		public function restart(e : Event = null) : void {
			_forceStopWave();
			stop();
			play();
		}
		
		/**
		 * Met le musique en pause
		 */
		public static function pause() : void {
			_getInstance().pause();
		}
		
		/**
		 * @private
		 */
		public function pause() : void {
			_forceStopWave();
			
			if(_isPlaying) {
				SoundPlayer.pause(_soundIdx);
			}
		}
		
		/**
		 * Arrête la musique.
		 */		
		public static function stop() : void {
			_getInstance().stop();		
		}

		/**
		 * private
		 */
		public function stop() : void {		
			_forceStopWave();
			_sound.soundOptions.startTime = 0;
			_cut();
		}
				
		private function _cut() : void {		
			if(_isPlaying) {
				//_musicChannel.stop();
				SoundPlayer.stop(_soundIdx);
				_isPlaying = false;
			}
			_isPaused = false;
		}
		
		
		
		private function _pause() : void {		
			if(_isPlaying) {
				//_musicChannel.stop();
				SoundPlayer.pause(_soundIdx);
				_isPlaying = false;
				_isPaused = true;
			}
		}
		
		
		

		/**
		 * Joue la musique en modulant le volume : minVolume -> maxVolume -> minVolume -> ...
		 * 
		 * @param minVolume
		 * Le volume minimal jusqu'où la vague doit descendre (entre 0 et 1).
		 * 
		 * @param waveDelay
		 * Le temps (en secondes) pour aller du volume min au max.
		 * 
		 */
		public static function wave(minVolume : Number = 0.2, waveDelay : Number = 5):void{
			_getInstance().wave(minVolume, waveDelay);
		}
		
		/**
		 * @private
		 */
		public function wave(minVolume : Number = 0.7, waveDelay : Number = 10):void {
			
			_isWaving = true;
			_minWaveVolume = minVolume;
			_waveDelay = waveDelay;
		
			if (_isPlaying){
				tweenVolume(minVolume, _waveDelay, _onWaveEndTween);			
			}
			else {
				play();
				volume = 0;
				tweenVolume(_maxVolume, _waveDelay, _onWaveEndTween);			
			}
		}
		
		
		private function _onWaveEndTween():void{
			//trace(this, "_onWaveEndTween", volume, _minWaveVolume);
			
			if (volume <= _minWaveVolume){
				tweenVolume(_maxVolume, _waveDelay, _onWaveEndTween);	
			}
			else {
				tweenVolume(_minWaveVolume, _waveDelay, _onWaveEndTween);	
			}
		}
		
		/**
		 * Arrête l'effet de vague
		 */
		public static function stopWave():void{
			_getInstance().stopWave();
			
		}
		
		/**
		 * @private
		 */
		public function stopWave():void{
			_isWaving = false;
			tweenVolume(_maxVolume);
		}
		
		private function _forceStopWave() : void {
			if (_isWaving){
				stopWave();
				volume = _maxVolume;
			}
		}
		
		
		
		//--------------------------------------
		//					GETTER / SETTER
		//--------------------------------------
		/**
		 * Temps en secondes de toggle.
		 */
		public static function get toggleTime() : Number {
			return _getInstance().toggleTime;
		}
		
		/**
		 * private
		 */
		public function get toggleTime() : Number {
			return _toggleTime;
		}
		
		
		/**
		 * private
		 */
		public function set toggleTime(toggleTime : Number) : void {
			_toggleTime = toggleTime;
		}	
		
		public static function set toggleTime(toggleTime : Number) : void {
			_getInstance().toggleTime = toggleTime;
		}
		
		/**
		 * Définit si la musique est en train de jouer (en wave ou normal).
		 */	
		public static function get isPlaying() : Boolean {
			return _getInstance().isPlaying;
		}

		/**
		 * @private
		 */
		public function get isPlaying() : Boolean {
			return _isPlaying;
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
		
		
	}
}

class MusicPlayerEnforcer {
	public function MusicPlayerEnforcer() {
		//do nada
	}
}

