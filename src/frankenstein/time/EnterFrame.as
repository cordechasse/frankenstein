/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.time {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import frankenstein.tools.UDictionary;


	/**
	 * Évènement diffusé à chaque EnterFrame
	 * 
	 * @eventType flash.events.Event.ENTER_FRAME
	 */
	[Event(name="enterFrame", type="flash.events.Event")]

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 16 oct 2008<br />
	 * 		<b>Version </b> 1.0.2<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	EnterFrame global.<br />
	 * 	Classe statique.
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		EnterFrame.addEventListener(Event.ENTER_FRAME, _ef);
	 * 		
	 * 		function _ef(e : Event):void{
	 * 			trace("enterframe");
	 * 		}
	 *  </pre>
	 * </listing>
	 * 
	 */
	public class EnterFrame extends EventDispatcher {
		
		private var _shape : Shape;
		
		//static
		private static var _instance : EnterFrame;
		private static var _allowInstantiation : Boolean = false;
		
		private static var _listeners : Dictionary = new Dictionary();
		
			

		
		//singleton
		private static function getInstance() : EnterFrame {
			if (_instance == null){
				_allowInstantiation = true;
				_instance = new EnterFrame();
				_allowInstantiation = false;
			}
					
			return _instance;
		}
		
		/**
		 * @private
		 */	
		public function EnterFrame(){
			if (!_allowInstantiation){
				throw new Error("Error : trying to instanciate singleton EnterFrame");
			}
		}
				
		private function _ef(e : Event) : void {
			dispatchEvent(new Event(Event.ENTER_FRAME));
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
		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
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
		public static function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			getInstance().removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Affiche la liste des listeners
		 */
		public static function traceStoredData() : void {
			getInstance().traceStoredData();
		}	
		
		/**
		 * @private
		 */
		public function traceStoredData():void{
			trace(this, "traceStoredData", UDictionary.getLength(_listeners));
		}
		
		/**
		 * @private
		 */
		public override function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			super.removeEventListener(type, listener, useCapture);
			
			delete _listeners[listener];
			
			if (UDictionary.getLength(_listeners) == 0 && _shape){
				_shape.removeEventListener(Event.ENTER_FRAME, _ef);
				_shape = null;
			}
		}
		
		/**
		 * @private
		 */
		public override function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			_listeners[listener] = arguments.callee;
			
			if (!_shape){
				_shape = new Shape();
				_shape.addEventListener(Event.ENTER_FRAME, _ef);
			}
		}
		
	}
}
