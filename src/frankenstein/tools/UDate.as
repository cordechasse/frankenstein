/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 4 août 2008<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>v1.0.0 by Nicobush</li>
	 * 				<li>v1.0.1 by Nicobush : ajout de la méthode getUSClockTime</li>
	 * 			</ul>
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour la gestion des dates : 
	 * 	<ul>
	 * 		<li>conversions</li>
	 * 		<li>formattage</li>
	 * 		<li>...</li>
	 * 	</ul>
	 * </p>
	 * @example
	 *  <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		var d : Date = new Date();
	 * 		var s : String = UDate.date2String(d, "dd/MM/yyyy HH:mm:SS");
	 * 		trace(s); //affiche 11/03/2010 11:10:25
	 * 	</pre>
	 * </listing>
	 * <p>
	 * 	Format des patterns pour string2Date et date2String (avec exemples pour le Lundi 25 Juin 1998 14h 31min 55s 14ms): 
	 * 	<ul>
	 * 		<li>yy : année sur 2 digits (ex: 98)</li>
	 * 		<li>yyyy : année sur 4 digits (ex: 1998)</li>
	 * 		<li>MM : mois en nombre (ex: 06)</li>
	 * 		<li>MMM : mois en String (format court) (ex: "Jun"), défini par la variable statique MONTHS_SHORT</li>
	 * 		<li>MMMM : mois en String (format long) (ex: "June"), défini par la variable statique MONTHS</li>
	 * 		<li>dd : jour de la semaine en nombre (ex: 25)</li>
	 * 		<li>D : jour de la semaine en String (format court) (ex: Mon), défini par la variable statique WEEKDAY_SHORT</li>
	 * 		<li>DD : jour de la semaine en String (format long) (ex: Monday), défini par la variable statique WEEKDAY</li>
	 * 		<li>HH : heures (ex: 14)</li>
	 * 		<li>mm : minutes (ex: 31)</li>
	 * 		<li>SS : secondes (ex: 55)</li>
	 * 		<li>ss : millisecondes (ex: 14)</li>
	 * 		<li>o : zone offset au format +0100</li>
	 * 		<li>O : zone offset au format +01:00</li>
	 * 	</ul>	
	 * </p>
	 * 
	 */
	public class UDate {

		/**
		 *	Liste des mois au format long.
		 */
		public static var MONTHS : Array = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");

		/**
		 * Liste des mois au format court.
		 */
		public static var MONTHS_SHORT : Array = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");

		/**
		 * Liste des jours de la semaine au format long (dimanche est le 1er jour de la semaine).
		 */
		public static var WEEKDAY : Array = new Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");

		/**
		 * Liste des jours de la semaine au format court (dimanche est le 1er jour de la semaine).
		 */
		public static var WEEKDAY_SHORT : Array = new Array("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");

		
		/**
		 * Ajoute des millisecondes à une date.
		 * 
		 * @param d
		 * La date à laquelle on ajoute les millisecondes.
		 * 
		 * @param milli
		 * Les millisecondes.
		 * 
		 * @return
		 * La nouvelle date
		 * 
		 */
		public static function addMilliseconds( d : Date , milli : Number ) : Date {
			var date : Date = new Date(d.getTime() + milli);
			return date;
		}

		
		/**
		 * Convertit des millisecondes en secondes, millisecondes.
		 * 
		 * @param millisec
		 * Temps en millisecondes.
		 * 
		 * @return
		 * Un object au format {seconds, milliseconds}.
		 * 
		 */
		public static function convertMillisec2Seconds( millisec : Number) : Object {
			var mil : uint = millisec % 1000;
			var sec : uint = Math.floor(millisec / 1000);
			
			var oReturn : Object = {
				milliseconds : mil, seconds : sec
			};
			
			return oReturn;
		}

		
		/**
		 * Convertit des millisecondes en minutes, secondes, millisecondes.
		 * 
		 * @param millisec
		 * Temps en millisecondes.
		 * 
		 * @return
		 * Un object au format {minutes, seconds, milliseconds}.
		 * 
		 */
		public static function convertMillisec2Minutes( millisec : Number) : Object {
			var oSeconds : Object = convertMillisec2Seconds(millisec);
			
			var sec : uint = oSeconds.seconds % 60;
			var min : uint = Math.floor(oSeconds.seconds / 60); 
			
			var oReturn : Object = {
				milliseconds : oSeconds.milliseconds, seconds : sec, minutes : min
			};
			
			return oReturn;
		}

		
		/**
		 * Convertit des millisecondes en heures, minutes, secondes, millisecondes.
		 * 
		 * @param millisec
		 * Temps en millisecondes.
		 * 
		 * @return
		 * Un object au format {hours, minutes, seconds, milliseconds}.
		 */
		public static function convertMillisec2Hours( millisec : Number) : Object {
			var oMinutes : Object = convertMillisec2Minutes(millisec);
			
			var min : uint = oMinutes.minutes % 60;
			var hours : uint = Math.floor(oMinutes.minutes / 60); 
			
			var oReturn : Object = {
				milliseconds : oMinutes.milliseconds, seconds : oMinutes.seconds, minutes : min, hours : hours
			};
		
			return oReturn;
		}

		
		/**
		 * Convertit des millisecondes en jours, heures, minutes, secondes, millisecondes.
		 * 
		 * @param millisec
		 * Temps en millisecondes.
		 * 
		 * @return
		 * Un object au format {days, hours, minutes, seconds, milliseconds}.
		 */
		public static function convertMillisec2Days( millisec : Number) : Object {
			var oHours : Object = convertMillisec2Hours(millisec);
			
			var hours : uint = oHours.hours % 24;
			var days : uint = Math.floor(oHours.hours / 24); 
			
			var oReturn : Object = {
				milliseconds : oHours.milliseconds, seconds : oHours.seconds, minutes : oHours.minutes, hours : hours, days : days
			};
			
			return oReturn;
		}

		
		
		/**
		 * Formatte un objet Date en String selon un pattern particulier.
		 * 
		 * @param d
		 * La date à formatter.
		 * 
		 * @param pattern
		 * Le pattern à appliquer.
		 * 
		 * @param escapeChar
		 * Caractère empechant l'interprétation du caractère suivant.
		 * 
		 * @return
		 * La date formatée en String.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var d : Date = new Date();
		 * 		var s : String = UDate.date2String(d, "dd/MM/yyyy HH:mm:SS");
		 * 		trace(s); //affiche 11/03/2010 11:10:25
		 * 	</pre>
		 * </listing>
		 */
		public static function date2String( d : Date, pattern : String , escapeChar : String = "@" ) : String {
			var i : uint = 0;
			var l : uint = pattern.length;
			var result : String = "";
			escapeChar = escapeChar == null ? "@" : escapeChar;
			
			while( i < l ) {
				var char : String = pattern.charAt(i);
				var pat : String = char;
				
				if( char == escapeChar ) {
					result += pattern.charAt(++i);
					++i;
					continue;
				}
				
				while( pattern.charAt(++i) == char && i < l ) pat += char;
				
				result += __convertPattern(pat, d);
			}
			
			return result;
		}

		
		/**
		 * Convertit une date String en objet Date.
		 * 
		 * @param from
		 * La date String à convertir.
		 * 
		 * @param format
		 * Le format de la date.
		 * 
		 * @param caseSensitive
		 * Sensible à la casse.
		 * 
		 * @param autoAddOverflow
		 * Accepte les dates non valides (ex: mois n°13).
		 *  
		 * @return
		 * La date formatée en String
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var s : String = "11/03/2010 11:10:25";
		 * 		var d : Date = UDate.string2Date(s, "dd/MM/yyyy HH:mm:SS")
		 * 		trace(d); //affiche Thu Mar 11 11:10:25 GMT+0100 2010 (trace de l'objet Date)
		 * 	</pre>
		 * </listing>
		 * 
		 */
		public static function string2Date( from : String , format : String , caseSensitive : Boolean = false , autoAddOverflow : Boolean = false ) : Date {
			var i : uint = 0;
			var searchIndex : uint = 0;
			var l : uint = format.length;
			var y : uint = 0;
			var mo : uint = 0;
			var d : uint = 0;
			var h : uint = 0;
			var mi : uint = 0;
			var s : uint = 0;
			var ms : uint = 0;
			var o : uint = 0;
			
			var str : String;
			var index : uint;
			
			while( i < l ) {
				var char : String = format.charAt(i);
				var pattern : String = char;
				
				while( format.charAt(++i) == char && i < l ) pattern += char;

				switch( true ) {
					case pattern == "yy"	: 
					
						str = from.substr(searchIndex, 2);
						if( !__testInteger(str) ) return null;
						
						y = uint(String(new Date().getFullYear()).substr(2) + str);
						searchIndex += 2;
						break;
					
					case pattern == "yyyy"	:
					
						str = from.substr(searchIndex, 4);
						if(!__testInteger(str)) return null;
					
						y = uint(str);
						searchIndex += 4;
						break;
					
					case pattern == "MM"	:
					
						mo = uint(from.substr(searchIndex, 2)) - 1;
						
						if( ( mo < 0 || mo > 11 ) && !autoAddOverflow ) return null;
						
						searchIndex += 2;
						break;
					
					case pattern == "MMM"	:
					
						mo = __searchArrayIndex(from.substr(searchIndex, 3), MONTHS_SHORT, caseSensitive);
						
						if( ( mo < 0 || mo > 11 ) && !autoAddOverflow ) return null;
						
						searchIndex += 3;
						break;
					
					case pattern == "MMMM"	:
					
						mo = __searchArrayIndex(from.substr(searchIndex, 3), MONTHS, caseSensitive);
						
						if( ( mo < 0 || mo > 11 ) && !autoAddOverflow) return null;
						
						searchIndex += String(MONTHS[mo]).length;
						break;
					
					case pattern == "dd"	:
						
						str = from.substr(searchIndex, 2);
						
						if( !__testInteger(str) ) return null;
						
						d = uint(str);
						searchIndex += 2;
						break;
						
					case pattern == "D"		:
					
						index = __searchArrayIndex(from.substr(searchIndex, 3), WEEKDAY_SHORT, caseSensitive);
						
						if( !index ) return null;
						
						str = String(WEEKDAY_SHORT[index]);
					
						searchIndex += str.length;
						break;
					
					case pattern == "DD"	:
					
						index = __searchArrayIndex(from.substr(searchIndex, 3), WEEKDAY, caseSensitive);
						
						if( !index ) return null;
						
						str = String(WEEKDAY[ index ]);
					
						searchIndex += str.length;
						break;
					
					case pattern == "HH"	:
					
						h = uint(from.substr(searchIndex, 2));
						
						if( ( h < 0 || h > 23 ) && !autoAddOverflow) return null;
						
						searchIndex += 2;
						break;
					
					case pattern == "mm"	:
					
						mi = uint(from.substr(searchIndex, 2));
						
						if( ( mi < 0 || mi > 59 ) && !autoAddOverflow ) return null;
						
						searchIndex += 2;
						break;
					
					case pattern == "SS"	:
					
						s = uint(from.substr(searchIndex, 2));
						
						if((mo < 0 || mo > 59) && !autoAddOverflow) return null;
						
						searchIndex += 2;
						break;
						
					case pattern == "ss"	:
					
						ms = uint(from.substr(searchIndex, 2));
						
						if((ms < 0 || ms > 999) && !autoAddOverflow) return null;
						
						searchIndex += 2;
						break;
					
					case pattern == "o"		:
					
						str = from.substr(searchIndex, 5);
						
						if( !__testTimezoneOffset(str) ) return null;
						
						o = __timezoneOffset2Number(str) * 60000;
						searchIndex += 5;
						break;
					
					case pattern == "O"		:
						
						str = from.substr(searchIndex, 6);
						
						if( !__testTimezoneOffset(str, true) ) return null;
						
						o = __timezoneOffset2Number(str, true) * 60000;
						searchIndex += 6;
						break;
					
					default					:
						
						if( from.substr(searchIndex, pattern.length) != pattern ) return null;
						
						searchIndex += pattern.length;
						break;
				}
			}
			
			// check month length if overflow is disabled
			if( !autoAddOverflow ) {
				if( mo == 1 ) {
					if ( ( (y % 4 == 0 ) && ( y % 100 != 0 ) ) || ( y % 400 == 0 ) ) {
						if( d > 29 ) return null;	
					}
					else if( d > 28 ) return null;
				}
				else if ( mo == 3 || mo == 5 || mo == 8 || mo == 10 ) {
					if( d > 30 ) return null;	
				}
				else if( d > 31 ) return null;
			}
			
			// check there is no more char from source
			if( from.length > searchIndex ) return null;
			
			return new Date(y, mo, d, h, mi, s, ms);
		}

		
		/**
		 * Modifie l'affichage d'une date selon un nouveau pattern.<br />
		 * Utile si on dispose par exemple d'une date au format français (jj/mm/aaaa) et
		 * qu'on veut une date au format américain (mm/jj/aaaa).
		 * 
		 * @param date
		 * La date String à convertir.
		 * 
		 * @param previousPattern
		 * Le pattern actuel de la date.
		 * 
		 * @param newPattern
		 * Le nouveau pattern à appliquer.
		 * 
		 * @return
		 * La date formatée avec le nouveau pattern.
		 * 
		 * 
		 */
		public static function convertDate(date : String, previousPattern : String, newPattern : String) : String {
			return date2String(string2Date(date, previousPattern), newPattern);
		}

		
		
		/**
		 * @private
		 */
		private static function __convertPattern( pattern : String , d : Date ) : String {
			switch(true) {
				case pattern == "yy"	: 
					return String(d.getFullYear()).substr(2);
				case pattern == "yyyy"	: 
					return String(d.getFullYear());
				case pattern == "M"		: 
					return String(d.getMonth() + 1);
				case pattern == "MM"	: 
					return __format2Digits(d.getMonth() + 1);
				case pattern == "MMM"	: 
					return MONTHS_SHORT[d.getMonth()];
				case pattern == "MMMM"	: 
					return MONTHS[ d.getMonth() ];
				case pattern == "d"		: 
					return String(d.getDate());
				case pattern == "dd"	: 
					return __format2Digits(d.getDate());
				case pattern == "D"		: 
					return WEEKDAY_SHORT[d.getDay()];
				case pattern == "DD"	: 
					return WEEKDAY[d.getDay()];
				case pattern == "h"		: 
					return String(__hour24to12(d.getHours()));
				case pattern == "hh"	: 
					return __format2Digits(__hour24to12(d.getHours()));
				case pattern == "H"		: 
					return String(d.getHours());
				case pattern == "HH"	: 
					return __format2Digits(d.getHours());
				case pattern == "m"		: 
					return String(d.getMinutes());
				case pattern == "mm"	: 
					return __format2Digits(d.getMinutes());
				case pattern == "S"		: 
					return String(d.getSeconds());
				case pattern == "SS"	: 
					return __format2Digits(d.getSeconds());
				case pattern == "s"		: 
					return String(d.getMilliseconds());
				case pattern == "ss"	: 
					return __format2Digits(d.getMilliseconds());
				case pattern == "aa"	: 
					return d.getHours() < 12 ? "am" : "pm";
				case pattern == "AA"	: 
					return d.getHours() < 12 ? "AM" : "PM";
				case pattern == "o"		: 
					return __timezoneOffset2String(d.getTimezoneOffset());
				case pattern == "O"		: 
					return __timezoneOffset2String(d.getTimezoneOffset(), ":");
				default					:
				
					var l : Number = pattern.length;
				
					return l > 1 ? __convertPattern(pattern.substr(0, l - 1), d) + pattern.substr(l - 1) : pattern;
			}
		}

		
		/**
		 * @private
		 */
		private static function __searchArrayIndex( s : String , a : Array , caseSensitive : Boolean ) : Number {
			s = caseSensitive ? s : s.toLowerCase();
			var l : Number = a.length;
			
			for(var i : Number = 0;i < l; i++) {
				var s1 : String = caseSensitive ? String(a[ i ]) : String(a[ i ]).toLowerCase();
				
				if( s1.indexOf(s) == 0 ) return i;
			}
			
			return NaN;
		}

		
		/**
		 * @private
		 */
		private static function __testInteger( s : String ) : Boolean {
			var l : uint = s.length;
			
			for( var i : uint = 0;i < l; i++ ) {
				if( isNaN(Number(s.charAt(i))) ) return false;
			}
			
			return true;
		}

		
		/**
		 * @private
		 */
		private static function __format2Digits( n : uint ) : String {
			return n < 10 ? "0" + n : String(n);
		}

		
		/**
		 * @private
		 */
		private static function __hour24to12( h : uint ) : uint {
			return h >= 12 ? h - 12 : h;
		}

		
		/**
		 * @private
		 */
		private static function __timezoneOffset2String( n : Number , separator : String = null ) : String {
			var sign : String = n < 0 ? "+" : "-";
			var h : Number = Math.abs(n) / 60;
			var min : String = __format2Digits(( h - Math.floor(h) ) * 60);
			var hour : String = __format2Digits(Math.floor(Math.abs(n) / 60));
			separator = separator == null ? "" : separator;
	
			return sign + hour + separator + min;
		}

		
		/**
		 * @private
		 */
		private static function __timezoneOffset2Number( s : String, separator : Boolean = false ) : Number {
			var n : uint = uint(s.substr(1, 2)) * 60 + uint(s.substr(separator ? 4 : 3, 2));
			
			return s.substr(0, 1) == "+" ? -n : n;
		}

		
		/**
		 * @private
		 */
		private static function __testTimezoneOffset( s : String, separator : Boolean = false ) : Boolean {
			var a : Array = s.split("");
			
			return (a[ 0 ] == "+" || a[ 0 ] == "-") && !isNaN(a[ 1 ]) && !isNaN(a[ 2 ]) && !isNaN(a[ separator ? 4 : 3 ]) && !isNaN(a[ separator ? 5 : 4 ]);
		}

		
		/**
		 * Retourne si une date est valide (le jour existe ou non ? ex: 32/02/2010).
		 * @param date La date à tester.
		 * @param pattern Le pattern de conversion de la date.
		 * 
		 */
		public static function isValid(date : String, pattern : String) : Boolean {
			return string2Date(date, pattern) != null;	
		}

		
		/**
		 * Retourne si une personne a dépassé un certain âge.
		 * 
		 * @param birthdate
		 * La date de naissance de la personne.
		 * 
		 * @param minAge
		 * Age minimum requis.
		 * 
		 * @param today
		 * La date d'aujourd'hui. Si null, on prendra l'heure du système (new Date()).
		 * 
		 */
		public static function isOldEnough(birthdate : Date, minAge : uint, today : Date = null) : Boolean {
			
			if (today == null)
				today = new Date();
	
			if (today.getTime() < birthdate.getTime()) {
				trace("/!\\ Warning birthdate is after today");
				return true;
			}
	
	
			var destYear : uint = (today.getFullYear() - minAge);
	
			if (destYear == birthdate.getFullYear()) {
				var minusMonth : int = today.getMonth() - birthdate.getMonth();
				if (minusMonth == 0) {
					var minusDay : int = today.getDate() - birthdate.getDate();
					return minusDay >= 0;
				} else {
					return minusMonth > 0;
				}
			} else {
				return (destYear - birthdate.getFullYear()) > 0;
			}
	
			return false;
		}
		
		
		/**
		 * Retourne l'heure au format US (AM - PM)
		 * 
		 * @param hrs
		 * L'heure
		 * 
		 * @param mins
		 * Les minutes
		 * 
		 * @return
		 * L'heure au format US (ex: 03:05 PM)
		 * 
		 */
		public static function getUSClockTime(hrs:uint, mins:uint):String {
		    var modifier:String = "PM";
		    var minLabel:String = _doubleDigitFormat(mins);
		
		    if(hrs > 12) {
		        hrs = hrs-12;
		    } else if(hrs == 0) {
		        modifier = "AM";
		        hrs = 12;
		    } else if(hrs < 12) {
		        modifier = "AM";
		    }
		
		    return (_doubleDigitFormat(hrs) + ":" + minLabel + " " + modifier);
		}
		
		private static function _doubleDigitFormat(num:uint):String {
			return (num < 10) ? ("0" + num) : num.toString();
		}		
		
	}
}
