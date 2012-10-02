/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.net {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * 
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 16 septembre 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * 
	 * <p>La classe Cache permet d'associer des données chargées à des chemins.<br />
	 * Grâce à ses méthodes statiques, il est possible de sauvegarder et récuper : 
	 * <ul>
	 * 		<li>des données au format XML</li>
	 * 		<li>des données au format binaire</li>
	 * </ul>
	 * 
	 * Cette classe peut potentiellement causer des problèmes de surchage de la mémoire.
	 * </p>
	 * 
	 * @example
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 	
	 * 		// Après un chargement de données (l'ajout en cache est automatisé par ScriptLoader et AdvancedLoader)
	 *		var data : XML = _scriptLoader.data;
	 *		
	 *		Cache.addXMLData("script.aspx", data);
	 *		
	 *		...
	 *		
	 *		// Dans une autre classe, si l'on veut récupérer les données
	 *		var data : XML = Cache.getXMLData("script.aspx");
	 *		
	 *		...
	 *		
	 *		// Plus tard, si de la mémoire doit être libérée
	 *		Cache.removeXMLData("script.aspx");
	 *		
	 *		// On peut vider complement le cache avec ces méthodes
	 *		Cache.flushXMLData();
	 *		Cache.flush(); // Revient à appelléer flushXMLData() et flushBytesArray() consécutivement
	 *		
	 * 	</pre>
	 * </listing> 
	 * 
	 * @see frankenstein.net.ScriptLoader
	 * @see frankenstein.net.AdvancedLoader
	 * 
	 * @author n.bush
	 * @project frankenstein
	 * @date 16 sept. 2009
	 * @desc 
	 */
	public class Cache {
		
		private static var _storedBytesArray : Dictionary = new Dictionary(true);
		private static var _storedXML : Dictionary = new Dictionary(true);
		
		/**
		 * Vide le cache.</br>
		 * Revient à appelléer flushXMLData() et flushBytesArray() consécutivement.
		 */
		public static function flush():void{
			flushBytesArray();	
			flushXMLData();	
		}
		
		//--------------------------------------
		//					TEXTDATA
		//--------------------------------------
		
		/**
		 * Renvoie l'objet XML associé au chemin dans le cache.<br />
		 * Renvoie "null" si le chemin est inconnu.
		 * 
		 * @param path
		 * Le chemin associé à l'objet XML.
		 * 
		 * @return
		 * Un objet XML
		 * 
		 */
		public static function getXMLData(path : String) : XML {
			return _storedXML[path];	
		}
		
		/**
		 * Ajoute l'objet XML associé au chemin.<br />
		 * Si le chemin existe déjà, le contenu est remplacé par le nouvel objet XML.
		 * 
		 * @param path
		 * Le chemin à associer à l'objet XML
		 * 
		 * @param xml
		 * L'objet XML à mettre en cache.
		 * 
		 */
		public static function addXMLData(path : String, xml : XML):void{
			_storedXML[path] = xml;
		}
		
		/**
		 * Supprime l'objet XML associé au chemin.
		 * 
		 * @param path
		 * Le chemin associé à l'objet XML.
		 * 
		 */
		public static function removeXMLData(path : String):void{
			_storedXML[path] = null;
		}
		
		/**
		 * Supprime du cache tous les objets XML enregistrés
		 * 
		 * @return void
		 */		
		public static function flushXMLData():void{
			_storedXML = new Dictionary(true);
		}

		
		//--------------------------------------
		//					BYTE ARRAY
		//--------------------------------------
		
		/**
		 * Renvoie l'objet ByteArray associé au chemin dans le cache.<br />
		 * Renvoie "null" si le chemin est inconnu.
		 * 
		 * @param path
		 * Le chemin associé à l'objet ByteArray.
		 * 
		 * @return
		 * Un objet ByteArray.
		 */
		public static function getByteArray(path : String) : ByteArray {
			return _storedBytesArray[path];
		}
		
		/**
		 * Ajoute l'objet ByteArray associé au chemin.<br />
		 * Si le chemin existe déjà, le contenu est remplacé par le nouvel objet ByteArray
		 * 
		 * @param path
		 * Le chemin à associer à l'objet ByteArray.
		 * 
		 * @param xml
		 * L'objet ByteArray à mettre en cache.
		 */
		public static function addByteArray(path : String, byteArray : ByteArray):void{
			_storedBytesArray[path] = byteArray;
		}
		
		/**
		 * Supprime l'objet ByteArray associé au chemin.
		 * 
		 * @param path
		 * Le chemin associé à l'objet ByteArray.
		 * 
		 */
		public static function removeByteArray(path : String):void{
			_storedBytesArray[path] = null;
		}
		
		/**
		 * Supprime du cache tous les objets ByteArray enregistrés
		 */	
		public static function flushBytesArray():void{
			_storedBytesArray = new Dictionary(true);
		}
	}
}
