/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.net.filesUploader {
 	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import frankenstein.events.ScriptErrorEvent;

	/**
	 * Évènement diffusé à la fin de l'appel du script
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Évènement diffusé pendant l'upload du / des fichier(s)
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]

	/**
	 * Évènement diffusé lors d'une erreur de type Securité
	 * 
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

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
	 */
	[Event(name="error_returned", type="frankenstein.events.ScriptErrorEvent")]

	/**
	 * Évènement diffusé si le script n'a pas été trouvé
	 * 
	 * @eventType frankenstein.events.ScriptErrorEvent.SCRIPT_MISSING
	 */
	[Event(name="script_missing", type="frankenstein.events.ScriptErrorEvent")]

	/**
	 * 
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> t.lepore<br />
	 * 		<b>Date </b> 12 déc 08<br />
	 * 		<b>Version </b> 1.0.1<br />
	 * 		<b>History</b>
	 * 			<ul>
	 * 				<li>Version 1.0.0 by thibault Lepore</li>
	 * 				<li>Version 1.0.1 bt nicoBush: correction d'un bug d'encodage UTF-8 des paramètres</li>
	 * 			</ul> 
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * 
	 * <p>Classe permettant d'envoyer des fichiers vers le serveur avec des variables.<br />
	 * Il recoit en retour un xml formaté selon la norme suivante :<br /> 
	 * &lt;root&gt;<br />
	 * 		&lt;error type="00" /&gt;<br />
	 * &lt;/root&gt;<br />
	 * </p>
	 * 
	 * @example 
	 * <listing version="3.0" >
	 * 	<pre class="prettyprint">
	 *		var urlVars : URLVariables = new URLVariables();
	 *		urlVars.idUser = "123456";
	 *		
	 *		var file1 : FileToUpload = new FileToUpload(monByteArray, "file");
	 *		
	 *		var uploader : FileUploader = new FilesUploader();
	 *		uploader.addEventListener(Event.COMPLETE, _onFileUploaded);
	 *		uploader.addEventListener(ProgressEvent.PROGRESS, _onFileUploading);
	 *		uploader.addEventListener(ScriptErrorEvent.ERROR_RETURNED, _onErrorScript);
	 *		uploader.uploadFiles("saveImg.aspx", [file1], urlVars);
	 *		
	 *		
	 *		function _onFileUploaded(e : Event):void{
	 *			//file is uploaded
	 *			trace("fileUploaded");
	 *		}	 
	 *
	 *		function _onFileUploading(e : ProgressEvent):void{
	 *			//file is uploading
	 *		}
	 *		
	 *		function _onErrorScript(e : ScriptErrorEvent):void{
	 *			//script returns an error
	 *			trace(e.errorMessage);
	 *		}
	 *	</pre>
	 * </listing>
	 * 
	 * @see frankenstein.net.filesUploader.FileToUpload
	 *
	 */
	
	/* 
	 * @author t.lepore
	 * @project Frankenstein
	 * 
	 */
	public class FilesUploader extends EventDispatcher {

		private var _boundary : String = '--';
		private var _scriptLoader : URLLoader;
		private var _url : String;
		private var _data : XML;

		/**
		 * Créé un nouveau FilesUploader
		 */
		public function FilesUploader() {
		}

		
		/**
		 * Envoie des fichiers avec des variables à un script serveur.
		 * 
		 * @param url
		 * Script destinataire.
		 * 
		 * @param files
		 * Tableau de FileToUpload.
		 * 
		 * @param
		 * Variables URLVariables contenant toutes les variables.
		 */
		public function uploadFiles(url : String, files : Array, variables : URLVariables = null) : void {
			
			_url = url;
			
			var i : int;
			
			var request : URLRequest = new URLRequest;
			var postData : ByteArray = new ByteArray;
			var bytes : String;
			var fileName : String;
			var file : FileToUpload;
			var contentType : String = 'application/octet-stream';

			_scriptLoader = new URLLoader();
			
			_scriptLoader.addEventListener(ProgressEvent.PROGRESS, _onUpload, false, 0, true);
			_scriptLoader.addEventListener(Event.COMPLETE, _onUploadComplete, false, 0, true);
			_scriptLoader.addEventListener(IOErrorEvent.IO_ERROR, _onUploadError, false, 0, true); 
			_scriptLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError, false, 0, true); 
			_scriptLoader.addEventListener(Event.OPEN, _onOpen, false, 0, true); 
			_scriptLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _onHttpStatus, false, 0, true); 
			 
			
			for (i = 0;i < 0x10; i++) {
				_boundary += String.fromCharCode(int(97 + Math.random() * 25));
			}
	
			_scriptLoader.dataFormat = URLLoaderDataFormat.BINARY;
						
			request.url = url;
			request.contentType = 'multipart/form-data; charset=UTF-8; boundary=' + _boundary;
			request.method = URLRequestMethod.POST;
			
			postData.endian = Endian.BIG_ENDIAN;
			
			// ETAPE 1 BOUNDARY DE DEPART /////////////////////////
			
			// -- + boundary
			postData = _writeBoundary(postData);
			// line break
			postData = _writeLineBreak(postData);
			
			/////////////////////////////////////////////////////
			
			// ETAPE 2 : NOM DU FICHIER ////////////////////////

			if (files != null) {
				for (i = 0;i < files.length; i++) {
					// content disposition
					bytes = 'Content-Disposition: form-data; name="Filename"';
					
					for (var j : int = 0;j < bytes.length; j++ ) {
						postData.writeByte(bytes.charCodeAt(j));
					}
					
					// 2 line breaks
					postData = _writeDoubleLineBreak(postData);
						
					// file name

					file = files[i] as FileToUpload;
					fileName = file.getName();
					postData.writeUTFBytes(fileName);
						
					// line break
					postData = _writeLineBreak(postData);
					// -- + boundary
					postData = _writeBoundary(postData);
					// line break
					postData = _writeLineBreak(postData);
				}
			}
			
			/////////////////////////////////////////////////////
			
			// ETAPE 3 : FICHIER ////////////////////////////////

			if (files != null) {
				for (i = 0;i < files.length; i++) {
					// content disposition
					bytes = 'Content-Disposition: form-data; name="Filedata' + (i + 1).toString() + '"; filename="';
					
					for (var m : int = 0;m < bytes.length; m++ ) {
						postData.writeByte(bytes.charCodeAt(m));
					}
						
					// file name
					file = files[i] as FileToUpload;
					
					var fileExt:String = "";
					if (file.getType()!="") {
						fileExt = "."+file.getType();
					}
					
					fileName = "image" + (i + 1).toString() + fileExt;
					postData.writeUTFBytes(fileName);
						
					// missing "
					postData = _writeQuote(postData);	
					// line break
					postData = _writeLineBreak(postData);
						
					// content type
					bytes = 'Content-Type: ' + contentType;
					
					for (var l : int = 0;l < bytes.length; l++ ) {
						postData.writeByte(bytes.charCodeAt(l));
					}
						
					// 2 line breaks
					postData = _writeDoubleLineBreak(postData);
						
					// file data
					file = null;
					file = files[i] as FileToUpload;
					var fileBytes : ByteArray = file.getBytes();
					postData.writeBytes(fileBytes, 0, fileBytes.length);
						
					// line break
					postData = _writeLineBreak(postData);	
					// -- + boundary
					postData = _writeBoundary(postData);
					// line break			
					postData = _writeLineBreak(postData);
				}
			}
			
			/////////////////////////////////////////////////////
			
			// ETAPE 4 : UPLOAD FIELD ///////////////////////////
			
			// upload field
			bytes = 'Content-Disposition: form-data; name="Upload"';
			
			for (i = 0;i < bytes.length; i++ ) {
				postData.writeByte(bytes.charCodeAt(i));
			}
				
			// 2 line breaks
			postData = _writeDoubleLineBreak(postData);
			
			/////////////////////////////////////////////////////
			
			// ETAPE 5 : SUBMIT QUIERY //////////////////////////
			
			// submit
			bytes = 'Submit Query';
			
			for (i = 0;i < bytes.length; i++ ) {
				postData.writeByte(bytes.charCodeAt(i));
			}
				
			// line break			
			postData = _writeLineBreak(postData);
			
			/////////////////////////////////////////////////////
			
			// ETAPE 6 : VARIABLES //////////////////////////////
			
			//on ajoute les variables en post
			if (variables != null) {
					
				for (var s : String in variables) {
					// -- + boundary
					postData = _writeBoundary(postData);
					// line break			
					postData = _writeLineBreak(postData);
						
					// upload field
					bytes = 'Content-Disposition: form-data; name="' + s + '"';
					
					for ( i = 0;i < bytes.length; i++ ) {
						postData.writeByte(bytes.charCodeAt(i));
					}
						
					// 2 line breaks
					postData = _writeDoubleLineBreak(postData);
						
					//var
					var mavar : String = variables[s];
						
					for (var k : int = 0;k < mavar.length; k++ ) {
						postData.writeUTFBytes(mavar.charAt(k));
					}
						
					// line break
					postData = _writeLineBreak(postData);
				}
			}
				
			// -- + boundary + --
			postData = _writeBoundary(postData);	
			postData = _writeDoubleDash(postData);
	
			request.data = postData;
			request.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));
			_scriptLoader.load(request);
		}

		
		
		//----------------------------------------------
		//				EVENEMENT DISPATCHES
		//----------------------------------------------

		private function _onUpload(e : ProgressEvent) : void {
			dispatchEvent(e);
		}

		
		private function _onUploadComplete(e : Event) : void {
			
			_data = XML(_scriptLoader.data);
			_checkDataValidity();
			
			
			_killAllEventListener();
		}

		
		private function _onUploadError(e : IOErrorEvent) : void {
			dispatchEvent(e);
			_killAllEventListener();
		}

		
		private function _onSecurityError(e : SecurityErrorEvent) : void {
			dispatchEvent(e);
			_killAllEventListener();
		}

		
		private function _onOpen(e : Event) : void {
			dispatchEvent(e);
		}

		
		private function _onHttpStatus(e : HTTPStatusEvent) : void {
			dispatchEvent(e);
		}

		
		private function _killAllEventListener() : void {
			_scriptLoader.removeEventListener(ProgressEvent.PROGRESS, _onUpload);
			_scriptLoader.removeEventListener(Event.COMPLETE, _onUploadComplete);
			_scriptLoader.removeEventListener(IOErrorEvent.IO_ERROR, _onUploadError); 
			_scriptLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError); 
			_scriptLoader.removeEventListener(Event.OPEN, _onOpen); 
			_scriptLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _onHttpStatus);
		}

		
		//----------------------------------------------
		//					WRITERS
		//----------------------------------------------

		private function _writeBoundary(byteArray : ByteArray) : ByteArray {
			var i : uint;
			
			byteArray = _writeDoubleDash(byteArray);
			
			for ( i = 0;i < _boundary.length; i++ ) {
				byteArray.writeByte(_boundary.charCodeAt(i));
			}
			
			return byteArray;
		}

		
		private function _writeDoubleDash(byteArray : ByteArray) : ByteArray {
			byteArray.writeShort(0x2d2d);
			
			return byteArray;
		}

		
		private function _writeQuote(byteArray : ByteArray) : ByteArray {
			byteArray.writeByte(0x22);
			
			return byteArray;
		}

		
		private function _writeLineBreak(byteArray : ByteArray) : ByteArray {
			byteArray.writeShort(0x0d0a);
			
			return byteArray;
		}

		
		private function _writeDoubleLineBreak(byteArray : ByteArray) : ByteArray {
			byteArray.writeInt(0x0d0a0d0a);
			
			return byteArray;
		}

		
		/**
		 * Données renvoyées par le script
		 */
		public function get data() : XML {
			return _data;
		}

		
		/**
		 * @private
		 * Verifie la validité du xml retourné
		 */
		private function _checkDataValidity() : void {
			
			
			
			//si il y a une erreur on la dispatch
			if (_data.error.propertyIsEnumerable(0)) {
				if (_data.error.@type != "00") {
					var e1 : ScriptErrorEvent = new ScriptErrorEvent(ScriptErrorEvent.ERROR_RETURNED);
					e1.errorCode = _data.error.@type;
					e1.errorMessage = _data.error;
					e1.scriptUrl = _url;
					dispatchEvent(e1);
				} else {
					var e2 : Event = new Event(Event.COMPLETE);
					dispatchEvent(e2);		
				}
			} else {
				var e3 : ScriptErrorEvent = new ScriptErrorEvent(ScriptErrorEvent.XML_NOT_WELL_FORMATED);
				e3.scriptUrl = _url;
				dispatchEvent(e3);
			}
		}

		
		//----------------------------------------------
		//				FLUSH
		//----------------------------------------------
		
		/**
		 * Libère la mémoire utilisée par l'objet
		 */		
		public function flush() : void {
			_killAllEventListener();
			_scriptLoader = null;
		}
	}
}
