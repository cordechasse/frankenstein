/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.ui.printer {
	import flash.display.IBitmapDrawable;	
	
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
	 * 	Interface que les pages à imprimer doivent implémenter pour être utilisées par la classe 
	 * 	Printer.
	 * </p>
	 * 
	 * @see frankenstein.ui.printer.Printer
	 */
	 public interface IPrintPage extends IBitmapDrawable {
		
		/**
		 * Insère le contenu dans une page selon une hauteur et largeur définie.
		 * 
		 * @param pageWidth
		 * Largeur de la zone dans lequel sera inséré le contenu.
		 * 
		 * @param pageHeight
		 * Hauteur de la zone dans lequel sera inséré le contenu.
		 *  
		 * @param params
		 * Contenu qui sera inséré. Il peut être de tout type, c'est du cas par cas.
		 * 
		 * @return
		 * Un PrintPageResult spécifiant si tout le contenu est rentré dans la zone.
		 * Si ce n'est pas le cas, il prend en paramètre "params", le contenu restant 
		 * à insérer.
		 * 
		 */
		function insertContent(pageWidth : Number, pageHeight : Number, params : * = null) : PrintPageResult;
	}
}
