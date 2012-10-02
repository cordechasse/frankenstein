/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.text {
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.StyleSheet;
	import flash.utils.Dictionary;
	import frankenstein.tools.UObject;
	import frankenstein.tools.UString;


	/**
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> a.lassauzay<br />
	 * 		<b>Date </b> 8 juin 2010<br />
	 * 		<b>Version </b> 1.1.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>Antoine Lassauzay v1.0.0</li>
	 * 				<li>NicoBush v1.1.0 : la variable _map est passée en statique afin de pouvoir
	 * 				 disposer de plusieurs feuilles de styles différentes</li>
	 * 			</ul>
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * 
	 * <p>La classe AdvancedStyleSheet permet l'interpretation de feuille de styles personnalisées.<br>
	 * Chaque règle CSS est interprêtée pour créer automatiquement des objets TextStyles.
	 * Toutes les propriétés de la classe TextStyles peuvent être définies dans une règle CSS.<br>
	 * Liste des propriétés ajoutées par rapport à la classe StyleSheet native :
	 * <ul>
	 * 		<li><code>embedFonts</code></li>
	 * 		<li><code>multiline</code></li>
	 * 		<li><code>antiAliasType</code></li>
	 * 		<li><code>selectable</code></li>
	 * 		<li><code>wordWrap</code></li>
	 * 		<li><code>gridFitType</code></li>
	 * </ul>
	 * </p>
	 * 
	 * @example
	 * Feuille de style "style.css":
	 * <listing version="3.0" >
	 * <pre class="prettyprint">
	 * 		.style1 {
	 *					color:#FF0000;
	 *					embedFonts:true;
	 *					antiAliasType:advanced;
	 *					font-size:24;
	 *					font-family:"ArialDKNY_12pt_st";
	 *					gridFitType:none;
	 *					selectable:true;
	 *		}
	 * 	</pre>
	 * 	</listing>
	 * 	
	 * 	@example
	 * 	Code AS3:
	 * 	<listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		// Chargement de la feuille de style
	 * 		var urlLoader:URLLoader = new URLLoader();
	 * 		urlLoader.addEventListener(Event.COMPLETE, _onUrlLoaderComplete, false, 0, true);
	 * 		urlLoader.load(new URLRequest("styles.css"));
	 * 		
	 * 		function _onUrlLoaderComplete(e:Event) : void {
	 * 					// On crée un objet AdvancedStyleSheet, en lui fournissant la feuille chargée
	 *					var sheet : AdvancedStyleSheet = new AdvancedStyleSheet();
	 *					sheet.parseCSS(_urlLoader.data);
	 *					
	 *					// On peut ajouter une feuille css globale
	 *					CSS.globalStyleSheet = sheet;
	 *			
	 *					// On crée notre instance de textfield
	 *					var textField0 : TextField = new TextField();
	 *					textField0.autoSize = TextFieldAutoSize.LEFT;
	 *					textField0.text = 'Mon texte formaté';
	 *					addChild(textField0);
	 *			
	 *					// On applique un style avec la rgèle css ".style1"
	 *					// qui est recherchée dans CSS.globalStyleSheet
	 *					CSS.apply(textField0, ".style1");
	 * 		}
	 * 	</pre>
	 * </listing> 
	 * 
	 * @see flash.text.StyleSheet
	 * @see frankenstein.core.TextStyles
	 * @see frankenstein.core.CSS
	 * @see frankenstein.core.CSS.globalStyleSheet
	 * 
	 * @author a.lassauzay
	 */
	public class AdvancedStyleSheet extends StyleSheet {
		
		private static var _map : Dictionary = new Dictionary();
		
		/**
		 * Constructeur de la classe AdvancedStyleSheet.
		 */
		public function AdvancedStyleSheet() {}
		
		/**
		 * Supprime tous les styles en cours dans l'objet AdvancedStyleSheet.
		 * Cette méthode native a été surchargée pour supprimer également tous les objets TextStyle
		 * en mémoire.
		 * 
		 * @see flash.text.StyleSheet
		 */
		override public function clear() : void {
			super.clear();
			_map = new Dictionary();
		}
		
		/**
		 * Interprète les styles CSS définit et remplit les propriétés de l'objet AdvancedStyleSheet.
		 * 
		 * @param CSSText Les styles CSS à interpréter sous forme de chaîne
		 * @see flash.text.StyleSheet
		 */
		override public function parseCSS(CSSText : String) : void {
			
			super.parseCSS(CSSText);
			var name:String;
			var format:Object;
			var i : int = -1;
			var l : uint = styleNames.length;
			while (++i < l) {
				// On récupère les infos parsées par l'objet StyleSheet
				name = styleNames[i]; // nom de la règle CSS
				format = this.getStyle(styleNames[i]); // propriétés associées
				
				//trace(this, "parseCSS", name);
				
				// On enregistre le style
				addTextStyle(name, parseStyle(format));
			}
		}
		
		/**
		 * Ajoute un nouveau style avec le nom spécifié à l'objet feuille de style.
		 * Cette méthode native a été surchargée pour créer également un objet TextStyles en mémoire.
		 * 
		 * @see flash.text.StyleSheet
		 */
		override public function setStyle(styleName : String, styleObject : Object) : void {
			//trace("setStyle("+styleName+", " + styleObject + ")");
			super.setStyle(styleName, styleObject);
			addTextStyle(styleName, parseStyle(styleObject));
		}
		
		/**
		 * Récupère un style par son nom.
		 * 
		 * @example
		 * <listing version="3.0" >
	 	 * 	<pre class="prettyprint">
	 	 * 	// On récupère le style et on l'applique au champs texte.
	 	 * 	var style : TextStyles = myAdvancedStyleSheet.getTextStyle(".style1");
	 	 * 	CSS.apply(tf, style);
	 	 * 	</pre>
	 	 * </listing>
	 	 *  	
		 * @param name Le nom du style à récupérer.
		 * @param useClone Définit si on utilise un clone du style ou l'original.
  		 * 
  		 * @return L'objet TextStyles associé au nom (copie ou original selon la propriété
  		 * <code>useClone</code>, null s'il n'existe pas).
		 * 
		 * @see frankenstein.core.TextStyles
		 */
		public function getTextStyle(name:String, useClone : Boolean = true) : TextStyles {
			if(_map[name]) {
				return useClone ? TextStyles(_map[name]).clone() : TextStyles(_map[name]);
			}
			return null;
		}
		
		/**
		 * Ajoute un style dans la feuille de style sans passer par l'interprétation d'une feuille CSS.
		 * 
		 * @param name Le nom du style à ajouter.
		 * @param style L'objet TextStyles à associer au style.
		 * 
		 * @see frankenstein.core.TextStyles
		 */
		public function addTextStyle(name:String, style:TextStyles) : void {
			_map[name] = style;
		}
		
		/**
		 * Supprime un style.
		 * 
		 * @param name Le nom du style à supprimer
		 */
		public function removeTextStyle(name:String) : void {
			if(_map[name]) {
				delete _map[name];
			}
		}
		
		/**
		 * Transforme un objet de style simple (issu de l'interpretation CSS native) en objet TextStyles.
		 * 
		 * @param formatObject L'objet de style
		 * @return Un nouvel objet TextStyles
		 */
		protected function parseStyle(formatObject:Object) : TextStyles {
			
//			trace(this, "parseStyle", UObject.dump(formatObject));
			
			var style:TextStyles = TextStyles.textFormat2TextStyles( transform(formatObject) );
			
			var antiAliasType:String;
			var gridFitType:String;
			var embed:String;
			var multiline:String;
			var wordWrap:String;
			var selectable:String;
			
			// On vérifie l'existence de la propriété "antiAliasType"
			if(formatObject["antiAliasType"] != undefined) {
				antiAliasType = formatObject["antiAliasType"];
				if(antiAliasType != AntiAliasType.ADVANCED && antiAliasType != AntiAliasType.NORMAL)
					antiAliasType = AntiAliasType.NORMAL;
				style.antiAliasType = antiAliasType;
			}
			
			if(formatObject["sharpness"] != undefined) {
				style.sharpness = parseFloat(formatObject["sharpness"]);
			}
			
			if(formatObject["thickness"] != undefined) {
				style.thickness = parseFloat(formatObject["thickness"]);
			}
			
			if(formatObject["antiAliasType"] != undefined) {
				antiAliasType = formatObject["antiAliasType"];
				if(antiAliasType != AntiAliasType.ADVANCED && antiAliasType != AntiAliasType.NORMAL)
					antiAliasType = AntiAliasType.NORMAL;
				style.antiAliasType = antiAliasType;
			}
			// On vérifie l'existence de la propriété "gridFitType"
			if(formatObject["gridFitType"] != undefined) {
				gridFitType = formatObject["gridFitType"];
				if(gridFitType != GridFitType.NONE && gridFitType != GridFitType.PIXEL && gridFitType != GridFitType.SUBPIXEL)
					gridFitType = GridFitType.PIXEL;
				style.gridFitType = gridFitType;
			}
			// On vérifie l'existence de la propriété "embedFonts"
			if(formatObject["embedFonts"] != undefined) {
				embed = formatObject["embedFonts"];
				style.embedFonts = UString.parseBoolean(embed);
			}
			// On vérifie l'existence de la propriété "multiline"
			if(formatObject["multiline"] != undefined) {
				multiline = formatObject["multiline"];
				style.multiline = UString.parseBoolean(multiline);
			}
			// On vérifie l'existence de la propriété "wordWrap"
			if(formatObject["wordWrap"] != undefined) {
				wordWrap = formatObject["wordWrap"];
				style.wordWrap = UString.parseBoolean(wordWrap);
			}
			// On vérifie l'existence de la propriété "selectable"
			if(formatObject["selectable"] != undefined) {
				selectable = formatObject["selectable"];
				style.selectable = UString.parseBoolean(selectable);
			}
			
			return style;
		}

	}
}