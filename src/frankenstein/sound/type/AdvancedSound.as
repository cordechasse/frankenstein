/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.sound.type {
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import frankenstein.events.SoundEvent;
	import frankenstein.tools.UDictionary;


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 4 nov 2009<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>1.0.0 by nicobush</li>
	 * 				<li>1.0.1 by nicobush : correction d'un bug sur le setVolume</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * 	Classe de Son avancée.<br /><br />
	 * 	Elle implémente ISound afin d'être controlée par le SoundPlayer.<br />
	 * 	Elle étend la classe Sound.<br />
	 * 	Elle peut prendre en paramètre dans le constructeur un SoundOptions, permettant de gérer
	 * 	le volume sonore, ajouter des boucles etc.
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		var sndTransform : SoundTransform = new SoundTransform();
	 * 		sndTransform.volume = 0.8;
	 * 		var sndOptions : SoundOptions = new SoundOptions(sndTransform);
	 * 	
	 * 		var snd : AdvancedSound = new AdvancedSound("son.mp3", null, sndOptions));
	 * 		SoundPlayer.play(snd);	
	 * 	</pre>
	 * </listing>
	 * 
	 * @see frankenstein.sound.players.SoundPlayer
	 * 
	 * 
	 * @author n.bush
	 * @project TweenMaxFunction
	 * @date 4 nov. 2009
	 * 
	 */
	public class AdvancedSound extends Sound implements ISound {

		private var _soundOptions : SoundOptions;

		private var _volume : Number = 1; 

		private var _stream : URLRequest;
		private var _context : SoundLoaderContext;

		private var _channels : Dictionary;

		private var _idxSoundOnLoaded : int = -1;

		
		
		/**
		 * Crée un nouvel objet AdvancedSound.
		 * 
		 * @param stream
		 * URLRequest du media.
		 * 
		 * @param context
		 * Contexte de chargement.
		 * 
		 * @param soundOptions
		 * Options de lecture du son.
		 *   
		 */
		public function AdvancedSound(stream : URLRequest = null, context : SoundLoaderContext = null, soundOptions : SoundOptions = null) {
			
			//super(stream, context);

			_stream = stream;
			_context = context;
			_channels = new Dictionary();
			
			_soundOptions = soundOptions == null ? new SoundOptions() : soundOptions;
		}

		
		
		
		//--------------------------------------
		//					PLAY
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function playSound(soundIdx : uint) : void {
			if (isLoaded) {
				var channel : SoundChannel;
				
				//si c'est un son en pause, on le resume
				if (_channels[soundIdx] == null) {
					//sinon on lance un nouveau channel
					channel = play(_soundOptions.startTime, _soundOptions.loops, _soundOptions.transform);
					channel.addEventListener(Event.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
					
					_channels[soundIdx] = channel;
					
					_idxSoundOnLoaded = -1;
				} else {
					var position : Number = (_channels[soundIdx] as SoundChannel).position;
					
					channel = play(position, _soundOptions.loops, _soundOptions.transform);
					channel.addEventListener(Event.SOUND_COMPLETE, _onSoundComplete, false, 0, true);
					
					_channels[soundIdx] = channel;
				}
			} else {
				_idxSoundOnLoaded = soundIdx;
				internalLoad();
				addEventListener(Event.COMPLETE, _onLoadComplete, false, 10);
			}
		}

		
		private function _onSoundComplete(event : Event) : void {
			var idx : uint = UDictionary.getKeyByValue(_channels, event.target) as uint;
			
			var e : SoundEvent = new SoundEvent(SoundEvent.SOUND_COMPLETE);
			e.soundIdx = idx;
			dispatchEvent(e);
			
			delete _channels[idx];
		}

		
		private function _onLoadComplete(event : Event) : void {
			removeEventListener(Event.COMPLETE, _onLoadComplete);
			if (_idxSoundOnLoaded != -1)
				playSound(_idxSoundOnLoaded);
		}

		
		//--------------------------------------
		//					STOP
		//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function stop(soundIdx : uint) : void {
			if (isLoaded) {
				if (_channels[soundIdx]) {
					_channels[soundIdx].stop();
					_channels[soundIdx].removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
				}
				delete _channels[soundIdx];
			}
		}

		
		/**
		 * @inheritDoc
		 */			
		public function pause(soundIdx : uint) : void {
			if (isLoaded) {
				if (_channels[soundIdx]) {
					_channels[soundIdx].stop();
					_channels[soundIdx].removeEventListener(Event.SOUND_COMPLETE, _onSoundComplete);
				}
			}
		}

		
		/**
		 * @inheritDoc
		 */
		public function internalLoad() : void {
			super.load(_stream, _context);
		}

		
		/**
		 * Spécifie si le média est chargé
		 * 
		 * @return
		 * Le média est chargé oui / non 
		 */
		public function get isLoaded() : Boolean {
			return (bytesLoaded >= bytesTotal && bytesTotal > 0);					
		}

		
		//--------------------------------------
		//					SOUND OPTIONS
		//--------------------------------------
		/**
		 * @inheritDoc
		 */
		public function get soundOptions() : SoundOptions {
			return _soundOptions;
		}

		
		public function set soundOptions(soundOptions : SoundOptions) : void {
			_soundOptions = soundOptions;
		}

		
		//----------------------------------------------
		//				VOLUME
		//----------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function getVolume(soundIdx : uint) : Number {
			if (_channels[soundIdx]) {
				var vol : Number = _channels[soundIdx].soundTransform.volume / _soundOptions.transform.volume;
				if (isNaN(vol))
					vol = 0;
				return vol;
			}
			
			return 0;
		}

		
		/**
		 * @inheritDoc
		 */
		public function setVolume(soundIdx : uint, volume : Number) : void {
			
//			trace(this, "setVolume", soundIdx, volume);
			
			if (isNaN(volume))
				volume = 0;
			
			_volume = volume;
			
			if (_channels[soundIdx]) {
				var t : SoundTransform = _channels[soundIdx].soundTransform;
				t.volume = _soundOptions.transform.volume * volume;
				_channels[soundIdx].soundTransform = t;
			}
		}
	}
}



