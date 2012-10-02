/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.core {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;		

	/**
	* Evenement dispatché quand la valeur du smoother change 
	*
	* @eventType flash.events.Event.CHANGE
	*/
	[Event(name="change", type="flash.events.Event")]
	
	/**
	* Evenement dispatché quand le smoother a atteint la valeur max 
	*
	* @eventType flash.events.Event.COMPLETE
	*/
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 26 mai 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>Object permettant de lisser un chargement.<br />
	 * Le loading passe par toutes les valeurs, malgré les sauts (0->1->2->3 à la place de 0->3).<br />
	 * Le rythme de passage d'une valeur à l'autre change en temps réel selon les valeurs passées. 
	 * </p>
	 * 
	 * @example
	 * On crée un loader qui charge une image.
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		
	 * 		//on cree le smoother
	 * 		var smoother : Smoother = new Smoother(0, 100);
	 * 		smoother.addEventListener(Event.CHANGE, _onSmootherChange);
	 * 		smoother.addEventListener(Event.COMPLETE, _onSmootherComplete);
	 * 		
	 * 		function _onSmootherComplete(e : Event):void{
	 * 			//loading complete
	 * 		}
	 * 		
	 * 		function _onSmootherChange(e : Event):void{
	 *	 		trace(smmother.value); //valeur qui évolue sans saut
	 * 		}
	 * 		
	 * 		
	 * 		//on cree le loader
	 * 		var loader : Loader = new Loader();
	 * 		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadComplete);
	 * 		loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
	 * 		loader.load(new URLRequest("monImage.jpg"));
	 * 		
	 * 		
	 * 		function _onLoadComplete(e : Event):void{
	 * 			smoother.update(100);
	 * 		}
	 * 		
	 * 		
	 * 		function _onLoadProgress(e : ProgressEvent):void{
	 *	 		smoother.update(e.bytesLoaded / e.bytesTotal * 100);
	 * 		}
	 * 	</pre>
	 * </listing>
	 * 	
	 * 
	 * @see flash.net.URLLoader
	 * @see flash.display.Loader
	 * 
	 * 	
	 * @author n.bush
	 * @since 26 mai 2009
	 * @version 1.0.0
	 */ 
	
	public class Smoother extends EventDispatcher {

		private var _currentValue : Number;
		private var _destValue : Number;
		private var _timer : Timer; 

		private var _lastTimeInfo : uint;
		private var _lastPrct : uint;
		
		
		private var _minValue : Number;
		private var _maxValue : Number;
		
		private var _minDelay : uint;
		private var _speedDelay : uint;

		
		private var _inc : Number;
		private var _speedInc : Number;
		private var _value : Number;
		
		private var _developpementMode : Boolean = false;
		
		/**
		 * Constructeur du Smoother.
		 * 
		 * @param min
		 * Valeur minimale.
		 * 
		 * @param max
		 * Valeur maximale.
		 * 
		 * @param minDelay
		 * Delai (en millisecondes) minimum entre le passage d'une valeur à l'autre 
		 * (pour eviter que ça aille trop vite)
		 * 
		 * @param speedDelay
		 * Delai (en millisecondes) utilisé lorsque le smoother a obtenu la valeur max 
		 * (pour que ça aille plus vite)
		 * 
		 * @param increment
		 * Increment utilisé pour la passage d'une valeur à une autre.
		 *  
		 * @param speedIncrement
		 * Increment utilisé lorsque le smoother a obtenu la valeur max 
		 * (pour que ça aille plus vite)
		 * 
		 */
		public function Smoother(min : Number = 0, max : Number = 100, minDelay : uint = 50, speedDelay : uint = 10, increment : Number = 1, speedIncrement : Number = 1):void{
			
			_minValue = min;
			_maxValue = max;
			_minDelay = minDelay;
			_inc = increment;
			_speedDelay = speedDelay;
			_speedInc = speedIncrement;
			
			
			_clear();
			
			reset();
			
		}
		
		private function _clear() : void {
			_currentValue = _minValue;
			_value = _minValue;
			
			if (_timer){
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _updtValue);
			}
			
		}
		
		/**
		 * Détruit tous les objets et écouteurs crées afin de libérer la mémoire
		 * 
		 * @return void
		 */
		public function flush():void{
			if (_timer){
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, _updtValue);
				_timer = null;
			}
		}
		
		
		/**
		 * Réinitialise le smoother
		 * 
		 * @return void
		 */
		public function reset():void{
			flush();
			_lastPrct = _minValue;
			_currentValue = _minValue;
			_value = _minValue;
			_timer = new Timer(_developpementMode ? _speedDelay : 500);
			_timer.addEventListener(TimerEvent.TIMER, _updtValue, false, 0, true);
		}
		

		/**
		 * Signifie au smoother qu'il doit atteindre la valeur spécifiée
		 * 
		 * @param v
		 * La nouvelle valeur à atteindre
		 * 
		 * @return void
		 */
		public function update(v : uint):void{
			
			if (v == _destValue)
				return;
			
			if (isNaN(v))
				v = _minValue;
			
			_destValue = v;
			
			if (_currentValue == _minValue && _destValue > _minValue){
				
				//si on recoit la valeur max des le depart => on utilise le speed delay
				if (_destValue == _maxValue)
					_timer.delay = _speedDelay;
					
				_timer.start();
				_lastPrct = _destValue;
				
			} else {
				_calculateDelay();
			}
			
			_lastTimeInfo = getTimer();
		}
		
		

		private function _calculateDelay() : void {
			if (_developpementMode) {
				_timer.delay = _speedDelay;
				return;	
			}
			
			
			var _timeElapsed : uint = getTimer() - _lastTimeInfo;
			var _prctDone : uint = _destValue - _currentValue;
			
			var newDelay : uint = Math.round(_timeElapsed / _prctDone);
			
			if (_destValue == _maxValue)
				newDelay = _speedDelay;
			else
				newDelay = newDelay < _minDelay ? _minDelay : newDelay;
			
			_timer.delay = newDelay;
		}

		
		private function _setValue(v : Number) : void {
			
			_value = v;
			
			
			var e : Event;
			
			if (v >= _maxValue) {
				v = _maxValue;
				e = new Event(Event.COMPLETE);
				_clear();
			}
			else {
				e = new Event(Event.CHANGE);
			}
			
			dispatchEvent(e);
		}

		
		private function _updtValue(event : TimerEvent) : void {
			if (_currentValue < _destValue){
				_currentValue += (_destValue == _maxValue ? _speedInc : _inc);
				_setValue(_currentValue);
			}
		}
		
		
		
		
		//--------------------------------------
		//					GETTER
		//--------------------------------------
		/**
		 * Retourne la valeur du smoother
		 *  
		 */
		public function get value() : Number {
			return _value;
		}
		
		/**
		 * @private
		 */
		public function get developpementMode() : Boolean {
			return _developpementMode;
		}
		
		/**
		 * Set le smoother en "mode développement"<br />
		 * Il utilisera alors les valeurs speedDelay et speedIncrement définis dans le constructeur
		 * afin d'aller plus vite, et de ne ralentir les tests
		 * 
		 * @default false
		 */
		public function set developpementMode(developpementMode : Boolean) : void {
			_developpementMode = developpementMode;
			if (_timer)
				_timer.delay = _speedDelay;
		}
	}
}
