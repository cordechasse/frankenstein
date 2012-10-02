/*
 * Copyright © CorDeChasse 1999-2011
 */
 
 package frankenstein.time {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * Évènement diffusé lorsque SharpTimer a atteint le nombre de répétitions spécifiés
	 * 
	 * @eventType flash.events.TimerEvent.TIMER_COMPLETE
	 */
	[Event(name="timerComplete", type="flash.events.TimerEvent")]
	
	/**
	 * Évènement diffusé lorsque le temps d'une fréquence est écoulé
	 * 
	 * @eventType flash.events.TimerEvent.TIMER
	 */
	[Event(name="timer", type="flash.events.TimerEvent")]

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 9 mars 2010<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe Timer beaucoup plus précise que celle fournie par Adobe.<br />
	 * 	Elle étend la classe Timer donc dispose d'exactement les mêmes méthodes / propriétés et s'utilise exactement pareil.<br />
	 * 	Attention toutefois, tout comme la classe Timer, en dessous d'une fréquence de 3ms, la classe SharpTimer est totalement imprécise.
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		var startTime : uint = getTimer();
	 * 	
	 * 		var sharpTimer = new SharpTimer(500, 10);
	 * 		sharpTimer.addEventListener(TimerEvent.TIMER, _onTimer);
	 * 		sharpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
	 * 		sharpTimer.start();
	 * 		
	 * 		private function _onTimer(event : TimerEvent) : void {
	 * 			trace("_onTimer", (getTimer() - startTime));
	 * 		}
	 * 		
	 * 		private function _onTimerComplete(event : TimerEvent) : void {
	 * 			trace("_onTimerComplete", (getTimer() - startTime));
	 * 		}
	 * 	</pre>
	 * </listing>
	 * 
	 */
	public class SharpTimer extends Timer {
		
		private var _initialDelay : Number;
		private var _startTime : uint;
		
		private var _isAutoStart : Boolean;
		
		/**
		 * Crée un nouveau SharpTimer.
		 * 
		 * @param delay
		 * Le delai en millisecondes.
		 * 
		 * @param repeatCount
		 * Le nombre de répetitions (si 0 alors le SharpTimer ne s'arrête jamais).
		 *  
		 */
		public function SharpTimer(delay : Number, repeatCount : int = 0) {
			_initialDelay = delay;
			super(delay, repeatCount);
		}
		
		/**
		 * Lance le timer
		 */
		public override function start():void{
			if (!_isAutoStart){
				addEventListener(TimerEvent.TIMER, _onTop, false, int.MAX_VALUE);
				_startTime = getTimer();
			}
			super.start();
		}
		
		
		private function _onTop(event : TimerEvent) : void {
			var newDelay : int = (_startTime + _initialDelay * (currentCount + 1)) - getTimer();
			if (newDelay <= 0)
				newDelay = 1;
			
			_isAutoStart = true;
			stop();
			super.delay = newDelay;
			start();
			_isAutoStart = false;
		}
		
		
		/**
		 * Delay du timer (en millisecondes).
		 */
		public override function get delay() : Number{
			return _initialDelay;
		}

		
		public override function set delay(value : Number) : void {
			_initialDelay = value;
			super.delay = value;
		}
		
		/**
		 * Réinitialise le SharpTimer.
		 */
		public override function reset() : void {
			super.reset();
			super.delay = _initialDelay;
		}
		
		/**
		 * Arrête le SharpTimer.
		 */
		public override function stop() : void {
			super.stop();
			super.delay = _initialDelay;
		}
		
		
	}
}
