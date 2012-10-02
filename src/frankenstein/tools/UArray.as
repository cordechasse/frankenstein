/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 27 nov 2008<br />
	 * 		<b>Version </b> 1.1.0<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>NicoBush v1.0.0</li>
	 * 				<li>NicoBush v1.1.0 : ajout de la méthode getIdxItem</li>
	 * 			</ul>
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour les Array
	 * </p>
	 * 
	 * @see Array
	 * 
	 */
	public class UArray {

		/**
		 * Mélange le contenu d'un tableau
		 * 
		 * @params a
		 * Le tableau.
		 * 
		 * @return a
		 * Le nouveau tableau, le données mélangées. 
		 */
		public static function randomize(a : Array) : Array {
			
			var _randomized : Array = [];
			
			var _listTmp : Array = a.concat();
			
			for (var i : uint = 0;i < a.length; i++) {
				
				var rand : uint = Math.floor(Math.random() * _listTmp.length);
				
				_randomized.push(_listTmp[rand]);
				_listTmp.splice(rand, 1);
			}
			
			
			return _randomized;
		}

		
		/**
		 * Trouve la plus petite valeur d'un tableau.
		 * 
		 * @param inArray
		 * Le tableau composé de nombres.
		 * 
		 * @return
		 * La plus petite valeur du tableau.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var numberArray:Array = new Array(2, 1, 5, 4, 3);
		 * 		trace("La plus petite valeur est: " + UArray.getLowestValue(numberArray));
		 * 	</pre>
		 * </listing>
		 */
		public static function getLowestValue(inArray : Array) : Number {
			return inArray[inArray.sort(16 | 8)[0]];
		}

		
		/**
		 * Trouve la plus grande valeur d'un tableau.
		 * 
		 * @param inArray
		 * Le tableau composé de nombres.
		 * 
		 * @return
		 * La plus grande valeur du tableau.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var numberArray:Array = new Array(2, 1, 5, 4, 3);
		 * 		trace("La plus grande valeur est: " + UArray.getHighestValue(numberArray));
		 * 	</pre>
		 * </listing>
		 */
		public static function getHighestValue(inArray : Array) : Number {
			return inArray[inArray.sort(16 | 8)[inArray.length - 1]];
		}

		/**
		 * Retourne une valeur du tableau au hasard.
		 * 
		 * @param array
		 * Le tableau.
		 * 
		 * @return
		 * Une valeur au hasard du tableau.
		 * 
		 */
		public static function getRandomValue(array : Array) : Object{
			return array[(array.length * Math.random()) >> 0];
		}
		

		
		/**
		 * Détermine si deux tableau contiennent les mêmes objets aux mêmes index.
		 * 
		 * @param first
		 * Le premier tableau.
		 * 
		 * @param second
		 * Le second tableau.
		 * 
		 * @return
		 * Un booléen.
		 * 
		 */
		public static function equals(first : Array, second : Array) : Boolean {
			var i : uint = first.length;
			if (i != second.length)
				return false;
			
			while (i--)
				if (first[i] != second[i])
					return false;
			
			return true;
		}

		
		/**
		 * Crée un nouveau tableau composé des données uniques d'un tableau
		 * 
		 * @param inArray
		 * Le tableau dans lequel on retire les élèments non-uniques.
		 * 
		 * @return
		 * Un nouveau tableau composé uniquement des donneés uniques.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var numberArray:Array = new Array(1, 2, 3, 4, 4, 4, 4, 5);
		 * 		trace(UArray.removeDuplicates(numberArray));
		 * 	</pre>
		 * </listing>
		 */
		public static function removeDuplicates(inArray : Array) : Array {
			return inArray.filter(UArray._removeDuplicatesFilter);
		}

		
		private static function _removeDuplicatesFilter(item : *, index : int, array : Array) : Boolean {
			return(array.lastIndexOf(item) == index);
		}

		
		/**
		 * Retourne si un tableau contient une valeur spécifique
		 * 
		 * @param a
		 * Le tableau à tester.
		 * 
		 * @param v
		 * La valeur à trouver.
		 * 
		 * @return
		 * Valeur présente oui / non.
		 * 
		 */
		public static function containsValue(a : Array, v : *) : Boolean {
			
			return getIdxItem(a, v) != -1;
			
			/*
			var l : uint = a.length;
			for (var i : uint = 0;i < l; i++) {
				if (a[i] == v)
					return true;
			}
			return false;
			 * 
			 */
		}
		
		
		
		public static function getIdxItem(a : Array, v : *) : int {
			var l : uint = a.length;
			for (var i : uint = 0;i < l; i++) {
				if (a[i] == v)
					return i;
			}
			return -1;
		}
		
		
		

		/**
		 * Retourne si un tableau contient un autre tableau.
		 * 
		 * @param master
		 * Le tableau à tester.
		 * 
		 * @param slave
		 * Le tableau à trouver dans le 1er.
		 * 
		 * @return
		 * Tableau présent oui / non.
		 * 
		 */
		public static function containsArray(master : Array, slave : Array) : Boolean {
			
			for (var i : uint = 0;i < slave.length; i++) {
				if (!containsValue(master, slave[i]))
					return false;
			}
			
			return true;
		}

		
		/**
		 * Retire tous les éléments demandés d'un tableau.
		 * 
		 * @param a
		 * Le tableau de départ.
		 * 
		 * @param item
		 * L'item à supprimer du tableau.
		 * 
		 * @return
		 * Un nouveau tableau sans les items demandés. 
		 * 
		 */
		public static function removeItem(a : Array, item : *) : Array {
			var newArray : Array = a.concat();
			var i : int = newArray.indexOf(item);
			
			while (i != -1) {
				newArray.splice(i, 1);
				
				i = newArray.indexOf(item, i);
			}
			
			return newArray;
		}

		
		/**
		 * Concatène plusieurs tableaux entre eux pour obtenir 1 seul tableau.
		 * 
		 * @param arrays
		 * Liste des tableaux à concaténer.
		 * 
		 * @return
		 * Le tableau qui contient tous les autres.
		 */
		public static function concatMultipleArrays(...arrays) : Array {
			var a : Array = [];
			var l : uint = arrays.length;
			for (var i : uint = 0;i < l; i++) {
				a = a.concat(arrays[i]);
			}
			
			return a;
		}

		/**
		 * Retourne le 1er tableau sans les valeurs contenues dans le second.
		 * 
		 * @param master
		 * Le tableau "maître".
		 * 
		 * @param slave
		 * Le tableau contenant les valeurs à retirer du tableau "maître".
		 * 
		 * @return
		 * Un nouveau tableau ne contenant que les valeurs du tableau "maître" et 
		 * non présente dans le tableau "esclave". 
		 */
		public static function less(master : Array, slave : Array) : Array {
			var a : Array = [];
			for (var i : uint = 0;i < master.length; i++) {
				if (!containsValue(slave, master[i]))
					a.push(master[i]);
			}
			return a;
		}

		
		
		/**
		 * Fait la somme de toutes les valeurs d'un tableau.
		 * 
		 * @param a
		 * Un tableau de nombre.
		 * 
		 * @return
		 * La somme de toutes les valeurs
		 * 
		 */
		public static function sum(a : Array) : Number {
			var r : Number = 0;
			var l : uint = a.length;
			var i : uint = 0;
			while (i < l) {
				r += a[i];
				i++;
			}
			
			return r;
		}

		/**
		 * Duplique un tableau.
		 * 
		 * @param a
		 * Un tableau.
		 * 
		 * @return
		 * La copie du tableau passé en paramètres.
		 *  
		 */		
		public static function clone(a : Array) : Array {
			return a.concat();
		}

		
		/**
		 * Supprime les éléments du tableau dont la valeur est vide ("" ou null ou undefined).
		 * 
		 * @param a
		 * Le tableau à nettoyer.
		 * 
		 * @return
		 * Le tableau nettoyé.
		 * 
		 */
		public static function clean(a : Array) : Array {
	
			var b : Array = [];
			var l : uint = a.length;
	
			var i : uint = 0;
			var j : uint = 0;
	
	
			while (i < l) {
				if (a[i] != "" && a[i] != undefined && a[i] != null) {
					b[j] = a[i];
					j++;
				}
	
				i++;
			}
	
	
			return b;
		}
	}
}

