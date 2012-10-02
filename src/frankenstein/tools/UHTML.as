/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> samystudio<br />
	 * 		<b>Date </b> 1 jan 2008<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour le code HTML.
	 * </p>
	 * 
	 * 
	 */
	public class UHTML {

		/**
		 * Nettoie le code HTML pour que flash puisse l'afficher proprement. <br />
		 * Les balises suivantes sont remplacées : 
		 * <ul>
		 * 	<li>&lt;strong&gt; -> &lt;b&gt;</li>
		 * 	<li>&lt;em&gt; -> &lt;b&gt;</li>
		 * 	<li>&lt;p&gt; -> &lt;p&gt;&lt;br&gt;</li>
		 * 	<li>&lt;br/&gt; -> &lt;br&gt;</li>
		 * 	<li>&lt;br /&gt; -> &lt;br&gt;</li>
		 * </ul>	
		 *  
		 * @param html
		 * Le code HTML à "nettoyer".
		 * 
		 * @return
		 * Un nouveau String correspondant au code html "nettoyé".
		 *
		 */
		public static function clean( html : String ) : String {
			
			var newHtml : String = html.replace(/\<strong\>/gi,"<b>");
			newHtml = newHtml.replace(/\<\/strong\>/gi,"</b>");
			newHtml = newHtml.replace(/\<em\>/gi,"<b>");
			newHtml = newHtml.replace(/\<\/em\>/gi,"</b>");
			newHtml = newHtml.replace(/\<\/p\>/gi,"</p><br>");
			newHtml = newHtml.replace(/\<br \/\>/gi,"<br>");
			newHtml = newHtml.replace(/\<br\/\>/gi,"<br>");
			
			return newHtml;
			
		}

		
	}
}
