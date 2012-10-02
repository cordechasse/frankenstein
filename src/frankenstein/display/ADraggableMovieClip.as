/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.display {
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import frankenstein.events.MovieClipEvent;


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 14 oct. 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>Classe abstraite à overrider pour créer clip "draggable."<br />
	 * De plus elle hérite de AMovieClip, donc hérite de toutes ses propriétés et méthodes.
	 * </p>
	 * 
	 * 	
	 * @author n.bush
	 * @since 14 oct. 2009
	 * @version 1.0.0
	 * 
	 */
	 
	/**
	 * Evenement dispatché quand le clip est "draggué" 
	 *
	 * @eventType frankenstein.events.MovieClipEvent.DRAGGING
	 */
	[Event(name="dragging", type="frankenstein.events.MovieClipEvent")]

	public class ADraggableMovieClip extends AMovieClip {

		private var _startDraggingPoint : Point;
		private var _startDraggingPos : Point;

		public function ADraggableMovieClip() {
			super();
		}

		/**
		 * @inheritDoc
		 */
		protected override function onStaged() : void {
			super.onStaged();
			addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		}

		/**
		 * @inheritDoc
		 */
		protected override function onUnStaged() : void {
			super.onUnStaged();
			removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			_stopDrag();
		}

		
		private function _onMouseDown(event : MouseEvent) : void {
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			_startDrag();
		}

		
		private function _onMouseUp(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			_stopDrag();
		}

		
		//--------------------------------------
		//					START DRAG
		//--------------------------------------

		protected function _startDrag() : void {
			_startDraggingPoint = new Point(stage.mouseX, stage.mouseY);
			_startDraggingPos = new Point(x, y);
			addEventListener(Event.ENTER_FRAME, _ef);
			_ef();	
		}

		
		protected function _stopDrag() : void {
			removeEventListener(Event.ENTER_FRAME, _ef);	
		}

		
		private function _ef(event : Event = null) : void {
			x = _startDraggingPos.x + (stage.mouseX - _startDraggingPoint.x);	
			y = _startDraggingPos.y + (stage.mouseY - _startDraggingPoint.y);
			
			dispatchEvent(new MovieClipEvent(MovieClipEvent.DRAGGING));	
		}
	}
}
