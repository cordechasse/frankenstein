/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.errors {

	/**
	 * 
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 15 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * <p>Classe d'erreurs pour les scripts</p>
	 * 
	 * 
	 * @see frankenstein.net.ScriptLoader
	 * 
	 * 	
	 * @author n.bush
	 * @since 15 jan 2009
	 * @version 1.0.0
	 * 
	 */
	 public class ScriptError extends Error {
		
		public var scriptUrl : String;
		public var errorCode : String;
		
		public function ScriptError(message : String = "", id : uint = 0) {
			super(message, id);
		}
	}
}
