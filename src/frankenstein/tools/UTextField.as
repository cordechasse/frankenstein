/*
 * Copyright © CorDeChasse 1999-2011
 */
 
package frankenstein.tools {
	import flash.net.registerClassAlias;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;		

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 27 nov 2008<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>
	 * 	Classe d'outils statiques pour les TextField
	 * </p>
	 * 
	 */
	public class UTextField {

		/**
		 * Retourne si un text a un overflow (contenu qui ne rentre pas dans le champs texte).<br />
		 * Attention : il ne faut pas que le texte soit en autoSize!
		 * 
		 * @param field
		 * Le champs texte source.
		 * 
		 * @return
		 * Si le textfield a un overflow
		 */
		public static function hasOverFlow(field : TextField) : Boolean {
			if (field.multiline)
				return field.maxScrollV > 1;
			else
				return field.maxScrollH > 1;
		}

		
		/**
		 * Retire l'overflow d'un TextField en supprimant les dernier mot et les remplacant par "...".<br />
		 * Si même en retirant les mots, le texte deborde, on retire les lettres des mots.<br />
		 * <br />
		 * Attention Fonctionner mal pour les champs HTML (balises fermantes).
		 * 
		 * 
		 * @param field
		 * Le champs texte source.
		 * 
		 * @param omissionCharacter
		 * Les caractères qui remplacent les mots supprimés.
		 * 
		 * @return
		 * Le texte supprimé.
		 */
		public static function removeOverFlow(field : TextField, omissionCharacter : String = "...") : String {
			if (!hasOverFlow(field))
				return "";
			
			var words : Array = field.htmlText.split(" ");
			var overflow : Array = [];
			while (hasOverFlow(field) && words.length > 1) {
				overflow.push(words.pop());
				field.htmlText = words.join(" ") + omissionCharacter;
			}
			
			//si on a encore de l'overflow, on coupe le dernier mot restant
			if (hasOverFlow(field)){
				var lastWord : String = _removeOverFlowLetter(field, omissionCharacter);
				overflow[overflow.length - 1] = lastWord;
			}
			
			return overflow.reverse().join(" ");
		}

		
		
		/**
		 * Remove textfield letter overflow
		 * 
		 * @param field
		 * Textfield source
		 * 
		 * @param omissionCharacter
		 * By what removed word are replaced
		 * 
		 * @return
		 * Le texte supprimé.
		 */
		private static function _removeOverFlowLetter(field : TextField, omissionCharacter : String = "...") : String {
			var letters : Array = field.htmlText.split("");
			var removedLetters : Array = [];
			while (hasOverFlow(field) && letters.length > 1) {
				removedLetters.push(letters.pop());
				field.htmlText = letters.join("") + omissionCharacter;
			}
			
			
			return removedLetters.reverse().join();
		}

		
		/**
		 * Retourne le contenu d'un texte sur des lignes spécifiques.
		 * 
		 * @param field
		 * Le champs texte source.
		 * 
		 * @param startLine
		 * la ligne de départ.
		 * 
		 * @param endLine
		 * La ligne de fin.
		 * 
		 * @return
		 * Le contenu des lignes.
		 */
		public static function getSlicedLine(field : TextField, startLine : uint, endLine : uint) : String {
			//trace("UTextField", "getSlicedLine", startLine, endLine);

			if (endLine > field.numLines)
				endLine = field.numLines;
			
			if (endLine < startLine)
				return "";
			
			var _lines : Array = [];	
			for (var i : uint = startLine;i < endLine; i++) {
				_lines.push(field.getLineText(i));	
			}
			
			return _lines.join("");
		}

		
		/**
		 * Duplique un TextField.
		 * 
		 * @param field
		 * Le TextField à dupliquer.
		 *  
		 * @return
		 * Un nouveau TextField qui à les mêmes propriétés que l'original.
		 * 
		 */
		public static function cloneTextField(field : TextField) : TextField {
			registerClassAlias(getQualifiedClassName(field).split('::').join('.'), TextField);

			var ba : ByteArray = new ByteArray();
			ba.writeObject(field);
			ba.position = 0;
			var clone : TextField = ba.readObject() as TextField;
			return clone;
		}
	}
}
