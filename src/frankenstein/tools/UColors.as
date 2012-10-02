/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 4 août 2008<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour la gestion des couleurs :
	 * 	<ul>
	 * 		<li>conversion Hexa -> String</li>
	 * 		<li>conversion String -> Hexa</li>
	 * 		<li>modification contraste d'une couleur</li>
	 * 		<li>transformation en niveau de gris</li>
	 * 		<li>...</li>
	 * 	</ul>
	 * </p>
	 * 
	 */
	public class UColors {

		/**
		 * Retourne un object {r, g, b} correspondant au code hexadecimal passé en paramètre.
		 * 
		 * @param hex
		 * Le code hexadecimal de la couleur.
		 * 
		 * @return
		 * Un objet {r, g, b}.
		 */
		public static function hex2RGB(hex : uint) : Object {
			var rgb24 : uint = hex;
			var r : uint = rgb24 >> 16;
			var g : uint = (rgb24 ^ (r << 16)) >> 8;
			var b : uint = (rgb24 ^ (r << 16)) ^ (g << 8);
			return {r:r, g:g, b:b};
		}

		
		/**
		 * Retourne un String correspondant au code hexadecimal de la couleur décimale.
		 * 
		 * @param r
		 * Composante rouge de la couleur.
		 * 
		 * @param g
		 * Composante verte de la couleur.
		 * 
		 * @param b
		 * Composante bleue de la couleur.
		 * 
		 * @param
		 * Prefix Le préfixe à ajouter.
		 * 
		 * @return
		 * Le code hexadécimal sous le format #123456.
		 */
		public static function RGB2hex(r : Number, g : Number, b : Number, prefix : String = "#") : String {
			var sr : String = r.toString(16);
			var sg : String = g.toString(16);
			var sb : String = b.toString(16);
			sr = (sr.length < 2) ? "0" + sr : sr;
			sg = (sg.length < 2) ? "0" + sg : sg;
			sb = (sb.length < 2) ? "0" + sb : sb;
			return prefix + (sr + sg + sb).toUpperCase();
		}

		
		/**
		 * Retourne un Number de la couleur décimale d'une couleur en RGB.
		 * 
		 * @param r
		 * Composante rouge de la couleur.
		 * 
		 * @param g
		 * Composante verte de la couleur.
		 * 
		 * @param b
		 * Composante bleue de la couleur.
		 * 
		 * @return
		 * Le code hexadécimal.
		 */
		public static function RGB2hexNumber(r : Number, g : Number, b : Number) : uint {
			return parseInt(RGB2hex(r, g, b, "0x"));
		}

		
		/**
		 * Retourne un object {a, r, g, b} correspondant au code hexadecimal passé paramètre.
		 * 
		 * @param hex
		 * Le code hexadecimal de la couleur ARGB.
		 * 
		 * @return
		 * Un objet {a, r, g, b}.
		 */ 
		public static function hex2ARGB(hex : uint) : Object {
			var rgb32 : uint = hex;
			var a : uint = rgb32 >> 24;
			if ( a < 0 ) { 
				a = 256 + a; 
			}
			var rgb24 : uint = rgb32 ^ ( a << 24 );
			var r : uint = rgb24 >> 16;
			var g : uint = (rgb24 ^ (r << 16)) >> 8;
			var b : uint = (rgb24 ^ (r << 16)) ^ (g << 8);
			return {a:a, r:r, g:g, b:b};
		}

		
		/**
		 * Retourne un string correspondant au code héxadecimal de la couleur décimale ARGB.
		 * 
		 * @param a
		 * Composante alpha de la couleur.
		 * 
		 * @param r
		 * Composante rouge de la couleur.
		 * 
		 * @param g
		 * Composante verte de la couleur.
		 * 
		 * @param b
		 * Composante bleue de la couleur.
		 * 
		 * @param prefix
		 * Le préfixe à ajouter.
		 * 
		 * @return
		 * Le code héxadecimal (String). 
		 * 
		 */
		public static function ARGB2hex(a : Number, r : Number, g : Number, b : Number, prefix : String = "#") : String {
			var sa : String = a.toString(16);
			var sr : String = r.toString(16);
			var sg : String = g.toString(16);
			var sb : String = b.toString(16);
			sa = (sa.length < 2) ? "0" + sa : sa;
			sr = (sr.length < 2) ? "0" + sr : sr;
			sg = (sg.length < 2) ? "0" + sg : sg;
			sb = (sb.length < 2) ? "0" + sb : sb;
			return prefix + (sa + sr + sg + sb).toUpperCase();
		}

		
		/**
		 * Retourne un Number de la couleur décimale d'une couleur en ARGB.
		 * 
		 * @param a
		 * Composante alpha de la couleur.
		 * 
		 * @param r
		 * Composante rouge de la couleur.
		 * 
		 * @param g
		 * Composante verte de la couleur.
		 * 
		 * @param b
		 * Composante bleue de la couleur.
		 * 
		 */
		public static function ARGB2hexNumber(a : Number, r : Number, g : Number, b : Number) : int {
			return parseInt(ARGB2hex(a, r, g, b, "0x"));
		}


		/**
		 * Convertit une couleur en niveau de gris.
		 * 
		 * @param hex
		 * La valeur hexadecimale de la couleur.
		 * 
		 * @return
		 * La nouvelle couleur en niveau de gris.
		 * 
		 */
		public static function toGrayscale(hex : uint) : uint {
			var color : Object = hex2ARGB(hex);
			var c : Number = 0;
			c += color.r * .3;
			c += color.g * .59;
			c += color.b * .11;
			color.r = color.g = color.b = c;
			return ARGB2hexNumber(color.a, color.r, color.g, color.b);
		}

		
		/**
		 * Change le contraste d'une couleur hexadécimale.
		 * 
		 * @param hex
		 * La couleur sur laquelle on applique le contraste.
		 * 
		 * @param inc
		 * La hauteur du réglage du contraste.
		 * 
		 * @return
		 * La nouvelle couleur.
		 *  
		 */
		public static function changeContrast(hex : Number, inc : Number) : Number {
			var o : Object = hex2RGB(hex);
			o.r = UMath.boundaryRestrict(o.r + inc, 0, 255);
			o.g = UMath.boundaryRestrict(o.g + inc, 0, 255);
			o.b = UMath.boundaryRestrict(o.b + inc, 0, 255);
			return Number(RGB2hex(o.r, o.g, o.b));
		}

		
		/**
		 * Retourne la valeur uint d'une couleur hexadécimale format String.
		 * 
		 * @param hex
		 * The hexadecimal string value (#123456).
		 * 
		 * @return
		 * La valeur hexadécimale en uint.
		 * 
		 */
		public static function hex2Number(hex : String) : uint {
			return Number("0x" + hex.substring(1));
		}
	}
}
