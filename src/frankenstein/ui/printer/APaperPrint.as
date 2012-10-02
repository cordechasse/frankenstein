/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.ui.printer {
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 16 jan 2009<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>v1.0.0 by nicoBush</li>
	 * 				<li>v1.0.1 by nicoBush: ajout d'un throw error si le safezone n'est pas défini</li>
	 * 			</ul> 
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * 	Classe abstraite que les PaperPrint doivent étendre.
	 * </p>
	 * 
	 * 
	 */
	public class APaperPrint extends MovieClip {
		
		/**
		 * Rectangle définissant la safeZone : zone dans laquelle le contenu peut être inséré.
		 */
		protected var _safeZone : Rectangle;

		/**
		 * Crée un nouveau PaperPrint
		 */
		public function APaperPrint() {
			
		}
		
		/**
		 * Définit la taille du la zone d'impression de l'imprimante.
		 * Les contenus doivent donc être repositionnés, redimmensionnés afin de rentrer dans
		 * cette zone.
		 * 
		 * La méthode est à overrider.
		 * 
		 * @param width
		 * La largeur de la zone d'impression.
		 * 
		 * @param height
		 * La hauteur de la zone d'impression.
		 */
		public function setSize(width : Number, height : Number):void{
			//to override
		}

		
		/**
		 * Définit le numéro de page de la page en cours.
		 * 
		 * La méthode est à overrider.
		 * 
		 * @param num
		 * Le numéro de la page actuelle.
		 * 
		 * @param totalPages
		 * Le nombre total de pages
		 * 
		 * 
		 */		
		public function setPageNumber(num : uint, totalPages : uint) : void {
			//to override
		}
		
		/**
		 * Rectangle définissant la safeZone : zone dans laquelle le contenu peut être inséré.
		 */
		public function get safeZone():Rectangle {
			
			if (!_safeZone)
				throw (new Error("APaperPrint Error: safeZone isn't defined. Check the class that extends APaperPrint."));
			
			return _safeZone;
		}
	}
}
