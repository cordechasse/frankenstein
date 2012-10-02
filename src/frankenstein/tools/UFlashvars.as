/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import frankenstein.core.StageReference;


	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> Bruno Cherios<br />
	 * 		<b>Date </b> 01 jan 2009<br />
	 * 		<b>Version </b> 1.0.2<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour la gestion des flashvars.<br />
	 * 	<br />
	 * 	Il faut que la variable StageReference.stage ait été settée avant de pouvoir utiliser les 
	 * 	méthodes de UFlashvars.
	 * 	
	 * </p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		StageReference.stage = stage;
	 * 		
	 * 		//affiche la valeur de la flashvar lang
	 * 		trace(UFlashvars.getvar("lang"));
	 * 	</pre>
	 * </listing>
	 * 
	 * 
	 */
	public class UFlashvars {

		private static var _aFlashVars : Dictionary;
		private static var _nLength : uint = 0;
			
		
		/**
		 * @private
		 */
		private static function _init() : void {
			
			var root : DisplayObject = StageReference.stage.root;
			
			_aFlashVars = new Dictionary(); 
			
			// copy the flashvars to _aFlashVars
			// save the length and the name of the falshvars
			for (var i : String in root.loaderInfo.parameters) {
				_aFlashVars[i] = root.loaderInfo.parameters[i];
				_nLength++;
			}
		}

		
		/**
		 * 
		 * Retourne la flashvar demandée.
		 * 
		 * @param name
		 * Le nom de la flashvar
		 * 
		 * @return
		 * La valeur de la flashvar, null si elle n'existe pas.
		 */
		public static function getVar(name : String) : String {
			
			if (_aFlashVars == null)
				_init();
			
			if (_aFlashVars[name] == null)
				throw(new Error("UFlashvars Error : flashvar " + name + " is not defined"));
			
			return _aFlashVars[name];
		}

		
		/**
		 * Retourne le nombre de flashvars de l'application.
		 * 
		 */
		public static function get length() : uint {
			
			if (_aFlashVars == null)
				_init();
			
			return UDictionary.getLength(_aFlashVars);
		}

		
		/**
		 * Retourne la liste de toutes les flashvars.
		 *  
		 */
		public static function get list() : Dictionary {
			if (_aFlashVars == null)
				_init();
			
			return _aFlashVars;
		} 

		
		/**
		 * Retourne si une flashvar existe.
		 * 
		 * @param name
		 * Le nom de la flashvar.
		 * 
		 * @return
		 * Elle existe oui / non.
		 */
		public static function doesVarExist(name : String) : Boolean {
			if (_aFlashVars == null)
				_init();
	
			if (_aFlashVars[name] == null)
	    	    return false;
	    	else
	        	return true;
		}
		
		/**
		 * Ajoute une Flashvar à la liste des flashvars disponibles.
		 * Peut-être utile pour simuler des flashvars dans l'IDE.
		 * 
		 * @param name
		 * Le nom de la flashvar à ajouter.
		 * 
		 * @param value
		 * La valeur de la flashvar
		 * 
		 * @throws Error
		 * Erreur renvoyé lorsque l'on essaie d'ajouter une flashvar alors qu'une du même nom existe dejà.
		 */
		public static function addVar(name : String, value : String):void{
			if (_aFlashVars == null)
				_init();
			
			if (UDictionary.containsKey(_aFlashVars, name))
				throw(new Error("UFlashvars Error : Trying to add an existing flashvar"));
			
			_aFlashVars[name] = value;
		}
	}
}
