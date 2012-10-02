/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.events 
{
	import flash.events.Event;
	
	/**
	 * 
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 4 fev 2008<br />
	 * 		<b>Version </b> 1.0.1<br />
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
	 * <p>Les évènements SocketServerEvent sont dispatchés lors de changement de status des SocketServer.</p>
	 * 
	 * @see frankenstein.socketServer.fms.FMSConnector
	 *  
	 * @author n.bush
	 * @since 4 fev 2008
	 * @version 1.0.0
	 */
	public class SocketServerEvent extends Event {
		
		/**
		 * La connexion au socket server est en cours
		 */
		public static const CONNECTING : String = "connecting";
		
		/**
		 * La connexion au socket server est établie
		 */
		public static const CONNECTED : String = "connected";
		
		/**
		 * Une erreur s'est produite à la connexion
		 */
		public static const CONNECTION_ERROR : String = "connection_error";
		
		/**
		 * La connexion est considérée comme impossible
		 */
		public static const CONNECTION_IMPOSSIBLE : String = "connection_impossible";
		
		/**
		 * La connexion au socket server est finie
		 */
		public static const DISCONNECTED : String = "disconnected";
		
		/**
		 * Description de l'erreur
		 */
		public var error : String;
		
		/**
		 * Numéro d'essai de connexion
		 */
		public var attempt : uint;
		
		/**
		 * URI de connexion
		 */
		public var uri : String;
		
		/**
		 * 
		 * Crée un nouveau SocketServerEvent
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
		public function SocketServerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event {
			var e : SocketServerEvent = new SocketServerEvent(type, bubbles, cancelable);
			e.error = error;
			e.attempt = attempt;
			e.uri = uri;
			return e;
		}
	}
}
