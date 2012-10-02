/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.time {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import frankenstein.core.StageReference;
	import frankenstein.events.InactivityEvent;


	/**
	 * Évènement diffusé lorsqu'une activité utilisateur a été détectée après une période d'inactivité
	 * 
	 * @eventType frankenstein.events.InactivityEvent.ACTIVITY
	 */
	[Event(name="activity", type="frankenstein.events.InactivityEvent")]


	/**
	 * Évènement diffusé lorsque qu'aucune activité utilisateur est détectée
	 * 
	 * @eventType frankenstein.events.InactivityEvent.NO_ACTIVITY
	 */
	[Event(name="no_activity", type="frankenstein.events.InactivityEvent")]



	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 28 mai 2008<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe qui avertit lorsque plus aucune activité n'a lieu (ni souris, ni clavier).
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		StageReference.stage = stage;
	 * 	
	 * 		var inactivity = new Inactivity(30000);
	 * 		inactivity.addEventListener(InactivityEvent.NO_ACTIVITY, _onNoActivity);
	 * 		inactivity.addEventListener(InactivityEvent.ACTIVITY, _onActivity);
	 * 		inactivity.listen();
	 * 		
	 * 		function _onNoActivity(e : InactivityEvent):void{
	 * 			trace("aucune activité utilisateur depuis 30 secondes");
	 * 		}
	 * 		
	 * 		function _onActivity(e : InactivityEvent):void{
	 * 			trace("l'utilisateur est redevenu actif");
	 * 		}
	 * 	</pre>
	 * </listing>
	 * 
	 */
	public class Inactivity extends EventDispatcher {

		
		private var _isActive : Boolean;
		private var _timeOut : uint;
		private var _stage : Stage;
	
		private var _timer : Timer;

		/**
		 * Crée un nouvel objet Inactivity.
		 * 
		 * @param inactiveTimeOut
		 * Le temps (en millisecondes) de non activité à partir duquel on déclare l'utilisateur 
		 * comme non actif.
		 */
		public function Inactivity(inactiveTimeOut : uint) {
			_timeOut = 	inactiveTimeOut;
			_stage = StageReference.stage;

			_timer = new Timer(inactiveTimeOut, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimeOut, false, 0, true);	
			
			_isActive = true;		
		}
		
		/**
		 * Ecoute l'activité de l'utilisateur.
		 */
		public function listen():void{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, _onActivity, false, 0, true);	
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _onActivity, false, 0, true);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, _onActivity, false, 0, true);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, _onActivity, false, 0, true);
			
			_timer.start();
		}
		
		/**
		 * Arrête l'écoute d'activité de l'utilisateur.
		 */
		public function stopListening():void{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, _onActivity);	
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onActivity);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onActivity);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, _onActivity);
			_timer.stop();	
		}
		
		
		private function _onActivity(event : Event) : void {
			_timer.reset();
			_timer.start();
			
			if (!_isActive){
				_isActive = true;
				dispatchEvent(new InactivityEvent(InactivityEvent.ACTIVITY));
			}
		}

		private function _onTimeOut(event : TimerEvent) : void {
			//trace(this, "_onTimeOut");
			
			dispatchEvent(new InactivityEvent(InactivityEvent.NO_ACTIVITY));
			_isActive = false;
		}
		
		/**
		 * retourne si l'utilisateur est actif
		 */
		public function get isActive() : Boolean {
			return _isActive;
		}
	}
}
