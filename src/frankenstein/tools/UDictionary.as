/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	import flash.utils.Dictionary;	
	
	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 9 janvier 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour la gestion des Dictionnaires. 
	 * </p>
	 */ 
	public class UDictionary {
		
		/**
		 * Retourne le nombre d'éléments stockés dans un Dictionnaire.
		 * 
		 * @param dictionnary
		 * Le dictionnaire à tester.
		 * 
		 * @return
		 * Le nombre d'éléments du Dictionnaire
		 */
		public static function getLength(dictionnary : Dictionary):uint {
			var total : uint = 0;
			for (var i : Object in dictionnary) {
				total++;
			}
			
			return total;
		}
		
		
		/**
		 * Retourne si un dictionnaire contient une clef spécifique.
		 * 
		 * @param dictionnary
		 * Le dictionnaire à tester.
		 * 
		 * @param key
		 * La clef à trouver dans le dictionnaire.
		 * 
		 */
		public static function containsKey(dictionary:Dictionary, key:Object):Boolean{
			for (var i : Object in dictionary) {
				if (i == key)
					return true;
			}
			
			return false;
		}
		
		
		/**
		 * Retourne si un dictionnaire contient une valeur spécifique.
		 * 
		 * @param dictionnary
		 * Le dictionnaire à tester.
		 * 
		 * @param value
		 * La valeur à trouver dans le dictionnaire.
		 * 
		 */
		public static function containsValue(dictionary:Dictionary, value:Object):Boolean{
			for (var i : Object in dictionary) {
				if (dictionary[i] == value)
					return true;
			}
			
			return false;
		}
		
		/**
		 * Retourne la liste des clefs d'un dictionnaire.
		 * 
		 * @param dictionnary
		 * Le dictionnaire.
		 * 
		 * @return
		 * Un tableau contenant toutes les clefs.
		 */
		public static function getKeys(dictionary:Dictionary):Array{
			var a : Array = [];
			for (var i : Object in dictionary) {
				a.push(i);
			}
			
			return a;	
		}
		
		
		/**
		 * Retourne une clef selon la valeur dans un dictionnaire (dictionnaire inversé).
		 * 
		 * @param dictionnary
		 * Le dictionnaire.
		 * 
		 * @return
		 * La 1ère clef trouvée.
		 */	
		public static function getKeyByValue(dictionary:Dictionary, value : Object):Object{
			for (var i : Object in dictionary) {
				if (dictionary[i] == value)
					return i;
			}
			
			return null;
		}
		
		
	}
}
