/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.sound.type {
	import flash.events.EventDispatcher;
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
	 * 	L'objet Voice joue toujours un seul son à la fois. Si un son est en cours de lecture et qu'un nouveau son est demandé, 
	 * 	un fadeOut de 25ms sera fait sur le son en cours avant de lancer le nouveau son. 
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		
	 * 		//joue le son1.mp3, un silence de 500ms puis le son2.mp3
	 * 		var seq : Sequence = new Sequence();
	 * 		seq.addSound(new AdvancedSound(new URLRequest("moi.mp3")));
	 * 		seq.addSound(new Silence(500));
	 * 		seq.addSound(new AdvancedSound(new URLRequest("jaime.mp3")));
	 * 		seq.addSound(new Silence(400));
	 * 		seq.addSound(new AdvancedSound(new URLRequest("lecordechasse.mp3")));
	 * 		
	 * 		var voice : Voice = new Voice();
	 * 		voice.say(snd);
	 * 			
	 * 	</pre>
	 * </listing>
	 * 
	 * 
	 * @author n.bush
	 * @project TweenMaxFunction
	 * @date 4 nov. 2009
	 * 
	 */
	public class Voice extends EventDispatcher {
		
		private var _idxSound : int = -1;
		private var _nextSound : ISound;

		/**
		 * Crée un nouvel objet Voice.
		 */
		public function Voice() {
			super();
		}
		
		/**
		 * Joue un ISound.<br /> 
		 * Si un ISound était déjà en train d'être joué, on fait d'abord un fadeOut de 25ms avant de lancer le nouvel ISound.
		 * 
		 * @param sound
		 * L'ISound à jouer.
		 * 
		 */
		public function say(sound : ISound):void{
			
			if (_idxSound != -1) {
				if (_nextSound == null)
					_fadeCurrentSound();
						
				_nextSound = sound;
			}
			else {
				_idxSound = SoundPlayer.play(sound);
				SoundPlayer.addEventListener(SoundEvent.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
				_nextSound = null;
			}
		}
		
		private function _fadeCurrentSound() : void {
			SoundPlayer.fadeOut(_idxSound, 0, 0.25, _onSoundFaded);
		}
		
		private function _onSoundFaded() : void {
			_onShutUp();
			if (_nextSound != null)
				say(_nextSound);
		}

		
		private function _onSoundComplete(event : SoundEvent) : void {
			//trace(this, "_onSoundComplete", event.soundIdx, _idxSound);
			if (event.soundIdx == _idxSound)
				_idxSound = -1;
		}

		/**
		 * Arrête la voix en fade (en 25 ms).
		 */
		public function shutUp():void{
			if (_idxSound != -1){
				SoundPlayer.fadeOut(_idxSound, 0, 0.25, _onShutUp);
			}
		}

		private function _onShutUp() : void {
			SoundPlayer.stop(_idxSound);
			_idxSound = -1;
		}
		
		
		/**
		 * Arrête la voix sans fade.
		 */
		public function killVoice():void{
			_onShutUp();
		}
		
		/**
		 * Coupe les sons et retire les eventListeners.
		 */
		public function close():void{
			SoundPlayer.removeEventListener(SoundEvent.SOUND_COMPLETE, _onSoundComplete);
			killVoice();				
		}
	}
}
