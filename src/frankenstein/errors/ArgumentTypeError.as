/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.errors {

	/**
	 * 
	 * <div class="author">
	 * 	<p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 01 jan 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * 	</p>
	 * 	<p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * 	</p>
	 * </div>
	 * <p>Classe d'erreurs concernant le type de paramètre</p>
	 * 
	 * 	
	 * @author n.bush
	 * @since 01 jan 2009
	 * @version 1.0.0
	 * 
	 */
	 public class ArgumentTypeError extends ArgumentError {
		public function ArgumentTypeError(paramName : String = "") {
			super((paramName == null) ? 'You passed an argument with an incorrect type to this method.' : 'The argument type you passed for parameter "' + paramName + '" is not allowed by this method.');
		}
	}
}
