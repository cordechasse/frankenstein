/*
 * Copyright © CorDeChasse 1999-2011
 */
 

package frankenstein.time {
	import flash.utils.Dictionary;	
	import flash.events.Event;	
	
	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 9 mars 2010<br />
	 * 		<b>Version </b> 1.0.2<br />
	 * 		<b>History<b>
	 * 			<ul>
	 * 				<li>1.0.0 by nicobush</li>
	 * 				<li>1.0.2 by nicobush : retrait du removeEventListener du EnterFrame 
	 * 				(mauvais decompte des listeners)</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe permettant d'attendre un certain nombre de frame avant d'appeler une méthode.<br />
	 * 	Cette classe est entièrement statique.
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		Waiter.waitFrames(25, this, _onWaited, "pif");
	 * 		
	 * 		function _onWaited(message : String):void{
	 * 			trace(message) // affiche "pif" au bout de 25 frames
	 * 		}
	 * 	</pre>
	 * </listing>
	 * 
	 */
	public class Waiter {
		
		private static var _list : Dictionary = new Dictionary(true);
		private static var _id : uint = 0;
		
		/**
		 * Attend un certain nombre de frames avant d'appeler le callback.
		 * 
		 * @param numFrames
		 * Le nombre de frames à attendre.
		 * 
		 * @param scope
		 * L'objet sur lequel sera appelé la méthode.
		 * 
		 * @param callback
		 * La méthode qui sera appelée à la fin du waiter.
		 * 
		 * @param params
		 * Liste des paramètres à passer à la fonction.
		 * 
		 * @return Index de la liste d'attente (est utile pour arrêter un Waiter) 
		 */
		public static function waitFrames(numFrames : uint, scope : Object, callback : Function, params : Array = null):uint{
			
			_id++;
			var o : Object = {frames : numFrames, callback : callback, callee : scope, params : params};
			_list[_id] = o;
			
			EnterFrame.addEventListener(Event.ENTER_FRAME, _ef);
			
			return _id;
		}
		
		/**
		 * Arrête un Waiter spécifique.
		 * 
		 * @param id
		 * L'index du waiter.
		 * 
		 */
		public static function stopWaiting(id : uint):void{
			delete _list[id];	
		}
		
		/**
		 * @private
		 */
		protected static function _ef(e : Event):void{
			var totalWaiters : uint;
			for (var i : Object in _list) {
				_list[i].frames--;
				totalWaiters++;
				
				if (_list[i].frames <= 0){
					_list[i].callback.apply(_list[i].callee, _list[i].params);
					delete _list[i];
					totalWaiters--;
				}
			}
			
			/*
			if (totalWaiters <= 0){
				EnterFrame.removeEventListener(Event.ENTER_FRAME, _ef);
			}
			 * 
			 */
					
		}
		
		/**
		 * Arrête tous les Waiters spécifiques à un objet particulier.
		 * 
		 * @param obj
		 * L'objet sur lequel on veut arrêter tous les Waiter.
		 * 
		 */
		public static function stopAllWaiterOfObject(obj : Object):void{
			for (var i : Object in _list) {
				//trace("Waiter", "stopAllWaiterOfObject", (_list[i].callee == obj));
				if (_list[i].callee == obj)
					delete _list[i];	
			}
		}
	}
}
