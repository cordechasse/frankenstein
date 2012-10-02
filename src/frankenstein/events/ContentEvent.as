/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.events {
	import flash.events.Event;

	/**
	 * 
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> SamYStudiO<br />
	 * 		<b>Date </b> 01 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 		<b>Version </b> 1.0.1 nicoCrete<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>Les évènements ContentEvent sont dispatchés par des objets (généralement des pages de site) afin d'avertir son changement de status.</p>
	 * 
	 * 
	 * @author SamYStudiO
	 * @since 01 jan 2009
	 * @version 1.0.0
	 */
	public class ContentEvent extends Event {

		/**
		 *  L'objet est pret 
		 */
		public static const READY : String = "ready";

		/**
		 * L'objet retourne une erreur
		 */
		public static const ERROR : String = "error";
		
		/**
		 * L'objet se cache 
		 */
		public static const HIDE : String = "hide";

		/**
		 * L'objet est caché
		 */
		public static const HIDDEN : String = "hidden";

		/**
		 * L'objet s'affiche
		 */
		public static const SHOW : String = "show";

		/**
		 * L'objet est entièrement affiché
		 */
		public static const SHOWN : String = "shown";

		/**
		 * L'objet s'initialize
		 */
		public static const INITIALIZING : String = "initializing";
		
		/**
		 * L'objet commence a être chargé
		 */
		public static const START_DOWNLOAD 	: String = "start_load";
		
		/**
		 * L'objet finit d'être chargé
		 */	
		public static const STOP_DOWNLOAD 	: String = "stop_load";		
		
		/**
		 * Progression du chargement de l'objet
		 */
		public static const PROGRESS		: String = "progress";	

		/**
		 *  Le pourcentage du chargement 
		 */
		public var percentage : Number;

		/**
		 * Le message d'erreur
		 */
		public var errorMessage : String;

		/**
		 * 
		 * Crée un nouveau ContentEvent.
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
		public function ContentEvent( type : String, bubbles : Boolean = false, cancelable : Boolean = false ) {
			super(type, bubbles, cancelable);
		}
		
		
	}
}
