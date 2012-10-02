/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.net {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import frankenstein.time.EnterFrame;

	
	/**
	 * Évènement diffusé à la fin du chargement du fichier
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Évènement diffusé à chaque progression du chargement
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
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
	 * <p>La classe AdvancedLoader apporte une gestion avancée du chargement de fichiers graphiques.<br />
	 * Elle permet notamment de charger des fichiers au format binaire afin de les mettre en cache.
	 * </p>
	 * 
	 * @example
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 * 	
	 * 		// On crée l'objet AdvancedLoader
	 * 		var advLoader : AdvancedLoader = new AdvancedLoader();
	 * 		advLoader.addEventListener(Event.COMPLETE, _onAssetLoaded, false, 0, true);
	 * 		advLoader.load(new URLRequest("fichier.swf"));
	 * 		
	 * 		function _onComplete(e : Event)
	 * 		{
	 * 			  // On récupère le contenu comme avec le Loader habituel
	 * 			  trace(advLoader.content);
	 * 			  addChild(advLoader);

	 * 			
	 * 		}
	 * 		
	 * 	</pre>
	 * </listing>
	 * 
	 * @see flash.display.Loader
	 * @see flash.net.URLRequest
	 * 
	 * @author n.bush
	 * @project frankenstein
	 * @date 17 sept. 2009
	 * @desc 
	 */
	public class AdvancedLoader extends Loader {
		
		private var _storeInMemory : Boolean;
		private var _forceRefresh : Boolean;
		private var _path : String;
		private var _context : LoaderContext;
		
		
		private var _urlLoader : URLLoader;
		
		/**
		 * Constructeur de la classe AdvancedLoader.
		 * 
		 * @param forceRefresh
		 * Précise si le cache doit être ignoré ou non.
		 * 
		 * @param storeInMemory
		 * Précise si le fichier doit être enregistré dans le cache une fois chargé.
		 * 
		 */
		public function AdvancedLoader(forceRefresh : Boolean = false, storeInMemory : Boolean = true) {
			super();
			
			_forceRefresh = forceRefresh;
			_storeInMemory = storeInMemory;
		}
		
		/**
		 * Lance le chargement de la requête.
		 * 
		 * @param urlrequest
		 * Ressource à charger.
		 * 
		 */
		public override function load(request : URLRequest, context : LoaderContext = null) : void{
			_path = request.url;
			_context = context;
			
			if (_forceRefresh || Cache.getByteArray(_path) == null){
				_loadMedia(request);
			}
			else {
				loadBytes(Cache.getByteArray(_path), _context);
			}
		}
		
		//--------------------------------------
		//					LOAD BYTE ARRAY
		//--------------------------------------
		
		/**
		 * @private
		 */
		private function _loadMedia(request:URLRequest) : void {
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, _onLoadComplete, false, 0, true);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress, false, 0, true);
			
			_urlLoader.load(request);
		}
		
		/**
		 * @private
		 */
		private function _onLoadProgress(event : ProgressEvent) : void {
			var e : ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			e.bytesLoaded = event.bytesLoaded;
			e.bytesTotal = event.bytesTotal;
			dispatchEvent(e);
		}
		
		/**
		 * @private
		 */
		private function _onLoadComplete(event : Event) : void {
			var bytes : ByteArray = event.target.data;
			if (_storeInMemory){
				Cache.addByteArray(_path, bytes);
			}
			
			//on charge les bytes et on attend le contenu
			loadBytes(bytes, _context);
		}
		
		
		//--------------------------------------
		//					LOAD BYTES
		//--------------------------------------
		
		/**
		 * Permet de convertir un objet ByteArray en objet graphique, typiquement ceux enregistrés en cache.
		 * 
		 * @param bytes
		 * Le ByteArray à charger.
		 * 
		 * @param context
		 * Le context de chargement.
		 * 
		 * @example
		 * <listing version="3.0">
		 * 	<pre class="prettyprint">
		 * 		var advLoader : AdvancedLoader = new AdvancedLoader();
		 * 		advLoader.addEventListener(Event.COMPLETE, _onBytesLoaded, false, 0, true);
		 * 		
		 * 		// Si le fichier est en cache, on interpréte directement les données binaire
		 * 		// (si le fichier est déjà en cache, un appel à la méthode load() l'utilisera directement)
		 * 		if( AdvancedLoader.isMediaAlreadyLoaded("fichier.swf") )
		 * 			  advLoader.loadBytes( Cache.getByteArray("fichier.swf" );
		 * 		else
		 * 			  advLoader.load(new URLRequest("fichier.swf"));
		 * 		
		 * 		function _onBytesLoaded(e : Event) : void
		 * 		{
		 * 			  addChild(advLoader.content);
		 * 		}
		 * 	</pre>
		 * </listing>
		 * 
		 * @see frankenstein.net.Cache
		 * @see flash.utils.ByteArray
		 * @see flash.display.Loader
		 * 
		 */
		public override function loadBytes(bytes : ByteArray, context : LoaderContext = null) : void {
			EnterFrame.addEventListener(Event.ENTER_FRAME, _waitingForContent, false, 0, true);
			super.loadBytes(bytes, context);
		}

		/**
		 * @private
		 * 
		 */
		private function _waitingForContent(event : Event) : void {
			if (content != null){
				EnterFrame.removeEventListener(Event.ENTER_FRAME, _waitingForContent);
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * Termine tous les chargements en cours.
		 * 
		 * @see flash.display.Loader#close()
		 * 
		 * @return void
		 */
		public override function close() : void {
			
			EnterFrame.removeEventListener(Event.ENTER_FRAME, _waitingForContent);
			
			if (_urlLoader){
				_urlLoader.removeEventListener(Event.COMPLETE, _onLoadComplete);
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS, _onLoadProgress);
				try {_urlLoader.close();}catch (e0 : Error){};
			}
			
			super.close();
		}
		
		
		/**
		 * Permet de vérifier la présence d'un fichier dans le cache.
		 * 
		 * @see frankenstein.net.Cache
		 * 
		 * @return Vrai si le chemin existe dans le cache, faux dans les autres cas
		 */
		public static function isMediaAlreadyLoaded(path : String):Boolean{
			return Cache.getByteArray(path) != null; 
		}
		
		
	}
}
