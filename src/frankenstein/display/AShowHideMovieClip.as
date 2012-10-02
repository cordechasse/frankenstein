/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.display {
	import frankenstein.tools.UFrame;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 24 juil 2008<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>Classe abstraite à overrider pour créer un clip show / hide.<br />
	 * Cette classe gère : 
	 * <ul>
	 * 		<li>les méthodes show / hide</li>
	 * 		<li>les méthodes onStaged, onUnStaged, onLayout</li>
	 * </ul>
	 * La timeline du clip doit être composée obligatoirement des frames "show" et "hide".<br /><br />
	 * De plus la classe hérite de AMovieClip, donc elle hérite de toutes ses propriétés et méthodes.
	 * </p>
	 * 
	 * 	
	 * @author n.bush
	 * @since 24 juil 2008
	 * @version 1.0.0
	 * 
	 */
	public dynamic class AShowHideMovieClip extends AMovieClip {
		
		//--------------------------------------
		//					SHOW / HIDE
		//--------------------------------------
		/**
		 * Va à la frame show.
		 * 
		 * @return void
		 */
		public function show():void{
			gotoAndPlay("show");
		}
		
		/**
		 * Va à la frame hide.
		 * 
		 * @return void
		 */
		public function hide():void{
			gotoAndPlay("hide");
		}
		
		
		//--------------------------------------
		//					SHOWN / HIDDEN
		//--------------------------------------
		
		/**
		 * Si la frame shown existe, il va à la frame "shown"
		 * sinon, il se déplace à la frame d'avant le "hide".
		 * 
		 * @return void
		 */
		public function shown():void{
			if (UFrame.doesFramelabelExists(this, "shown")){
				gotoAndStop("shown");
			}
			else {
				gotoAndStop(UFrame.getFrameNumberForLabel(this, "hide") - 1);
			}
		}
		
		/**
		 * Retourne à la toute première frame.
		 */
		public function hidden():void{
			gotoAndStop(1);
		}
		
		
		
	}
}
