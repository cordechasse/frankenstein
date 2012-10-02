/*
 * Copyright © CorDeChasse 1999-2011
 */
 
 package frankenstein.net {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

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
	 * 		<b>Date </b> 26 juillet 2010<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>Version 1.0.0 by nicoBush</li>
	 * 				<li>Version 1.0.1 by nicoBush : modif de la doc pour plus de clareté</li>
	 * 			</ul> 
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * 
	 * <p>La classe TranslationsGroup est une classe statique qui peut stocker plusieurs objets Translations.<br />
	 * Elle peut :
	 * <ul>
	 * 	<li>Charger un groupe de traduction depuis un script back / XML</li>
	 * 	<li>Ajouter des groupes de trad via d'autres objets Translations</li>
	 * 	<li>Ajouter des groupes de trad via un XML externe (et plusieurs groupes à la volée)</li>
	 * </ul> 
	 * 
	 * <br />
	 * Attention : Pour le chargement des groupes de traductions, on utilise l'objet Translations, il faut donc
	 * setter les propriétés <code>ScriptLoader.DEFAULT_SCRIPTS_PATH</code> et 
	 * <code>Translations.TRANSLATION_SCRIPT</code>
	 * 
	 * @example
	 * Utilisation de la classe
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		
	 * 		//---------------------------------
	 * 		// 		Chargement d'un groupe de traduction "common"
	 * 		//---------------------------------
	 * 		 
	 * 		ScriptLoader.DEFAULT_SCRIPTS_PATH = "http://dev.cordechasse.fr/scripts/";
	 * 		ScriptLoader.addDefaultVariable("codeLang", "fr");
	 * 		ScriptLoader.addDefaultVariable("codeCountry", "fr");
	 * 		Translations.TRANSLATION_SCRIPT = "getTranslation.aspx";
	 * 		
	 * 		TranslationsGroup.addEventListener(Event.COMPLETE, _onTradsLoaded);
	 * 		
	 * 		TranslationsGroup.loadTranslations("common");
	 * 		
	 * 		function _tradsLoaded(e : Event) : void{
	 * 			trace( TranslationsGroup.translationsGroupLoaded ) // common
	 * 			trace( TranslationsGroup.getTrad("common", "nom_de_la_trad") ) // la valeur de la trad
	 * 		}
	 * 		
	 * 		
	 * 		//---------------------------------
	 * 		// 		Ajout de plusieurs groupes de trads via XML
	 * 		//---------------------------------
	 * 		
	 * 		var xml : XML = &lt;root&gt;
	 * 							&lt;translation type="monGroupeDeTrad0"&gt;
	 * 								&lt;maClef0&gt;&lt;![CDATA[Traduction 0 du groupe de trad 0]]&gt;&lt;/maClef0&gt;
	 * 								&lt;maClef1&gt;&lt;![CDATA[Traduction 1 du groupe de trad 0]]&gt;&lt;/maClef1&gt;
	 * 								&lt;maClef2&gt;&lt;![CDATA[Traduction 2 du groupe de trad 0]]&gt;&lt;/maClef2&gt;
	 * 							&lt;/translation&gt;
	 * 							&lt;translation type="monGroupeDeTrad1"&gt;
	 * 								&lt;maClef0&gt;&lt;![CDATA[Traduction 0 du groupe de trad 1]]&gt;&lt;/maClef0&gt;
	 * 								&lt;maClef1&gt;&lt;![CDATA[Traduction 1 du groupe de trad 1]]&gt;&lt;/maClef1&gt;
	 * 								&lt;maClef2&gt;&lt;![CDATA[Traduction 2 du groupe de trad 1]]&gt;&lt;/maClef2&gt;
	 * 							&lt;/translation&gt;
	 * 						&lt;/root&gt;
	 * 		
	 * 		TranslationsGroup.addMultipleTranslationsFromXML(xml.translation);	
	 * 	 	
	 * 	 	//---------------------------------
	 * 		// 		Insertion d'un objet traductions
	 * 		//---------------------------------
	 * 		
	 * 		var t : Translations = new Translations("home");
	 * 		t.load();
	 * 		 		
	 * 		TranslationsGroup.addTranslationsObject(t);
	 * 		
	 * 	</pre>
	 * </listing> 
	 * 
	 * @see Translations
	 * 
	 * 
	 * @author n.bush
	 * @project Frankenstein
	 * @date 26 juil. 2010
	 * @desc 
	 */
	public class TranslationsGroup {

		private static var _translationsList : Dictionary = new Dictionary();

		private static var _dispatcher : EventDispatcher = new EventDispatcher();

		private static var _lastTranslationsLoaded : String;

		
		//--------------------------------------
		//					LOAD
		//--------------------------------------

		/**
		 * Charge un nouveau groupe de traductions, et l'ajoute au dictionnaire du TranslationGroup.<br />
		 * Le chemin du script est définit par les variables statiques :
		 * <ul>
		 * 	<li>ScriptLoader.DEFAULT_SCRIPTS_PATH : répertoire des scripts.</li>
		 * 	<li>Translations.TRANSLATION_SCRIPT : nom du script de traductions.</li>
		 * </ul>
		 * 
		 * Un évènement Event.COMPLETE est dispatché lorsque la traduction est chargée.
		 * 
		 * @param group Le nom de référence du groupe
		 * @param overwriteIfExists Si un groupe du même nom existe déjà, doit-il être écrasé? 
		 * 
		 */
		public static function loadTranslations(group : String, overwriteIfExists : Boolean = false) : void {
			if (_translationsList[group] && !overwriteIfExists) {
				_dispTradsLoaded(group);	
			} else {
				var t : Translations = new Translations(group);
				_translationsList[group] = t;
				
				t.addEventListener(Event.COMPLETE, _onTradsLoaded);
				t.load();
			}
		}
		
		//chargement OK
		private static function _onTradsLoaded(event : Event) : void {
			var t : Translations = Translations(event.target);
			t.removeEventListener(Event.COMPLETE, _onTradsLoaded);
			
			_dispTradsLoaded(t.group);	
		}
		
		private static function _dispTradsLoaded(group : String) : void {
			_lastTranslationsLoaded = group;
			_dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}

		

		
		//--------------------------------------
		//					SET
		//--------------------------------------
		/**
		 * Ajoute un nouveau groupe de traductions.<br />
		 * 
		 * 
		 * @param group Le nom de référence du groupe.
		 * @param xml Le XML de données au format suivant:
		 * <pre class="prettyprint">
		 * &lt;root&gt;
		 * 		&lt;translation type='monGroupeDeTrad'&gt;
		 * 			&lt;maClef&gt;&lt;![CDATA[Ma Valeur]]&gt;&lt;/maClef&gt;
		 * 		&lt;/translation&gt;
		 * &lt;/root&gt;
		 * </pre>
		 * @param overwriteIfExists Si un groupe du même nom existe déjà, doit-il être écrasé?
		 * 
		 */
		public static function addTranslationsFromXML(group : String, xml : XML, overwriteIfExists : Boolean = false) : void {
			if (_translationsList[group] && !overwriteIfExists) {
				throw(new Error("TranslationsGroup Error : trying to add a translations whereas group already exists"));	
			} else {
				var t : Translations = new Translations(group);
				t.setData(xml);
				_translationsList[group] = t;
				
				//trace("[TranslationsGroup]", "addTranslationsFromXML", group, xml);
				
			}
		}

		
		/**
		 * Ajoute plusieurs groupes de traductions.
		 * La source est une XMLList au format:<br />
		 * <pre class="prettyprint">
		 * &lt;translation type="monGroupeDeTrad0"&gt;
		 * 	&lt;maClef0&gt;&lt;![CDATA[Traduction 0 du groupe de trad  0]]&gt;&lt;/maClef0&gt;
		 * 	&lt;maClef1&gt;&lt;![CDATA[Traduction 1 du groupe de trad  0]]&gt;&lt;/maClef1&gt;
		 * 	&lt;maClef2&gt;&lt;![CDATA[Traduction 2 du groupe de trad  0]]&gt;&lt;/maClef2&gt;
		 * &lt;/translation&gt;
		 * &lt;translation type="monGroupeDeTrad1"&gt;
		 * 	&lt;maClef0&gt;&lt;![CDATA[Traduction 0 du groupe de trad  1]]&gt;&lt;/maClef0&gt;
		 * 	&lt;maClef1&gt;&lt;![CDATA[Traduction 1 du groupe de trad  1]]&gt;&lt;/maClef1&gt;
		 * 	&lt;maClef2&gt;&lt;![CDATA[Traduction 2 du groupe de trad  1]]&gt;&lt;/maClef2&gt;
		 * &lt;/translation&gt;
		 * </pre>
		 *  
		 * @param translationsList La XMLList des nouvelles traductions à ajouter.
		 * @param overwriteIfExists Si un groupe du même nom existe déjà, doit-il être écrasé?
		 * 
		 */
		public static function addMultipleTranslationsFromXML(translationsList : XMLList, overwriteIfExists : Boolean = false) : void {
			var l : uint = translationsList.length();
			var i : uint;
			
			
			while (i < l) {
				
				//on recrée un faux noeud root
				var root : XML = <root />;
				root.appendChild(translationsList[i]);
				
				addTranslationsFromXML(translationsList[i].@type.toString(), root, overwriteIfExists);
				//trace("[TranslationsGroup]", "addMultipleTranslationsFromXML", translationsList[i].@type.toString());
				i++;
			}
		}

		
		//--------------------------------------
		//					TRANSLATIONS OBJECT
		//--------------------------------------

		/**
		 * Ajoute un nouvel objet Translations, à la liste stockée par le TranslationsGroup.
		 * 
		 * @param t L'objet Translations à ajouter
		 * @param overwriteIfExists Si un groupe du même nom existe déjà, doit-il être écrasé?
		 * 
		 */
		public static function addTranslationsObject(t : Translations, overwriteIfExists : Boolean = false) : void {
			if (!_translationsList[t.group] || overwriteIfExists) {
				_translationsList[t.group] = t;
			}
		}

		
		/**
		 * Retourne l'objet Translations à partir de son nom de groupe.
		 * 
		 * @param group Le nom du groupe de l'objet Translations
		 * 
		 */
		public static function getTranslationsObject(group : String) : Translations {
			return _translationsList[group];
		}

		
		//--------------------------------------
		//					GETTER
		//--------------------------------------

		/**
		 * Retourne une traduction à partir de son nom de groupe et de sa clef.<br />
		 * Si la traduction n'existe pas, on renvoie : <br />
		 * missing_translation, group=nom_du_groupe, field=nom_de_la_clef;
		 * 
		 * @param group Le nom du groupe.
		 * @param key Le nom de la clef.
		 * 
		 * @return La traduction liée au binôme group/key
		 */		
		public static function getTranslation(group : String, key : String) : String {
			if (_translationsList[group] != null) {
				return 	Translations(_translationsList[group]).getTranslation(key);
			}
			
			return  "missing_translation, group=" + group + ", field=" + key;
		}


		/**
		 * Retourne le dernier groupe de traduction chargé.
		 */		
		public static function get translationsGroupLoaded() : String {
			return _lastTranslationsLoaded;
		}

		
		//--------------------------------------
		//					EVENTDISPATCHER
		//--------------------------------------
		
		/**
		 * Ajoute un écouteur d'évènements.
		 * 
		 * @param type
		 * Le type d'évènement à écouter.
		 * 
		 * @param listener
		 * La méthode appelée lorsque l'évènement est dispatché.
		 * 
		 * @param useCapture.
		 *  
		 * @param priority
		 * Priorité d'écoute.
		 * 
		 * @param useWeakReference
		 * Référence faible.
		 * 
		 */
		public static function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		
		/**
		 * Retire l'écouteur d'évènements.
		 * 
		 * @param type
		 * Le type d'évènement qui est écouté.
		 * 
		 * @param listener
		 * La méthode appelée lorsque l'évènement est dispatché.
		 * 
		 */
		public static function removeEventListener(type : String, listener : Function) : void {
			_dispatcher.removeEventListener(type, listener);
		}
	}
}
