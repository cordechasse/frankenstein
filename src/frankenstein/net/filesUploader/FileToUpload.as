/*
 * Copyright © CorDeChasse 1999-2011
 */
 
 package frankenstein.net.filesUploader {
	import flash.utils.ByteArray;	

	/**
	 * 
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> t.lepore<br />
	 * 		<b>Date </b> 12 déc 08<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 		<b>History</b>
	 * 		<ul>
	 * 			<li>Version 1.0.0 by Thibault Leporé</li>
	 * 			<li>Version 1.0.1 by Nico Le Breton : ajout du type de fichier</li>
	 * 		</ul>
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * 
	 * <p>Classe permettant d'envoyer des fichiers vers le serveur avec des variables</p>
	 * Fichier à envoyer via le FilesUploader
	 * 
	 * 
	 * @see frankenstein.net.filesUploader.FilesUploader
	 */
	 
	 /* 
	 * @author t.lepore
	 * @project 
	 * 
	 */

	public class FileToUpload {

		private var _bytes : ByteArray;
		private var _name : String;
		private var _type : String;

		/**
		 * Crée un nouveau FileToUpload.
		 * 
		 * @param byte
		 * Données du fichier.
		 * 
		 * @param fileName
		 * Nom du fichier.
		 * 
		 * @param type
		 * Type de fichier (png, jpg, etc.)
		 * 
		 * @return
		 */
		public function FileToUpload(byte : ByteArray, fileName : String, type:String = "") {
			_bytes = byte;
			_name = fileName;
			_type = type;
		}

		
		/**
		 * Getter du nom.
		 * 
		 * @return
		 * Le nom du fichier
		 */
		public function getName() : String {
			return _name;
		}
		
		/**
		 * Getter du type.
		 * 
		 * @return
		 * Le type du fichier (png, jpg, etc.)
		 */
		public function getType() : String {
			return _type;
		}
		
		/**
		 * Getter des données.
		 * 
		 * @return
		 * Les données du fichier.
		 */
		public function getBytes() : ByteArray {
			return _bytes;
		}
	}
}
