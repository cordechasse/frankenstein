/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.ui.printer {

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 16 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * Classe de résultats de l'insertion de contenu dans une page pour l'impression.
	 * </p>
	 * 
	 */
	 public class PrintPageResult {
		
		private var _pageFits : Boolean = false;
		private var _params : *;
		
		/**
		 * Crée un nouveau PrintPageResult
		 * 
		 * @param pageFits
		 * Définit si tout le contenu rentre dans la page ou non.
		 * 
		 * @param params
		 * Liste des paramètres qui seront passés à la page suivante si le contenu ne rentre pas
		 * dans la page (généralement la valeur est à null si pageFits = true).
		 * 
		 * 
		 */
		public function PrintPageResult(pageFits : Boolean = false, params : * = null) {
			_pageFits = pageFits;
			_params = params;
		}
		
		/**
		 * Définit si le contenu rentre dans la page.
		 */
		public function get pageFits() : Boolean {
			return _pageFits;
		}
		
		public function set pageFits(b : Boolean) : void {
			_pageFits = b;
		}
		
		/**
		 * Liste des paramètres qui seront passés à la page suivante si le contenu ne rentre pas
		 * dans la page (généralement la valeur est à null si pageFits = true).
		 */
		public function get params() : * {
			return _params;
		}
		
		public function set params(p : *) : void {
			_params = p;
		}
	}
}
