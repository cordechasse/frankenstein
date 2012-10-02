/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.sound.type {
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import frankenstein.events.SoundEvent;

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
	 * 	Son blanc d'une durée définie. <br />
	 * 	Cet objet est utile lorsqu'on veut jouer une phrase composée de plusieurs mots (qui sont des mp3 séparés). 
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		//joue le son1.mp3, un silence de 500ms puis le son2.mp3
	 * 		var seq : Sequence = new Sequence();
	 * 		seq.addSound(new AdvancedSound(new URLRequest("moi.mp3")));
	 * 		seq.addSound(new Silence(500));
	 * 		seq.addSound(new AdvancedSound(new URLRequest("jaime.mp3")));
	 * 		seq.addSound(new Silence(400));
	 * 		seq.addSound(new AdvancedSound(new URLRequest("lecordechasse.mp3")));
	 * 		
	 * 		SoundPlayer.play(snd);	
	 * 	</pre>
	 * </listing>
	 * 
	 * 
	 * @see frankenstein.sound.players.SoundPlayer
	 * 
	 * @author n.bush
	 * @project TweenMaxFunction
	 * @date 4 nov. 2009
	 * 
	 */
	public class Silence extends EventDispatcher implements ISound {

		private var _timer : Timer;
		private var _delay : uint;
		private var _timeStart : uint;

		private var _idxSound : uint;

		
		/**
		 * Crée un nouveau silence.
		 * 
		 * @param time
		 * Durée du silence (en millisecondes).
		 * 
		 * @return
		 */
		public function Silence(time : uint) : void {
			
			_delay = time;
			
			_timer = new Timer(time, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimesout, false, 0, true);
		}

		
		//--------------------------------------
		//					PLAY / STOP
		//--------------------------------------
		/**
		 * @inheritDoc
		 */
		public function playSound(idxSound : uint) : void {
			
			_idxSound = idxSound;
			
			_timer.reset();
			_timer.start();
			
			_timeStart = getTimer();
		}

		
		/**
		 * @inheritDoc
		 */
		public function stop(idxSound : uint) : void {
			_timer.stop();
		}

		
		private function _onTimesout(event : TimerEvent) : void {
			
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimesout);
			
			var e : SoundEvent = new SoundEvent(SoundEvent.SOUND_COMPLETE);
			e.soundIdx = _idxSound;
			dispatchEvent(e);
		}

		
		/**
		 * @private
		 */
		public function get isLoaded() : Boolean {
			return true;
		}

		
		/**
		 * @private
		 */
		public function internalLoad() : void {
			//do nada
		}

		
		/**
		 * @inheritDoc
		 */
		public function pause(idxSound : uint) : void {
			_timer.stop();
			_delay = _delay - (getTimer() - _timeStart);
			_timer.delay = _delay;
		}

		
		/**
		 * @private
		 */
		public function getVolume(idxSound : uint) : Number {
			return 0;
		}

		
		/**
		 * @private
		 */
		public function setVolume(idxSound : uint, v : Number) : void {
			//do nada	
		}

		
		/**
		 * @private
		 */
		public function get soundOptions() : SoundOptions {
			return null;
		}
	}
}
