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
	 * 		<b>Date </b> 17 sept 2008<br />
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
	 * <p>Les évènements MovieClipEvent sont dispatchés par l'objet AMovieClip et ADraggableMovieClip.</p>
	 * 
	 * @see frankenstein.display.ADraggableMovieClip
	 * @see frankenstein.display.AMovieClip
	 * 
	 * @author n.bush
	 * @since 17 sept 2008
	 * @version 1.0.0
	 */
	public class MovieClipEvent extends Event {
		
		/**
		 * La frame demandée est atteinte
		 */
		public static const FRAME_REACHED : String = "frame_reached";
		
		/**
		 * L'objet est en train d'être "draggué"
		 */
		public static const DRAGGING : String = "dragging";
		
		/**
		 * 
		 * Crée un nouveau MovieClipEvent
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
		public function MovieClipEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event {
			return new MovieClipEvent(type, bubbles, cancelable);
		}
		
	}
}
