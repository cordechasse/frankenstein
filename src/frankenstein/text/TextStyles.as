/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.text {
	import flash.text.TextField;
	import flash.text.GridFitType;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 26 mai 2009<br />
	 * 		<b>Version </b> 1.2.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>Nicobush v1.0.0</li>
	 * 				<li>Antoine Lassauzay v1.0.1 :<br />
	 * 							- Ajout des méthodes clone() et converTextFormat()<br />
	 * 							- Ajout des propriétés multiline, wordWrap, selectable, antiAliasType,
	 * 							gridFitType
	 * 				</li>
	 * 				<li>Nicobush v1.1.0 :<br />
	 * 							- correction d'un oubli dans la méthode Clone<br />
	 * 							- ajout de la méthode inheritUnsetProperties
	 * 				</li>
	 * 				<li>Nicobush v1.2.0 :<br />
	 * 							- modif de la méthode inheritUnsetProperties : ajout du size<br />
	 * 							- modif de la methode textFormat2TextStyles : ajout du letterspacing
	 * 				</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>Spécifie le style d'un champ texte.</p>
	 * <p>
	 * La classe s'utilise avec La classe CSS.<br />
	 * Si la typo est une typo pixel, le texte est forcé à la taille de la typo. ex: Arial_11pt_st sera forcée en taille 11.<br />
	 * Dans cette classe, on peut traiter les cas particulier des typos, pour les langues orientales par exemple.
	 * </p>
	 * 
	 *  @example
	 * Application d'un style :
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		var txt : TextField = new TextField();
	 * 		
	 * 		// Utilisation avec l'objet TextStyles
	 * 		var style : TextStyles = new TextStyles("Arial");
	 * 		CSS.apply(txt, style);
	 * 	</pre>
	 * </listing>
	 * 
	 * 
	 * @see frankenstein.core.CSS
	 * 	
	 */ 
	public class TextStyles extends TextFormat {

		public var embedFonts : Boolean = true;

		private var _multiline : Boolean = false;
		
		private var _wordWrap : Boolean = false;
		
		private var _selectable : Boolean = false;
		
		private var _antiAliasType : String = AntiAliasType.NORMAL;
		
		private var _sharpness : Number = 0;
		
		private var _thickness : Number = 0;
				
		private var _gridFitType : String = GridFitType.PIXEL;

		private var _isMultilineSet : Boolean;
		private var _isWordWrapSet : Boolean;
		private var _isSelectableSet : Boolean;
		private var _isAntiAliasTypeSet : Boolean;
		private var _isGridFitTypeSet : Boolean;
		private var _isLetterSpacingSet : Boolean;
		
		

		/**
		 * Constructeur de la classe TextStyles
		 * 
		 * @param font
		 * Le nom exact de la typo (pas celui du nom de linkage).
		 * 
		 * @param embedFonts
		 * Typo embarquée oui / non.
		 * 
		 * @param bold
		 * Texte en gras oui / non.
		 * 
		 * @param size
		 * Taille du texte.
		 *  
		 * @param color
		 * Couleur du texte.
		 * 
		 * @param italic
		 * Texte en italique oui / non.
		 * 
		 * @param antiAliasType
		 * Mode d'antialias défini par les constantes de AntiAliasType.
		 * 
		 * @param underline
		 * Texte souligné oui / non.
		 * 
		 * @param url
		 * Cible du lien.
		 * 
		 * @param target
		 * Fenètre cible du lien.
		 * 
		 * @param align
		 * Alignement du texte.
		 * 
		 * @param leftMargin
		 * Marge gauche.
		 * 
		 * @param rightMargin
		 * Marge droite.
		 * 
		 * @param indent
		 * Indentation.
		 * 
		 * @param leading
		 * Espacement vertical.
		 * 
		 * @see flash.text.TextField
		 * 
		 */
		 
		public function TextStyles( font : String = "_sans", embedFonts : Boolean = true , bold : Object = null , size : Object = null , color : Object = null , italic : Object = null , underline : Object = null , url : String = null , target : String = null , align : String = null , leftMargin : Object = null , rightMargin : Object = null , indent : Object = null , leading : Object = null ) {		
			//si on a une typo pixel, la taille est dans le nom, et on la force
			var pt : int = parseInt(font.split("_")[ 1 ]);
				
			super(font, pt != 0 ? pt : size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading);
			
			this.embedFonts = embedFonts;
		}
		
		/**
		 * Duplique l'objet TextStyles
		 * 
		 * @return L'objet dupliqué
		 */
		public function clone() : TextStyles {
			var textStyles : TextStyles =  new TextStyles();
			textStyles.align = this.align;
			textStyles.blockIndent = this.blockIndent;
			textStyles.bold = this.bold;
			textStyles.bullet = this.bullet;
			textStyles.color = this.color;
			textStyles.font = this.font;
			textStyles.indent = this.indent;
			textStyles.italic = this.italic;
			textStyles.kerning = this.kerning;
			textStyles.leading = this.leading;
			textStyles.leftMargin = this.leftMargin;
			textStyles.rightMargin = this.rightMargin;
			textStyles.size = this.size;
			textStyles.tabStops = this.tabStops;
			textStyles.target = this.target;
			textStyles.underline = this.underline;
			textStyles.url = this.url;
			textStyles.embedFonts = this.embedFonts;
			textStyles.letterSpacing = this.letterSpacing;
			textStyles.sharpness = this.sharpness;
			textStyles.thickness = this.thickness;
			
			
			if (_isMultilineSet)
				textStyles.multiline = this.multiline;
			
			if (_isWordWrapSet)
				textStyles.wordWrap = this.wordWrap;
			
			if (_isSelectableSet)
				textStyles.selectable = this.selectable;
				
			if (_isAntiAliasTypeSet)
				textStyles.antiAliasType = this.antiAliasType;
				
			if (_isGridFitTypeSet)
				textStyles.gridFitType = this.gridFitType;
			
			return textStyles;
		}
		
		
		/**
		 * Réinsère les propriétés du TextField qui n'ont pas été définies dans le TextStyles.
		 * Les propriétés sont : multiline, wordWrap, selectable, antiAliasType, gridFitType
		 */
		public function inheritUnsetProperties(tf : TextField) : void{
			if (!_isMultilineSet)
				multiline = tf.multiline;
				
			if (!_isWordWrapSet)
				wordWrap = tf.wordWrap;
				
			if (!_isSelectableSet)
				selectable = tf.selectable;
				
			if (!_isAntiAliasTypeSet)
				antiAliasType = tf.antiAliasType;
				
			if (!_isGridFitTypeSet)
				gridFitType = tf.gridFitType;
			
			if (!_isLetterSpacingSet)
				letterSpacing = tf.getTextFormat().letterSpacing;
			
			if (!size)
				size = tf.getTextFormat().size;
			
			
		}
		
		
		
		
		/**
		 * Retourne un nouvel objet TextStyles à partir d'un objet TextFormat
		 * 
		 * @param format L'objet TextFormat à convertir.
		 * 
		 * @return Nouvel objet TextStyles.
		 */
		public static function textFormat2TextStyles(format:TextFormat) : TextStyles {
			
			var textStyles : TextStyles =  new TextStyles();
			textStyles.align = format.align;
			textStyles.blockIndent = format.blockIndent;
			textStyles.bold = format.bold;
			textStyles.bullet = format.bullet;
			textStyles.color = format.color;
			textStyles.font = format.font;
			textStyles.indent = format.indent;
			textStyles.italic = format.italic;
			textStyles.kerning = format.kerning;
			textStyles.leading = format.leading;
			textStyles.leftMargin = format.leftMargin;
			textStyles.rightMargin = format.rightMargin;
			textStyles.size = format.size;
			textStyles.tabStops = format.tabStops;
			textStyles.target = format.target;
			textStyles.underline = format.underline;
			textStyles.url = format.url;
			textStyles.letterSpacing = format.letterSpacing;
			
			
			
			return textStyles;
		}
		
		
		public function get multiline() : Boolean {
			return _multiline;
		}
		
		
		public function set multiline(multiline : Boolean) : void {
			_isMultilineSet = true;
			_multiline = multiline;
		}
		
		
		public function get wordWrap() : Boolean {
			return _wordWrap;
		}
		
		
		public function set wordWrap(wordWrap : Boolean) : void {
			_isWordWrapSet = true;
			_wordWrap = wordWrap;
		}
		
		
		public function get selectable() : Boolean {
			return _selectable;
		}
		
		
		public function set selectable(selectable : Boolean) : void {
			_isSelectableSet = true;
			_selectable = selectable;
		}
		
		
		public function get antiAliasType() : String {
			return _antiAliasType;
		}
		
		
		public function set antiAliasType(antiAliasType : String) : void {
			_isAntiAliasTypeSet = true;
			_antiAliasType = antiAliasType;
		}
		
		
		public function get gridFitType() : String {
			_isGridFitTypeSet = true;
			return _gridFitType;
		}
		
		
		public function set gridFitType(gridFitType : String) : void {
			_gridFitType = gridFitType;
		}
		
		
		public override function set letterSpacing(value : Object) : void {
			_isLetterSpacingSet = true;
			super.letterSpacing = value;
		}

		public function get sharpness() : Number {
			return _sharpness;
		}

		public function set sharpness(sharpness : Number) : void {
			_sharpness = sharpness;
		}

		public function get thickness() : Number {
			return _thickness;
		}

		public function set thickness(thickness : Number) : void {
			_thickness = thickness;
		}
		
		
		
	}
}
