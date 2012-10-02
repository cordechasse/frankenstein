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
	 * <p>Classe d'erreurs du StageReference</p>
	 * 
	 * 
	 * @author n.bush
	 * @since 18 mars 2010
	 * @version 1.0.0
	 * 
	 */
	public class StageReferenceError extends Error {

		public function StageReferenceError() {
			super("StageReference is not set.");
		}
	}
}
