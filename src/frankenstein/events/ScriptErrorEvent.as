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
	 * 		<b>Date </b> 15 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>Les évènements ScriptErrorEvent sont dispatchés par l'objet ScriptLoader lors d'erreur de script de type:
	 * <ul>
	 * 	<li>XML mal formaté</li>
	 * 	<li>Une erreur est retournée par le script (ex: &lt;error type='02'&gt;Missing Parameter&lt;/error&gt;)</li>
	 * 	<li>Le script est introuvable</li>
	 * </ul>
	 * </p>
	 * 
	 * @see frankenstein.net.ScriptLoader
	 *  
	 * @author n.bush
	 * @since 15 jan 2009
	 * @version 1.0.0
	 */
	public class ScriptErrorEvent extends Event {

		/**
		 * Le XML est mal formaté
		 */
		public static const XML_NOT_WELL_FORMATED : String = "xml_format_error";

		/**
		 * Le script a retourné une erreur
		 */
		public static const ERROR_RETURNED : String = "error_returned";

		/**
		 * Le script est introuvable
		 */
		public static const SCRIPT_MISSING : String = "script_missing";

		/**
		 * Le message d'erreur retourné par le script
		 */
		public var errorMessage : String;

		/**
		 * Le code erreur retourné par le script
		 */
		public var errorCode : String;

		/**
		 * L'url du script
		 */
		public var scriptUrl : String;

		/**
		 * 
		 * Crée un nouveau ScriptErrorEvent
		 * 
		 * @param type
		 * Le type d'évènement.
		 * 
		 * @param bubbles.
		 * Détermine si l'évènement remonte dans la hierarchie des clips (effet bubble).
		 * 
		 * @param cancelable
		 * Détermine si l'évènement peut être annulé.
		 * 
		 */		
		public function ScriptErrorEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}

		
		/**
		 * @inheritDoc
		 */
		public override function clone() : Event {
			var clonedEvent : ScriptErrorEvent = new ScriptErrorEvent(type, bubbles, cancelable);
			clonedEvent.scriptUrl = scriptUrl;
			clonedEvent.errorMessage = errorMessage;
			clonedEvent.errorCode = errorCode;
			
			return clonedEvent;
		}
	}
}
