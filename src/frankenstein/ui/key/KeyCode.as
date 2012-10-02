/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.ui.key {
	import flash.utils.Dictionary;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 17 déc 2008<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * Classe statiques de code ASCII des touches claviers.
	 * </p> 
	 * <p>
	 * <font color='red'><b>Attention:</b></font><br />
	 * Il existe le risque que les touches dispatchés ne correspondent pas exactement aux touches sur
	 * lesquelles l'utilisateur à réellement appuyé. En effet on rencontre des différences selon les 
	 * systèmes d'exploitation, ordinateur portable ou fixe, langues etc.<br />
	 * Il faut donc se limiter aux touches les plus communes qui sont :
	 * <ul>
	 * 	<li>Touches de A à Z sauf M</li>
	 * 	<li>Flèches</li>
	 * 	<li>Touches de F1 à F8</li>
	 * 	<li>Touches de 0 à 9 (pas celles du pavés numériques)</li>
	 * 	<li>CTRL</li>
	 * 	<li>ALT</li>
	 * 	<li>ESPACE</li>
	 * 	<li>SHIFT</li>
	 * 	<li>TAB</li>
	 * 	<li>BACKSPACE</li>
	 * </ul>
	 * et éviter les caractères spéciaux, touches système (Pomme), Les touches du pavés numériques 
	 * (tous les ordinateurs n'en ont pas forcément), les ponctuations etc.	
	 * </p> 
	 */
	 public class KeyCode {

		//LETTERS
		public static const A : uint = 65;
		public static const B : uint = 66;
		public static const C : uint = 67;
		public static const D : uint = 68;
		public static const E : uint = 69;
		public static const F : uint = 70;
		public static const G : uint = 71;
		public static const H : uint = 72;
		public static const I : uint = 73;
		public static const J : uint = 74;
		public static const K : uint = 75;
		public static const L : uint = 76;
		public static const M : uint = 77;
		public static const N : uint = 78;
		public static const O : uint = 79;
		public static const P : uint = 80;
		public static const Q : uint = 81;
		public static const R : uint = 82;
		public static const S : uint = 83;
		public static const T : uint = 84;
		public static const U : uint = 85;
		public static const V : uint = 86;
		public static const W : uint = 87;
		public static const X : uint = 88;
		public static const Y : uint = 89;
		public static const Z : uint = 90;

		//NUMBERS
		public static const ZERO : uint = 48;
		public static const ONE : uint = 49;
		public static const TWO : uint = 50;
		public static const THREE : uint = 51;
		public static const FOUR : uint = 52;
		public static const FIVE : uint = 53;
		public static const SIX : uint = 54;
		public static const SEVEN : uint = 55;
		public static const EIGHT : uint = 56;
		public static const NINE : uint = 57;

		//NUMPAD
		public static const NUMPAD_0 : uint = 96;
		public static const NUMPAD_1 : uint = 97;
		public static const NUMPAD_2 : uint = 98;
		public static const NUMPAD_3 : uint = 99;
		public static const NUMPAD_4 : uint = 100;
		public static const NUMPAD_5 : uint = 101;
		public static const NUMPAD_6 : uint = 102;
		public static const NUMPAD_7 : uint = 103;
		public static const NUMPAD_8 : uint = 104;
		public static const NUMPAD_9 : uint = 105;
		public static const NUMPAD_MULTIPLY : uint = 106;
		public static const NUMPAD_ADD : uint = 107;
		public static const NUMPAD_ENTER : uint = 108;
		public static const NUMPAD_SUBTRACT : uint = 109;
		public static const NUMPAD_DECIMAL : uint = 110;
		public static const NUMPAD_DIVIDE : uint = 111;

		//FUNCTION KEYS
		public static const F1 : uint = 112;
		public static const F2 : uint = 113;
		public static const F3 : uint = 114;
		public static const F4 : uint = 115;
		public static const F5 : uint = 116;
		public static const F6 : uint = 117;
		public static const F7 : uint = 118;
		public static const F8 : uint = 119;
		public static const F9 : uint = 120;
		public static const F10 : uint = 121;
		public static const F11 : uint = 122;
		public static const F12 : uint = 123;
		public static const F13 : uint = 124;
		public static const F14 : uint = 125;
		public static const F15 : uint = 126;

		//SYMBOLS
		public static const COLON : uint = 186;
		public static const EQUALS : uint = 187;
		public static const UNDERSCORE : uint = 189;
		public static const QUESTION_MARK : uint = 191;
		public static const TILDE : uint = 192;
		public static const OPEN_BRACKET : uint = 219;
		public static const BACKWARD_SLASH : uint = 220;
		public static const CLOSED_BRACKET : uint = 221;
		public static const QUOTES : uint = 222;
		public static const EXCLAMATION_MARK : uint = 223;

		
		//OTHER KEYS		
		public static const BACKSPACE : uint = 8;
		public static const TAB : uint = 9;
		public static const CLEAR : uint = 12;
		public static const ENTER : uint = 13;
		public static const SHIFT : uint = 16;
		public static const CONTROL : uint = 17;
		public static const ALT : uint = 18;
		public static const CAPS_LOCK : uint = 20;
		public static const ESC : uint = 27;
		public static const SPACEBAR : uint = 32;
		public static const PAGE_UP : uint = 33;
		public static const PAGE_DOWN : uint = 34;
		public static const END : uint = 35;
		public static const HOME : uint = 36;
		public static const LEFT : uint = 37;
		public static const UP : uint = 38;
		public static const RIGHT : uint = 39;
		public static const DOWN : uint = 40;
		public static const INSERT : uint = 45;
		public static const DELETE : uint = 46;
		public static const HELP : uint = 47;
		public static const NUM_LOCK : uint = 144;

		
		private static function getAsciiCodes() : Dictionary {
			var _ascii : Dictionary = new Dictionary();
			
			_ascii[65] = "A";
			_ascii[66] = "B";
			_ascii[67] = "C";
			_ascii[68] = "D";
			_ascii[69] = "E";
			_ascii[70] = "F";
			_ascii[71] = "G";
			_ascii[72] = "H";
			_ascii[73] = "I";
			_ascii[74] = "J";
			_ascii[75] = "K";
			_ascii[76] = "L";
			_ascii[77] = "M";
			_ascii[78] = "N";
			_ascii[79] = "O";
			_ascii[80] = "P";
			_ascii[81] = "Q";
			_ascii[82] = "R";
			_ascii[83] = "S";
			_ascii[84] = "T";
			_ascii[85] = "U";
			_ascii[86] = "V";
			_ascii[87] = "W";
			_ascii[88] = "X";
			_ascii[89] = "Y";
			_ascii[90] = "Z";
			_ascii[48] = "0";
			_ascii[49] = "1";
			_ascii[50] = "2";
			_ascii[51] = "3";
			_ascii[52] = "4";
			_ascii[53] = "5";
			_ascii[54] = "6";
			_ascii[55] = "7";
			_ascii[56] = "8";
			_ascii[57] = "9";
			_ascii[32] = "Space";
			_ascii[13] = "Enter";
			_ascii[17] = "Ctrl";
			_ascii[16] = "Shift";
			_ascii[18] = "Alt";
			_ascii[192] = "~";
			_ascii[38] = "Up";
			_ascii[40] = "Down";
			_ascii[37] = "Left";
			_ascii[39] = "Right";
			_ascii[96] = "Numpad 0";
			_ascii[97] = "Numpad 1";
			_ascii[98] = "Numpad 2";
			_ascii[99] = "Numpad 3";
			_ascii[100] = "Numpad 4";
			_ascii[101] = "Numpad 5";
			_ascii[102] = "Numpad 6";
			_ascii[103] = "Numpad 7";
			_ascii[104] = "Numpad 8";
			_ascii[105] = "Numpad 9";
			_ascii[111] = "Numpad /";
			_ascii[106] = "Numpad *";
			_ascii[109] = "Numpad -";
			_ascii[107] = "Numpad +";
			_ascii[110] = "Numpad .";
			_ascii[45] = "Insert";
			_ascii[46] = "Delete";
			_ascii[33] = "Page Up";
			_ascii[34] = "Page Down";
			_ascii[35] = "End";
			_ascii[36] = "Home";
			_ascii[112] = "F1";
			_ascii[113] = "F2";
			_ascii[114] = "F3";
			_ascii[115] = "F4";
			_ascii[116] = "F5";
			_ascii[117] = "F6";
			_ascii[118] = "F7";
			_ascii[119] = "F8";
			_ascii[120] = "F9";
			_ascii[121] = "F10";
			_ascii[122] = "F11";
			_ascii[123] = "F12";
			_ascii[124] = "F13";
			_ascii[125] = "F14";
			_ascii[126] = "F15";
			
			_ascii[188] = ",";
			_ascii[190] = ".";
			_ascii[186] = ";";
			_ascii[222] = "'";
			_ascii[219] = "[";
			_ascii[221] = "]";
			_ascii[189] = "-";
			_ascii[187] = "+";
			_ascii[220] = "\\";
			_ascii[223] = "!";
			_ascii[191] = "/";
			_ascii[9] = "TAB";
			_ascii[8] = "Backspace";
			_ascii[27] = "ESC";
			
			return _ascii;
		}

		/**
		 * Retourne la touche correspondant au code ascii.
		 * 
		 * @param asciiCode
		 * Le code ascii retourné par flash.
		 * 
		 * @return
		 * La touche correspondant au code (selon le tableau de correspondance de la classe, 
		 * donc il y a la possibilité que la valeur retournée soit fausse, voir le message "Attention").
		 */
		public static function getKeyString(asciiCode : uint) : String {
			return getAsciiCodes()[asciiCode];
		}
	
	}
}