/*
 * Copyright © CorDeChasse 1999-2011
 */

﻿package frankenstein.net {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import frankenstein.events.ScriptErrorEvent;
	import frankenstein.tools.UString;


	/**
	 * Évènement diffusé à la fin du chargement du script si celui est bien formaté et ne comporte pas d'erreurs
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Évènement diffusé après le chargement, si le XML n'est pas bien formaté
	 * 
	 * @eventType frankenstein.events.ScriptErrorEvent.XML_NOT_WELL_FORMATED
	 */
	[Event(name="xml_format_error", type="frankenstein.events.ScriptErrorEvent")]

	/**
	 * Évènement diffusé après le chargement, si l'analyse du XML révèle une erreur EasyBack
	 * 
	 * @eventType frankenstein.events.ScriptErrorEvent.ERROR_RETURNED
	 */	[Event(name="error_returned", type="frankenstein.events.ScriptErrorEvent")]

	/**
	 * Évènement diffusé si le script n'a pas été trouvé
	 * 
	 * @eventType frankenstein.events.ScriptErrorEvent.SCRIPT_MISSING
	 */	[Event(name="script_missing", type="frankenstein.events.ScriptErrorEvent")]

	/**
	 * 
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 17 septembre 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * 
	 * <p>La classe ScriptLoader permet de charger des scripts back-end.<br />
	 * Elle étend la classe URLLoader et lui ajoute des fonctionnalités pour gérer plus efficacement les échanges client-serveur.
	 *  
	 * </p>
	 * 
	 * @example Utilisation de la classe
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 	
	 *		// Ce réglage de paramètre sera typiquement fait dans la classe principale du projet
	 *		ScriptLoader.DEFAULT_SCRIPTS_PATH = "http://www.site.com/scripts/";
	 *		ScriptLoader.addDefaultVariable("subsidiary", "fr");
	 *		
	 *		// si le script n'existe pas dans le cache
	 *		if( ! ScriptLoader.isScriptAlreadyLoaded("script.aspx") ){
	 *
	 *			// On crée l'objet ScriptLoader, par défault il sauvegarde le script en cache
	 *			  scriptLoader = new ScriptLoader();
	 *			  scriptLoader.addEventListener(Event.COMPLETE, _onScriptLoaded, false, 0, true);
	 *			  scriptLoader.addEventListener(ScriptErrorEvent.ERROR_RETURNED, _onErrorReturned, false, 0, true);
	 *			  scriptLoader.addEventListener(ScriptErrorEvent.SCRIPT_MISSING, _onScriptMissing, false, 0, true);
	 *			  scriptLoader.addEventListener(ScriptErrorEvent.XML_NOT_WELL_FORMATED, _onXmlNotWellFormated, false, 0, true);
	 *			  scriptLoader.load( new URLRequest("script.aspx") );
	 *			
	 *		}
	 *		
	 *		function _onScriptLoaded(e : Event) : void
	 *		{
	 *			  // La propriété data est déjà formatée au format XML
	 *			  var items : XMLList = scriptLoader.data.item;
	 *		}
	 *			
	 *		function _onXmlNotWellFormated(event : ScriptErrorEvent) : void
	 *		{
	 *		
	 *			  // Si le XML renvoyé est mal formaté
	 *	 	
	 *		}
	 *		
	 *		function _onScriptMissing(event : ScriptErrorEvent) : void
	 *		{
	 *		
	 *			  // Si le script est manquant
	 *			  trace(event.scriptUrl);
	 *		}
	 *		
	 *		function _onErrorReturned(event : ScriptErrorEvent) : void
	 *		{
	 *				// Si le script a renvoyé une erreur EasyBack
	 *			  trace(event.errorCode);
	 *			  trace(event.errorMessage);
	 *		}
	 * 	</pre>
	 * </listing>
	 * 
	 * @see frankenstein.net.Cache
	 * @see frankenstein.events.ScriptErrorEvent
	 * @see flash.net.URLLoader
	 * @see flash.net.URLRequest
	 * 
	 * @author n.bush
	 * @project frankenstein
	 * @date 17 sept. 2009
	 * @desc 
	 */
	public class ScriptLoader extends URLLoader {

		private static var _defaultVariables : Array = [];

		/**
		 * Contient le chemin par défault des scripts, utilisé par tous les objets ScriptLoader.
		 * 
		 * @default ""
		 */
		public static var DEFAULT_SCRIPTS_PATH : String = "";

		private var _storeInMemory : Boolean;
		private var _urlRequest : URLRequest;

		private var _forceRefresh : Boolean;
		private var _useDefaultVariables : Boolean;

		/**
		 * Constructeur de la classe ScriptLoader.
		 * 
		 * @param forceRefresh
		 * Précise si le cache doit être ignoré ou non.
		 * 
		 * @param storeInMemory
		 * Précise si le script doit être enregistré dans le cache une fois chargé.
		 * 
		 * @param useDefaultVariables
		 * Indique que le ScriptLoader ne tient pas compte des paramètres par défaut, 
		 * ajoutée avec la méthode addDefaultVariable. 
		 * 
		 */
		public function ScriptLoader(forceRefresh : Boolean = false, storeInMemory : Boolean = true, useDefaultVariables : Boolean = true) {
			super();
			
			_forceRefresh = forceRefresh;
			_storeInMemory = storeInMemory;
			_useDefaultVariables = useDefaultVariables;
		}

		
		/**
		 * Lance le chargement de la requête.
		 * 
		 * @param urlrequest
		 * Ressource à charger.
		 * 
		 * @return void
		 */
		public override function load(urlrequest : URLRequest) : void {
			
			
			var scriptPath : String = DEFAULT_SCRIPTS_PATH + urlrequest.url;
			var urlVariables : URLVariables = urlrequest.data as URLVariables;
			
			//on ajoute les variables par defaut
			if (_useDefaultVariables) {
				
				var l : uint = _defaultVariables.length;
				
				if (urlVariables == null && l > 0)
					urlVariables = new URLVariables();
					
				for (var i : uint = 0;i < l;i++) {
					urlVariables[_defaultVariables[i].name] = _defaultVariables[i].value; 
				}
			}
			
			//si on force le refresh, on supprime l'entre dans le cache
			if (_forceRefresh) {
				Cache.removeXMLData(scriptPath + "?" + (urlVariables != null ? urlVariables.toString() : ""));
			}
			
			//on recupere les données en cache
			//si on en a on les utilise
			//sinon on charge le script
			_urlRequest = new URLRequest(scriptPath);
			var storedData : XML = Cache.getXMLData(scriptPath + "?" + (urlVariables != null ? urlVariables.toString() : ""));
			if (storedData != null) {
				data = storedData;
				_checkDataValidity(data);
				//trace("=======>REUSE");
			} else {
				
				_urlRequest.method = UString.getFileExtension(scriptPath).toLowerCase() == "xml" ? URLRequestMethod.GET : URLRequestMethod.POST;
			
				if (urlVariables != null)
					_urlRequest.data = urlVariables;
				
				
				addEventListener(Event.COMPLETE, _onLoadComplete, false, int.MAX_VALUE, true);
				addEventListener(IOErrorEvent.IO_ERROR, _onScriptMissing, false, int.MAX_VALUE, true);
				super.load(_urlRequest);
				
				
				//trace("=======>NEW");
			}
		}

		
		/**
		 * @private
		 */
		private function _onScriptMissing(event : IOErrorEvent) : void {
			
			//trace(this, "_onScriptMissing");
			//on empeche la propagation
			event.stopPropagation();
			event.stopImmediatePropagation();
			
			removeEventListener(Event.COMPLETE, _onLoadComplete);
			removeEventListener(IOErrorEvent.IO_ERROR, _onScriptMissing);
			
			
			dispatchEvent(new ScriptErrorEvent(ScriptErrorEvent.SCRIPT_MISSING));
		}

		
		/**
		 * @private
		 */
		private function _onLoadComplete(event : Event) : void {
			
			//on empeche la propagation
			event.stopPropagation();
			event.stopImmediatePropagation();
			
			removeEventListener(Event.COMPLETE, _onLoadComplete);
			removeEventListener(IOErrorEvent.IO_ERROR, _onScriptMissing);
			
			data = XML(data);
			
			//on sauvegarde en cache si demandé
			if (_storeInMemory) {
				var urlVarStr : String = _urlRequest.data != null ? _urlRequest.data.toString() : "";
				Cache.addXMLData(_urlRequest.url + "?" + urlVarStr, data);
			}
			
			//on verifie la validité du xml
			_checkDataValidity(data);
		}

		
		/**
		 * @private
		 */
		private function _checkDataValidity(xml : XML) : void {
			//si il y a une erreur on la dispatch
			if (xml.error.propertyIsEnumerable(0)) {
				if (xml.error.@type != "00") {
					var e1 : ScriptErrorEvent = new ScriptErrorEvent(ScriptErrorEvent.ERROR_RETURNED);
					e1.errorCode = xml.error.@type;
					e1.errorMessage = xml.error;
					e1.scriptUrl = _urlRequest.url;
					dispatchEvent(e1);
				} else {
					var e2 : Event = new Event(Event.COMPLETE);
					dispatchEvent(e2);		
				}
			} else {
				var e3 : ScriptErrorEvent = new ScriptErrorEvent(ScriptErrorEvent.XML_NOT_WELL_FORMATED);
				e3.scriptUrl = _urlRequest.url;
				dispatchEvent(e3);
			}
		}

		
		
		
		
		
		
		//--------------------------------------
		//					STATIC
		//--------------------------------------
		
		/**
		 * Ajoute un paramètre par défault valable pour tous les objets ScriptLoader créés après l'appel 
		 * de cette méthode.
		 * 
		 * @param name
		 * Nom du paramètre.
		 * 
		 * @param name
		 * Valeur du paramètre.
		 * 
		 */
		public static function addDefaultVariable(name : String, value : String) : void {
			_defaultVariables.push({name : name, value: value});
		}

		
		/**
		 * Indique si le script est déjà en cache.
		 * 
		 * @param path
		 * Nom du script<br/>(attention, le nom sera concaténé avec la valeur de la constante DEFAULT_SCRIPTS_PATH)
		 * 
		 * @return
		 * Booléen qui indique si oui ou non le script est en cache
		 */
		public static function isScriptAlreadyLoaded(path : String) : Boolean {
			return Cache.getXMLData(path) != null;
		}
	}
}
