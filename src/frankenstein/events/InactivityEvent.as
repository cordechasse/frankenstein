/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.events {
	import flash.events.Event;
	
	
	/**
	 * 
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 01 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>NicoBush v1.0.0</li>
	 * 				<li>NicoBush v1.0.1 : override de la méthode clone</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>Les évènements InactivityEvent sont dispatchés par l'objet Inactivity.</p>
	 * 
	 * 
	 * @see frankenstein.time.Inactivity
	 * 
	 * @author n.bush
	 * @since 01 jan 2009
	 * @version 1.0.0
	 */
	
	public class InactivityEvent extends Event {
		
		/**
		 * Activité en cours
		 */
		public static const ACTIVITY : String = "inactivity";
		
		/**
		 * Aucune activité
		 */
		public static const NO_ACTIVITY : String = "no_inactivity";
		
		/**
		 * 
		 * Crée un nouveau InactivityEvent
		 * 
		 * @param type
		 * Le type d'évènement.
		 * 
		 * @param bubbles
		 * Détermine si l'évènement remonte dans la hierarchie des clips (effet bubble).
		 * 
		 * @param cancelable
		 * Détermine si l'évènement peut être annulé.
		 * 
		 */
		public function InactivityEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event {
			return new InactivityEvent(type, bubbles, cancelable);
		}
	}
}
