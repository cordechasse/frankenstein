/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	
	import frankenstein.errors.ArgumentTypeError;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 28 juillet 2008<br />
	 * 		<b>Version </b> 1.1.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>Nicobush v1.0.0</li>
	 * 				<li>Antoine Lassauzay v1.0.1 : ajout de la méthode parseBoolean</li>
	 * 				<li>Nicobush v1.1 : Optimisation de la méthode getWordDistance</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour les Strings.
	 * </p>
	 */
	public class UString {

		
		private static var NUMBER_RANGE : Array = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57];
		private static var UPPERCASE_RANGE : Array = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90];
		private static var LOWERCASE_RANGE : Array = [97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122];
		private static var PUNCTUATION_RANGE : Array = [33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 58, 59, 60, 61, 62, 63, 64];
		
		
		/**
		 * Retourne si l'email est valide.
		 * 
		 * @param str
		 * L'email à tester.
		 * 
		 */
		public static function isEmail(str : String) : Boolean {
			var disallowedChars : String = "()<>,;:\\\"[] `~!#$%^&*+={}|/?'";
			var username : String = "";
			var domain : String = "";
			var n : Number;
			var i : Number;
	
			// Find the @ && check if only one is present
			var ampPos : Number = str.indexOf("@");
			
			if(ampPos == -1) return false; // missing at sign
			else if(str.indexOf("@", ampPos + 1) != -1) return false; // too many at signs
	
			// Separate the address into username and domain.
			username = str.substring(0, ampPos);
			domain = str.substring(ampPos + 1);
	
			// Validate username has no illegal characters
			// and has at least one character.
			var usernameLen : Number = username.length;
			
			if(usernameLen == 0) return false; // missing username

			for(i = 0;i < usernameLen; i++) {
				if(disallowedChars.indexOf(username.charAt(i)) != -1) return false; // invalid char
			}
			
			var domainLen : Number = domain.length;
			
			// If IP domain, then must follow [x.x.x.x] format
			if(domain.charAt(0) == "[" && domain.charAt(domain.length - 1) == "]") {
				// Parse out each IP number.
				var ipArray : Array = new Array();
				var ipAddr : String = domain.substring(1, domain.length - 1);
				var pos : Number = 0;
				var newpos : Number = 0;
				
				while(true) {
					newpos = ipAddr.indexOf(".", pos);
					
					if(newpos != -1) ipArray.push(ipAddr.substring(pos, newpos)); else {
						ipArray.push(ipAddr.substring(pos));
						break;
					}
					
					pos = newpos + 1;
				}
				
				if(ipArray.length != 4) return false; // invalid IP domain

				n = ipArray.length;
				
				for(i = 0;i < n; i++) {
					var item : Number = Number(ipArray[i]);
					
					if(isNaN(item) || item < 0 || item > 255) return false; // invalid IP domain
				}
			} else {
				// Must have at least one period
				var periodPos : Number = domain.indexOf(".");
				var nextPeriodPos : Number = 0;
				var lastDomain : String = "";
				
				if(periodPos == -1) return false; // missing period in domain

				while(true) {
					nextPeriodPos = domain.indexOf(".", periodPos + 1);
					
					if(nextPeriodPos == -1) {
						lastDomain = domain.substring(periodPos + 1);
						if(lastDomain.length != 3 && lastDomain.length != 2 && lastDomain.length != 4 && lastDomain.length != 6) {
							return false; // invalid domain
						}
						
						break;
					}
					else if(nextPeriodPos == periodPos + 1) return false; // invalid periods in domain

					periodPos = nextPeriodPos;
				}
	
				// Check that there are no illegal characters in the domain.
				for(i = 0;i < domainLen; i++) {
					if(disallowedChars.indexOf(domain.charAt(i)) != -1) return false; // invalid char
				}
				
				// Check that the character immediately after the @ is not a period.
				if(domain.charAt(0) == ".") return false; // invalid domain 
			}
	
			return true;
		}

		
		/**
		 * Retire les espaces et tab avant et apres une chaine de caractères.
		 * 
		 * @param v
		 * Le String à "nettoyer".
		 * 
		 * @return
		 * Un nouveau String sans espace avant et après son contenu.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var s = "    	qsd    					";
		 * 		trace(">"+UString.trim(s)+"<"); // affiche ">qsd<"
		 * 	</pre>
		 * </listing>
		 * 
		 */
		public static function trim(v : String) : String {
			return _ltrim(_rtrim(v));
		}

		
		private static function _rtrim(v : String) : String {
			var LTrimExp : RegExp = /^(\s|\n|\r|\t|\v)*/m;
			return v.replace(LTrimExp, "");
		}

		
		private static function _ltrim(v : String) : String {
			var RTrimExp : RegExp = /(\s|\n|\r|\t|\v)*$/;
			return v.replace(RTrimExp, "");
		}

		
		/**
		 * Retourne l'extension d'un fichier.
		 * 
		 * @param filename
		 * Le nom du fichier.
		 * 
		 * @return
		 * L'extension du fichier (chaine de caractères vides si pas d'extension).
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var s = "monfichier.exe";
		 * 		trace(UString.getFileExtension(s)); //affiche "exe"
		 * 	</pre>
		 * </listing>
		 *  
		 */
		public static function getFileExtension(filename : String) : String {
			
			//on retire les données en parametres derriere un point d'exclamation
			if (filename.lastIndexOf("?") != -1 && filename.lastIndexOf(".") != -1 && (filename.lastIndexOf("?") > filename.lastIndexOf("."))) {
				filename = filename.substring(0, filename.lastIndexOf("?"));
			}
			
			//on retourne l'extension
			if (filename.indexOf(".") == -1 || filename.lastIndexOf(".") == filename.length - 1)
				return "";
			else 
				return filename.substring(filename.lastIndexOf(".") + 1, filename.length);
		}

		
		
		/**
		 * Retourne la distance entre 2 mots (distance de Levenshtein).<br />
		 * Cette méthode est utilisé pour trouver le mot le plus proche dans un dictionnaire par ex.
		 *  
		 * @param source
		 * Le mot source.
		 * 
		 * @param dest
		 * Le mot cible.
		 * 
		 * @return
		 * La distance (0 équivaut à deux mots identiques).
		 * 
		 */
		public static function getWordDistance(source : String, target : String) : uint {
			var i : uint;
			var j : uint;
			if(source == null) source = '';
			if(target == null) target = '';
			if(source == target) return 0;
			var d : Array = new Array();
			var cost : uint;
			var n : uint = source.length;
			var m : uint = target.length;
			if(n == 0) return m;
			if(m == 0) return n;
			
			
			while (i <= n){
				d[i] = new Array();
				d[i][0] = i;
				i++;
			}
			
			
			while (j <= m){
				d[0][j] = j;
				j++;
			}
			
			i = 1;
			while (i <= n){
				var s_i : String = source.charAt(i - 1);
				
				j = 1;
				while (j <= m){
					var t_j : String = target.charAt(j - 1);
					if(s_i == t_j) cost = 0; 
					else cost = 1;
					d[i][j] = _minimum(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost);
					j++;
				}
				i++;
			}
			return d[n][m];
		}

		
		private static function _minimum(a : uint, b : uint, c : uint) : uint {
			return a < b ? (a < c ? a : c) : (b < c ? b : c); 
		}
		
		
		
		/**
		 * Trie cette liste de mots, du plus proche au plus éloigné d'un mot initial (selon la 
		 * distance de Levenshtein).
		 * 
		 * @param word
		 * Le mot de départ.
		 * 
		 * @param list
		 * La liste de mots.
		 * 
		 * @param maxDistance
		 * La distance maximale acceptée. Si zéro, aucun mot ne sera retiré de la liste finale.
		 * 
		 * @return
		 * Un tableau trié des mots les plus proches.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var s = "nicolas";
		 * 		var list : Array = ["bertrand", "nico", "nicole", "nicholas", "nick", "robert"];
		 * 		
		 * 		trace(UString.getNearestWord(s, list)); // affiche "nicholas,nicole,nico,nick,bertrand,robert"
		 * 	</pre>
		 * </listing>
		 * 
		 */
		public static function getNearestWord(word : String, list : Array, maxDistance : uint = 0) : Array {
			
			var sortedWords : Array = [];
			
			var l : uint = list.length;
			var i : uint = 0;
			while (i < l) {
				var dist : uint = getWordDistance(word, list[i]);
				if (maxDistance == 0 || dist < maxDistance)
					sortedWords.push({word : list[i], distance : dist});
				
				i++;
			}
			
			sortedWords = sortedWords.sortOn("distance", Array.NUMERIC);
			
			var returnedWords : Array = [];
			l = sortedWords.length;
			i = 0;
			while (i < l) {
				returnedWords[i] = sortedWords[i].word;
				i++;
			}
						
			return returnedWords;
		}

		
		/**
		 * Génère un String en random (par ex pour un password)
		 * 
		 * @param numCharacters
		 * Le nombre de caractère dans le mot à générer.
		 * 
		 * @param numbers
		 * Des nombres peuvent être insérés dans le mot.
		 * 
		 * @param lettersUpperCase
		 * Des majuscules peuvent être insérés dans le mot.
		 * 
		 * @param lettersLowerCase
		 * Des minuscules peuvent être insérés dans le mot.
		 *  
		 * @param punctuation
		 * Des ponctuations peuvent être insérés dans le mot.
		 *  
		 * @return
		 * Un mot composé de lettres au hasard.
		 * 
		 */		
		public static function getRandomString(numCharacters : uint, numbers : Boolean = true, lettersUpperCase : Boolean = true, lettersLowerCase : Boolean = true, punctuation : Boolean = true) : String {
			var str : String = "";
			var i : uint = 0;
	
			var ranges : Array = [];
			if (numbers)
				ranges.push(NUMBER_RANGE);
	
			if (lettersUpperCase)
				ranges.push(UPPERCASE_RANGE);
	
			if (lettersLowerCase)
				ranges.push(LOWERCASE_RANGE);
	
			if (punctuation)
				ranges.push(PUNCTUATION_RANGE);
	
			if (ranges.length == 0) {
				throw(new Error("UString error, randomString : you must at least choose one range"));
			}
	
	
			while (i < numCharacters) {
				str += String.fromCharCode(Number(UArray.getRandomValue(UArray.getRandomValue(ranges) as Array)));
				i++;
			}
	
			return str;
		}

		
		/**
		 * Formate un nombre pour qu'il soit lisible (ajout de caractères entre les milliers et 
		 * choix du caractère séparateur entre entier et décimale).
		 * 
		 * @param n
		 * Le nombre à formater.
		 * 
		 * @param decimalChar
		 * Le caractère de séparation entre les entiers et les décimales.
		 * 
		 * @param kiloChar
		 * Le caractère de séparation entre les milliers (ex: 20 000 à la place de 20000).
		 * 
		 * @param showDecimal
		 * Spécifie si on affiche ou non les décimales
		 * 
		 * @param numDecimal
		 * Le nombre de décimale à afficher.
		 * 
		 * @return
		 * Un String formatté selon les paramètres
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		//affiche "625 604,30"
		 * 		trace(UString.formatNumber(625604.295, ",", " ", true, 2));
		 * 		
		 * 	</pre>
		 * </listing> 
		 * 
		 * 
		 */
		public static function formatNumber(n : Number, decimalChar : String = ".", kiloChar : String = " ", showDecimal : Boolean = true, numDecimal : uint = 2) : String {
			
			if (isNaN(n)) {
				throw (new ArgumentTypeError());
			}
			
			var num : String = n.toString();
			var decimales : String = "";
			
			if (Math.floor(n) != n) {
				decimales = num.substr(num.indexOf(".") + 1, num.length);
				num = num.substr(0, num.indexOf("."));
			}
				
			var s : String = "";
			
			
			var j : uint = 0;
			for (var i : int = num.length - 1 ;i >= 0; i--) {
				if ( (j != 0) && (j % 3 == 0) )
					s += kiloChar;
				
				s += num.charAt(i);
				
				j++;
			}
			
			var s2 : String = "";
			for (var k : int = s.length - 1 ;k >= 0; k--) {
				s2 += s.charAt(k);
			}
			
			if (numDecimal != 0){
				if (showDecimal){
					if (decimales.length <= numDecimal){
						s2 += decimalChar + decimales;
						var zeroIdx : uint;
						var zeroLength : uint = (numDecimal - decimales.length);
						while (zeroIdx < zeroLength){
							s2 += "0";
							zeroIdx++;
						}
					}
					else {
						var nDecimal : Number = Number(decimales);
						nDecimal = Math.round(nDecimal / Math.pow(10, decimales.length - numDecimal));
						s2 += decimalChar + nDecimal;
					}
				}
			}
			
			return s2;
		}
		
		/**
		 * Retire les accents d'un String.
		 * liste des caractères remplacés :
		 * <ul>
		 * 	<li>àâä => a</li>
		 * 	<li>éèêë => e</li>
		 * 	<li>îï => i</li>
		 * 	<li>ôö => o</li>
		 * 	<li>ùûü => u</li>
		 * </ul>
		 * 
		 * @param str
		 * Le String auquel on veut retirer les accents.
		 * 
		 * @return
		 * Un nouveau String.
		 * 
		 */
		public static function removeAccents(str : String):String{
			var temp : String = str.replace(/[àâä]/g,"a");
			temp = temp.replace(/[éèêë]/g, "e");
			temp = temp.replace(/[îï]/g, "i");
			temp = temp.replace(/[ôö]/g, "o");
			temp = temp.replace(/[ùûü]/g, "u");
			temp = temp.replace(/[ÀÂÄ]/g,"A");
			temp = temp.replace(/[ÉÈÊË]/g, "E");
			temp = temp.replace(/[ÎÏ]/g, "I");
			temp = temp.replace(/[ÔÖ]/g, "O");
			temp = temp.replace(/[ÙÛÜ]/g, "U");
			return temp;
		}
		
		/**
		 * Retourne si la valeur booléenne d'un String (1 ou "true" = true sinon false).
		 * 
		 * @param s
		 * Le String à convertir en Booléen.
		 * 
		 * @return
		 * Un Booléen.
		 * 
		 */
		public static function parseBoolean(s : String):Boolean{
			return (isNaN(Number(s)) ? (s.toLowerCase() == "true") : (Number(s) == 1));
		}

		public static function replaceAll(source : String, search : String, replace : String) : String {
			var pattern:RegExp = new RegExp(search, "gi");  
			return source.replace(pattern, replace)
		}
		
	}
}
