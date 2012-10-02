/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	import flash.geom.Point;	

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> t.lepore<br />
	 * 		<b>Date </b> 15 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>v1.0.0 by NicoBush</li>
	 * 				<li>v1.0.1 bt NicoBush : Retrait des méthodes inutiles exabyte2bit, exabit2bit,
	 * 				petabit2bit, petabyte2bit, terabit2bit, terabyte2bit</li>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour opérations mathématiques.
	 * </p>
	 */
	public class UMath {

		
		/**
		 * Byte value.
		 */
		protected static const BYTE : Number = 8;

		/**
		 * Kilobit value.
		 */
		protected static const KILOBIT : Number = 1024;

		/**
		 * Kilobyte value.
		 */
		protected static const KILOBYTE : Number = 8192;

		/**
		 * Mega bit value.
		 */
		protected static const MEGABIT : Number = 1048576;

		/**
		 * Megabyte value.
		 */
		protected static const MEGABYTE : Number = 8388608;

		/**
		 * Gigabit value.
		 */
		protected static const GIGABIT : Number = 1073741824;

		/**
		 * Gigabyte value.
		 */
		protected static const GIGABYTE : Number = 8589934592;

		
		
		/**
		 * Convertit des degrés en Radians.
		 * 
		 * @param ang
		 * angle en degrés à convertir.
		 * 
		 * @return
		 * L'angle en radians.
		 */
		public static function deg2rad(ang : Number) : Number {
			return ang * Math.PI / 180;
		}

		
		/**
		 * Convertit des radians en degrés.
		 * 
		 * @param ang
		 * Angle en radians à convertir.
		 * 
		 * @return
		 * L'angle en degrés.
		 */
		public static function rad2deg(ang : Number) : Number {
			return ang * 180 / Math.PI;
		}

		
		
		/**
		 * Définit l'équation d'une droite à partir de deux points (y = ax + b).
		 * 
		 * @param p0
		 * Le premier point.
		 * 
		 * @param p1
		 * Le deuxieme point.
		 * 
		 * @return
		 * Un objet o : {a , b}
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		//on définit les deux points
		 * 		var point0 : Point = new Point(36, 42);
		 * 		var point1 : Point = new Point(85, 116);
		 * 		
		 * 		//on calcule l'équation
		 * 		var eq : Object = UMath.getLineEquation(point0, point1);
		 * 		
		 * 		trace("le point en x = 100 présent sur la droite a pour y : " + (eq.a * 100 + eq.b))
		 * 	</pre>
		 * </listing>
		 */
		public static function getLineEquation(p0 : Point, p1 : Point) : Object {
			var a : Number = (p1.y - p0.y) / (p1.x - p0.x);
			var b : Number = p0.y - a * p0.x; 
					
			var o : Object = {};
			o.a = a;
			o.b = b;
			return o;
		}

		
		/**
		 * Rotationne un point selon un angle.
		 * 
		 * @param point
		 * Le point réference.
		 * 
		 * @param angle
		 * L'angle à appliquer.
		 * 
		 * @param isRadian
		 * On utilise ou non des radians.
		 * 
		 * @return
		 * Le point résultat.
		 */
		public static function rotatePoint(point : Point, angle : Number, isRadian : Boolean = false) : Point {
			if (angle == 0) return point.clone();
			var radAngle : Number = isRadian ? angle : deg2rad(angle);
			var angleCos : Number = Math.cos(radAngle);
			var angleSin : Number = Math.sin(radAngle);
			return new Point(point.x * angleCos - point.y * angleSin, point.x * angleSin + point.y * angleCos);
		}

		
		
		/**
		 * Retourne un angle positif entre 0 et 360 (ou 0 et PI/2 si radian).
		 * 
		 * @param a
		 * L'angle.
		 * 
		 * @param isRadian
		 * On utilise ou non des radians.
		 * 
		 * @return
		 * Le nouvel angle 
		 */
		public static function resolveAngle(a : Number, isRadian : Boolean = true) : Number {
			var circleAngle : Number = isRadian ? 2 * Math.PI : 360;
			
			var mod : Number = a % circleAngle;
			return (mod < 0) ? circleAngle + mod : mod;
		}

		
		
		/**
		 * Convertit des Fahrenheit en Celsius.
		 * 
		 * @param f
		 * La valeur en Fahrenheit.
		 * 
		 * @param p
		 * Le nombre de décimale demandée.
		 * 
		 * @return
		 * La valeur en Celsius.
		 */
		public static function toCelsius(f : Number,p : Number = 2) : Number {
			var d : String;
			var r : Number = (5 / 9) * (f - 32);
			var s : Array = r.toString().split(".");
			if (s[1] != undefined) d = s[1].substr(0, p); else {
				var i : Number = p;
				while (i > 0) {
					d += "0";
					i--;
				}
			}
			var c : String = s[0] + "." + d;
			return Number(c);
		}

		
		/**
		 * Convertit des Celsius en Fahrenheit.
		 * 
		 * @param c
		 * la valeur en Celsius.
		 * 
		 * @param p
		 * Le nombre de décimale demandée.
		 * 
		 * @return
		 * La valeur en Fahrenheit.
		 */
		public static function toFahrenheit(c : Number, p : Number = 2) : Number {
			var d : String;
			var r : Number = (c / (5 / 9)) + 32;
			var s : Array = r.toString().split(".");
			if (s[1] != undefined) d = s[1].substr(0, p); else {
				var i : Number = p;
				while (i > 0) {
					d += "0";
					i--;
				}
			}
			var f : String = s[0] + "." + d;
			return Number(f);		
		}

		
		
		/**
		 * Retourne le nombre dans les bornes spécifiées (bornes comprises).
		 * 
		 * @param n
		 * Le nombre à utiliser.
		 * 
		 * @param min
		 * La valeur minimale.
		 * 
		 * @param max
		 * La valeur maximale.
		 * 
		 * @return
		 * Le nombre dans les bornes.
		 */
		public static function boundaryRestrict(n : Number, min : Number, max : Number) : Number {
			var _min : Number;
			var _max : Number;
			
			if (min > max) {
				_min = max;
				_max = min;
			} else {
				_min = min;
				_max = max;
			}
			
			if (n < _min)
				return _min;
			if (n > _max)
				return _max;
			
			return n;
		}

		
		/**
		 * Retourne le nombre s'il est inclu dans les bornes,
		 * la valeur max s'il est inférieur à la plus petite borne,
		 * la valeur min s'il est supérieur à la plus grande borne.
		 * 
		 * @param n 
		 * Le nombre à utiliser.
		 * 
		 * @param min
		 * La valeur minimale.
		 * 
		 * @param max
		 * La valeur maximale.
		 * 
		 * @param loopOnExtreme
		 * Définit si lorsqu'une valeur sort des bornes, si on prend la valeur max opposée
		 * ou si on calcule les valeurs intermediaires.
		 * 
		 * @return
		 * Le nombre dans les bornes en repartant de la borne inverse.
		 */
		public static function boundaryLoop(n : int, min : int, max : int, loopOnExtreme : Boolean = false) : Number {
			var _min : int;
			var _max : int;
	
			if (min > max) {
				_min = max;
				_max = min;
			} else {
				_min = min;
				_max = max;
			}
	
	
			if (n < _min) {
				if (loopOnExtreme)
					return _max;
				
				var modMin : Number = (_min - n) % (min - _max - 1);
				if (modMin == 0) {
					n = _min;
				} else {
					n = _max - (modMin - _min) + 1;
				}
				n = _max - modMin + 1;
			}
		
			if (n > _max) {
				
				if (loopOnExtreme)
					return _min;
				
				var modMax : Number = (n - _max) % (_max - min + 1);
				if (modMax == 0) {
					n = _max;
				} else {
					n = (modMax - 1) + _min;
				}
			}
	
	
			return n;
		}

		
		
		
		/**
		 * Retourne si un nombre est dans les bornes specifiées.
		 * 
		 * @param n
		 * Le nombre à utiliser.
		 * 
		 * @param min
		 * La valeur minimale.
		 * 
		 * @param max
		 * La valeur maximale.
		 * 
		 * @return
		 * Un booléen.
		 */
		public static function isInBoundary(n : Number, min : Number, max : Number) : Boolean {
			return n == boundaryRestrict(n, min, max);
		}

		
		/**
		 * Retourne un nombre au hasard dans les bornes specifiées.
		 * 
		 * @param min
		 * La valeur minimale.
		 * 
		 * @param max
		 * La valeur maximale.
		 * 
		 * @return
		 * Le nombre au hasard.
		 */
		public static function getRandomInBoundary(min : Number, max : Number, float : Boolean = false) : Number {
			var n : Number = min + Math.random() * (max - min + (float ? 0 : 1)); 
			return float ? n : n >> 0;
		}

		
		
		
		/**
		 * Convertit des octets en MegaOctets.
		 * 
		 * @param n
		 * Le nombre à convertir.
		 */
		public static function byte2Megabyte(n : Number) : Number {
			return n / MEGABIT;
		}

		
		/**
		 * Convertit des octets en KiloOctets.
		 * 
		 * @param n
		 * Le nombre à convertir.
		 */
		public static function byte2Kilobyte(n : Number) : Number {
			return n / KILOBIT;
		}

		
		/**
		 * Convertit des octets en bit.
		 * 
		 * @param n
		 * Le nombre à convertir.
		 */
		public static function byte2bit(n : Number) : Number {
			return n * BYTE;
		}

		
		/**
		 * Convertit des KiloBits en bit.
		 * 
		 * @param n
		 * Le nombre à convertir.
		 */
		public static function kilobit2bit(n : Number) : Number {
			return n * KILOBIT;
		}

		
		/**
		 * Convertit des KiloOctets en bits.
		 * 
		 * @param n
		 * Le nombre à convertir.
		 */
		public static function kilobyte2bit(n : Number) : Number {
			return n * KILOBYTE;	
		}

		
		/**
		 * Convertit des MegaOctets en bits.
		 * 
		 * @param n
		 * Le nombre à convertir.
		 */
		public static function megabit2bit(n : Number) : Number {
			return n * MEGABIT;
		}

		
		/**
		 * Convertit des MegaOctets en bits.
		 * 
		 * @param n
		 * Le nombre à convertir.
		 */
		public static function megabyte2bit(n : Number) : Number {
			return n * MEGABYTE;
		}			

		
		/**
		 * Convertit des GigaBit en bits.
		 * 
		 * @param n
		 * Le nombre à convertir.
		 */
		public static function gigabit2bit(n : Number) : Number {
			return n * GIGABIT;
		}

		
		/**
		 * Convertit des GigaOctets en bits.
		 * 
		 * @param n
		 * Le nombre à convertir.
		 */
		public static function gigabyte2bit(n : Number) : Number {
			return n * GIGABYTE;
		}
		
	
	}
}
