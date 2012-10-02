/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.net {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import frankenstein.errors.ArgumentTypeError;
	import frankenstein.tools.UString;


	/**
	 * Évènement diffusé lorsque l'objet Init est initialisé
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * 
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 23 juillet 2008<br />
	 *		<b>Version </b> 1.1.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>v1.0.0 by nicoBush</li>
	 * 				<li>v1.1.0 by Thibault Lepore: support de l'extension des domaines
	 * 				et des alias</li>
	 * 				<li>v1.1.1 by nicoBush: correction de bugs avec les swfadress et extends</li>
	 * 			</ul> 
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * 
	 * <p>La classe Init permet de centraliser la configuration de l'application.<br />
	 * Son rôle principal est de charger un fichier XML d'initialisation et rendre disponible
	 * pour l'application :
	 * <ul>
	 * 	<li>Le domaine en cours</li>
	 * 	<li>Les chemins (scripts, médias, swf, ...) pour le domaine en cours</li>
	 * 	<li>Les constantes</li>
	 * </ul>
	 * 
	 * Depuis la version 1.1.0 elle gère en plus :
	 * <ul> 
	 * 	 <li>Les extensions de domaines via l'attribut "extends"</li>
	 * 	 <li>Déclarer plusieurs domaines en 1 seul noeud</li>
	 * 	 <li>les alias (voir méthode <code>setAlias</code>)</li>
	 * </ul>
	 * 
	 * Cette classe s'utilise en appellant des méthodes statiques.
	 * Vous ne pouvez pas instancier la classe Init.
	 *  
	 * </p>
	 * <p>
	 * <b>A. Structure du XML</b><br /><br />
	 * Le XML du Init est composé de deux noeuds principaux : domains et constants
	 *  <listing version="3.0" >
	 * 		<pre class="prettyprint">
	 * 	&lt;root&gt;
	 * 						&lt;!-- déclaration des domaines --&gt;
	 * 						&lt;domains&gt;
	 * 							...
	 * 						&lt;/domains&gt;
	 * 						
	 * 						&lt;!--déclaration des constantes --&gt;
	 * 						&lt;constants&gt;
	 * 							...
	 * 						&lt;/constants&gt;
	 * 	&lt;/root&gt;						 						
	 * 		</pre>
	 * </listing>
	 * </p>
	 * <p>
	 * <b>B. Les domaines</b><br /><br />
	 * &nbsp;&nbsp;&nbsp;&nbsp;<b>1. Déclaration d'un domaine</b><br />
	 * Chaque domaine est définit au sein du noeud <code>&lt;domain&gt;</code> de la sorte :
	 * <listing version="3.0" >
	 * 		<pre class="prettyprint">
	 * 	&lt;!-- déclaration d'un domaine type--&gt;
	 * 	&lt;d domain="http://test.cordechasse.fr"&gt;
	 * 						&lt;path name="racine"&gt;/loc/&lt;/path&gt;
	 * 						&lt;path name="scripts"&gt;/scripts/&lt;/path&gt;
	 * 						&lt;path name="swf"&gt;/swf/&lt;/path&gt;
	 * 						&lt;path name="xml"&gt;/xml/&lt;/path&gt;
	 * 						&lt;path name="img"&gt;/img/&lt;/path&gt;
	 * 	&lt;/d&gt; 			
	 * 		</pre>
	 * 	</listing>
	 * 	On peut créer autant de noeud path que l'on veut avec les noms que l'on désire.<br />
	 * 	</p>
	 * 	<p>
	 * 	&nbsp;&nbsp;&nbsp;&nbsp;<b>2. Environnement de dev</b><br />
	 * 	On peut déclarer un domaine en "devEnvironnement", qui ajoute les raccourcis claviers
	 * 	et le context menu pour afficher le FPSCounter.<br />
	 * 	Le domaine IDE est par defaut en mode "devEnvironnement": 
	 * 	<listing version="3.0" >
	 * 		<pre class="prettyprint">
	 * 	&lt;!-- déclaration d'un domaine type--&gt;
	 * 	&lt;d domain="http://test.cordechasse.fr" devEnvironnement="true"&gt;
	 * 						&lt;path name="racine"&gt;/loc/&lt;/path&gt;
	 * 						&lt;path name="scripts"&gt;/scripts/&lt;/path&gt;
	 * 						&lt;path name="swf"&gt;/swf/&lt;/path&gt;
	 * 						&lt;path name="xml"&gt;/xml/&lt;/path&gt;
	 * 						&lt;path name="img"&gt;/img/&lt;/path&gt;
	 * 	&lt;/d&gt; 			
	 * 		</pre>
	 * 	</listing>
	 * </p>
	 * <p>
	 * &nbsp;&nbsp;&nbsp;&nbsp;<b>3. Extension de domaine</b><br />
	 * On peut également étendre un autre domaine grâce à l'attribut "extends".<br />
	 * Les propriétés déjà déclarées dans le domaine père seront ajoutées au domaine fils.<br />
	 * Si une propriété est redéclaré, elle sera écrasée. Si une propriété n'existait pas, elle
	 * sera ajoutée.<br />
	 * La propriété devEnvironnement n'est pas héritée.<br />
	 * Attention, il faut faire attention à ne pas faire des domaine qui s'étendent mutuellement
	 * pour ne pas faire de boucle infinie.  
	 * <listing version="3.0" >
	 * 		<pre class="prettyprint">
	 * 	&lt;!-- déclaration d'un domaine qui en etend un autre--&gt;
	 * 	&lt;d domain="http://test.cordechasse.fr"&gt;
	 * 						&lt;path name="racine"&gt;/loc/&lt;/path&gt;
	 * 						&lt;path name="scripts"&gt;/scripts/&lt;/path&gt;
	 * 						&lt;path name="swf"&gt;/swf/&lt;/path&gt;
	 * 						&lt;path name="xml"&gt;/xml/&lt;/path&gt;
	 * 						&lt;path name="img"&gt;/img/&lt;/path&gt;
	 * 	&lt;/d&gt;
	 * 	&lt;d domain="http://test2.cordechasse.fr" extends="http://test.cordechasse.fr"&gt;
	 * 						&lt;path name="xml"&gt;/fr/fr/xml/&lt;/path&gt;
	 * 						&lt;path name="sounds"&gt;/sounds/&lt;/path&gt;
	 * 	&lt;/d&gt;
	 * 		</pre>
	 * 	</listing> 	
	 * </p> 
	 * <p>
	 * &nbsp;&nbsp;&nbsp;&nbsp;<b>4. Déclaration de multiples domaines</b><br />
	 * On peut déclarer plusieurs domaines en un seul, en séparant les noms de domaines par
	 * des virgules.
	 * <listing version="3.0" >
	 * 		<pre class="prettyprint">
	 * 	&lt;!-- déclaration de multiples domaines --&gt;
	 * 	&lt;d domain="http://test1.cordechasse.fr, http://test2.cordechasse.fr"&gt;
	 * 					&lt;path name="scripts"&gt;/script/&lt;/path&gt;
	 * 	&lt;/d&gt;
	 * 		</pre>
	 * 	</listing> 	
	 * </p> 
	 * <p>
	 * <p>
	 * &nbsp;&nbsp;&nbsp;&nbsp;<b>5. Alias</b><br />
	 * On peut déclarer des alias qui seront remplacés automatiquement par la classe.
	 * <listing version="3.0" >
	 * 		<pre class="prettyprint">
	 * 	&lt;!-- Ajout d'alias --&gt;
	 * 	&lt;d domain="http://test1.cordechasse.fr"&gt;
	 * 					&lt;path name="sounds"&gt;sounds/$monAlias&lt;/path&gt;
	 * 	&lt;/d&gt;
	 * 		</pre>
	 * 	</listing>
	 * 	Code Actionscript :
	 * 	<listing version="3.0" >
	 * 		<pre class="prettyprint">
	 * 		Init.setAlias("$monAlias", "fr");
	 * 		Init.load();
	 * 		trace(Init.getPath("sounds")); // affiche : sounds/fr
	 * 		</pre>
	 * 	</listing> 	
	 * </p> 
	 * <p>
	 * <b>C. Les constantes</b><br /><br />
	 * On déclare les constantes (variables non liées au domaine), dans le noeud "constants"
	 * de la façon suivante:
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 	&lt;group name="swf"&gt;
	 * 					&lt;c name="swf_inscription"&gt;inscription.swf&lt;/c&gt;
	 * 					&lt;c name="swf_website"&gt;website.swf&lt;/c&gt;
	 * 	&lt;/group&gt;
	 * 	</pre>
	 * </listing>
	 * </p>
	 * <p>
	 * <b>D. Fichier Init type</b><br /><br />
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 	&lt;root&gt;
	 * 						&lt;!-- déclaration des domaines --&gt;
	 * 						&lt;domains&gt;
	 * 											&lt;!-- déclaration du domaine de l'IDE --&gt;
	 * 											&lt;d domain="IDE"&gt;
	 *														 		&lt;path name="racine"&gt;../../../&lt;/path&gt;
	 *	 															&lt;path name="scripts"&gt;http://devmartine.cordechasse.fr/scripts/&lt;/path&gt;
	 *	 															&lt;path name="swf"&gt;../swf/&lt;/path&gt;
	 *	 															&lt;path name="xml"&gt;../xml/&lt;/path&gt;
	 *	 															&lt;path name="img"&gt;../img/&lt;/path&gt;
	 * 											&lt;/d&gt;
	 * 			
	 * 											&lt;!-- déclaration du domaine par défaut, si aucun des domaines specifié ne correspond --&gt;
	 * 											&lt;d domain="DEFAULT"&gt;
	 * 																&lt;path name="racine"&gt;/loc/&lt;/path&gt;
	 * 																&lt;path name="scripts"&gt;/scripts/&lt;/path&gt;
	 * 																&lt;path name="swf"&gt;/swf/&lt;/path&gt;
	 * 																&lt;path name="xml"&gt;/xml/&lt;/path&gt;
	 * 																&lt;path name="img"&gt;/img/&lt;/path&gt;
	 * 											&lt;/d&gt;
	 * 			
	 * 											&lt;!-- déclaration d'un domaine type--&gt;
	 * 											&lt;d domain="http://test.cordechasse.fr"&gt;
	 * 																&lt;path name="racine"&gt;/loc/&lt;/path&gt;
	 * 																&lt;path name="scripts"&gt;/scripts/&lt;/path&gt;
	 * 																&lt;path name="swf"&gt;/swf/&lt;/path&gt;
	 * 																&lt;path name="xml"&gt;/xml/&lt;/path&gt;
	 * 																&lt;path name="img"&gt;/img/&lt;/path&gt;
	 * 											&lt;/d&gt;
	 * 			
	 * 											&lt;!-- déclaration d'un domaine qui en hérite d'un autre --&gt;
	 * 											&lt;d domain="http://dave.cordechasse.fr" extends="http://test.cordechasse.fr" devEnvironnement="true"&gt;
	 * 												&lt;path name="img"&gt;/images/&lt;/path&gt;
	 * 											&lt;/d&gt;
	 * 			
	 * 											&lt;!-- déclaration de multiples domaines au sein d'un seul --&gt;
	 * 											&lt;d domain="http://test.cordechasse.fr, http://chose.cordechasse.fr" extends="DEFAULT" devEnvironnement="true"&gt;
	 * 																&lt;path name="scripts"&gt;/script/&lt;/path&gt;
	 * 											&lt;/d&gt;
	 * 						&lt;/domains&gt;
	 * 		
	 * 						&lt;!--déclaration des constantes --&gt;
	 * 						&lt;constants&gt;
	 * 											&lt;group name="swf"&gt;
	 * 																&lt;c name="swf_inscription"&gt;inscription.swf&lt;/c&gt;
	 * 																&lt;c name="swf_website"&gt;website.swf&lt;/c&gt;
	 * 											&lt;/group&gt;
	 * 											&lt;group name="sound"&gt;
	 * 																&lt;c name="generic"&gt;generic.swf&lt;/c&gt;
	 * 																&lt;c name="games"&gt;games.swf&lt;/c&gt;
	 * 											&lt;/group&gt;
	 * 						&lt;/constants&gt;
	 * 	&lt;/root&gt;
	 * 	</pre>
	 * </listing>
	 * </p>
	 * @example
	 * Utilisation de la classe
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 	//gestions des Alias
	 * 	Init.setAlias("$loc", "fr");
	 * 		
	 * 	//chargement du XML
	 * 	Init.addEventListener(Event.COMPLETE, _onMgLoaded);
	 * 	Init.load();
	 * 		
	 * 	//fichier chargé
	 * 	function _onMgLoaded(event : Event) : void {
	 * 		trace(Init.isDevEnvironnement());
	 * 		trace(Init.getPath("swf"));
	 * 		trace(Init.getConstant("swf", "swf_website"));
	 * 	}
	 * 	</pre>
	 * </listing>
	 *  
	 */
	public class Init extends EventDispatcher {

		//vars
		private var _isAlreadyLoaded : Boolean = false;
		private var _urlLoader : URLLoader;

		private var _paths : Dictionary;
		private var _domains : Array = [];
		private var _possibleDomains : Array = [];
		private var _alias : Array = [];
		private var _constantsGroups : Array;
		private var _domain : String;
		private var _domainName : String;

		private var _isDevDomain : Boolean;
		private var _loop : uint;
		
		/**
		 * @private
		 */
		public var IS_INIT : Boolean = false;
		
		/**
		 * @private
		 */
		public var IS_LOADED : Boolean = false;

		/**
		 * @private
		 */
		private static var _instance : Init;

		//const
		/**
		 * Domaine de l'IDE.
		 */
		public static const IDE_DOMAIN : String = "IDE";
		
		/**
		 * Domaine par défaut, si aucun autre domaine ne correspond.
		 */
		public static const DEFAULT_DOMAIN : String = "DEFAULT";

		
		/**
		 * @private
		 */		
		public function Init(p : InitEnforcer) {
			_constantsGroups = [];
			_getCurrentDomain();
		}

		
		private static function _initialize() : void {
			if (_instance == null)
				_instance = new Init(new InitEnforcer());
		}

		
		/**
		 * Indique si l'objet Init est initialisé.
		 * 
		 * @return
		 * Vrai si le Init est initialisé, faux dans les autres cas
		 */
		public static function isInit(  ) : Boolean {
			_checkInstance();
			return _instance.IS_INIT;
		}

		
		/**
		 * @private
		 */
		private function _getCurrentDomain( scene : DisplayObject = null ) : void {
			if ( ExternalInterface.available == true ) {
				try {
					_domain = ExternalInterface.call('window.location.toString');
					
					if (_domain.indexOf("#") != -1){
						_domain = _domain.split("#")[0];
					}
					
				}
				catch ( e : Error ) {
					_domain = "DEFAULT";
				}
			}
			else if (scene){
				_domain = scene.loaderInfo.url;
			}
			else {
				_domain = "DEFAULT";
			}
			
			if (Capabilities.playerType == "StandAlone")
				_domain = "IDE";
		}

		
		
		//--------------------------------------
		//					LOAD
		//--------------------------------------
		
		/**
		 * Charge le fichier XML d'initialisation (par défaut <code>"init.xml"</code>)</br> 
		 * Se reporter à la description de la classe pour connaitre la syntaxe du fichier d'intialisation.
		 * 
		 * @param urlInit
		 * Le chemin du fichier de configuration.
		 * 
		 * @throws Error
		 * Une erreur de type <code>Error</code>si le fichier est déjà chargé 
		 */
		public static function load( urlInit : String = "init.xml", displayObject : DisplayObject = null ) : void {
			_checkInstance();
			_instance.IS_INIT = true;
			
			if (_instance._isAlreadyLoaded) {
				throw (new Error("Init Error : trying to load init file twice"));
			} else {
				
				if ( displayObject != null ) 
					_instance._getCurrentDomain(displayObject);
				
				_instance._urlLoader = new URLLoader();
				_instance._urlLoader.addEventListener(Event.COMPLETE, _instance._onInitLoaded, false, 0, true);
				_instance._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, _instance._onInitLoadingError, false, 0, true);
				_instance._urlLoader.load(new URLRequest(urlInit));
			}
		}

		
		/**
		 * Interprète les données XML pour l'intialisation. Cette méthode est utile dans le cas
		 * ou les données du Init sont dans un XML qui contient d'autres données (trads, 
		 * navigation etc.).
		 * 
		 * @param datas
		 * Les données à interpréter de type <code>XML</code> ou <code>XMLList</code>
		 * 
		 * @throws frankenstein.errors.ArgumentTypeError
		 * Si les données ne sont pas correctes
		 * 
		 * @throws Error
		 * Une erreur de type <code>Error</code>&nbsp;si le domaine par défaut n'existe pas
		 * 
		 * @see Init
		 * @see XML
		 * @see XMLList
		 * @see frankenstein.errors.ArgumentTypeError
		 * 
		 */
		public static function setDatas( datas : *, displayObject : DisplayObject = null ) : void {
			
			var xml : XML;
			
			if (datas is XMLList)
				xml = XML(datas);
			else if (datas is XML) {
				xml = datas;	
			} else {
				throw (new ArgumentTypeError("datas"));
			}
			
			_checkInstance();
			_instance.IS_INIT = true;
			
			if ( displayObject != null ) 
				_instance._getCurrentDomain(displayObject);
				
			_instance._buildPaths(xml.domains.d);
			_instance._buildConstants(xml.constants.group);
		}

		
		/**
		 * @private
		 */
		private function _onInitLoadingError(e : IOErrorEvent) : void {
			throw (new Error("Init Error : can't load init : " + e.text));
		}

		
		/**
		 * @private
		 */
		private function _onInitLoaded(e : Event) : void {
			var _data : XML = XML(e.target.data);
			
			setDatas(_data);
			
			_urlLoader.removeEventListener(Event.COMPLETE, _onInitLoaded);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, _onInitLoadingError);
			
			var e2 : Event = new Event(Event.COMPLETE);
			dispatchEvent(e2);
			
			IS_LOADED = true;
		}

		
		
		//--------------------------------------
		//					BUILD PATHS AND CONSTANTS 
		//--------------------------------------
		
		/**
		 * @private
		 *
		 */
		private function _buildPaths(domains : XMLList) : void {
			
			//on recupere tous les domaines valides
			for (var i : uint = 0;i < domains.length(); i++) {
				if (domains[i].@domain != "") {
					_possibleDomains.push(i);
				}
			}
	
			// creations des domaines
			_addDomains(domains);
			_checkDomains(domains);
			
			var _defaultDomain : Domain = _getDefaultDomain();
			
			if (_defaultDomain == null){
				throw (new Error("Init Error : DEFAULT domain doesn't exist"));
			}
			
			var currentDomain : Domain;
			
			
			switch(_domains.length) {
				case 0:
					throw (new Error("Init Error : no domain declared"));
					break;
				case 1:
					currentDomain = _domains[0];
					break;
				default:
					//on recupere le domain qui contient le path
					var availableDomains : Array = [];
					
					for (var j : uint = 0; j < _domains.length; j++) {
						if (_domain.indexOf(_domains[j].name) != -1){
							availableDomains.push(j);
						}
					}
					
					//on recupere la liste des domaines qui correspondent au domaine actuel
					switch (availableDomains.length){
						case 0:
							currentDomain = _defaultDomain;
							break;
						case 1:
							currentDomain = _domains[availableDomains[0]];
							break;
						default:
							var selectedIdx : int = -1;
							var lengthDomain : uint = 0;
							
							var k : uint;
							var l : uint = availableDomains.length;
							
							while (k < l){
								if (Domain(_domains[availableDomains[k]]).name.length > lengthDomain){
									lengthDomain = _domains[availableDomains[k]];
									selectedIdx = k;
								}
								k++;
							}
							
							currentDomain = _domains[availableDomains[selectedIdx]];
						
							break;
					}
					
					break;
			}
			
	
			_isDevDomain = currentDomain.dave;
			_paths = currentDomain.paths;
			_domainName = currentDomain.name;
			
			replacePaths();
		}


		/**
		 * @private
		 *
		 */
		private function _getDefaultDomain() : Domain {
			var i : uint;
			var l : uint = _domains.length;
			
			while (i < l){
				if (Domain(_domains[i]).name == DEFAULT_DOMAIN){
					return Domain(_domains[i]);
				}
				i++;
			}
			
			return null;
		}
		 
		
		
		/**
		 * @private
		 *
		 */
		private function _addDomains(domains : XMLList, parent : Domain = null) : void {
			//trace(this, "_addDomains ==>", _loop, parent);
			
			var parentName : String = "";

			if(parent) {
				parentName = parent.name;
			}
	
			var i : uint;
			var pl : uint = _possibleDomains.length;
	
			for (i = 0; i < pl; i++) {
				if(domains[_possibleDomains[i]].attribute("extends") == parentName || domains[_possibleDomains[i]].attribute("extends") == undefined) {
					var domainNames : Array = domains[_possibleDomains[i]].@domain.split(",");
				
					var j : uint;
					var nl : uint = domainNames.length;
				
					for (j = 0;j < nl; j++) {
						var domainName : String = UString.trim(domainNames[j]);
						
						
						if(!_isDomainExisting(domainName)) {
							
							if(domains[_possibleDomains[i]].attribute("extends") == undefined) {
								parent = null;
								//trace(this, "_addDomains", "ICI");
							}
							else {
								//trace(this, "_addDomains", "LA", parent);
							}
							
							var domain : Domain = new Domain(domainName, domains[_possibleDomains[i]], parent);
							_domains.push(domain);
						
							_addDomains(domains, domain);
						}
					}
				}
			}
			
			_loop++;
		}

		
		/**
		 * @private
		 *
		 */
		private function _checkDomains(domains : XMLList) : void {
			var i : uint;
			var pl : uint = _possibleDomains.length;
			
			for (i = 0;i < pl; i++) {
				var parentExist : Boolean = false;
				
				if(domains[_possibleDomains[i]].attribute("extends") != undefined) {
					for (var j : uint = 0;j < _domains.length; j++) {
						if(_domains[j].name == domains[_possibleDomains[i]].attribute("extends")) {
							parentExist = true;
						}
					}
				} else {
					parentExist = true;
				}
				
				if(!parentExist) {
					var domainNames : Array = domains[_possibleDomains[i]].@domain.split(",");

					for (var k : uint = 0;k < domainNames.length; k++) {
						var domainName : String = UString.trim(domainNames[k]);
						
						throw (new Error("InitError : domain " + domainName + " can't extends domain " + domains[_possibleDomains[i]].attribute("extends")));
					}
				}
			}
		}

		
		/**
		 * @private
		 *
		 */
		private function _isDomainExisting(domainName : String) : Boolean {
			var exist : Boolean = false;
			
			for (var i : uint = 0;i < _domains.length; i++) {
				if(_domains[i].name == domainName) {
					exist = true;
				}
			}
			
			return exist;
		}

		
		/**
		 * @private
		 */
		private function _buildConstants(groups : XMLList) : void {
			
			for (var i : uint = 0;i < groups.length(); i++) {
				if (_constantsGroups[groups[i].@name] == null)
					_constantsGroups[groups[i].@name] = [];
				
				for (var j : uint = 0;j < groups[i].c.length(); j++) {
					_constantsGroups[groups[i].@name][groups[i].c[j].@name] = groups[i].c[j].toString();
				}
			}
		}

		
		//--------------------------------------
		//					GETTER
		//--------------------------------------
		
		/**
		 * Retourne un chemin pour le domaine en cours, en fonction du nom du chemin.
		 * 
		 * @param path
		 * Le nom du chemin
		 * 
		 * @return
		 * Un String
		 * 
		 * @throws Error Une erreur de type <code>Error</code> si le nom du chemin n'est pas reconnu 
		 */
		public static function getPath(path : String) : String {
			_checkInstance();
	
			if (_instance._paths.propertyIsEnumerable(path)) {
				return _instance._paths[path];
			} else {
				throw (new Error("InitError : trying to access unknown path : " + path));
			}
		}

		
		/**
		 * Retourne si une path est définie.
		 * 
		 * @param path
		 * Le nom du chemin
		 */
		public static function isPathSet(path : String) : Boolean  {
			return (_instance._paths.propertyIsEnumerable(path));
		}
		
		
		
		
		/**
		 * Remplace un pattern dans les paths
		 * 
		 * @param pattern
		 * Le pattern à remplacé
		 * 
		 * @param value
		 * La valeur de remplacement
		 * 
		 * @return void
		 */
		public static function setAlias(pattern : String, value : String) : void {
			_checkInstance();
			
			_instance._alias.push([pattern, value]);
			
			//trace("setAlias", _instance._alias.length);
			
			if(_instance.IS_LOADED) {
				replacePaths();
			}
		}

		
		/**
		 * @private
		 *
		 */
		private static function replacePaths() : void {
			_checkInstance();
			
			//trace("replacePaths", _instance._alias.length);

			var i : uint;
			var pl : uint = _instance._domains.length;
	
			for (i = 0; i < pl; i++) {
				var domain : Domain = _instance._domains[i];
				var al : uint = _instance._alias.length;
				
				for (var j : uint = 0;j < al; j++) {
					domain.replacePaths(_instance._alias[j][0], _instance._alias[j][1]);
				}
			}
		}

		
		/**
		 * Retourne la valeur d'une constante définie dans un groupe.
		 * 
		 * @param group
		 * Le nom du groupe de constante.
		 * 
		 * @param name
		 * Le nom de la constante dans le groupe.
		 * 
		 * @return
		 * La valeur de la constante
		 * 
		 * @throws Error
		 * Une erreur de type <code>Error</code> quand la constante n'est pas définie
		 */
		public static function getConstant(group : String, name : String) : Object {
			_checkInstance();
			if (_instance._constantsGroups[group] != null && _instance._constantsGroups[group][name] != null) {
				return _instance._constantsGroups[group][name];
			} else {
				throw (new Error("InitError : trying to access unknown constant group: " + group + ", name: " + name));
			}
		}


		/**
		 * Retourne si une constante est définie.
		 * 
		 * @param group
		 * Le nom du groupe de constante.
		 * 
		 * @param name
		 * Le nom de la constante dans le groupe.
		 * 
		 */
		public static function isConstantSet(group : String, name : String) : Boolean {
			return (_instance._constantsGroups[group] != null && _instance._constantsGroups[group][name] != null);
		}


		
		/**
		 * Enregistre une nouvelle constante.
		 * 
		 * @param group Le nom du groupe de constantes (si le groupe n'existe pas, il sera créé automatiquement)
		 * @param constant Le nom de la constante (si elle est déjà définie, celle-ci est écrasée)
		 * @param value La valeur de la constante
		 * @return void
		 *  
		 */
		public static function setConstant(group : String, name : String, value : Object) : void {
			_checkInstance();
			if (_instance._constantsGroups[group] == null)
				_instance._constantsGroups[group] = [];
			_instance._constantsGroups[group][name] = value;
		}

		
		/**
		 * Retourne le domaine en cours utilisé par le Init.
		 * 
		 * @return Chaîne qui correspond au domaine
		 */
		public static function getDomain() : String {
			_checkInstance();
			return _instance._domainName;
		}

		
		/**
		 * Indique si la configuration actuelle correspond à l'environnement de développement.
		 * 
		 * @return Vrai ou faux
		 */
		public static function isDevEnvironnement() : Boolean {
			_checkInstance();
			return (getDomain() == IDE_DOMAIN) || _instance._isDevDomain;
		}

		
		//--------------------------------------
		//					CHECK INSTANCE IS BUILD
		//--------------------------------------
		
		/**
		 * @private
		 */
		private static function _checkInstance() : void {
			if (_instance == null)
				_initialize();
		}

		
		//--------------------------------------
		//				STATIC EVENT DISPATCHER					
		//--------------------------------------
		
		/**
		 * Appelle la méthode <code>addEventListener</code> de l'instance statique du Init
		 * 
		 * @see flash.events.EventDispatcher
		 * 
		 * @return void
		 */
		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			_checkInstance();
			_instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		
		/**
		 * Appelle la méthode <code>removeEventListener</code> de l'instance statique du Init
		 * 
		 * @see flash.events.EventDispatcher
		 * 
		 * @return void
		 */
		public static function removeEventListener(type : String, listener : Function) : void {
			_checkInstance();
			_instance.removeEventListener(type, listener);
		}
	}
}

import flash.utils.Dictionary;

/**
 * @private
 */
class InitEnforcer {

	function InitEnforcer() {
		//do nada
	}
}

class Domain {

	private var _paths : Dictionary;
	private var _name : String;
	private var _dave : Boolean;
	

	public function Domain(name : String, xml : XML, parent : Domain = null) : void {
		
		//trace(this, "Domain", name, parent);
		
		_name = name;
		_paths = new Dictionary(true);
		_dave = xml.@devEnvironnement.toString() == "true";
		
		if(parent) {
			for (var path : String in parent.paths) {
				_paths[path] = parent.paths[path];
			}
		}
			
		var parentName : String = "";
		if(parent) {
			parentName = parent.name;
		}
			
		var i : uint;
		var l : uint = xml.path.length();
			
		for(i = 0;i < l; i++) {
			_paths[String(xml.path[i].@name)] = String(xml.path[i]);
		}
	}

	
	public function getPath(path : String) : String {
		if (_paths.propertyIsEnumerable(path)) {
			return _paths[path];
		} else {
			throw (new Error("DomainError : trying to access unknown path : " + path));
		}
	}

	
	public function replacePaths(pattern : String, value : String) : void {
		for (var path : String in _paths) {
			_paths[path] = _paths[path].replace(pattern, value);
		}
	}

	
	public function get dave() : Boolean {
		return _dave;
	}

	
	public function get name() : String {
		return _name;
	}

	
	public function get paths() : Dictionary {
		return _paths;
	}
	
	public function toString():String{
		return "[object Domain] name=" + name + " dev=" + _dave;
	}
	
}


	
	

