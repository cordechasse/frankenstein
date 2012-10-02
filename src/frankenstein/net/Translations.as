/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.net {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import frankenstein.events.ScriptErrorEvent;


	/**
	 * Évènement diffusé lorsque les trads sont chargées et prêtes à être lues
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * 
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 31 mars 2008<br />
	 * 		<b>Version </b> 1.0.2<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>Version 1.0.0 by nicoBush</li>
	 * 				<li>Version 1.0.1 by Thibault Lepore: création d'un groupe de trad à partir d'un XML externe</li>
	 * 				<li>Version 1.0.2 by nicoCrete : Changement du nom de la méthode getTrad en getTranslation</li>
	 * 				<li>Version 1.0.3 by nicoBush : une fermeture de crochet avait été oubliée!</li>
	 * 			</ul> 
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * 
	 * <p>La classe Translations permet de charger et de récupérer toutes les contenus traduits de l'application.<br /><br />
	 * Elle fonctionne avec le script standard <code>getTranslation.aspx</code> associé à EasyBack.
	 * Toute fois, le script appellé peut être modifié en changeant la valeur de la variable <code>Translations.TRANSLATION_SCRIPT</code>.<br/>
	 * La classe Translations utilise un objet ScriptLoader pour effectuer le chargement de données, 
	 * elle est donc soumise à la valeur de la propriété <code>ScriptLoader.DEFAULT_SCRIPTS_PATH</code>.<br/><br />
	 * Il faut créer un nouvel objet Translations pour chaque groupe de traduction.
	 * </p>
	 * 
	 * @example Utilisation de la classe
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 		
	 * 		// On définit le chemin par défaut des scripts
	 * 		ScriptLoader.DEFAULT_SCRIPTS_PATH = "http://dev.cordechasse.fr/scripts/";
	 * 		
	 * 		// Dans un site multilangues, on peut ajouter des paramètres par défaut
	 * 		ScriptLoader.addDefaultVariable("codeLang", "fr");
	 * 		ScriptLoader.addDefaultVariable("codeCountry", "fr");
	 * 		
	 * 		// On crée notre objet Translations
	 * 		var trads : Translations = new Translations("common");
	 * 		trads.addEventListener(Event.COMPLETE, _tradsLoaded, false, 0, true);
	 * 		trads.load();
	 * 		
	 * 		function _tradsLoaded(e : Event) : void
	 * 		{
	 * 			trace( trads.group ) // common
	 * 			
	 * 			trace( trads.getTrad("nom_de_la_trad") ) // la valeur de la trad
	 * 			
	 * 		}
	 * 	
	 * 	</pre>
	 * </listing> 
	 * 
	 * 
	 * @author n.bush
	 * @project Koleos
	 * @date 31 mars 08
	 * @desc 
	 */
	public class Translations extends EventDispatcher {

		private var _scriptLoader : ScriptLoader;
		private var _xml : XML;
		private var _group : String;

		/**
		 * Le nom du script de traduction. Par défaut, il s'agit du nom de base dans EasyBack.
		 */
		public static var TRANSLATION_SCRIPT : String = "getTranslation.aspx";

		/**
		 * Crée un nouvel objet Translations.<br/>
		 * 
		 * @param group Le nom du groupe dans EasyBack.
		 */
		public function Translations(group : String) {
			_group = group;
		}

		
		/**
		 * Lance le chargement du groupe de traduction.
		 * 
		 */
		public function load() : void {
			var urlVars : URLVariables = new URLVariables();
			urlVars.type = group;
			
			var req : URLRequest = new URLRequest(TRANSLATION_SCRIPT);
			req.data = urlVars;
			
			_scriptLoader = new ScriptLoader();
			_scriptLoader.addEventListener(Event.COMPLETE, _onTradLoaded, false, 0, true);
			_scriptLoader.addEventListener(ScriptErrorEvent.ERROR_RETURNED, _onErrorReturned, false, 0, true);
			_scriptLoader.addEventListener(ScriptErrorEvent.SCRIPT_MISSING, _onScriptMissing, false, 0, true);
			_scriptLoader.addEventListener(ScriptErrorEvent.XML_NOT_WELL_FORMATED, _onXmlNotWellFormated, false, 0, true);
			_scriptLoader.load(req);
		}

		
		private function _onErrorReturned(event : ScriptErrorEvent) : void {
			throw new Error("[Translations] Can't read translations, group : " + _group);
			_clear();
		}

		
		private function _onScriptMissing(event : ScriptErrorEvent) : void {
			throw new Error("[Translations], Can't find translations script : " + TRANSLATION_SCRIPT);
			_clear();
		}

		
		private function _onXmlNotWellFormated(event : ScriptErrorEvent) : void {
			throw new Error("[Translations], XML isn't well formated : " + TRANSLATION_SCRIPT);
			_clear();
		}

		
		private function _onTradLoaded(e : Event) : void {
			_xml = _scriptLoader.data;
		
			_clear();
			
			var e2 : Event = new Event(Event.COMPLETE);
			dispatchEvent(e2);
		}

		
		private function _clear() : void {
			if (_scriptLoader) {
				_scriptLoader.removeEventListener(Event.COMPLETE, _onTradLoaded);
				_scriptLoader.removeEventListener(ScriptErrorEvent.ERROR_RETURNED, _onErrorReturned);
				_scriptLoader.removeEventListener(ScriptErrorEvent.SCRIPT_MISSING, _onScriptMissing);
				_scriptLoader.removeEventListener(ScriptErrorEvent.XML_NOT_WELL_FORMATED, _onXmlNotWellFormated);
				_scriptLoader = null;
			}
		}

		
		//--------------------------------------
		//					GETTER
		//--------------------------------------
		
		/**
		 * Permet de récupérer la valeur d'une traduction par rapport à son code.
		 * 
		 * @param code
		 * Le code qui correspond à la traduction voulue.
		 * 
		 * @return
		 * La valeur de la traduction.
		 */
		public function getTranslation(code : String) : String {
			if (_xml.translation[code].propertyIsEnumerable(0)){
				return _xml.translation[code];
			}
			//trace(this, "MISSING TRAD , group="+_group+", field="+code);
			return  "missing_translation, group=" + _group + ", field=" + code;
		}

		
		/**
		 * Renvoie toutes les traductions (debug).
		 * 
		 * @return
		 * Le nom du groupe et les traductions associées.
		 * 
		 */
		public function getAllTranslations() : String {
			return ("group : " + _group + " : " + _xml.translation);
		}

		
		/**
		 * Retourne le nom du groupe de traductions de l'objet Translations.
		 * 
		 * @return
		 * Le groupe de l'objet Traduction.
		 */
		public function get group() : String {
			return _group;
		}

		
		/**
		 * Ferme la connection au serveur mais ne supprime pas les données chargées.
		 * 
		 * @return void
		 * 
		 */
		public function close() : void {
			_clear();
		}

		
		//--------------------------------------
		//					SETTER
		//--------------------------------------
			
		/**
		 * Creer le groupe de traduction à partir d'un XML externe
		 * 
		 * @return void
		 * 
		 */	
		public function setData(data : XML) : void {
			_xml = data;
			
			_clear();
			
			var e2 : Event = new Event(Event.COMPLETE);
			dispatchEvent(e2);
		}
	}
}