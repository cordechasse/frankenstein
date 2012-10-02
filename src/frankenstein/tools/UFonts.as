/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	import flash.text.Font;	

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 26 février 2008<br />
	 * 		<b>Version </b> 1.1.0<br />
	 * 		<b>History</b>
 	 * 			<ul>
 	 * 				<li>Version 1.0.0 by nicoBush</li>
 	 * 				<li>Version 1.1.0 by nicoBush : Ajout de la méthode isFontEmbed</li>
 	 * 			</ul> 
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour les typos
	 * </p>
	 * 
	 * 
	 */
	public class UFonts {

		/**
		 * Trace la liste de toutes les typos embarquées.
		 */
		public static function traceEmbedFontsList() : void {
			var embeddedFontsArray : Array = Font.enumerateFonts(false);

			for (var i : uint = 0;i < embeddedFontsArray.length; i++) {
				trace("UFonts", embeddedFontsArray[i].fontName, "type=" + embeddedFontsArray[i].fontStyle, "embedding=" + embeddedFontsArray[i].fontType);
			}
		}

		/**
		 * Retourne si une typo est embarquée ou non.
		 * 
		 * @param fontName
		 * Le nom exact de la typo
		 *  
		 * 
		 */		
		public static function isFontEmbed(fontName : String) : Boolean {
			
			var embeddedFontsArray : Array = Font.enumerateFonts(false);
			
			var i : uint;
			var l : uint = embeddedFontsArray.length;
			
			while (i < l){
				if (embeddedFontsArray[i].fontName == fontName)
					return true;
				i++;
			}
			
			
			return false;
		}
	}
}
