/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.display {
	import flash.events.MouseEvent;
	import frankenstein.tools.UFrame;


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 26 mai 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>Classe abstraite à overrider pour créer un clip selectionnable.<br />
	 * Cette classe gère : 
	 * <ul>
	 * 		<li>le gotoAndPlay sur le rollover/rollout</li>
	 * 		<li>les méthodes onStaged, onUnStaged, onLayout</li>
	 * 		<li>le buttonMode</li>
	 * 		<li>l'état selectionné / deselectionné</li>
	 * </ul>
	 * La timeline du clip doit être composée obligatoirement des frames "over" (ou "in"), "out" et "select".<br />
	 * La frame "unselect" est optionnelle.<br /><br />
	 * De plus la classe hérite de AMovieClip, donc elle hérite de toutes ses propriétés et méthodes.
	 * </p>
	 * 
	 * 	
	 * @author n.bush
	 * @since 01 jan 2009
	 * @version 1.0.1
	 * 
	 */
	public dynamic class ASelectableButton extends AButton {
		
		private var _isSelected : Boolean; 
		private var _disabledOnSelected : Boolean; 
		
		public function ASelectableButton() {
			super();
		}
		
		/**
		 * Met le clip en mode "selectionné" : mouseEnabled = false et gotoAndPlay("selected")
		 * 
		 * @return void
		 */
		public function select():void{
			if (!_isSelected){
				if (_disabledOnSelected){
					removeEventListener(MouseEvent.ROLL_OVER, _over);
					removeEventListener(MouseEvent.ROLL_OUT, _out);
					mouseEnabled = false;
				}
				_isSelected = true;
				gotoAndPlay("select");
				
			}
		}

		
		/**
		 * Met le clip en mode "deselectionné" : mouseEnabled = true et gotoAndPlay("unselect") ou gotoAndStop(1)
		 * 
		 * @return void
		 */
		public function unselect():void{
			if (_isSelected){
				if (UFrame.doesFramelabelExists(this, "unselect"))
					gotoAndPlay("unselect");
				else
					gotoAndStop(1);
					
				_isSelected = false;
				
				if (_disabledOnSelected){
					mouseEnabled = true;
					addEventListener(MouseEvent.ROLL_OVER, _over);
					addEventListener(MouseEvent.ROLL_OUT, _out);
				}
			}
		}

		/**
		 * 
		 * Définit si le clip est sélectionné ou non.
		 * 
		 */
		public function isSelected() : Boolean {
			return _isSelected;
		}
		
		public function set disabledOnSelected(b : Boolean):void{
			_disabledOnSelected = b;
		}
				
	}
}
