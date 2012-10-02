/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import frankenstein.errors.ArgumentTypeError;



	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 27 août 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour la gestion de l'affichage de DisplayObjects. 
	 * </p>
	 */ 
	public class UDisplay {	

		/**
		 * Alignement en bas.
		 */
		public static const BOTTOM : String = "B";
		/**
		 * Alignement en bas-gauche. 
		 */
		public static const BOTTOM_LEFT : String = "BL";
		/**
		 * Alignement en bas-droite. 
		 */
		public static const BOTTOM_RIGHT : String = "BR";
		/**
		 * Alignement à gauche. 
		 */
		public static const LEFT : String = "L";
		/**
		 * Alignement au milieu.
		 */
		public static const MIDDLE : String = "C";
		/**
		 * Alignement à droite.
		 */
		public static const RIGHT : String = "R";
		/**
		 * Alignement en haut. 
		 */
		public static const TOP : String = "T";
		/**
		 * Alignement en haut-gauche. 
		 */
		public static const TOP_LEFT : String = "TL";
		/**
		 * Alignement en haut-droite. 
		 */
		public static const TOP_RIGHT : String = "TR";

		
		/**
		 * Redimmensionne un DisplayObject dans une rectangle avec de nombreux paramètres de règlages.
		 * 
		 * @param displayObject 
		 * Le DisplayObject à redimmensionner.
		 * 
		 * @param rectangle 
		 * Le rectangle correspondant à la zone dans lequel le DisplayObject doit être resizé.
		 * 
		 * @param fillRect 
		 * Définit si le DisplayObject doit entirement remplir le Rectangle (et donc être éventuellement croppé) 
		 * 
		 * @param align 
		 * L'alignement du DisplayObject dans le Rectangle
		 * 
		 * @param allowUpscale 
		 * Définit si on accepte de upscaler le DisplayObject (avec risque de perte de qualité)
		 * 
		 * @return void
		 * 
		 */
		public static function fitIntoRect(displayObject : DisplayObject, rectangle : Rectangle, fillRect : Boolean = true, align : String = "C", allowUpscale : Boolean = true) : void {
			var posX : Number = displayObject.x;
			var posY : Number = displayObject.y;
			
			var matrix : Matrix = getMatrixToFitIntoRect(getRealDisplayObjectSize(displayObject), rectangle, fillRect, align, allowUpscale);
			displayObject.transform.matrix = matrix;
			
			displayObject.x += posX;
			displayObject.y += posY;
		}

		
		/**
		 * Retourne la taille réelle d'un DisplayObject (peut importe son scale)  
		 * 
		 * @param displayObject
		 * Le DisplayObject à tester
		 * 
		 * @return 
		 * Un Rectangle correspondant a la taille réelle du DisplayObject (les valeur x et y sont toujours à 0).
		 */
		public static function getRealDisplayObjectSize(displayObject : DisplayObject) : Rectangle {
			var w : Number = displayObject.width / displayObject.scaleX;
			var h : Number = displayObject.height / displayObject.scaleY;
			var rect : Rectangle = new Rectangle(0, 0, w, h);
			
			return rect;
		}

		
		
		
		/**
		 * Retourne la matrice de Transformation à appliquer pour qu'un DisplayObject rentre dans une zone
		 * rectangle  
		 * 
		 * @param displayObject
		 * Le DisplayObject à resizer.
		 * 
		 * @param rectangle
		 * Le rectangle correspondant à la zone dans lequel le DisplayObject doit être resizé.
		 * 
		 * @param fillRect
		 * Définit si le DisplayObject doit entièrement remplir le Rectangle (et donc être éventuellement croppé)
		 *  
		 * @param align
		 * L'alignement du DisplayObject dans le Rectangle
		 * 
		 * @param allowUpscale
		 * Définit si on accepte de upscaler le DisplayObject (avec risque de perte de qualité)
		 *
		 * @return
		 * La matrice de Transformation à appliquer pour qu'un DisplayObject rentre dans une zone
		 * rectangle 
		 */
		public static function getMatrixToFitIntoRect(sourceRect : Rectangle, rectangle : Rectangle, fillRect : Boolean = true, align : String = "C", allowUpscale : Boolean = true) : Matrix {
			var matrix : Matrix = new Matrix();
			
			var wD : Number = sourceRect.width;
			var hD : Number = sourceRect.height;
			
			var wR : Number = rectangle.width;
			var hR : Number = rectangle.height;
			
			var sX : Number = wR / wD;
			var sY : Number = hR / hD;
			
			if (!allowUpscale) {
				if (sX > 1)
					sX = 1;
				
				if (sY > 1)
					sY = 1;
			}
			
			
			var rD : Number = wD / hD;
			var rR : Number = wR / hR;
			
			var sH : Number = fillRect ? sY : sX;
			var sV : Number = fillRect ? sX : sY;
			
			var s : Number = rD >= rR ? sH : sV;
			var w : Number = wD * s;
			var h : Number = hD * s;
			
			var tX : Number = 0.0;
			var tY : Number = 0.0;
			
			switch(align) {
				case LEFT :
				case TOP_LEFT :
				case BOTTOM_LEFT :
					tX = 0.0;
					break;
					
				case RIGHT :
				case TOP_RIGHT :
				case BOTTOM_RIGHT :
					tX = w - wR;
					break;
					
				default : 					
					tX = 0.5 * (w - wR);
			}
			
			switch(align) {
				case TOP :
				case TOP_LEFT :
				case TOP_RIGHT :
					tY = 0.0;
					break;
					
				case BOTTOM :
				case BOTTOM_LEFT :
				case BOTTOM_RIGHT :
					tY = h - hR;
					break;
					
				default : 					
					tY = 0.5 * (h - hR);
			}
			
			matrix.scale(s, s);
			matrix.translate(rectangle.left - tX, rectangle.top - tY);
			
			return matrix;
		}

		
		/**
		 * Crée une miniature d'une image ou d'un DisplayObject.<br />
		 * La miniature sera redimmensionnée homothetiquement et croppée si besoin.
		 * 
		 * @param source
		 * Le media source. Peut être de type BitmapData ou DisplayObject.<br />
		 * La source ne sera pas modifiée.
		 * 
		 * @param width
		 * La largeur de la miniature.
		 * 
		 * @param height
		 * La hauteur de la miniature.
		 * 
		 * @param align
		 * Alignement de la minituare si elle ne dispose pas du même ratio largeur/hauteur que 
		 * l'image source.<br />
		 * Voir les constantes d'alignements de la classe.
		 * 
		 * @param smooth
		 * Définit si le BitmapData doit être smoother ou non.
		 * 
		 * @param fillRect
		 * Définit si la miniature entièrement remplir la zone définie (et donc être éventuellement croppé), 
		 * ou non (bandes verticales ou horizontales).
		 * 
		 * @param bgColor
		 * La couleur du fond de la miniature (au format ARGB). Si le paramètre fillRect est à "true" alors 
		 * la couleur de fond ne sera pas visible.
		 * 
		 */
		public static function createThumb(source : *, width : int, height : int, align : String = "C", smooth : Boolean = true, fillRect : Boolean = true, bgColor : uint = 0xFF000000) : Bitmap {
			
			var bitmapData : BitmapData;
			
			if (source is BitmapData) {
				bitmapData = source;
			}
			else if (source is DisplayObject) {
				bitmapData = new BitmapData(source.width, source.height, true, bgColor);
				bitmapData.draw(source);
			} else {
				throw(new ArgumentTypeError(getQualifiedClassName(source)));
			}
			
			
			var bitmap : Bitmap = new Bitmap(bitmapData);
			var thumbnail : BitmapData = new BitmapData(width, height, true, bgColor);
			
			thumbnail.draw(bitmapData, getMatrixToFitIntoRect(new Rectangle(0, 0, bitmapData.width, bitmapData.height), thumbnail.rect, fillRect, align), null, null, null, smooth);
			bitmap = null;
			
			return new Bitmap(thumbnail, PixelSnapping.AUTO, smooth);
		}

		
		
		/**
		 * Crée un snapshot du displayObject (à fond transparent).
		 * 
		 * @param source
		 * Le DisplayObject source.
		 * 
		 * @param smooth
		 * Lissage activé oui/non.
		 * 
		 * @return
		 * Un nouvel objet Bitmap.
		 * 
		 */
		public static function snapshot(source : DisplayObject, smooth : Boolean = true) : Bitmap {
			return createThumb(source, source.width, source.height, MIDDLE, smooth, true, 0);
		}

		
		/**
		 * Teinte un DisplayObject.
		 * 
		 * @param source
		 * Le DisplayObject à teinter.
		 * 
		 * @param color
		 * Le code couleur en uint (0xFF3200).
		 * 
		 * @param alpha
		 * Le pourcentage de couleur à appliquer.
		 *  
		 */
		public static function tint(source : DisplayObject, color : uint, alpha : Number = 1) : void {
			
			var ct : ColorTransform = new ColorTransform();
			
			var rgb : Object = UColors.hex2RGB(color);
			
			ct.redMultiplier = 1 - alpha;
			ct.greenMultiplier = 1 - alpha;
			ct.blueMultiplier = 1 - alpha;

			ct.redOffset = rgb.r * alpha;
			ct.greenOffset = rgb.g * alpha;
			ct.blueOffset = rgb.b * alpha;
			
			
			source.transform.colorTransform = ct;
		}

		
		
		
		
		/**
		 * Modifie les couleurs du DisplayObject : luminosité, contraste, saturation, nuance
		 * 
		 * @param d
		 * Le DisplayObject sur lequel on applique la modification de couleur.
		 * 
		 * @param brightness
		 * La luminosité.
		 * 
		 * @param contrast
		 * Le contraste.
		 * 
		 * @param saturation
		 * La saturation.
		 * 
		 * @param hue
		 * la nuance.
		 * 
		 */
		public static function adjustColor(d : DisplayObject, brightness : Number, contrast : Number, saturation : Number, hue : Number) : void {
			var cm : ColorMatrixInternal = new ColorMatrixInternal();
			cm.adjustColor(brightness, contrast, saturation, hue);
			d.filters = [new ColorMatrixFilter(cm)];
		}
		
		
		
		
		public static function drawRect(d : Sprite, width : Number = 100, height : Number = 100, x: Number = 0, y: Number = 0, color: int = -1, colorAlpha : Number = 1) : void {
			
			if (color == -1){
				color = Math.random() * 0xFFFFFF;
			}
			
			d.graphics.beginFill(color, colorAlpha);
			d.graphics.drawRect(x, y, width, height);
			d.graphics.endFill();
		}
		
	}
}

dynamic class ColorMatrixInternal extends Array {

	// constant for contrast calculations:
	private static const DELTA_INDEX : Array = [0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
			0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
			0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
			0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 
			0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
			1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
			1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25, 
			2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
			4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
			7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8, 
			10.0];

	// identity matrix constant:
	private static const IDENTITY_MATRIX : Array = [1,0,0,0,0,
			0,1,0,0,0,
			0,0,1,0,0,
			0,0,0,1,0,
			0,0,0,0,1];
	private static const LENGTH : Number = IDENTITY_MATRIX.length;

	
	// initialization:
	public function ColorMatrixInternal(p_matrix : Array = null) {
		p_matrix = fixMatrix(p_matrix);
		copyMatrix(((p_matrix.length == LENGTH) ? p_matrix : IDENTITY_MATRIX));
	}

	
	// public methods:
	public function reset() : void {
		for (var i : uint = 0;i < LENGTH; i++) {
			this[i] = IDENTITY_MATRIX[i];
		}
	}

	
	public function adjustColor(p_brightness : Number,p_contrast : Number,p_saturation : Number,p_hue : Number) : void {
		adjustHue(p_hue);
		adjustContrast(p_contrast);
		adjustBrightness(p_brightness);
		adjustSaturation(p_saturation);
	}

	
	public function adjustBrightness(p_val : Number) : void {
		p_val = cleanValue(p_val, 100);
		if (p_val == 0 || isNaN(p_val)) { 
			return; 
		}
		multiplyMatrix([1,0,0,0,p_val,
				0,1,0,0,p_val,
				0,0,1,0,p_val,
				0,0,0,1,0,
				0,0,0,0,1]);
	}

	
	public function adjustContrast(p_val : Number) : void {
		p_val = cleanValue(p_val, 100);
		if (p_val == 0 || isNaN(p_val)) { 
			return; 
		}
		var x : Number;
		if (p_val < 0) {
			x = 127 + p_val / 100 * 127;
		} else {
			x = p_val % 1;
			if (x == 0) {
				x = DELTA_INDEX[p_val];
			} else {
				//x = DELTA_INDEX[(p_val<<0)]; // this is how the IDE does it.
				x = DELTA_INDEX[(p_val << 0)] * (1 - x) + DELTA_INDEX[(p_val << 0) + 1] * x; // use linear interpolation for more granularity.
			}
			x = x * 127 + 127;
		}
		multiplyMatrix([x / 127,0,0,0,0.5 * (127 - x),
				0,x / 127,0,0,0.5 * (127 - x),
				0,0,x / 127,0,0.5 * (127 - x),
				0,0,0,1,0,
				0,0,0,0,1]);
	}

	
	public function adjustSaturation(p_val : Number) : void {
		p_val = cleanValue(p_val, 100);
		if (p_val == 0 || isNaN(p_val)) { 
			return; 
		}
		var x : Number = 1 + ((p_val > 0) ? 3 * p_val / 100 : p_val / 100);
		var lumR : Number = 0.3086;
		var lumG : Number = 0.6094;
		var lumB : Number = 0.0820;
		multiplyMatrix([lumR * (1 - x) + x,lumG * (1 - x),lumB * (1 - x),0,0,
				lumR * (1 - x),lumG * (1 - x) + x,lumB * (1 - x),0,0,
				lumR * (1 - x),lumG * (1 - x),lumB * (1 - x) + x,0,0,
				0,0,0,1,0,
				0,0,0,0,1]);
	}

	
	public function adjustHue(p_val : Number) : void {
		p_val = cleanValue(p_val, 180) / 180 * Math.PI;
		if (p_val == 0 || isNaN(p_val)) { 
			return; 
		}
		var cosVal : Number = Math.cos(p_val);
		var sinVal : Number = Math.sin(p_val);
		var lumR : Number = 0.213;
		var lumG : Number = 0.715;
		var lumB : Number = 0.072;
		multiplyMatrix([lumR + cosVal * (1 - lumR) + sinVal * (-lumR),lumG + cosVal * (-lumG) + sinVal * (-lumG),lumB + cosVal * (-lumB) + sinVal * (1 - lumB),0,0,
				lumR + cosVal * (-lumR) + sinVal * (0.143),lumG + cosVal * (1 - lumG) + sinVal * (0.140),lumB + cosVal * (-lumB) + sinVal * (-0.283),0,0,
				lumR + cosVal * (-lumR) + sinVal * (-(1 - lumR)),lumG + cosVal * (-lumG) + sinVal * (lumG),lumB + cosVal * (1 - lumB) + sinVal * (lumB),0,0,
				0,0,0,1,0,
				0,0,0,0,1]);
	}

	
	public function concat(p_matrix : Array) : void {
		p_matrix = fixMatrix(p_matrix);
		if (p_matrix.length != LENGTH) { 
			return; 
		}
		multiplyMatrix(p_matrix);
	}

	
	public function clone() : ColorMatrixInternal {
		return new ColorMatrixInternal(this);
	}

	
	public function toString() : String {
		return "ColorMatrixInternal [ " + this.join(" , ") + " ]";
	}

	
	// return a length 20 array (5x4):
	public function toArray() : Array {
		return slice(0, 20);
	}

	
	// private methods:
	// copy the specified matrix's values to this matrix:
	protected function copyMatrix(p_matrix : Array) : void {
		var l : Number = LENGTH;
		for (var i : uint = 0;i < l;i++) {
			this[i] = p_matrix[i];
		}
	}

	
	// multiplies one matrix against another:
	protected function multiplyMatrix(p_matrix : Array) : void {
		var col : Array = [];
			
		for (var i : uint = 0;i < 5;i++) {
			for (var j : uint = 0;j < 5;j++) {
				col[j] = this[j + i * 5];
			}
			for (j = 0;j < 5;j++) {
				var val : Number = 0;
				for (var k : Number = 0;k < 5;k++) {
					val += p_matrix[j + k * 5] * col[k];
				}
				this[j + i * 5] = val;
			}
		}
	}

	
	// make sure values are within the specified range, hue has a limit of 180, others are 100:
	protected function cleanValue(p_val : Number,p_limit : Number) : Number {
		return Math.min(p_limit, Math.max(-p_limit, p_val));
	}

	
	// makes sure matrixes are 5x5 (25 long):
	protected function fixMatrix(p_matrix : Array = null) : Array {
		if (p_matrix == null) { 
			return IDENTITY_MATRIX; 
		}
		if (p_matrix is ColorMatrixInternal) { 
			p_matrix = p_matrix.slice(0); 
		}
		if (p_matrix.length < LENGTH) {
			p_matrix = p_matrix.slice(0, p_matrix.length).concat(IDENTITY_MATRIX.slice(p_matrix.length, LENGTH));
		} else if (p_matrix.length > LENGTH) {
			p_matrix = p_matrix.slice(0, LENGTH);
		}
		return p_matrix;
	}
}

