/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.core {

	import flash.utils.Dictionary;
	
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
	 * <p>La classe Constants permet de stocker des variables et d'y accéder à tout moment depuis n'importe où</p>
	 * 
	 * @example
	 * 
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		var myPoint : Point = new Point(100, 200);
	 * 		Constants.addValue("point", myPoint);
	 * 		
	 * 		trace(Constants.getValue("point")); // (x=100, y=200)
	 * 	</pre>
	 * </listing>
	 * 
	 * 	
	 * 	
	 * @author n.bush
	 * @since 5 oct. 2009
	 * @version 1.0.0
	 */
	 
	public class Constants {
		
		private static var _data : Dictionary = new Dictionary();
		
		
		/**
		 * Ajoute une constante.
		 * 
		 * @param name
		 * Le nom auquel sera assigné l'objet stocké.
		 * 
		 * @param value
		 * La valeur à stocker.
		 *   
		 */
		public static function addValue(name : String, value : *):void{
			_data[name] = value;
		}
		
		/**
		 * Retourne une constante stockée
		 * 
		 * @param name
		 * Le nom de la constante à recupérer.
		 * 
		 * @return
		 * La constante stokée.
		 * 
		 */
		public static function getValue(name : String):*{
			return _data[name];
		}
		
		
		
	}
}
