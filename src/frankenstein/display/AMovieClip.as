/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.display {
	import flash.display.MovieClip;
	import flash.events.Event;
	import frankenstein.events.MovieClipEvent;
	import frankenstein.time.EnterFrame;
	import frankenstein.tools.UFrame;




	/**
	 * Evenement dispatché lorsque la frame demandée est atteinte, suite à un playToFrame 
	 *
	 * @eventType frankenstein.events.MovieClipEvent.FRAME_REACHED
	 */
	[Event(name="frame_reached", type="frankenstein.events.MovieClipEvent")]

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 14 oct 2009<br />
	 * 		<b>Version </b> 1.1.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>v1.0.0 by nicobush</li>
	 * 				<li>v1.1.0 by nicobush : ajout de la propriété listenToLayout</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>Classe abstraite à overrider pour créer tout type de MovieClip<br />
	 * Cette classe apporte : <ul>
	 * 		<li>méthodes spécifiques appelées lors de l'ajout / retrait de la scène (onStaged, onUnStaged)</li>
	 * 		<li>méthode appelée lors du resize de la scène (onLayout) : seulement appelé si la variable listenToLayout est à true</li>
	 * 		<li>gestion de lecture jusqu'à une frame spécifique (playToFrame)</li>
	 * 		<li>gestion de lecture en arrière</li>
	 * 	</ul>
	 * </p>
	 * 
	 * 	
	 * @author n.bush
	 * @since 14 oct. 2009
	 * @version 1.0.0
	 * 
	 */
	public class AMovieClip extends MovieClip {

		private var _destFrame : uint;
		private var _isPlayingBF : Boolean;
		private var _listenToLayout : Boolean;

		/**
		 * Constructeur : attention la classe est abstraite, elle doit donc être étendue mais jamais instanciée seule.
		 * 
		 */
		public function AMovieClip() {
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}

		
		private function _onRemovedFromStage(event : Event) : void {
			removeEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			stage.removeEventListener(Event.RESIZE, _onStageResize);
			
			stop();
			
			onUnStaged();
		}

		
		private function _onAddedToStage(event : Event) : void {
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, _onRemovedFromStage);
			
			onStaged();
			
			if (_listenToLayout){
				stage.addEventListener(Event.RESIZE, _onStageResize);
				onLayout();
			}
		}

		
		private function _onStageResize(event : Event) : void {
			onLayout();
		}

		
		//--------------------------------------
		//					PLAY FORWARD / BACKWARD / TOFRAME
		//--------------------------------------
		
		/**
		 * Joue en arrière le MovieClip jusqu'à ce qu'il atteigne la frame demandée
		 * 
		 * @param destFrame
		 * Le nom de la frame (String) or son numéro (uint)
		 * 
		 * @return void
		 * 
		 */	
		public function playBackward(destFrame : *) : void {
			
			if (_isPlayingBF) {
				_stopPlayingBF();
			}
			
			_destFrame = _getDestinationFrame(destFrame);
			
			if (!_isPlayingBF && currentFrame > _destFrame) {			
				_startPlayingBF();
			}
		}

		
		/**
		 * Joue en avant le MovieClip jusqu'à ce qu'il atteigne la frame demandée
		 * 
		 * @param destFrame
		 * Le nom de la frame (String) or son numéro (uint)
		 * 
		 * @return void
		 * 
		 */	
		public function playForward(destFrame : *) : void {
			if (_isPlayingBF) {
				_stopPlayingBF();
			}
			
			_destFrame = _getDestinationFrame(destFrame);
			
			if (!_isPlayingBF && currentFrame < _destFrame) {			
				_startPlayingBF();
			}
		}

		
		/**
		 * Va à la frame demandée que ce soit en arrière ou en avant (attention ne boucle pas).
		 * 
		 * @param destFrame
		 * Le nom de la frame (String) or son numéro (uint)
		 * 
		 * @return void
		 * 
		 */
		public function playToFrame(destFrame : *) : void {
			var __destFrame : uint = _getDestinationFrame(destFrame); 
			
			if (__destFrame < currentFrame)
				playBackward(__destFrame);
			else if (__destFrame > currentFrame && __destFrame <= totalFrames) {
				playForward(__destFrame);
			} else {
				_dispFrameReached();
			}
		}

		
		/*
		 * returns a valid destination frame
		 */
		private function _getDestinationFrame(destFrame : *) : uint {
			var _resultFrame : int; 
			if (destFrame is String) {
				_resultFrame = UFrame.getFrameNumberForLabel(this, destFrame);
			}
			else if (destFrame is uint) {
				_resultFrame = destFrame;
			} else {
				throw (new ArgumentError("AMovieClip: playBackward accept only 2 types of parameter : String or uint"));
			}
			
			
			if (_resultFrame < 0 || _resultFrame > totalFrames) {
				throw (new ArgumentError("AMovieClip: destination label is unknown"));	
			}
			
			
			return _resultFrame;
		}

		
		
		//--------------------------------------
		//					ENTERFRAME
		//--------------------------------------

		private function _startPlayingBF( ) : void {
			EnterFrame.addEventListener(Event.ENTER_FRAME, _ef, false, 0, true);
			_isPlayingBF = true;
		}

		
		private function _stopPlayingBF( ) : void {
			EnterFrame.removeEventListener(Event.ENTER_FRAME, _ef);
			_isPlayingBF = false;
		}

		
		private function _ef(event : Event) : void {
			var inc : int = (_destFrame - currentFrame) / Math.abs(_destFrame - currentFrame); 
			switch (inc) {
				case 0:
					_stopPlayingBF();
					_dispFrameReached();
					break;
				case 1:
					nextFrame();
					break;
				case -1:
					prevFrame();
					break;
			}
		}

		
		//--------------------------------------
		//					LAYOUT
		//--------------------------------------
		
		/**
		 * Méthode à overrider<br />
		 * Cette méthode est appelée quand le clip est ajouté à la scène.
		 * 
		 * @return void
		 * 
		 */
		protected function onStaged() : void {
		}		

		
		/**
		 * Méthode à overrider<br />
		 * Cette méthode est appelée quand le clip est retiré de la scène.
		 * 
		 * @return void
		 * 
		 */

		protected function onUnStaged() : void {
		}		

		
		/**
		 * Méthode à overrider<br />
		 * 
		 * Cette méthode est appelée quand le stage est redimmensionné.
		 * @return void
		 * 
		 */
		protected function onLayout() : void {
		}
		
		
		/**
		 * Défini si la méthode onLayout est appelée lors d'un resize stage (par default false)
		 * 
		 * @default false
		 * 
		 */
		public function get listenToLayout() : Boolean {
			return _listenToLayout;
		}
		
		
		public function set listenToLayout(b : Boolean):void{
			_listenToLayout = b;
			
			if (stage){
				if (b){
					stage.addEventListener(Event.RESIZE, _onStageResize);
					onLayout();
				}
				else
					stage.removeEventListener(Event.RESIZE, _onStageResize);
			}
		}
		
		//--------------------------------------
		//					DISP
		//--------------------------------------

		private function _dispFrameReached() : void {
			dispatchEvent(new MovieClipEvent(MovieClipEvent.FRAME_REACHED));
		}

		
		//--------------------------------------
		//					OVERRIDES
		//--------------------------------------
		/**
		 * @private
		 */
		override public function gotoAndPlay( frame : Object, scene : String = null ) : void {
			_stopPlayingBF();
			super.gotoAndPlay(frame, scene);
		}

		
		/**
		 * @private
		 */
		override public function gotoAndStop( frame : Object, scene : String = null ) : void {
			_stopPlayingBF();
			super.gotoAndStop(frame, scene);
		}

		
		/**
		 * @private
		 */
		override public function play( ) : void {
			_stopPlayingBF();
			super.play();
		}

		
		/**
		 * @private
		 */
		override public function stop( ) : void {
			_stopPlayingBF();
			super.stop();
		}
	}
}
