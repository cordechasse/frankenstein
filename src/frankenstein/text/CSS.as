/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.text
{
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import frankenstein.tools.UFonts;
	import frankenstein.tools.UTextField;

	


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 26 mai 2009<br />
	 * 		<b>Version </b> 1.1.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>Nicobush v1.0.0</li>
	 * 				<li>Antoine Lassauzay v1.1.0 : prise en charge des feuilles de style</li>
	 * 				<li>Nicobush v1.1.1 : ajout du check de la typo embarquée<br />
	 * 									  correction du bug des multilines
	 * 															
	 * 				</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>La classe CSS permet d'appliquer un style à un champ texte.<br />
	 * On peut la plugger avec la classe AdvancedStyleSheet qui permet d'utiliser facilement des 
	 * feuilles de style CSS localisées.
	 * </p>
	 * 
	 * @example
	 * Settage de la propriété globalStyleSheet :
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		// On crée un objet AdvancedStyleSheet, en lui fournissant la feuille chargée
 	 *		var sheet : AdvancedStyleSheet = new AdvancedStyleSheet();
 	 *		sheet.parseCSS(cssText);
	 *		// On peut ajouter une feuille css globale
 	 *		CSS.globalStyleSheet = sheet;
	 * 	</pre>
 	 * </listing>
 	 * 
 	 * @example
	 * Application d'un style :
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		var txt : TextField = new TextField();
	 * 		
	 * 		// Utilisation avec l'objet TextStyles
	 * 		var style : TextStyles = new TextStyles("Arial");
	 * 		CSS.apply(txt, style);
	 * 		
	 * 		// Utilisation avec les feuilles de style
	 * 		// en supposant que ".style1" soit le nom d'une règle CSS chargée dans CSS.globalStyleSheet
	 * 		CSS.apply(txt, ".style1");
	 * 		
	 * 		// Utilisation d'un simple TextFormat
	 * 		txt.embedFonts = true;
	 * 		
	 * 		var format : TextFormat = new TextFormat();
	 * 		format.font = "Arial";
	 * 		CSS.apply(txt, format);
	 * 		 
	 * 	</pre>
	 * </listing>
	 * 
 	 * 
 	 * @see frankenstein.text.AdvancedStyleSheet
	 * @see frankenstein.text.TextStyles
 	 *  
	 */ 
	 
	public class CSS {
		
		/**
		 * Feuille de style globale et utilisée par défaut par la classe CSS.
		 * 
		 * @example
		 * Settage de la propriété globalStyleSheet :
		 * <listing version="3.0" >
		 * 	<pre class="prettyprint">
		 * 		// On crée un objet AdvancedStyleSheet, en lui fournissant la feuille chargée
	 	 *		var sheet : AdvancedStyleSheet = new AdvancedStyleSheet();
	 	 *		sheet.parseCSS(cssText);
		 *		// On peut ajouter une feuille css globale
	 	 *		CSS.globalStyleSheet = sheet;
		 * 	</pre>
	 	 * </listing>
		 */
		public static var globalStyleSheet : AdvancedStyleSheet = new AdvancedStyleSheet();
		
		
		/**
		 * Applique un style à un champ texte.
		 * 
		 * @param tf
		 * Le champ texte sur lequel on applique le style.
		 * 
		 * @param style
		 * Le style à appliquer :
		 * 	<ul>
		 * 		<li>un objet TextStyles (frankenstein.text.TextStyles)</li>
		 * 		<li>un objet TextFormat (flash.text.TextFormat)</li>
		 * 		<li>une chaîne représentant le nom d'une règle CSS (String)</li>
		 * 	</ul>
		 * 	
		 * @example
		 * <listing version="3.0" >
		 * 	<pre class="prettyprint">
		 * 		var txt : TextField = new TextField();
		 * 		
		 * 		// Utilisation avec l'objet TextStyles
		 * 		var style : TextStyles = new TextStyles("Arial");
		 * 		CSS.apply(txt, style);
		 * 		
		 * 		// Utilisation avec les feuilles de style
		 * 		// en supposant que ".style1" soit le nom d'une règle CSS chargée dans CSS.globalStyleSheet
		 * 		CSS.apply(txt, ".style1");
		 * 	</pre>
		 * </listing>
		 * 
		 *     
		 */
		public static function apply( tf : TextField , style : *) : void {
			
			
			
			var ts : TextStyles = __getStyle(style, tf);
				
			//on checke si la typo est embarquée qu'elle est bien présente
			if (ts.embedFonts && !UFonts.isFontEmbed(ts.font)){
				throw(new Error("The font \"" + ts.font + "\" is not embed. Textfield may not display correctly."));
			}
			
			
			
			tf.defaultTextFormat = ts;
			tf.setTextFormat(ts);
			tf.embedFonts = ts.embedFonts;
			tf.multiline = ts.multiline;
			tf.wordWrap = ts.wordWrap;
			tf.selectable = ts.selectable;
			tf.antiAliasType = ts.antiAliasType;
			tf.gridFitType = ts.gridFitType;
			tf.thickness = ts.thickness;
			tf.sharpness = ts.sharpness;
			
//			trace("CSS", "apply", tf.antiAliasType, tf.thickness, tf.sharpness);
		}

		

		/**
		 * Applique un style à un champ texte.<br />
		 * Si le texte depasse de la taille du champ, la taille du texte est réduite.
		 * 
		 * @param txt
		 * Le champ texte sur lequel on applique le style.
		 * 
		 * @param style
		 * Le style à appliquer :
		 * <ul>
		 * 		<li>un objet TextStyles (frankenstein.text.TextStyles)</li>
		 * 		<li>un objet TextFormat (flash.text.TextFormat)</li>
		 * 		<li>une chaîne représentant le nom d'une règle CSS (String)</li>
		 * 	</ul>
		 * 
		 * @param textValue
		 * Le texte à mettre dans le champ
		 * 
		 * @param minSize
		 * La taille minimale que le texte pourra avoir.
		 * 
		 * @param verticalAlign
		 * Activation ou non de l'alignement vertical.
		 * 
		 * @param omissionCharacter
		 * Les caractères qui remplacent les mots supprimés (si malgré la reduction de taille 
		 * de typo, le texte ne rentre pas).
		 *   
		 */
		public static function applyAndFit(txt : TextField, style: Object, textValue : String, minSize : Number = 10, verticalAlign : Boolean = true, omissionCharacter : String = "...") : void {

			var initSize : Rectangle = new Rectangle(txt.x, txt.y, txt.width, txt.height);
			var ts : TextStyles = __getStyle(style, txt);
			
			//on checke si la typo est embarquée qu'elle est bien présente
			if (ts.embedFonts && !UFonts.isFontEmbed(ts.font)){
				throw(new Error("The font \"" + ts.font + "\" is not embed. Textfield may not display correctly."));
			}
			
			//on force le embedFonts avant, pour avoir un numLines juste
			txt.embedFonts = true;
			txt.htmlText = textValue;		
			CSS.apply(txt, ts);
			
			
			
			//on reduit la taille
			while (UTextField.hasOverFlow(txt) && ts.size >= minSize) {
				CSS.apply(txt, ts);
				ts.size = Number(ts.size) - 1;
			}
			
			//on retire l'overflow si besoin
			UTextField.removeOverFlow(txt, omissionCharacter);
			
			//on recentre le tout
			if (verticalAlign){
				txt.y = initSize.y + (initSize.height - txt.textHeight) / 2 - 2;
			}
			
		}
		
		/**
		 *
		 */
		public static function getTextStyle( style : * , tf : TextField = null ) : TextStyles
		{
			return __getStyle( style , tf || new TextField() );
		}
		
		/**
		 * @private
		 * 
		 * Permet de récuperer un objet TextStyles à partir de n'importe quel argument
		 */
		private static function __getStyle(style : *, tf : TextField) : TextStyles {
			var ts : TextStyles;
			if(style is TextFormat) {
				ts = style is TextStyles ? style : TextStyles.textFormat2TextStyles(style);
			}
			else if(style is String) {
				if (!globalStyleSheet){
					throw(new Error("CSS Error : GlobalStyleSheet isn't set."));
				}
				else {
					if(globalStyleSheet.getTextStyle(style) != null) {
						ts = globalStyleSheet.getTextStyle(style);
					}
					else {
						ts = new TextStyles();
					}
				}
			}
			else {
				ts = TextStyles.textFormat2TextStyles(tf.defaultTextFormat);
			}
			
			//on reinsere les propriétés non declarées dans le TextStyles
			ts.inheritUnsetProperties(tf);
			
			return ts;
		}
		
		
	}
}
